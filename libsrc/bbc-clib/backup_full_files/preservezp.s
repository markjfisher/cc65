	.export	preservezp, restorezp
	.import		subysp
	.import		addysp
	.include	"zeropage.inc"
	
	.code
preservezp:
	; make room on the stack
	ldy	#zpspace
	jsr	subysp
	
	ldy	#zpspace-1
preserveloop:
	lda	c_sp, y		; ??? c_sp always first in zp?
	sta	(c_sp), y	

	dey
	bpl	preserveloop
	rts

restorezp:
	ldy	#zpspace-1
restoreloop:
	lda	(c_sp), y
	sta	c_sp, y
	dey
	bpl	restoreloop
	
	ldy	#zpspace
	jsr	addysp
	rts
 
	.end