; Dominic Beesley, 2005
; Mark Fisher, 2026
;

;       OSLib implementation for BBC/Master Target      

        .export osfile_store_load

        .import steaxysp

.proc osfile_store_load
        ldy     #2
        jsr     steaxysp
        rts
.endproc
