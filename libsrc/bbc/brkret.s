        .export         _set_brk_ret, _clear_brk_ret
        .importzp       clib_ws
        ; no c_sp, no subysp/addysp needed

        .include        "bbc.inc"

        .code

; returns A=0 first time, A=1 when returning via BRK
; clobbers A, X, Y
_set_brk_ret:
        ; Save current hardware stack pointer in X
        tsx

        ; Pull caller return address into workspace
        pla                             ; low
        ldy     #WS_RTSTO_LO
        sta     (clib_ws),y
        pla                             ; high
        iny
        sta     (clib_ws),y

        ; Push the return address back so we can RTS normally
        ; (note Y is WS_RTSTO_HI here)
        lda     (clib_ws),y             ; high
        pha
        dey                              ; WS_RTSTO_LO
        lda     (clib_ws),y             ; low
        pha

        ; Save S (from X) into workspace
        txa
        ldy     #WS_OLDS
        sta     (clib_ws),y

        ; Arm the BRK return target in workspace
        sei
        lda     #<trapbrk
        ldy     #WS_BRKRET_LO
        sta     (clib_ws),y
        lda     #>trapbrk
        iny
        sta     (clib_ws),y

        ; mark armed
        ldy     #WS_FLAGS
        lda     #1
        sta     (clib_ws),y
        cli

        lda     #0
        rts

; Entered from your BRK vector handler when armed.
; Restores hardware S and re-creates caller return so we “return 1”.
trapbrk:
        ; Disarm immediately (avoid re-entrancy)
        lda     #0
        ldy     #WS_FLAGS
        sta     (clib_ws),y
        ldy     #WS_BRKRET_LO
        sta     (clib_ws),y
        iny
        sta     (clib_ws),y

        ; Restore hardware S first, so subsequent pushes land on the right stack
        ldy     #WS_OLDS
        lda     (clib_ws),y
        tax
        txs

        ; Re-push saved return address to the hardware stack
        ldy     #WS_RTSTO_HI
        lda     (clib_ws),y
        pha
        dey                             ; WS_RTSTO_LO
        lda     (clib_ws),y
        pha

        cli
        lda     #1
        rts

; Disarm (if armed). No C-stack frame to free in this variant.
_clear_brk_ret:
        sei
        ; if already disarmed, return
        ldy     #WS_FLAGS
        lda     (clib_ws),y
        beq     done

        ; clear brkret and flag
        lda     #0
        sta     (clib_ws),y             ; FLAGS
        ldy     #WS_BRKRET_LO
        sta     (clib_ws),y
        iny
        sta     (clib_ws),y
done:
        cli
        rts
