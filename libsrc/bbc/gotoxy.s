;
; Dominic Beesley 14.04.2005
;
; void __fastcall__ gotoxy (unsigned char x, unsigned char y);
;

        .include "oslib/os.inc"

        .export  gotoxy
        .export  _gotoxy
        .import  popa

; This is called by cc65 functions that have still Y on c_sp
gotoxy:
        jsr     popa            ; Get Y

; this is the C exposed version
_gotoxy:                        ; Set the cursor position
        pha                     ; save Y for the moment
        lda     #31
        jsr     OSWRCH
        jsr     popa            ; Get X
        jsr     OSWRCH
        pla
        jmp     OSWRCH
