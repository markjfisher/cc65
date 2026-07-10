; Mark Fisher, 2026
;
; int __fastcall__ clock_gettime (clockid_t clk_id, struct timespec *tp);
;

        .export         _clock_gettime

        .import         __systime
        .import         pushax, incsp1, steaxspidx, return0
        .importzp       ptr1

        .include        "time.inc"

.proc   _clock_gettime

        jsr     pushax

; Clear tv_sec and tv_nsec.

        sta     ptr1
        stx     ptr1+1
        lda     #$00
        ldy     #.sizeof(timespec)-1
:       sta     (ptr1),y
        dey
        bpl     :-

; BBC __systime reads the RTC and returns a time_t in sreg:AX.

        jsr     __systime

; Store tv_sec into the output timespec. tv_nsec remains zero.

        ldy     #timespec::tv_sec
        jsr     steaxspidx

; Drop clk_id and return success.

        jsr     incsp1
        jmp     return0

.endproc
