;
; ROM-aware strlen function for BBC target
; Uses ROM version if available, falls back to local implementation
;

        .export         _strlen_rom_demo
        .import         clib_rom_available
        .importzp       ptr1, ptr2

        .code

; _strlen_rom_demo - Example ROM-aware string length function
; Input: ptr to string in A/X (low/high)
; Output: length in A/X
; Destroys: A, X, Y
_strlen_rom_demo:
        ; Store string pointer
        sta     ptr1
        stx     ptr1+1
        
        ; Check if ROM is available
        lda     clib_rom_available
        beq     use_local_strlen        ; ROM not available, use local version
        
        ; ROM is available - call ROM strlen at $999C
        lda     ptr1
        ldx     ptr1+1
        jmp     $999C                   ; Jump to ROM strlen function
        
use_local_strlen:
        ; Fallback: local strlen implementation
        ldy     #0                      ; Initialize counter
        lda     ptr1
        sta     ptr2
        lda     ptr1+1
        sta     ptr2+1
        
count_loop:
        lda     (ptr2),y                ; Get character
        beq     done                    ; If zero, we're done
        iny                             ; Increment counter
        bne     count_loop              ; Continue if Y hasn't wrapped
        
        ; Handle strings > 255 chars (increment high byte)
        inc     ptr2+1
        jmp     count_loop
        
done:
        ; Return count in A/X (Y contains low byte)
        tya                             ; A = low byte of count
        ldx     #0                      ; X = high byte (0 for strings < 256)
        rts


