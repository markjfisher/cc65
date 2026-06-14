; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; time_t _systime(void);

        .export         __systime

        .import         _mktime
        .import         subysp, addysp
        .import         OSWORD
        .importzp       c_sp, ptr1, ptr2, sreg, tmp1, tmp2, tmp3

        .include        "time.inc"

TM_SIZE          = .sizeof(tm)
BLOCK_OFFSET     = TM_SIZE
FRAME_SIZE       = TM_SIZE + 7

.proc _bcd_to_bin
        sta     tmp1
        and     #$0F
        sta     tmp2
        lda     tmp1
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     tmp1
        asl     a
        sta     tmp3
        asl     a
        asl     a
        clc
        adc     tmp3
        adc     tmp2
        rts
.endproc

.proc __systime
        ldy     #FRAME_SIZE
        jsr     subysp

        lda     c_sp
        sta     ptr2
        clc
        adc     #BLOCK_OFFSET
        sta     ptr1
        lda     c_sp+1
        sta     ptr2+1
        adc     #$00
        sta     ptr1+1

        ldy     #$00
        lda     #$01
        sta     (ptr1),y

        lda     #$0E
        ldx     ptr1
        ldy     ptr1+1
        jsr     OSWORD

        ldy     #$00
@decode:
        lda     (ptr1),y
        jsr     _bcd_to_bin
        sta     (ptr1),y
        iny
        cpy     #$06
        bcc     @decode

        ldy     #tm::tm_sec
        lda     #$00
        sta     (ptr2),y
        iny
        sta     (ptr2),y
        dey
        ldy     #$06
        lda     (ptr1),y
        ldy     #tm::tm_sec
        sta     (ptr2),y

        ldy     #$05
        lda     (ptr1),y
        ldy     #tm::tm_min
        sta     (ptr2),y
        iny
        lda     #$00
        sta     (ptr2),y

        ldy     #$04
        lda     (ptr1),y
        ldy     #tm::tm_hour
        sta     (ptr2),y
        iny
        lda     #$00
        sta     (ptr2),y

        ldy     #$02
        lda     (ptr1),y
        ldy     #tm::tm_mday
        sta     (ptr2),y
        iny
        lda     #$00
        sta     (ptr2),y

        ldy     #$01
        lda     (ptr1),y
        sec
        sbc     #$01
        ldy     #tm::tm_mon
        sta     (ptr2),y
        iny
        lda     #$00
        sta     (ptr2),y

        ldy     #$00
        lda     (ptr1),y
        cmp     #$46
        bcs     @year_ok
        clc
        adc     #100
@year_ok:
        ldy     #tm::tm_year
        sta     (ptr2),y
        iny
        lda     #$00
        sta     (ptr2),y

        ldy     #tm::tm_wday
        lda     #$00
        sta     (ptr2),y
        iny
        sta     (ptr2),y
        iny
        sta     (ptr2),y
        iny
        sta     (ptr2),y
        iny
        sta     (ptr2),y
        iny
        sta     (ptr2),y

        lda     ptr2
        ldx     ptr2+1
        jsr     _mktime

        sta     ptr1
        stx     ptr1+1
        lda     sreg
        sta     ptr1+2
        lda     sreg+1
        sta     ptr1+3

        ldy     #FRAME_SIZE
        jsr     addysp

        lda     ptr1+2
        sta     sreg
        lda     ptr1+3
        sta     sreg+1
        lda     ptr1
        ldx     ptr1+1
        rts
.endproc
