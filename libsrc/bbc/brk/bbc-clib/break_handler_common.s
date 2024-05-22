; break_handler_common.s
; Shared state & RAM brkhandler used by both prod/debug installers.

; This version for bbc-clib ensures CLIB ROM is paged in before calling CLIB code or returning to C.

        .export  _disarm_brk_ret
        .export  brkhandler
        .export  bh_brkret, bh_rtsto, bh_olds, bh_oldbrkv, bh_installed
        .export  bh_mode, bh_dbg_entry

        .import  _exit
        .import  clib_rom_slot

; Absolute vectors/regs:
ROMSEL_CURRENT  := $F4
ROMSEL          := $FE30
ERR_MSG_PTR     := $FD

ESC_CODE        = $1B

        .bss
bh_oldbrkv:   .res 2      ; saved BRKV (or debug chain target)
bh_brkret:    .res 2      ; non-zero => armed, hbh_olds trap entry (&trapbrk or &trapbrk_dbg)
bh_rtsto:     .res 2      ; saved return address of caller of set_brk_ret*
bh_olds:      .res 1      ; saved hardware S at set_brk_ret* time
bh_installed: .res 1      ; 0/1: whether we've installed our handler into BRKV

        .code

; --- helper: select CLIB ROM bank (clobbers A) ---
select_clib:
        lda     clib_rom_slot
        sta     ROMSEL_CURRENT
        sta     ROMSEL
        rts

_disarm_brk_ret:
        php
        sei
        lda     #$00
        sta     bh_brkret
        sta     bh_brkret+1
        sta     bh_dbg_entry
        sta     bh_dbg_entry+1
        sta     bh_mode
        plp
        rts

; --- RAM BRK handler (ROM-aware) ---
brkhandler:
        php
        sei
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
        sta     bh_dbg_entry
        sta     bh_dbg_entry+1
        sta     bh_mode

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
        lda     bh_mode
        beq     bh_prod

        ; if debug and entry is set, tail-jump there
        lda     bh_dbg_entry
        ora     bh_dbg_entry+1
        beq     bh_prod

        ; patch-and-jump (safe absolute)
        php
        sei
        lda     bh_dbg_entry
        sta     bh_jmp_loc
        lda     bh_dbg_entry+1
        sta     bh_jmp_loc + 1
        plp     ; restores previous interrupt status value

        jmp     $FFFF

bh_jmp_loc = * - 2

bh_prod:
        ldy     #$00
        lda     (ERR_MSG_PTR), y
        ; this is vital, to restore the old interrupt status value. Side effects of not doing this are next application run, cgetc doesn't get any key presses due to irq_handler not firing.
        plp
        jmp     _exit

        .bss
bh_dbg_entry:   .res 2
bh_mode:        .res 1
