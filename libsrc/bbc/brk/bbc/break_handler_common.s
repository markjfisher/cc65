; break_handler_ram_common.s
; Shared state & RAM brkhandler used by both prod/debug installers.

        .export  _clear_brk_ret
        .export  brkhandler

        ; These are shared variables installers will import:
        .export  bh_brkret, bh_rtsto, bh_olds, bh_oldbrkv, bh_installed

        .import  _exit
        .import  _soft_abort_cleanup
        .import  BRKV

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

; Disarm guard and restore BRKV if we installed it.
_clear_brk_ret:
        php
        sei

        ; Disarm guard if armed
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

@done:
        plp
        rts


; RAM BRK handler
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

        ; ---- armed return path ----
        ; disarm
        lda     #0
        sta     bh_brkret
        sta     bh_brkret+1

        ; restore hardware S saved at set_brk_ret* time
        ldx     bh_olds
        ; we need to discard 1 return address left on the stack, so just increment X by 2 before setting it to SP
        inx
        inx
        txs

        ; push saved return address so RTS returns to C site
        lda     bh_rtsto+1
        pha
        lda     bh_rtsto
        pha

        ; we changed S — the entry-saved A/X/Y and P are on the old stack,
        ; so DON'T try to pop them. Just return A=1.
        cli
        lda     #1
        rts

@pass:
        ; jsr     _soft_abort_cleanup
        lda     #$1B    ; restore our pass thorugh exit code
        jmp     _exit
