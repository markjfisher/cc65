; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; off_t __fastcall__ lseek(int fd, off_t offset, int whence);

        .export         _lseek

        .import         __fd_getflags, __fd_getchannel
        .import         __fd_getseek, __fd_setseek
        .import         ___ptr, ___ext
        .import         popax, subysp, incsp4
        .import         errout, errout2
        .importzp       c_sp, ptr1, sreg, tmp1, tmp2, tmp3

        .include        "errno.inc"
        .include        "stdio.inc"
        .include        "fdtable.inc"

.proc _lseek
        sta     tmp3            ; whence low byte
        txa
        sta     tmp1            ; whence high byte

        jsr     popax           ; offset low word
        sta     ptr1
        stx     ptr1+1
        jsr     popax           ; offset high word
        sta     ptr1+2
        stx     ptr1+3
        jsr     popax           ; fd low byte
        sta     tmp2

        ldy     #$04
        jsr     subysp
        ldy     #$00
        lda     ptr1
        sta     (c_sp),y
        iny
        lda     ptr1+1
        sta     (c_sp),y
        iny
        lda     ptr1+2
        sta     (c_sp),y
        iny
        lda     ptr1+3
        sta     (c_sp),y

        lda     tmp1
        beq     :+
        jmp     @einval
:       lda     tmp3
        cmp     #$03
        bcc     :+
        jmp     @einval
:
        lda     tmp2
        jsr     __fd_getflags
        cmp     #$FF
        bne     :+
        jsr     incsp4
        rts
:
        sta     tmp1            ; flags
        and     #FD_FLAG_CON
        beq     :+
        jmp     @epipe
:

        lda     tmp3
        cmp     #SEEK_SET
        beq     @seek_set
        cmp     #SEEK_CUR
        beq     @seek_cur

        lda     tmp2
        jsr     __fd_getchannel
        cmp     #$FF
        bne     :+
        jsr     incsp4
        jmp     errout2
:
        jsr     ___ext
        jmp     @add_offset

@seek_set:
        lda     #$00
        tax
        sta     sreg
        sta     sreg+1
        beq     @add_offset

@seek_cur:
        lda     tmp1
        and     #FD_FLAG_SEEKPEND
        beq     @read_ptr
        lda     tmp2
        jsr     __fd_getseek
        jmp     @add_offset

@read_ptr:
        lda     tmp2
        jsr     __fd_getchannel
        cmp     #$FF
        bne     :+
        jsr     incsp4
        jmp     errout2
:
        jsr     ___ptr

@add_offset:
        clc
        ldy     #$00
        adc     (c_sp),y
        sta     ptr1
        txa
        iny
        adc     (c_sp),y
        sta     ptr1+1
        lda     sreg
        iny
        adc     (c_sp),y
        sta     ptr1+2
        lda     sreg+1
        iny
        adc     (c_sp),y
        sta     ptr1+3

        lda     ptr1+3
        bmi     @einval

        ldy     #$00
        lda     ptr1
        sta     (c_sp),y
        iny
        lda     ptr1+1
        sta     (c_sp),y
        iny
        lda     ptr1+2
        sta     (c_sp),y
        iny
        lda     ptr1+3
        sta     (c_sp),y

        lda     tmp2
        jsr     __fd_setseek
        cmp     #$FF
        bne     @return_pos
        rts

@return_pos:
        lda     ptr1+3
        sta     sreg+1
        lda     ptr1+2
        sta     sreg
        lda     ptr1
        ldx     ptr1+1
        rts

@einval:
        jsr     incsp4
        lda     #<EINVAL
        jmp     errout

@epipe: jsr     incsp4
        lda     #<ESPIPE
        jmp     errout
.endproc
