;
; Startup code for cc65 (bbc clib rom version)
; REQUIRES cc65 CLIB ROM to be present in any sideways ROM

        .export         _exit
        .export         __STARTUP__ : absolute = 1      ; Mark as startup
        .export         __Cstart
        .export         _exit_main

        .import         initlib, donelib
        .import         zerobss
        .import         callmain
        .import         preservezp, restorezp
        .import         _raise

        .import         disable_cursor_edit
        .import         restore_cursor_edit
        .import         init_stack

        .import         OSWRCH
        .import         cursor
        .import         setcursor

        .import         _install_brk_handler_global
        .import         _uninstall_brk_handler_global

        .import         detect_clib_rom
        .import         clib_rom_available
        .import         clib_rom_slot
        .import         original_romsel
        .import         print_error_and_exit
        .import         rom_error_msg

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

        jsr     detect_clib_rom
        lda     clib_rom_available
        bne     rom_found

        lda     #<rom_error_msg
        ldx     #>rom_error_msg
        jsr     print_error_and_exit
        rts

rom_found:
        jsr     disable_cursor_edit
        jsr     init_stack

        ; disable interrupts while we setup the vectors
        php
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

        jsr     _install_brk_handler_global
        plp

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

_exit_main:
        ; Save the exit code in user flag
        tax
        ldy     #$FF
        lda     #osbyte_USER_FLAG
        jsr     OSBYTE

        jsr     donelib

        ; If we enabled ESC events, restore previous state
        lda     oldescen
        bne     @skip_disable
        lda     #osbyte_DISABLE_EVENT
        ldx     #EVNTV_ESCAPE
        jsr     OSBYTE

@skip_disable:
        php
        sei
        jsr     _uninstall_brk_handler_global

        ; restore event handler
        lda     oldeventv
        sta     EVNTV
        lda     oldeventv+1
        sta     EVNTV+1
        plp

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

; force return to OS, restoring SP will remove any potential return calls no longer needed
_exit:  ldx     save_s
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

        jsr     preservezp
        cli

        ldx     #0
        lda     #3              ; SIGINT ???
        jsr     _raise

        ; disable interrupts, as we pass it on...
        sei
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


_cleanup_display:
        ; turn cursor back on, in case anything turned it off (e.g. cgetc() with default cursor value off)
        lda     #$01
        sta     cursor
        jsr     setcursor
        jsr     restore_cursor_edit

        ; --- Clear ESC/VDU state so next run reads keys normally ---
        lda     #$7E            ; OSBYTE 126: acknowledge Escape
        jsr     OSBYTE
        lda     #$DA            ; OSBYTE 218: flush VDU queue
        jsr     OSBYTE

        rts

        .bss
oldeventv:      .res    2
oldescen:       .res    1       ; was escape event enabled before?
save_s:	        .res    1       ; save stack pointer
