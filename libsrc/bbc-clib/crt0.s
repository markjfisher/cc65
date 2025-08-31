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
        .import         OSWRCH
        .import         _clear_brk_ret
        .import         cursor
        .import         setcursor

        ; .import         trap_brk, release_brk

        .export         __Cstart
        .export         _exit_main
        .export         _soft_abort_cleanup

        .include        "zeropage.inc"
        .include        "oslib/os.inc"
        .include        "oslib/osbyte.inc"

ROMSEL_CURRENT  := $F4
ROMSEL          := $FE30

.segment        "STARTUP"
__Cstart:

reset:

        ; Zero BSS segment BEFORE ROM detection
        ; (so we don't zero out clib_rom_available after setting it)
        jsr     zerobss

        ; Check for cc65 CLIB ROM
        jsr     detect_clib_rom

        ; ROM must be present - exit with error if not found
        lda     clib_rom_available
        bne     rom_found

        ; ROM not found - display error and exit
        lda     #<rom_error_msg
        ldx     #>rom_error_msg
        jsr     print_error_and_exit
        ; After error message, return to the user
        ; debatable if we care about the stack pointer value restoration
        rts

rom_found:
        jsr     disable_cursor_edit
        ; setup c_sp for software stack pointer
        jsr     init_stack

        ; disable interrupts while we setup the vectors
        sei

        ; set up escape handler
        lda     EVNTV
        sta     oldeventv
        lda     EVNTV + 1
        sta     oldeventv + 1

        lda     #<eschandler
        sta     EVNTV
        lda     #>eschandler
        sta     EVNTV + 1

        ; jsr     trap_brk

        ; reenable interrupts
        cli

        ; enable escape event
        lda     #osbyte_ENABLE_EVENT
        ldx     #EVNTV_ESCAPE
        jsr     OSBYTE
        stx     oldescen

        jsr     initlib

        ; Save stack pointer for clean exit
        tsx
        stx     save_s

        jsr     callmain

_exit_main:     ; AX contains exit code, store LSB in user flag

        ; Save the exit code in user flag
        tax                     ; Move to X for OSBYTE set user flag.
        ldy     #255
        lda     #osbyte_USER_FLAG
        jsr     OSBYTE

        jsr     _clear_brk_ret
        jsr     donelib

        ; Invalidate ROM detection state to force fresh scan on next run
        lda     #0
        sta     clib_rom_available  ; Clear "ROM found" flag
        sta     clib_rom_slot       ; Clear slot number

        ; Restore original ROMSEL before exit
        lda     original_romsel
        sta     ROMSEL_CURRENT
        sta     ROMSEL
        jsr     _cleanup_display

exit:
        rts

_exit:  ldx     save_s                ; force return to OS
        txs
        jmp     _exit_main

eschandler:
        php     ;push flags
        cmp     #EVNTV_ESCAPE
        bne     nohandle

        pha     ; push regs
        txa
        pha
        tya
        pha

        ; preserve zp
        jsr     preservezp

        cli                        ; reenable interrupts

        ldx     #0
        lda     #3              ; SIGINT ???
        jsr     _raise

        sei                        ; disable interrupts, as we pass it on...

        ; restore zp
        jsr     restorezp

        pla
        tay
        pla
        tax
        pla
        plp
        rts

nohandle:
        plp
        pha
        lda     oldeventv
        sta     @evj+1
        lda     oldeventv+1
        sta     @evj+2
        pla
@evj:   jmp     $FFFF           ; patched to oldeventv

_soft_abort_cleanup:
        ; Restore EVNTV atomically
        sei
        lda     oldeventv
        sta     EVNTV
        lda     oldeventv+1
        sta     EVNTV+1
        cli

        ; If we enabled ESC events, restore previous state
        lda     oldescen
        bne     :+
        lda     #osbyte_DISABLE_EVENT
        ldx     #EVNTV_ESCAPE
        jsr     OSBYTE
:
        rts

_cleanup_display:
        lda     #$01
        sta     cursor
        jsr     setcursor
        jsr     restore_cursor_edit
        rts

        .bss
oldeventv:         .res     2
oldescen:          .res     1 
save_s:            .res     1
