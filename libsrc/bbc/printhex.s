; Dominic Beesley, 2005
; Mark Fisher, 2026
;

        .include "oslib/os.inc"
        .export printhex

printhex:
        pha
        and     #$F0
        clc
        ror
        ror
        ror
        ror
        cmp     #10
        bcc     xx
        adc     #$6
xx:     adc     #$30
        jsr     OSWRCH
        pla
        and     #$F
        cmp     #10
        bcc     yy
        adc     #$6
yy:     adc     #$30
        jsr     OSWRCH
        rts
