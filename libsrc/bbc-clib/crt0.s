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
        
        .import         brkret
        .import         trap_brk, release_brk
        .import         OSWRCH                  ; For debug output
        
        .export         __Cstart
        .export         _exit_bits
                
        .include "zeropage.inc"
        .include "oslib/os.inc"
        .include "oslib/osbyte.inc"
        
        .bss
save_s:        .res        1                ; save stack pointer before entering main
                                ; exit can be called from any level!

.segment        "STARTUP"

__Cstart:

reset:
        ; Debug: Print startup indicator
        lda        #'S'
        jsr        OSWRCH
        
        jsr        zerobss
        jsr        disable_cursor_edit
        jsr        init_stack
        
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

        tsx
        stx        save_s                
        
        jsr        callmain

_exit_bits:        ; AX contains exit code, store LSB in user flag
        

        tax
        ldy        #0
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
        

        .bss
oldeventv:         .res        2
oldescen:          .res        1        ; was escape event enabled before?
