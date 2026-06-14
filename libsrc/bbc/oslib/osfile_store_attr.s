; Dominic Beesley, 2005
; Mark Fisher, 2026
;

;       OSLib implementation for BBC/Master Target      
;

        .export osfile_store_attr

        .import steaxysp

.proc osfile_store_attr
        ldy     #$E
        jsr     steaxysp
        rts
.endproc
