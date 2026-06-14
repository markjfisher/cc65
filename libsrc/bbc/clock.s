; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; clock_t clock (void);
; unsigned _clocks_per_sec (void);

        .export         _clock
        .importzp       sreg

        .include        "oslib/os.inc"
        .include        "oslib/osword.inc"
.proc   _clock

        lda #<timeblock
        tax
        lda #>timeblock
        tay
        lda #OSWORD_READ_SYS_CLOCK
        jsr OSWORD

        lda timeblock + 3
        sta sreg+1
        lda timeblock + 2
        ldx timeblock + 1
        lda timeblock

        rts

.endproc

.bss
timeblock:      .res    5