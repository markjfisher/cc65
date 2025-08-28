; break_handler.s
; Production install/arm entry: _set_brk_ret

        .export  _set_brk_ret

        .import  BRKV
        .import  brkhandler            ; RAM handler in common

        ; shared state from common
        .import  bh_brkret, bh_rtsto, bh_olds, bh_oldbrkv, bh_installed

        .code

; returns A=0 on first return (armed), A=1 when returning via BRK
_set_brk_ret:
        ; Install handler into BRKV once (production chain to old BRKV)
        php
        sei
        lda     bh_installed
        bne     @bh_is_installed

        ; Save current BRKV to chain back to it
        lda     BRKV
        sta     bh_oldbrkv
        lda     BRKV+1
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
        sta     bh_rtsto            ; low
        pla
        sta     bh_rtsto+1          ; high
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        ; Arm: bh_brkret = &trapbrk
        sei
        lda     #<trapbrk
        sta     bh_brkret
        lda     #>trapbrk
        sta     bh_brkret+1
        cli

        lda     #0
        rts

; Local trap entry for production set_brk_ret
trapbrk:
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
