; break_handler_debug.s
; Debug install/arm entry: _set_brk_ret_debug

        .export  _set_brk_ret_debug
        .import  BRKV
        .import  brkhandler
        .import  bh_brkret, bh_rtsto, bh_olds, bh_oldbrkv, bh_installed
        .import  print0, printhex, OSWRCH

        .code

; returns A=0 on first return (armed), A=1 when returning via BRK
_set_brk_ret_debug:
        ; Install handler into BRKV once (chain to bombmessage)
        php
        sei
        lda     bh_installed
        bne     @bh_is_installed

        ; Chain target = bombmessage
        lda     #<bombmessage
        sta     bh_oldbrkv
        lda     #>bombmessage
        sta     bh_oldbrkv+1

        ; Install our RAM handler
        lda     #<brkhandler
        sta     BRKV
        lda     #>brkhandler
        sta     BRKV+1

        lda     #1
        sta     bh_installed
@bh_is_installed:
        plp

        ; Save S
        tsx
        stx     bh_olds

        ; Pull caller return address, store, and push back
        pla
        sta     bh_rtsto
        pla
        sta     bh_rtsto+1
        ; lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        ; Arm: bh_brkret = &trapbrk_dbg
        php
        sei
        lda     #<trapbrk_dbg
        sta     bh_brkret
        lda     #>trapbrk_dbg
        sta     bh_brkret+1
        plp

        lda     #0
        rts

; Local trap entry for debug set_brk_ret
trapbrk_dbg:
        ; disarm
        lda     #0
        sta     bh_brkret
        sta     bh_brkret+1

        ; restore S and push saved return address
        ldx     bh_olds
        ; we need to discard 1 return address left on the stack, so just increment X by 2 before setting it to SP
        inx
        inx
        txs
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        lda     #1
        rts


; ---------- Debug banner ----------
.macro domessage msgaddr
        lda     #<msgaddr
        sta     $F2
        lda     #>msgaddr
        sta     $F3
        jsr     print0
.endmacro

m0: .byte "BRK occurred at &", 0
m1: .byte ", Y=", 0
m2: .byte ", X=", 0
m3: .byte ", A=", 0
m4: .byte ", P=", 0
m5: .byte 13, 10, "ERR=", 0
m6: .byte " : ", 0

bombmessage:
        php
        pha
        txa
        pha
        tya
        pha

        domessage m0

        lda $FE
        jsr printhex
        lda $FD
        jsr printhex

        domessage m1
        pla
        jsr printhex

        domessage m2
        pla
        jsr printhex

        domessage m3
        pla
        jsr printhex

        domessage m4
        pla
        jsr printhex

        domessage m5
        ldy #0
        lda ($FD),y
        jsr printhex

        domessage m6
        ldy #0
@lp:    iny
        beq @done
        lda ($FD),y
        beq @done
        jsr OSWRCH
        jmp @lp
@done:  jmp @done
