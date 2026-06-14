; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; unsigned char wherey (void);
;

        .export  _wherex
        .include "oslib/os.inc"
        .include "oslib/vduvars.inc"

_wherex:
        lda     VDU_WKSP + VDUVAR_TEXT_CURSOR_XY + 0
        ldx     #0
        rts
