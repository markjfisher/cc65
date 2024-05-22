
; Dominic Beesley 2005
; OSLib implementation for BBC/Master Target 
;
; xosfile_delete
;

        .export         _xosfile_delete

        .import         osfile_alloc_block
        .import         osfile_store_fn
        .import         osfile_callosfile
        .import         xosfile_ret_read_delete_load
        .import         _clear_brk_ret
        .import         _set_brk_ret
        .import         ldaxysp
        .import         addysp
        .importzp       c_sp

        .include        "osfile.inc"

;;extern os_error *xosfile_delete (char const *file_name,
;      fileswitch_object_type *obj_type,
;      bits32 *load_addr,
;      bits32 *exec_addr,
;      long *size,
;      fileswitch_attr *attr);
;extern fileswitch_object_type osfile_delete (char const *file_name,
;      bits32 *load_addr,
;      bits32 *exec_addr,
;      long *size,
;      fileswitch_attr *attr);


.proc _xosfile_delete

        jsr     osfile_alloc_block  ; Allocates OSFILE block + filename buffer, sets up ptr2
  
        ; Get filename pointer (offset by 18-byte OSFILE block + 128-byte filename buffer)
        ldy     #18 + 128 + 11
        jsr     ldaxysp
        jsr     osfile_store_fn

        jsr     _set_brk_ret
        bne     er

        lda     #OSFile_Delete
        jsr     osfile_callosfile

        ; Clean up the 128-byte filename buffer
        lda     #128
        jsr     addysp

        ldy     #18 + 12
        jsr     xosfile_ret_read_delete_load
        jsr     _clear_brk_ret
        lda     #0
        tax
        rts

er:
        ; Clean up the 128-byte filename buffer on error path too
        lda     #128
        jsr     addysp
        ldy     #18 + 12
        jsr     addysp
        lda     $fd
        ldx     $fe
        rts

.endproc
