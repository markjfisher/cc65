
; Dominic Beesley 2005
; OSLib implementation for BBC/Master Target 
;
; osfile_write_load
;
        .export         _osfile_write_exec

        .import         osfile_write_X_start
        .import         osfile_store_exec
        .import         osfile_callosfile
        .import         osfile_fndchk
        .import         ldeaxysp
        .import         ldaxysp
        .import         addysp

        .include        "osfile.inc"

;extern os_error *xosfile_write_load (char const *file_name,
;      bits32 load_addr);
;extern void osfile_write_load (char const *file_name,
;      bits32 load_addr);

.proc _osfile_write_exec

        jsr     osfile_write_X_start
        jsr     osfile_store_exec

        lda     #OSFile_WriteExec
        jsr     osfile_callosfile

        ; Clean up the 128-byte filename buffer allocated by osfile_write_X_start
        lda     #128
        jsr     addysp

        ; and the stack from the calling params
        ldy     #18 + 6
        jsr     addysp

        rts

.endproc
