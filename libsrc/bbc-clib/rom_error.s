;
; ROM error handling for bbc-clib target
; Displays error message when ROM is not present
;

        .export         print_error_and_exit
        .importzp       ptr1

        .include "oslib/os.inc"

        .code

; print_error_and_exit - Display error message and exit
; Input: A/X = pointer to null-terminated error message (low/high)
; Does not return
print_error_and_exit:
        ; Store message pointer
        sta     ptr1
        stx     ptr1+1
        
        ; Print error message character by character
        ldy     #0
print_loop:
        lda     (ptr1),y
        beq     print_done
        jsr     OSWRCH
        iny
        bne     print_loop
        
print_done:
        ; Print newline
        lda     #13
        jsr     OSWRCH
        lda     #10  
        jsr     OSWRCH
        
        ; Simple return to OS (no complex cleanup needed in early startup)
        rts



        .rodata
rom_error_msg:
        .byte   "ERROR: cc65 CLIB ROM not found", 0
        .byte   "Please install cc65 CLIB ROM in sideways slot 1", 0

        .export rom_error_msg
