; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; int open(const char *name, int flags, ...);

        .export         _open

        .import         __fd_getfree
        .import         _osfind
        .import         _close_file
        .import         ___ext, ___ptr2
        .import         addysp, subysp
        .import         ldaxysp, pusha
        .import         errout
        .import         OSFILE
        .importzp       c_sp, ptr1, ptr2, sreg, tmp1, tmp2, tmp3

        .include        "fcntl.inc"
        .include        "errno.inc"
        .include        "fdtable.inc"
        .include        "oslib/osfile.inc"

BLOCK_SIZE       = 18
FILENAME_SIZE    = 128
META_ACCESS      = BLOCK_SIZE + FILENAME_SIZE
META_EXISTS      = META_ACCESS + 1
FRAME_SIZE       = BLOCK_SIZE + FILENAME_SIZE + 2

.proc check_exists
        lda     #$00
        ldy     #BLOCK_SIZE - 1
@clear:  sta     (ptr2),y
        dey
        bpl     @clear

        ldy     #$00
        lda     ptr1
        sta     (ptr2),y
        iny
        lda     ptr1+1
        sta     (ptr2),y

        lda     #OSFile_Read
        ldx     ptr2
        ldy     ptr2+1
        jsr     OSFILE
        rts
.endproc

.proc _open
        ldy     #FRAME_SIZE
        jsr     subysp

        lda     c_sp
        clc
        adc     #BLOCK_SIZE
        sta     ptr1
        lda     c_sp+1
        adc     #$00
        sta     ptr1+1

        ldy     #FRAME_SIZE + 3
        jsr     ldaxysp
        sta     ptr2
        stx     ptr2+1

        ldy     #$00
@copy:  lda     (ptr2),y
        beq     @term
        sta     (ptr1),y
        iny
        cpy     #127
        bcc     @copy
@term:  lda     #$0D
        sta     (ptr1),y

        lda     c_sp
        sta     ptr2
        lda     c_sp+1
        sta     ptr2+1

        ldy     #FRAME_SIZE + 1
        jsr     ldaxysp
        sta     tmp3

        lda     tmp3
        and     #O_RDWR
        sta     tmp2
        ldy     #META_ACCESS
        sta     (c_sp),y
        cmp     #O_RDONLY
        beq     @access_ok
        cmp     #O_WRONLY
        beq     @access_ok
        cmp     #O_RDWR
        beq     @access_ok
        jmp     @einval

@access_ok:
        lda     tmp3
        and     #O_TRUNC
        beq     :+
        lda     tmp2
        cmp     #O_RDONLY
        bne     @check_append
        jmp     @einval
:       

@check_append:
        lda     tmp3
        and     #O_APPEND
        beq     :+
        lda     tmp2
        cmp     #O_RDONLY
        bne     @check_exists
        jmp     @einval
:       

@check_exists:
        jsr     check_exists
        sta     tmp1
        ldy     #META_EXISTS
        sta     (c_sp),y

        lda     tmp3
        and     #(O_CREAT | O_EXCL)
        cmp     #(O_CREAT | O_EXCL)
        bne     @maybe_create
        lda     tmp1
        beq     @maybe_create
        jmp     @eexist

@maybe_create:
        lda     tmp1
        bne     @maybe_truncate
        lda     tmp3
        and     #O_CREAT
        bne     @choose_mode
        jmp     @enoent

@maybe_truncate:
        lda     tmp3
        and     #O_TRUNC
        beq     @choose_mode

@choose_mode:
        ldy     #META_ACCESS
        lda     (c_sp),y
        cmp     #O_RDONLY
        beq     @open_read

        cmp     #O_RDWR
        bne     :+
        lda     tmp3
        and     #O_APPEND
        bne     @use_update
        lda     tmp3
        and     #O_TRUNC
        bne     @open_write
        jmp     @use_update
:       

        lda     tmp3
        and     #O_APPEND
        bne     @use_update

        ldy     #META_EXISTS
        lda     (c_sp),y
        beq     @open_write

        lda     tmp3
        and     #O_TRUNC
        bne     @open_write
        beq     @use_update

@open_write:
        lda     #$80
        sta     tmp1
        lda     #FD_FLAG_WRITE
        bne     @do_open

@use_update:
        lda     #$C0
        sta     tmp1

        ldy     #META_ACCESS
        lda     (c_sp),y
        cmp     #O_RDWR
        beq     @open_update
        lda     #FD_FLAG_WRITE
        bne     @do_open

@open_read:
        lda     #$40
        sta     tmp1
        lda     #FD_FLAG_READ
        bne     @do_open

@open_update:
        lda     #FD_FLAG_READ | FD_FLAG_WRITE

@do_open:
        sta     tmp2
        lda     tmp1
        jsr     pusha
        lda     ptr1
        ldx     ptr1+1
        jsr     _osfind

        pha
        ldy     #FRAME_SIZE
        jsr     addysp
        pla
        sta     tmp1

        lda     tmp1
        beq     @io_error

        jsr     pusha
        lda     tmp2
        jsr     __fd_getfree
        cmp     #$FF
        bne     @got_fd
        cpx     #$FF
        bne     @got_fd

        lda     tmp1
        jsr     _close_file
        lda     #$FF
        tax
        rts

@got_fd: pha
        lda     tmp3
        and     #O_APPEND
        beq     @ret_fd

        lda     tmp1
        jsr     ___ext

        sta     ptr1
        stx     ptr1+1
        lda     sreg
        sta     ptr2
        lda     sreg+1
        sta     ptr2+1

        lda     tmp1
        jsr     pusha

        lda     ptr2
        sta     sreg
        lda     ptr2+1
        sta     sreg+1
        lda     ptr1
        ldx     ptr1+1
        jsr     ___ptr2

@ret_fd:
        pla
        ldx     #$00
        rts

@enoent:
        ldy     #FRAME_SIZE
        jsr     addysp
        lda     #<ENOENT
        jmp     errout

@eexist:
        ldy     #FRAME_SIZE
        jsr     addysp
        lda     #<EEXIST
        jmp     errout

@einval:
        ldy     #FRAME_SIZE
        jsr     addysp
        lda     #<EINVAL
        jmp     errout

@io_error:
        lda     #<EIO
        jmp     errout
.endproc
