        .export         trap_brk
        .export         trap_brk_clib
        .export         release_brk
        .export         brkhandler

        .import         _exit_bits
        .import         BRKV

        .importzp       clib_ws
        .importzp       clib_jptr

        .include        "bbc.inc"

        .code

; ------------------------------------------------------------
; Install our BRK handler, chaining to a fixed "bombmessage"
; afterwards (used for CLIB self-test).
; ------------------------------------------------------------
trap_brk_clib:
        php
        sei
        ; oldbrkv = &bombmessage
        lda     #<bombmessage
        ldy     #WS_OLDBRKV_LO
        sta     (clib_ws),y
        lda     #>bombmessage
        iny
        sta     (clib_ws),y

        ; BRKV = &brkhandler
        lda     #<brkhandler
        sta     BRKV
        lda     #>brkhandler
        sta     BRKV+1
        plp
        rts

; ------------------------------------------------------------
; Install our BRK handler, chaining back to the previous BRKV.
; ------------------------------------------------------------
trap_brk:
        php
        sei
        ; Save current BRKV into workspace
        lda     BRKV
        ldy     #WS_OLDBRKV_LO
        sta     (clib_ws),y
        lda     BRKV+1
        iny
        sta     (clib_ws),y

        ; BRKV = &brkhandler
        lda     #<brkhandler
        sta     BRKV
        lda     #>brkhandler
        sta     BRKV+1
        plp
        rts

; ------------------------------------------------------------
; Restore the previous BRKV from workspace.
; ------------------------------------------------------------
release_brk:
        php
        sei
        ldy     #WS_OLDBRKV_LO
        lda     (clib_ws),y
        sta     BRKV
        iny
        lda     (clib_ws),y
        sta     BRKV+1
        plp
        rts

; ------------------------------------------------------------
; BRK handler:
; - If ESC ($1B), pass through (cleanup + chain)
; - If workspace brkret != 0, tail-jump to that target
; - Else, cleanup + chain to old BRKV
; ------------------------------------------------------------
brkhandler:
        php
        pha
        txa
        pha
        tya
        pha

        ; Check escape (error code is byte after BRK)
        ldy     #0
        lda     ($FD),y
        cmp     #$1B
        beq     brk_pass

        ; Load workspace brkret into clib_jptr and test non-zero
        ldy     #WS_BRKRET_LO
        lda     (clib_ws),y
        sta     clib_jptr
        iny
        lda     (clib_ws),y
        sta     clib_jptr+1
        lda     clib_jptr
        ora     clib_jptr+1
        beq     brk_pass

        ; Tail-jump to brkret target (trap entry from brkret.s)
        plp                     ; restore P (optional: you can also keep interrupts disabled)
        jmp     (clib_jptr)

brk_pass:
        ; Pass-through: perform cleanup then chain to saved BRKV / bombmessage
        ; Load pointer to _exit_bits from workspace -> clib_jptr
        ldy     #WS_EXIT_BITS_LO
        lda     (clib_ws),y
        sta     clib_jptr
        iny
        lda     (clib_ws),y
        sta     clib_jptr+1

        ; Emulate "JSR (clib_jptr)".
        ; For RTS to land at label :after, we must push (:after - 1).
        lda     #<(after-1)
        pha
        lda     #>(after-1)
        pha
        jmp     (clib_jptr)

after:
        ; restore registers before chaining
        pla
        tay
        pla
        tax
        pla
        plp

        ; jmp (oldbrkv)
        ldy     #WS_OLDBRKV_LO
        lda     (clib_ws),y
        sta     clib_jptr
        iny
        lda     (clib_ws),y
        sta     clib_jptr+1
        jmp     (clib_jptr)

; ------------------------------------------------------------
; Optional "bomb" message routine (unchanged)
; ------------------------------------------------------------
        .import print0
        .import printhex
        .import OSWRCH

        .macro domessage msgaddr
        lda     #<msgaddr
        sta     $F2
        lda     #>msgaddr
        sta     $F3
        jsr     print0
        .endmacro

m0:     .byte "BRK occurred at &", 0
m1:     .byte ", Y=", 0
m2:     .byte ", X=", 0
m3:     .byte ", A=", 0
m4:     .byte ", P=", 0
m5:     .byte 13, 10, "ERR=", 0
m6:     .byte " : ", 0

bombmessage:
        php
        pha
        txa
        pha
        tya
        pha

        domessage m0

        lda     $FE
        jsr     printhex
        lda     $FD
        jsr     printhex

        domessage m1
        pla
        jsr     printhex

        domessage m2
        pla
        jsr     printhex

        domessage m3
        pla
        jsr     printhex

        domessage m4
        pla
        jsr     printhex

        domessage m5
        ldy     #0
        lda     ($FD),y
        jsr     printhex

        domessage m6
        ldy     #0
lp:     iny
        beq     done
        lda     ($FD),y
        beq     done
        jsr     OSWRCH
        jmp     lp

done:   jmp     done
