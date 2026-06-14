; Dominic Beesley, 2005
; Mark Fisher, 2026
;

; DIR* __fastcall__ opendir (const char* name);

        .export         _opendir
        .export         _dirs

        .import         ___directerrno
        .importzp       ptr1, ptr2, tmp1

        .include        "errno.inc"

MAXOPENDIRS = 2

.struct DIR
        channel  .byte
        name_ptr .dword
        count    .dword
        seq      .dword
        used     .byte
        name_len .byte
        name     .res 20
.endstruct

.bss
_dirs:   .res    .sizeof(DIR) * MAXOPENDIRS

.code
.proc _opendir
        lda     #$00
        sta     ptr1
        sta     ptr1+1

        lda     #<(_dirs + .sizeof(DIR))
        sta     ptr2
        lda     #>(_dirs + .sizeof(DIR))
        sta     ptr2+1
        ldy     #DIR::used
        lda     (ptr2),y
        bne     @check_first
        lda     ptr2
        sta     ptr1
        lda     ptr2+1
        sta     ptr1+1

@check_first:
        lda     #<(_dirs + (.sizeof(DIR) * 0))
        sta     ptr2
        lda     #>(_dirs + (.sizeof(DIR) * 0))
        sta     ptr2+1
        ldy     #DIR::used
        lda     (ptr2),y
        bne     @have_choice
        lda     ptr2
        sta     ptr1
        lda     ptr2+1
        sta     ptr1+1

@have_choice:

        lda     ptr1
        ora     ptr1+1
        bne     @init_dir

        lda     #EMFILE
        jsr     ___directerrno
        lda     #$00
        tax
        rts

@init_dir:
        ldy     #DIR::channel
        lda     #$00
        sta     (ptr1),y
        ldy     #DIR::seq
        sta     (ptr1),y
        iny
        sta     (ptr1),y
        iny
        sta     (ptr1),y
        iny
        sta     (ptr1),y
        ldy     #DIR::used
        lda     #$01
        sta     (ptr1),y

        lda     ptr1
        ldx     ptr1+1
        rts
.endproc
