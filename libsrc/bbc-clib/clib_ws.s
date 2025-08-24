.include "bbc.inc"

; --- ZP pointers reserved for CLIB ---
.segment "CLIBZP": zeropage

clib_ws:    .res 2      ; -> workspace in RAM
clib_jptr:  .res 2      ; scratch for jmp (ptr)
