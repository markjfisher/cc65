;
;	extern os_error *xos_generate_error (os_error const *error);
;	extern void os_generate_error (os_error const *error);
;

;
;	Dominic Beesley 2005
;

;	Both raise the error!

		.export _os_generate_error
		.export _xos_generate_error
		.import	pusha, popax
		.importzp c_sp, ptr1, ptr2

_os_generate_error:
_xos_generate_error:
		; store brk, error number, message on stack!
		; then jump to brk
		
		jsr	popax
		sta	ptr2
		stx	ptr2 + 1

		; reserve 256 bytes on stack 
		dec	c_sp + 1

		lda	c_sp
		sta	ptr1
		lda	c_sp + 1
		sta	ptr1 + 1
		
		ldy	#0
		lda	#0	; brk
		sta	(ptr1), Y
		lda	(ptr2), Y
		iny
		sta	(ptr1), Y ; error number

lp:		lda	(ptr2), Y
		iny
		beq	dn	; too long!
		sta	(ptr1), Y
		cmp	#0
		bne	lp

dn:		jmp	(ptr1)



