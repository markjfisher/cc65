; Dominic Beesley, 2005
; Mark Fisher, 2026
;


;       OSLib implementation for BBC/Master Target      

        .import steaxysp
        .export osfile_store_len

.proc osfile_store_len
        ldy     #$A
        jsr     steaxysp
        rts
.endproc
