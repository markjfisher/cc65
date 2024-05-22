; OSFIND wrapper for BBC Micro
; unsigned char __fastcall__ osfind(unsigned char mode, const char *name);

; see https://central.kaserver5.org/Kasoft/Typeset/BBC/Ch43.html
; 
; Opens a file for writing or reading and writing. The routine is entered at &FFCE and indirects via &21C. The value in A determines the type of operation.

; A=0	causes a file or files to be closed.
; A=&40	causes a file to be opened for input (reading).
; A=&80	causes a file to be opened for output (writing).
; A=&C0	causes a file to be opened for input and output (random access).
; If A=&40, &80 or &C0 then Y(high byte) and X(low byte) must contain the address of a location in memory which contains
; the file name terminated with CR (&0D).
; On exit Y will contain the channel number allocated to the file for all future operations.
; If Y=0 then the operating system was unable to open the file.
; If A=0 then a file, or all files, will be closed depending on the value of Y.
; Y=0 will close all files, otherwise the file whose channel number is given in Y will be closed.
; On exit C, N, V and Z are undefined and D=0. The interrupt state is preserved, however interrupts may be enabled during the operation

        .export         _osfind
        .import         popa
        .importzp       ptr1

OSFIND = $FFCE

_osfind:
        ; name is in A/X (low/high byte of pointer)
        sta     ptr1
        stx     ptr1+1

        ; mode is on the stack, pop it into A
        jsr     popa

        ; move name pointer into X/Y (X=low, Y=high)
        ldx     ptr1
        ldy     ptr1+1

        ; Call OSFIND
        jsr     OSFIND

        ; OSFIND returns channel number in Y register
        ; Return it in A (with X=0 for 16-bit return)
        tya
        ldx     #$00

        rts

