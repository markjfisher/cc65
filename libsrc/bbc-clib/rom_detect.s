;
; BBC Micro ROM Detection for cc65 CLIB
; Checks for presence of cc65 CLIB sideways ROM in slot 1
;

        .export         detect_clib_rom
        .export         clib_rom_available

        .include "oslib/os.inc"

        .bss
clib_rom_available:     .res    1       ; 0=no ROM, 1=ROM available

        .code

; detect_clib_rom - Check for cc65 CLIB ROM presence
; Returns: A=1 if ROM found, A=0 if not found
; Destroys: A, X, Y
detect_clib_rom:
        ; Default to no ROM
        lda     #0
        sta     clib_rom_available
        
        ; Check ROM slot 1 ($8000-$BFFF)
        ; BBC ROM header format:
        ; $8000: Language entry (3 bytes: 0,0,0 for service ROM)
        ; $8003: Service entry (JMP instruction = $4C)
        ; $8006: ROM type
        ; $8007: Copyright offset
        ; $8008: Version
        ; $8009: Title string
        
        ; First check if there's a valid ROM header
        lda     $8000           ; Should be 0 for service ROM
        bne     no_rom
        lda     $8001           ; Should be 0
        bne     no_rom  
        lda     $8002           ; Should be 0
        bne     no_rom
        
        ; Check for JMP instruction at service entry
        lda     $8003           ; Should be $4C (JMP)
        cmp     #$4C
        bne     no_rom
        
        ; Check ROM type (we use $81)
        lda     $8006
        cmp     #$81
        bne     no_rom
        
        ; Check for our ROM title string "cc65 CLIB"
        ; Title starts at $8009
        ldx     #0
title_loop:
        lda     expected_title,x
        beq     title_match     ; End of string
        cmp     $8009,x
        bne     no_rom
        inx
        cpx     #9              ; Length of "cc65 CLIB"
        bcc     title_loop
        
title_match:
        ; ROM found and verified!
        lda     #1
        sta     clib_rom_available
        rts

no_rom:
        lda     #0
        sta     clib_rom_available
        rts

        .rodata
expected_title:
        .byte   "cc65 CLIB", 0
