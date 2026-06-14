; Dominic Beesley, 2005
; Mark Fisher, 2026
;

;
; BBC Micro ROM Detection for cc65 CLIB
; Checks for presence of cc65 CLIB sideways ROM in slot 1
;

        .export         detect_clib_rom
        .export         clib_rom_available
        .export         clib_rom_slot
        .export         original_romsel

        .include        "oslib/os.inc"

        .bss
clib_rom_available:     .res    1       ; 0=no ROM, 1=ROM available
clib_rom_slot:          .res    1       ; ROM slot number (0-15) where CLIB ROM found
original_romsel:        .res    1       ; Original ROMSEL value to restore at exit

        .code

; https://www.sprow.co.uk/bbc/library/sidewrom.pdf
;
; Changing ROMs
; The currently selected ROM number set with the write only ROM select latch at address &FE30. As &FE30
; is write only a RAM copy of the currently selected ROM is held at &F4. To manually alter the current ROM
; perform
;  LDX#romnum
;  STX&F4
;  STX&FE30
; Note that &F4 is written before the hardware register incase an interrupt occurs between the two stores. Ths
; MOS preserves &F4 during interrupt processing so on exit from the interrupt handler the correct ROM will
; be reselected.
; Unless the desired target address in "romnum" is the same as that at which this code resides, the changeover
; of ROMs will need to be performed from RAM

ROMSEL_CURRENT  = $F4
ROMSEL          = $FE30

; detect_clib_rom - Scan sideways ROM slots for cc65 CLIB ROM
; Returns: A=1 if ROM found, A=0 if not found
; Destroys: A, X, Y
detect_clib_rom:
        ; Default to no ROM
        lda     #0
        sta     clib_rom_available
        sta     clib_rom_slot

        ; Save current ROMSEL value, this is held in &F4, as ROMSEL is write only
        lda     ROMSEL_CURRENT
        pha

        ; Scan ROM slots 15 to 0
        ldx     #$0F            ; Start with top slot, as it has highest priority

slot_loop:
        ; Page in ROM slot X
        stx     ROMSEL_CURRENT
        stx     ROMSEL

        ; Check if this slot contains our ROM
        jsr     check_current_rom
        bcc     found_rom       ; C == 0 means ROM found

        ; Try next slot
        dex
        bpl     slot_loop

        ; ROM not found in any slot
        pla                     ; Restore original ROMSEL
        sta     ROMSEL_CURRENT
        sta     ROMSEL
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

        ; Check for our ROM title string "cc65 CLIB".
        ; Title starts at $8009. The expected_title string is NUL-terminated, so
        ; the beq on the terminator is what ends a successful match. (The old
        ; code also had a `cpy #9 / bcc` guard which exited the loop one
        ; iteration too early — after matching all 9 chars y=9, the bcc was not
        ; taken and it fell through to not_our_rom, so a matching ROM was never
        ; detected. The NUL terminator alone is the correct, sufficient bound.)
        ; returns C=0 for match, C=1 for no match
        ldy     #0
title_check_loop:
        lda     expected_title,y
        beq     our_rom_found   ; reached NUL terminator - all chars matched
        cmp     $8009,y
        bne     not_our_rom
        iny
        bne     title_check_loop ; always loops (NUL terminator ends the match)

not_our_rom:
        sec
        rts

our_rom_found:
        clc
        rts

        .rodata
expected_title:
        .byte   "cc65 CLIB", 0  ; needs the 0 terminator for the string match routine. shorter this way.
