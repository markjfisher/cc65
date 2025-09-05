; break_handler_debug.s
; Debug arming entry: _set_brk_ret_debug
; ROM-free: uses only OSWRCH (no CLIB ROM calls).

        .export  _set_brk_ret_debug
        .export  _set_brk_debug_mode_only

        .import  _install_brk_handler_global   ; idempotent global install
        .import  bh_brkret, bh_rtsto, bh_olds
        .import  bh_dbg_entry, bh_mode
        .import  OSWRCH

        .code

; common code
set_bomb:
        lda     #<bombmessage_and_hang
        sta     bh_dbg_entry
        lda     #>bombmessage_and_hang
        sta     bh_dbg_entry+1
        rts

; This is a trap to use while in development mode, you can ensure you get a banner and hang your app at the exact error location
; by calling this. Otherwise, without an armed escape handler, the application will simply exit.
_set_brk_debug_mode_only:
        jsr     _install_brk_handler_global      ; idempotent
        lda     #$01
        sta     bh_mode
        jsr     set_bomb
        rts

; returns A=0 on first return (armed), A=1 when returning via BRK
_set_brk_ret_debug:
        ; ensure BRK handler is installed (no-op if already)
        jsr     _install_brk_handler_global

        ; mark debug mode
        lda     #$01
        sta     bh_mode

        ; Save S (like production armer)
        tsx
        stx     bh_olds

        ; Pull caller return address, store, and push back
        pla
        sta     bh_rtsto            ; low
        pla
        sta     bh_rtsto+1          ; high
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        ; Arm: bh_brkret = &trapbrk_dbg and set debug entry pointer
        php
        sei
        lda     #<trapbrk_dbg
        sta     bh_brkret
        lda     #>trapbrk_dbg
        sta     bh_brkret+1

        jsr     set_bomb
        plp

        lda     #0
        rts

; Local trap entry for debug armer (mirrors prod)
trapbrk_dbg:
        lda     #0
        sta     bh_brkret
        sta     bh_brkret+1

        ldx     bh_olds
        inx
        inx
        txs
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        lda     #1
        rts

; ------------------ ROM-free banner helpers ------------------

; Print zero-terminated string at absolute address in A:Y (or via macro below)
; Clobbers: A, X, Y
printz_abs:
        ; expects: address in (tmp lo/hi) or use macro that sets up Y and absolute label
        rts                     ; (we only use the macro form below)

; Print a zero-terminated string given by label (absolute), via OSWRCH
.macro printz label
        ; .local l1, l2
        ldy     #0
:       lda     label,y
        beq     :+
        jsr     OSWRCH
        iny
        bne     :-
:
.endmacro

; Print A as two uppercase hex digits via OSWRCH
; Clobbers: A, X, Y
printhex8:
        pha                     ; save original A for low nibble later
        tax                     ; X = original
        lsr a                   ; high nibble = A>>4
        lsr a
        lsr a
        lsr a
        tay
        lda     hexdigs,y
        jsr     OSWRCH
        txa
        and     #$0F
        tay
        lda     hexdigs,y
        jsr     OSWRCH
        pla                     ; restore original (not needed further, but tidy)
        rts

hexdigs: .byte "0123456789ABCDEF"

; ---------- Debug banner (ROM-free) ----------
m0: .byte "BRK occurred at &", 0
m1: .byte 13, 10, "Y=&", 0
m2: .byte ", X=&", 0
m3: .byte ", A=&", 0
m4: .byte ", P=&", 0
m5: .byte 13, 10, "ERR=", 0
m6: .byte " : ", 0

; Entry the common handler will tail-jump to when bh_dbg_entry != 0
bombmessage_and_hang:
        php
        pha
        txa
        pha
        tya
        pha

        printz m0
        lda $FE
        jsr printhex8
        lda $FD
        jsr printhex8

        printz m1
        pla
        jsr printhex8

        printz m2
        pla
        jsr printhex8

        printz m3
        pla
        jsr printhex8

        printz m4
        pla
        jsr printhex8

        printz m5
        ldy #0
        lda ($FD),y
        jsr printhex8

        printz m6
        ldy #0
@lp:    iny
        beq @done
        lda ($FD),y
        beq @done
        jsr OSWRCH
        jmp @lp
@done:  ; hang for inspection
        jmp @done
