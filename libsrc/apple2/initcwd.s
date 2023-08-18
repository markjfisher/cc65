;
; Oliver Schmidt, 18.04.2005
;

        .export         initcwd
        .import         __cwd, __dos_type

        .include        "zeropage.inc"
        .include        "apple2.inc"
        .include        "mli.inc"

mli_parameters:
        .byte $01     ; number of parameters
        .addr __cwd   ; address of parameter

initcwd:
        ; Check for ProDOS 8
        lda     __dos_type
        beq     oserr

        ; Save random counter
        lda     RNDL
        pha
        lda     RNDH
        pha

        ; Call MLI
        jsr     $BF00           ; MLI call entry point
        .byte   GET_PREFIX_CALL ; MLI command
        .addr   mli_parameters  ; MLI parameter

        ; Restore random counter
        tax
        pla
        sta     RNDH
        pla
        sta     RNDL
        txa

        ; Check for null prefix
        ldx     __cwd
        beq     done

        ; Remove length byte and trailing slash
        dex
        stx     tmp1
        ldx     #$00
:       lda     __cwd + 1,x
        sta     __cwd,x
        inx
        cpx     tmp1
        bcc     :-

        ; Add terminating zero
        lda     #$00
        sta     __cwd,x

done:   rts

oserr:  lda     #$01            ; "Bad system call number"
        sec
        rts
