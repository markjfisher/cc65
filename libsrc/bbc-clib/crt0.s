;
; Startup code for cc65 BBC CLIB ROM target
; REQUIRES cc65 CLIB ROM to be present in sideways slot 1
;
; This must be the *first* file on the linker command line
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
        .import         __HIMEM__               ; Top of memory (defined by linker)
        .importzp       c_sp                    ; C software stack pointer

        .import         brkret
        .import         trap_brk, release_brk

        .export         __Cstart
        .export         _exit_bits

        .include        "zeropage.inc"
        .include        "oslib/os.inc"
        .include        "oslib/osbyte.inc"

.segment        "STARTUP"

__Cstart:
        ; Debug A: Startup
        ; lda        #'A'
        ; jsr        OSWRCH

        ; Save stack pointer for clean exit
        tsx
        stx        save_s

        ; THIS IS DONE BELOW IN init_stack
        ; ; Setup minimal C runtime
        ; ; Setup software stack pointer to top of memory
        ; lda        #<__HIMEM__
        ; sta        c_sp
        ; lda        #>__HIMEM__
        ; sta        c_sp+1

reset:

        ; Zero BSS segment BEFORE ROM detection
        ; (so we don't zero out clib_rom_available after setting it)
        jsr        zerobss

        ; Check for cc65 CLIB ROM
        jsr        detect_clib_rom

        ; Debug B: After basic setup
        ; lda        #'B'
        ; jsr        OSWRCH

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

        ; Debug C: After interrupt setup
        ; lda        #'C'
        ; jsr        OSWRCH

        jsr        initlib

        ; tsx
        ; stx        save_s                

        ; Debug D: Before calling main
        ; lda        #'D'
        ; jsr        OSWRCH

        jsr        callmain

_exit_bits:        ; AX contains exit code, store LSB in user flag

        ; Debug: Print exit code before storing
        pha                     ; Save exit code on stack
        
        ; Print "Exit code: " 
        lda        #'E'
        jsr        OSWRCH
        lda        #'='
        jsr        OSWRCH
        
        ; Print exit code as hex
        pla                     ; Restore exit code
        pha                     ; Save again for later use
        jsr        print_hex_byte
        
        ; Print newline
        lda        #13
        jsr        OSWRCH
        lda        #10  
        jsr        OSWRCH
        
        ; Now store in user flag
        pla                     ; Restore exit code
        tax                     ; Move to X for OSBYTE
        ldy        #255
        lda        #osbyte_USER_FLAG
        jsr        OSBYTE

        lda        #'R'
        jsr        debug_checkpoint

        lda        #'A'
        jsr        debug_checkpoint

        lda        #'B'
        jsr        debug_checkpoint

        lda        #'C'
        jsr        debug_checkpoint

        lda        #'D'
        jsr        debug_checkpoint

        ; Print newline
        lda        #13
        jsr        OSWRCH
        lda        #10  
        jsr        OSWRCH

        jsr        donelib

        ; Debug checkpoint 1: After donelib
        lda        #'1'
        jsr        debug_checkpoint

        ; reset escape event state
        lda        oldescen
        bne        l1
        lda        #osbyte_DISABLE_EVENT
        ldx        #EVNTV_ESCAPE
        jsr        OSBYTE

        ; Debug checkpoint 2: After disable event
        lda        #'2'
        jsr        debug_checkpoint

l1:     sei

        jsr        release_brk

        ; Debug checkpoint 3: After release_brk
        lda        #'3'
        jsr        debug_checkpoint

        ; restore event handler
        lda        oldeventv
        sta        EVNTV
        lda        oldeventv + 1
        sta        EVNTV + 1
        cli

        ; Debug checkpoint 4: After restore event handler
        lda        #'4'
        jsr        debug_checkpoint

        jsr        restore_cursor_edit

        ; Debug checkpoint 5: After restore_cursor_edit
        lda        #'5'
        jsr        debug_checkpoint

        ; Invalidate ROM detection state to force fresh scan on next run
        lda        #0
        sta        clib_rom_available  ; Clear "ROM found" flag
        sta        clib_rom_slot       ; Clear slot number

        ; Restore original ROMSEL before exit
        lda        original_romsel
        sta        $FE30

        ; Debug checkpoint 6: Final checkpoint before exit
        lda        #'6'
        jsr        debug_checkpoint

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

; debug_checkpoint - Print checkpoint number and current user flag value
; Input: A = checkpoint character ('1', '2', etc.)
; Destroys: A, X, Y
debug_checkpoint:
        ; Print checkpoint character
        jsr        OSWRCH
        
        ; Print "="
        lda        #'='
        jsr        OSWRCH
        
        ; Read current user flag value
        ; ldx        #0
        ldy        #0
        lda        #osbyte_USER_FLAG
        jsr        OSBYTE

        ; Save the original user flag value we just read
        stx        temp_user_flag
        
        ; Print the user flag value in hex
        txa                     ; Move returned value to A
        jsr        print_hex_byte
        
        ; Print space for readability
        lda        #' '
        jsr        OSWRCH

        ; Restore the original value (Call 2 of workaround)
        ldx        temp_user_flag  ; X=original value to restore
        ldy        #255            ; Y=255 for restoration mode
        lda        #osbyte_USER_FLAG
        jsr        OSBYTE

        rts

        .bss
oldeventv:         .res        2
oldescen:          .res        1        ; was escape event enabled before?
save_s:            .res        1        ; old stack pointer
temp_user_flag:    .res        1        ; temporary storage for user flag value
