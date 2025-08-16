;
; BBC Micro ROM Detection for cc65 CLIB
; Checks for presence of cc65 CLIB sideways ROM in slot 1
;

        .export         detect_clib_rom
        .export         clib_rom_available
        .export         clib_rom_slot
        .export         original_romsel

        .include "oslib/os.inc"

        .bss
clib_rom_available:     .res    1       ; 0=no ROM, 1=ROM available
clib_rom_slot:          .res    1       ; ROM slot number (0-15) where CLIB ROM found
original_romsel:        .res    1       ; Original ROMSEL value to restore at exit

        .code

; detect_clib_rom - Scan sideways ROM slots for cc65 CLIB ROM
; Returns: A=1 if ROM found, A=0 if not found
; Destroys: A, X, Y
detect_clib_rom:
        ; Default to no ROM
        lda     #0
        sta     clib_rom_available
        sta     clib_rom_slot
        
        ; Save current ROMSEL value
        lda     $FE30
        pha
        
        ; Scan ROM slots 0-15
        ldx     #0              ; Start with slot 0
        
slot_loop:
        ; Page in ROM slot X
        stx     $FE30           ; Write slot number to ROMSEL
        
        ; Check if this slot contains our ROM
        jsr     check_current_rom
        bne     found_rom       ; A != 0 means ROM found
        
        ; Try next slot
        inx
        cpx     #16             ; Check slots 0-15
        bcc     slot_loop
        
        ; ROM not found in any slot
        pla                     ; Restore original ROMSEL
        sta     $FE30
        sta     original_romsel ; Also store for consistency
        lda     #0
        sta     clib_rom_available
        rts
        
found_rom:
        ; Store the slot number where ROM was found
        stx     clib_rom_slot
        lda     #1
        sta     clib_rom_available
        
        ; DON'T restore original ROMSEL - keep our ROM active!
        ; The ROM slot X is already paged in from the scan
        ; Store original ROMSEL for later restoration at exit
        pla
        sta     original_romsel
        rts

; check_current_rom - Check if ROM at $8000 is our CLIB ROM
; Returns: A=1 if our ROM, A=0 if not
; Destroys: A, Y
check_current_rom:
        ; BBC ROM header format:
        ; $8000: Language entry (3 bytes: 0,0,0 for service ROM)
        ; $8003: Service entry (JMP instruction = $4C)
        ; $8006: ROM type
        ; $8007: Copyright offset
        ; $8008: Version
        ; $8009: Title string
        
        ; First check if there's a valid ROM header
        lda     $8000           ; Should be 0 for service ROM
        bne     not_our_rom
        lda     $8001           ; Should be 0
        bne     not_our_rom  
        lda     $8002           ; Should be 0
        bne     not_our_rom
        
        ; Check for JMP instruction at service entry
        lda     $8003           ; Should be $4C (JMP)
        cmp     #$4C
        bne     not_our_rom
        
        ; Check ROM type (we use $82)
        lda     $8006
        cmp     #$82
        bne     not_our_rom
        
        ; Check for our ROM title string "cc65 CLIB"
        ; Title starts at $8009
        ldy     #0
title_check_loop:
        lda     expected_title,y
        beq     our_rom_found   ; End of string - match!
        cmp     $8009,y
        bne     not_our_rom
        iny
        cpy     #9              ; Length of "cc65 CLIB"
        bcc     title_check_loop
        
our_rom_found:
        ; This is our ROM!
        lda     #1
        rts

not_our_rom:
        lda     #0
        rts

        .rodata
expected_title:
        .byte   "cc65 CLIB", 0
