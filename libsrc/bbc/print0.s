; Dominic Beesley, 2005
; Mark Fisher, 2026
;

        .import OSASCI
        .export print0
.proc print0
        ldy     #0
l0:     lda     ($F2), Y
        beq     out
        jsr     OSASCI
        iny
        bne     l0
out:    rts
.endproc
