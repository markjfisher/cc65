; Dominic Beesley 27.04.2005
; Close file function for BBC Micro
; int __fastcall__ close_file(unsigned char channel);

; see https://central.kaserver5.org/Kasoft/Typeset/BBC/Ch43.html
; 
; OSFIND with A=0 closes a file
; channel = 0 will close all files, otherwise the file whose channel number is given in Y will be closed.

        .export         _close_file
        .import         popa
        .import         return0

OSFIND = $FFCE

_close_file:
        tay
        
        ; A=0 for close operation, clear x for good measure
        lda     #$00
        tax
        
        ; Call OSFIND to close the file
        jsr     OSFIND
        
        ; Return 0 for success (OSFIND doesn't return a meaningful value for close)
        jmp     return0