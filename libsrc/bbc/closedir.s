; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; int __fastcall__ closedir (DIR* dir);

        .export         _closedir

        .importzp       ptr1

.struct DIR
        channel  .byte
        name_ptr .dword
        count    .dword
        seq      .dword
        used     .byte
        name_len .byte
        name     .res 20
.endstruct

.proc _closedir
        sta     ptr1
        stx     ptr1+1
        ora     ptr1+1
        beq     @done

        ldy     #DIR::used
        lda     #$00
        sta     (ptr1),y

@done:  tax
        rts
.endproc
