;
; Dominic Beesley 2005, Mark Fisher 2025
; OSLib implementation for BBC/Master Target

; osfile_* utility functions

; Create an OSFILE parameter block + filename buffer at TOS
; Sets up ptr2 to point to filename buffer for osfile_store_fn calls

        .import subysp
        .importzp c_sp, ptr2
        .export osfile_alloc_block

.proc osfile_alloc_block
        ; Allocate 18-byte OSFILE parameter block
        ldy        #18
        jsr        subysp
        
        ; Allocate 128 bytes for filename buffer
        ldy        #128
        jsr        subysp
        
        ; Set up ptr2 to point to the filename buffer (at current c_sp)
        ; This is used by osfile_store_fn calls that typically follow
        lda        c_sp
        sta        ptr2
        lda        c_sp + 1
        sta        ptr2 + 1
        
        rts
.endproc
