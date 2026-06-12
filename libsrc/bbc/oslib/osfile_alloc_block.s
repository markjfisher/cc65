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
        ; The OSFILE parameter block must sit at the LOWEST address (c_sp),
        ; because the osfile_store_* helpers write its fields at SP+0..SP+17 and
        ; osfile_callosfile passes c_sp to OSFILE as the block address. The
        ; 128-byte filename buffer must sit ABOVE it, or the filename string
        ; and the block overlap and OSFILE sees a garbage name ("Bad string").
        ;
        ; So allocate the filename buffer first (higher address), then the
        ; block (lower address = c_sp), and point ptr2 at the buffer (c_sp+18).

        ; Allocate 128 bytes for filename buffer (ends up above the block)
        ldy        #128
        jsr        subysp

        ; Allocate 18-byte OSFILE parameter block (ends up at c_sp)
        ldy        #18
        jsr        subysp

        ; ptr2 = c_sp + 18  -> the filename buffer, just above the block
        clc
        lda        c_sp
        adc        #18
        sta        ptr2
        lda        c_sp + 1
        adc        #0
        sta        ptr2 + 1

        rts
.endproc
