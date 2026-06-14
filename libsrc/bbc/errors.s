; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; Routines for setting errorno and returning -1L

        .include        "errno.inc"
        .export         einval
        .export         emfile
        .export         ebadf
        .export         eio

        .export         errout
        .export         errout2

        .importzp       sreg
einval:
        lda     #<EINVAL
        bne     errout

emfile: lda     #<EMFILE
        bne     errout

ebadf:  lda     #<EBADF
        bne     errout

eio:    lda     #<EIO
        bne     eio

errout: sta     ___errno
errout2:
        ldx     #0
        stx     ___errno + 1
        dex
        txa
        sta     sreg
        sta     sreg + 1
        rts
