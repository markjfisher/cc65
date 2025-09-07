
; Dominic Beesley 2005, Mark Fisher 2025
; OSLib implementation for BBC/Master Target 
;
; osfile_* utility functions
;
; shared startup for all the osfile_write_X functions

        .export         osfile_write_X_start

        .import         ldaxysp
        .import         ldeaxysp
        .import         osfile_alloc_block 
        .import         osfile_store_fn
        .importzp       c_sp  

.proc osfile_write_X_start

        jsr     osfile_alloc_block ; Allocates OSFILE block + filename buffer, sets up ptr2

        ; Get filename pointer (offset by 18-byte OSFILE block + 128-byte filename buffer) 
        ldy     #18 + 128 + 5  ; file_name
        jsr     ldaxysp
  
        jsr     osfile_store_fn
  
        ldy     #18 + 128 + 3  ; parameter data
        jsr     ldeaxysp
  
        rts

  .endproc
