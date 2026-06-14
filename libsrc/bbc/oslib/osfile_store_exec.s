; Dominic Beesley, 2005
; Mark Fisher, 2026
;


;       OSLib implementation for BBC/Master Target      
;
        .export osfile_store_exec

        .import steaxysp

.proc osfile_store_exec
        ldy     #6
        jsr     steaxysp
        rts
.endproc
