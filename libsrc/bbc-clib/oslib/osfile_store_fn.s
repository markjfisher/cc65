;
; Dominic Beesley 2005, Mark Fisher 2025
; OSLib implementation for BBC/Master Target 
;
; osfile_* utility functions
;
; Assumes an OSFILE parameter block is at TOS
; Store filename pointer

        .import         steaxysp
        .export         osfile_store_fn
        .importzp       ptr1, ptr2

  ; Takes filename pointer in A/X and buffer pointer in ptr2
  ; Caller must set up ptr2 to point to a 128-byte buffer
.proc osfile_store_fn  
        sta     ptr1
        stx     ptr1 + 1

        ; Copy string and convert null terminator to CR
        ; ptr2 should already point to the buffer
        ldy     #0
lp:     lda     (ptr1), y
        beq     dn
        sta     (ptr2), y
        iny
        cpy     #127   ; Limit to 127 chars (+ CR = 128 bytes)
        bcc     lp
        dey
dn:     lda     #$d
        sta     (ptr2), y

        ; Store buffer address in OSFILE parameter block
        ldy     #0
        lda     ptr2
        ldx     ptr2 + 1
        jsr     steaxysp
        rts

.endproc
