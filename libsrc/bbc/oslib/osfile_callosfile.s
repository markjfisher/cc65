
;	Dominic Beesley 2005
;	OSLib implementation for BBC/Master Target	
;
;	osfile_* utility functions
;
;	Assumes an OSFILE parameter block is at TOS
;	call OSFILE A contains reason code, c_sp points to parameter block

		.import OSFILE
		.export osfile_callosfile
		.importzp c_sp

		.proc osfile_callosfile
		ldx	c_sp
		ldy	c_sp + 1
		jsr	OSFILE
		rts
		.endproc
