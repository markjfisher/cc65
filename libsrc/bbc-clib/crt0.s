;
; Startup code for cc65 BBC CLIB ROM target
; REQUIRES cc65 CLIB ROM to be present in sideways slot 1
;

        .export         _exit
        .export         __STARTUP__ : absolute = 1      ; Mark as startup

        .import         initlib, donelib
        .import         zerobss
        .import         callmain        
        .import         preservezp, restorezp
        .import         _raise

        .import         disable_cursor_edit
        .import         restore_cursor_edit
        .import         init_stack
        .import         detect_clib_rom
        .import         clib_rom_available
        .import         clib_rom_slot
        .import         original_romsel
        .import         print_error_and_exit
        .import         rom_error_msg
        .import         OSWRCH                  ; For debug output
        .importzp       c_sp                    ; C software stack pointer

        .import         brkret
        .import         trap_brk, release_brk
        .importzp       clib_ws, clib_jptr

        .export         __Cstart
        .export         _exit_bits

        .include        "zeropage.inc"
        .include        "oslib/os.inc"
        .include        "oslib/osbyte.inc"
        .include        "bbc.inc"

; --- Workspace lives in BSS (RAM) ---
.segment "BSS"
        .export  __clib_ws_base
__clib_ws_base:
        .res 10

.segment        "STARTUP"
__Cstart:
        ; Save stack pointer for clean exit
        tsx
        stx        save_s

        lda     #<__clib_ws_base
        sta     clib_ws
        lda     #>__clib_ws_base
        sta     clib_ws+1

        ; save the exit location into workspace for break handler
        lda     #<_exit_bits
        ldy     #WS_EXIT_BITS_LO
        sta     (clib_ws),y
        lda     #>_exit_bits
        iny
        sta     (clib_ws),y

reset:

        ; Zero BSS segment BEFORE ROM detection
        ; (so we don't zero out clib_rom_available after setting it)
        jsr        zerobss

        ; Check for cc65 CLIB ROM
        jsr        detect_clib_rom

        ; ROM must be present - exit with error if not found
        lda        clib_rom_available
        bne        rom_found

        ; ROM not found - display error and exit
        lda        #<rom_error_msg
        ldx        #>rom_error_msg
        jsr        print_error_and_exit
        ; After error message, return to the user
        ; debatable if we care about the stack pointer value restoration
        rts

rom_found:
        jsr        disable_cursor_edit
        ; setup c_sp for software stack pointer
        jsr        init_stack

        ; disable interrupts while we setup the vectors
        sei

        ; set up escape handler
        lda        EVNTV
        sta        oldeventv
        lda        EVNTV + 1
        sta        oldeventv + 1

        lda        #<eschandler
        sta        EVNTV
        lda        #>eschandler
        sta        EVNTV + 1

        jsr        trap_brk

        ; reenable interrupts
        cli

        ; enable escape event
        lda        #osbyte_ENABLE_EVENT
        ldx        #EVNTV_ESCAPE
        jsr        OSBYTE
        stx        oldescen

        jsr        initlib

        jsr        callmain

_exit_bits:        ; AX contains exit code, store LSB in user flag

        ; Save the exit code in user flag
        tax                     ; Move to X for OSBYTE set user flag.
        ldy        #255
        lda        #osbyte_USER_FLAG
        jsr        OSBYTE

        jsr        donelib

        ; reset escape event state
        lda        oldescen
        bne        l1
        lda        #osbyte_DISABLE_EVENT
        ldx        #EVNTV_ESCAPE
        jsr        OSBYTE

l1:     sei

        jsr        release_brk

        ; restore event handler
        lda        oldeventv
        sta        EVNTV
        lda        oldeventv + 1
        sta        EVNTV + 1
        cli

        jsr        restore_cursor_edit

        ; Invalidate ROM detection state to force fresh scan on next run
        lda        #0
        sta        clib_rom_available  ; Clear "ROM found" flag
        sta        clib_rom_slot       ; Clear slot number

        ; Restore original ROMSEL before exit
        lda        original_romsel
        sta        $FE30

exit:   rts

_exit:  ldx        save_s                ; force return to OS
        txs
        jmp        _exit_bits

eschandler:
        php        ;push flags
        cmp        #EVNTV_ESCAPE
        bne        nohandle

        pha        ; push regs
        txa
        pha
        tya
        pha

        ; preserve zp
        jsr        preservezp

        cli                        ; reenable interrupts

        ldx        #0
        lda        #3              ; SIGINT ???
        jsr        _raise

        sei                        ; disable interrupts, as we pass it on...

        ; restore zp
        jsr        restorezp

        pla
        tay
        pla
        tax
        pla
        plp
        rts

nohandle:
        plp
        jmp        (oldeventv)


; print_hex_byte - Print byte in A as two hex digits
; Input: A = byte to print
; Destroys: A, X
; print_hex_byte:
;         ; Save original value
;         pha

;         ; Print high nibble
;         lsr                     ; Shift right 4 times
;         lsr
;         lsr  
;         lsr
;         jsr     print_hex_digit

;         ; Print low nibble
;         pla                     ; Restore original
;         and     #$0F            ; Keep only low nibble
;         jsr     print_hex_digit
;         rts

; ; print_hex_digit - Print single hex digit (0-15)
; ; Input: A = digit (0-15)
; ; Destroys: A
; print_hex_digit:
;         cmp     #10
;         bcc     print_decimal   ; 0-9
;         ; A-F 
;         clc
;         adc     #'A'-10
;         jmp     print_char
; print_decimal:
;         clc
;         adc     #'0'
; print_char:
;         jsr     OSWRCH
;         rts


        .bss
oldeventv:         .res        2
oldescen:          .res        1        ; was escape event enabled before?
save_s:            .res        1        ; old stack pointer
