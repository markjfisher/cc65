; break_handler_common.s
; Shared state & RAM brkhandler for ROM runtime (bbc-clib).
; Ensures CLIB ROM is paged in before calling CLIB code or returning to C.

        .export  _clear_brk_ret
        .export  brkhandler
        .export  bh_brkret, bh_rtsto, bh_olds, bh_oldbrkv, bh_installed

        .export  ROMSEL_CURRENT, ROMSEL, ERR_MSG_PTR

        .import  _exit
        .import  _soft_abort_cleanup
        .import  clib_rom_slot

; Absolute vectors/regs:
BRKV            := $0202
ROMSEL_CURRENT  := $F4
ROMSEL          := $FE30
ERR_MSG_PTR     := $FD

ESC_CODE        = $1B

        .bss
bh_oldbrkv:   .res 2
bh_brkret:    .res 2
bh_rtsto:     .res 2
bh_olds:      .res 1
bh_installed: .res 1

        .code

; --- helper: select CLIB ROM bank (clobbers A) ---
select_clib:
        lda     clib_rom_slot
        sta     ROMSEL_CURRENT
        sta     ROMSEL
        rts

; Disarm and restore BRKV if installed.
_clear_brk_ret:
        php
        sei
        lda     bh_brkret
        ora     bh_brkret+1
        beq     @maybe_restore
        lda     #0
        sta     bh_brkret
        sta     bh_brkret+1
@maybe_restore:
        lda     bh_installed
        beq     @done
        lda     bh_oldbrkv
        sta     BRKV
        lda     bh_oldbrkv+1
        sta     BRKV+1
        lda     #0
        sta     bh_installed
@done:  plp
        rts

; --- RAM BRK handler (ROM-aware) ---
brkhandler:
        php
        pha
        txa
        pha
        tya
        pha

        ; ESC?
        ldy     #0
        lda     (ERR_MSG_PTR),y
        cmp     #ESC_CODE
        beq     @pass

        ; armed?
        lda     bh_brkret
        ora     bh_brkret+1
        beq     @pass

        ; ---- armed path ----
        ; disarm
        lda     #0
        sta     bh_brkret
        sta     bh_brkret+1

        ; ensure CLIB ROM is selected before we resume C
        jsr     select_clib

        ; restore S saved at arm time
        ldx     bh_olds
        ; we need to discard 1 return address left on the stack, so just increment X by 2 before setting it to SP
        inx
        inx
        txs

        ; craft return
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        ; return with A=1; cannot plp because we swapped stacks
        cli
        lda     #1
        rts

@pass:
        jsr     _soft_abort_cleanup
        lda     #$1B    ; restore our pass thorugh exit code
        jmp     _exit
