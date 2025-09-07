;
; Dominic Beesley 2005
; OSLib implementation for BBC/Master Target        
;
; Used by various functions for string manipulations
        .export _bbc_string_buf

        .bss
_bbc_string_buf:		.res 255, 0
