; Minimal debug crt0.s for ROM detection testing
; This version focuses only on ROM detection

        .export         __STARTUP__ : absolute = 1      ; Mark as startup
        .export         __Cstart

        .import         detect_clib_rom
        .import         clib_rom_available
        .import         clib_rom_slot
        .import         original_romsel
        .import         print_error_and_exit
        .import         rom_error_msg
        .import         _main
        .import         OSWRCH                  ; For debug output
                
        .include "zeropage.inc"

.segment        "STARTUP"

__Cstart:

reset:
        ; Debug: Print startup indicator
        lda        #'S'
        jsr        OSWRCH
        
        ; Debug: Print before ROM detection  
        lda        #'D'
        jsr        OSWRCH
        
        ; Check for cc65 CLIB ROM (REQUIRED!)
        jsr        detect_clib_rom
        
        ; Debug: Print after ROM detection
        lda        #'C'
        jsr        OSWRCH
        
        ; ROM must be present - exit with error if not found
        lda        clib_rom_available
        bne        rom_found
        
        ; Debug: Print ROM not found
        lda        #'N'
        jsr        OSWRCH
        
        ; ROM not found - display error and exit
        lda        #<rom_error_msg
        ldx        #>rom_error_msg
        jsr        print_error_and_exit
        ; After error message, halt completely - don't continue to rom_found
        rts
        
rom_found:
        ; Debug: Print ROM found
        lda        #'F'
        jsr        OSWRCH
        
        ; Debug: Print ROM slot number
        lda        #'['
        jsr        OSWRCH
        lda        clib_rom_slot
        clc
        adc        #'0'           ; Convert to ASCII digit
        jsr        OSWRCH
        lda        #']'
        jsr        OSWRCH
        
        ; Debug: Verify ROM function is accessible at expected address  
        ; Print first 4 bytes of _strlen at $999C (should be 85 5E 86 5F)
        lda        #'@'           ; Debug indicator
        jsr        OSWRCH
        
        ; Print 4 bytes in hex
        lda        $999C          ; First byte (should be $85)
        jsr        print_hex_byte
        lda        $999D          ; Second byte (should be $5E) 
        jsr        print_hex_byte
        lda        $999E          ; Third byte (should be $86)
        jsr        print_hex_byte
        lda        $999F          ; Fourth byte (should be $5F)
        jsr        print_hex_byte
        
call_main:
        ; Call main function
        jsr        _main
        
        ; Exit back to OS (simple return)
        rts

.segment        "CODE"

; Simple exit routine  
.export _exit
_exit:
        ; Invalidate ROM detection state to force fresh scan on next run
        lda     #0
        sta     clib_rom_available  ; Clear "ROM found" flag
        sta     clib_rom_slot       ; Clear slot number
        
        ; Restore original ROMSEL before exit
        lda     original_romsel
        sta     $FE30
        
        ; Print clear exit indicator
        lda     #13     ; Carriage return
        jsr     OSWRCH
        lda     #10     ; Line feed
        jsr     OSWRCH
        lda     #'['
        jsr     OSWRCH
        lda     #'E'
        jsr     OSWRCH
        lda     #'X'
        jsr     OSWRCH
        lda     #'I'
        jsr     OSWRCH
        lda     #'T'
        jsr     OSWRCH
        lda     #']'
        jsr     OSWRCH
        lda     #13
        jsr     OSWRCH
        lda     #10
        jsr     OSWRCH
        ; Return to OS cleanly
        rts

; print_hex_byte - Print byte in A as two hex digits
; Input: A = byte to print
; Destroys: A, X
print_hex_byte:
        ; Save original value
        pha
        
        ; Print high nibble
        lsr                     ; Shift right 4 times
        lsr
        lsr  
        lsr
        jsr     print_hex_digit
        
        ; Print low nibble
        pla                     ; Restore original
        and     #$0F            ; Keep only low nibble
        jsr     print_hex_digit
        rts

; print_hex_digit - Print single hex digit (0-15)
; Input: A = digit (0-15)
; Destroys: A
print_hex_digit:
        cmp     #10
        bcc     print_decimal   ; 0-9
        ; A-F 
        clc
        adc     #'A'-10
        jmp     print_char
print_decimal:
        clc
        adc     #'0'
print_char:
        jsr     OSWRCH
        rts
