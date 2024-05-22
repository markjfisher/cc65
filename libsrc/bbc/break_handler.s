; break_handler.s
; Production install/arm entry: _set_brk_ret

; Explanation of break handling.

; Lifecycle (crt0 does this for you)
; - Global install once at startup so all BRKs go through the handler.
; - Global uninstall on exit so the language’s BRK handler is restored.
;
; Arming (trap/long-jump use)
; - set_brk_ret() — Production armer. Arms once; non-ESC BRK returns A=1 to the caller; ESC falls through to OS exit.
; - set_brk_ret_debug() — Debug armer. Arms once and enables the debug banner for pass-through cases. Non-ESC BRK still returns A=1.
; - disarm_brk_ret() — Clears the one-shot arm (no BRKV changes).
;
; Debug “catch-all” switch (no arming)
; - set_brk_debug_mode_only() — Enable banner for unarmed BRKs (and ESC if you want). Doesn’t arm; doesn’t touch stacks. Use it when you want to catch unexpected BRKs anywhere.
; Internally this just sets bh_mode=1 and bh_dbg_entry = bombmessage_and_hang. Because bh_dbg_entry lives in the debug object, the banner code only links if you call a debug API.

        .export  _set_brk_ret

        .import  BRKV
        .import  brkhandler            ; RAM handler in common

        ; shared state from common
        .import  bh_brkret, bh_rtsto, bh_olds
        .import  bh_mode
        .import  _install_brk_handler_global

        .code

; returns A=0 on first return (armed), A=1 when returning via BRK
_set_brk_ret:
        ; production mode
        lda     #$00
        sta     bh_mode

        ; ensure global BRKV is installed (idempotent)
        jsr     _install_brk_handler_global

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
