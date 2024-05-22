; Dominic Beesley 27.04.2005

        .export         __fd_getfree

        .importzp       c_sp
        .import         fd_chan, fd_flags, emfile
        .import         incsp1
        .import         popa

        .include        "fdtable.inc"

; unsigned char __fastcall _fd_getfree(unsigned char channel, unsigned char flags)        
; // get a free fd, if not available returns -1
; // and sets errno to EMFILE
; // sets flags to flags, channel to channel

__fd_getfree:
        ; A = flags, channel is in C software stack

        ; don't corrupt A
        ldy     #FD_START
next:   ldx     fd_flags, y
        beq     gotfreefd
        iny
        cpy     #FD_MAX
        bcc     next

        ; failed to find a free FD, remove stack parameter, and exit with ___errno set to EMFILE
        jsr     incsp1
        jmp     emfile        

gotfreefd:
        ; Y contains the FD, A contains "flags"
        sta     fd_flags, y

        tya
        pha     ; save FD for the return
        tax     ; and use it as an index into fd_chan entries

        jsr     popa    ; fetch "channel", popa doesn't affect X
        sta     fd_chan - FD_START, x

        ; return the FD
        pla
        ldx     #$00
        rts
