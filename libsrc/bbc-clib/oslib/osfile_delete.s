
; Dominic Beesley 2005, Mark Fisher 2025
; OSLib implementation for BBC/Master Target        
;
; osfile_delete
;

; uses C stack to allocate 128 byte buffer for filename to avoid using BSS
; and thus making eligible for ROM

        .export   _osfile_delete

        .import   osfile_alloc_block
        .import   osfile_store_fn
        .import   osfile_callosfile
        .import   osfile_ret_read_delete_load
        .import   ldaxysp, addysp
        .importzp c_sp

        .include "osfile.inc"

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

.proc _osfile_delete
        ; Allocates OSFILE block + filename buffer, sets up ptr2
        jsr        osfile_alloc_block

        ; Get filename pointer (offset by 18-byte OSFILE block + 128-byte filename buffer)
        ldy     #18 + 128 + 9
        jsr     ldaxysp
        jsr     osfile_store_fn

        lda     #OSFile_Delete
        jsr     osfile_callosfile

        ; Clean up the 128-byte filename buffer
        lda     #128
        jsr     addysp

        ldy     #18 + 10
        jmp     osfile_ret_read_delete_load

.endproc
