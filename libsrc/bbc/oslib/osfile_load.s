
; Dominic Beesley 2005, Mark Fisher 2025
; OSLib implementation for BBC/Master Target        
;
; osfile_delete
;

        .export   _osfile_load

        .import   osfile_alloc_block
        .import   osfile_store_fn
        .import   osfile_store_load
        .import   osfile_callosfile
        .import   osfile_ret_read_delete_load
        .import   ldeaxysp
        .import   ldaxysp
        .import   addysp
        .importzp c_sp, sreg

        .include "osfile.inc"

;extern os_error *xosfile_load (char const *file_name,
;      byte *addr,
;      fileswitch_object_type *obj_type,
;      bits32 *load_addr,
;      bits32 *exec_addr,
;      long *size,
;      fileswitch_attr *attr);
;extern fileswitch_object_type osfile_load (char const *file_name,      10
;      byte *addr,                                                      8
;      bits32 *load_addr                                                6
;      bits32 *exec_addr,                                               4
;      long *size,                                                      2
;      fileswitch_attr *attr);                                          0

.proc _osfile_load
        jsr     osfile_alloc_block                ; Allocates OSFILE block + filename buffer, sets up ptr2

        ; Get filename pointer (offset by 18-byte OSFILE block + 128-byte filename buffer)
        ldy     #18 + 128 + 11
        jsr     ldaxysp
        jsr     osfile_store_fn

        ldy     #18 + 128 + 9
        jsr     ldaxysp                ; if addr is non-zero then setup
        cmp     #0
        bne     setupload
        cpx     #0
        bne     setupload

        lda     #1
        ldy     #6
        sta     (c_sp), y

d:      lda     #OSFile_Load
        jsr     osfile_callosfile

        ; A holds the returned object type; pass it straight to the return
        ; handler without freeing the buffer first (see osfile_read.s). The
        ; handler frees 18 (block) + 128 (buffer) + 12 (6 pointer args).
        ldy     #18 + 128 + 12
        jmp     osfile_ret_read_delete_load

setupload:
        pha
        lda     #0
        ; block+6 (exec-addr low byte) = 0 => load at the caller-supplied addr.
        ; The block is at c_sp+0 (the filename buffer sits above it), so the
        ; offset is just 6.
        ldy     #6
        sta     (c_sp),  Y
        sta     sreg
        sta     sreg + 1
        pla
        jsr     osfile_store_load
        jmp     d

.endproc
