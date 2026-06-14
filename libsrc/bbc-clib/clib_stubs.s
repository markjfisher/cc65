		; 457 symbol(s) vectored through the fixed jump table at $8100
		.export	ARGSV
ARGSV		:=	$000214
		.export	BGETV
BGETV		:=	$000216
		.export	BPUTV
BPUTV		:=	$000218
		.export	BRKV
BRKV		:=	$000202
		.export	BYTEV
BYTEV		:=	$00020A
		.export	CLIV
CLIV		:=	$000208
		.export	CNPV
CNPV		:=	$00022E
		.export	EVNTV
EVNTV		:=	$000220
		.export	FILEV
FILEV		:=	$000212
		.export	FINDV
FINDV		:=	$00021C
		.export	FSCV
FSCV		:=	$00021E
		.export	GBPBV
GBPBV		:=	$00021A
		.export	GSINIT
GSINIT		:=	$00FFC2
		.export	GSREAD
GSREAD		:=	$00FFC5
		.export	IND1V
IND1V		:=	$000230
		.export	IND2V
IND2V		:=	$000232
		.export	IND3V
IND3V		:=	$000234
		.export	INSV
INSV		:=	$00022A
		.export	IRQ1V
IRQ1V		:=	$000204
		.export	IRQ2V
IRQ2V		:=	$000206
		.export	KEYV
KEYV		:=	$000228
		.export	NETV
NETV		:=	$000224
		.export	NVRDCH
NVRDCH		:=	$00FFCB
		.export	NVWRCH
NVWRCH		:=	$00FFC8
		.export	OSARGS
OSARGS		:=	$00FFDA
		.export	OSASCI
OSASCI		:=	$00FFE3
		.export	OSBGET
OSBGET		:=	$00FFD7
		.export	OSBPUT
OSBPUT		:=	$00FFD4
		.export	OSBYTE
OSBYTE		:=	$00FFF4
		.export	OSCLI
OSCLI		:=	$00FFF7
		.export	OSEVEN
OSEVEN		:=	$00FFBF
		.export	OSFILE
OSFILE		:=	$00FFDD
		.export	OSFIND
OSFIND		:=	$00FFCE
		.export	OSGBPB
OSGBPB		:=	$00FFD1
		.export	OSNEWL
OSNEWL		:=	$00FFE7
		.export	OSRDCH
OSRDCH		:=	$00FFE0
		.export	OSRDRM
OSRDRM		:=	$00FFB9
		.export	OSWORD
OSWORD		:=	$00FFF1
		.export	OSWRCH
OSWRCH		:=	$00FFEE
		.export	RDCHV
RDCHV		:=	$000210
		.export	REMV
REMV		:=	$00022C
		.export	UPTV
UPTV		:=	$000222
		.export	USERV
USERV		:=	$000200
		.export	VDUV
VDUV		:=	$000226
		.export	VDU_WKSP
VDU_WKSP		:=	$000300
		.export	WORDV
WORDV		:=	$00020C
		.export	WRCHV
WRCHV		:=	$00020E
		.export	_OSASCI
_OSASCI		:=	$00FFE3
		.export	_OSWRCH
_OSWRCH		:=	$00FFEE
		; skipping symbol __HEADER_M_FILEOFFS__
		; skipping symbol __HEADER_M_LAST__
		; skipping symbol __HEADER_M_SIZE__
		; skipping symbol __HEADER_M_START__
		; skipping symbol __JUMP_M_FILEOFFS__
		; skipping symbol __JUMP_M_LAST__
		; skipping symbol __JUMP_M_SIZE__
		; skipping symbol __JUMP_M_START__
		; skipping symbol __MAIN_FILEOFFS__
		; skipping symbol __MAIN_LAST__
		; skipping symbol __MAIN_SIZE__
		; skipping symbol __MAIN_START__
		; skipping symbol __ZP_FILEOFFS__
		; skipping symbol __ZP_LAST__
		; skipping symbol __ZP_SIZE__
		; skipping symbol __ZP_START__
		; skipping symbol ___bzero
		; skipping symbol ___heapblocksize
		; skipping symbol ___setjmp
		; skipping symbol ___swap
		; skipping symbol __cos
		; skipping symbol __ctype
		; skipping symbol __ctypeidx
		; skipping symbol __hextab
		; skipping symbol __longminstr
		; skipping symbol __osmaperrno
		; skipping symbol __sin
		; skipping symbol __sys_errlist
		; skipping symbol __sysuname
		.export	_abs	; vectored
_abs		:=	$8100
		.export	_atoi	; vectored
_atoi		:=	$8103
		.export	_atol	; vectored
_atol		:=	$8106
		.export	_bzero	; vectored
_bzero		:=	$8109
		.export	_cclear	; vectored
_cclear		:=	$810C
		.export	_cclearxy	; vectored
_cclearxy		:=	$810F
		.export	_chline	; vectored
_chline		:=	$8112
		.export	_chlinexy	; vectored
_chlinexy		:=	$8115
		.export	_close_file	; vectored
_close_file		:=	$8118
		.export	_cputc	; vectored
_cputc		:=	$811B
		.export	_cputcxy	; vectored
_cputcxy		:=	$811E
		.export	_decompress_lz4	; vectored
_decompress_lz4		:=	$8121
		.export	_decompress_lzsa1	; vectored
_decompress_lzsa1		:=	$8124
		.export	_decompress_lzsa2	; vectored
_decompress_lzsa2		:=	$8127
		.export	_decompress_zx02	; vectored
_decompress_zx02		:=	$812A
		.export	_div	; vectored
_div		:=	$812D
		.export	_doesclrscrafterexit	; vectored
_doesclrscrafterexit		:=	$8130
		.export	_getcpu	; vectored
_getcpu		:=	$8133
		.export	_gotox	; vectored
_gotox		:=	$8136
		.export	_gotoxy	; vectored
_gotoxy		:=	$8139
		.export	_gotoy	; vectored
_gotoy		:=	$813C
		.export	_htonl	; vectored
_htonl		:=	$813F
		.export	_htons	; vectored
_htons		:=	$8142
		.export	_idiv32by16r16	; vectored
_idiv32by16r16		:=	$8145
		.export	_imaxabs	; vectored
_imaxabs		:=	$8148
		.export	_imul16x16r32	; vectored
_imul16x16r32		:=	$814B
		.export	_imul8x8r16	; vectored
_imul8x8r16		:=	$814E
		.export	_isalnum	; vectored
_isalnum		:=	$8151
		.export	_isalpha	; vectored
_isalpha		:=	$8154
		.export	_isascii	; vectored
_isascii		:=	$8157
		.export	_isblank	; vectored
_isblank		:=	$815A
		.export	_iscntrl	; vectored
_iscntrl		:=	$815D
		.export	_isdigit	; vectored
_isdigit		:=	$8160
		.export	_isgraph	; vectored
_isgraph		:=	$8163
		.export	_islower	; vectored
_islower		:=	$8166
		.export	_isprint	; vectored
_isprint		:=	$8169
		.export	_ispunct	; vectored
_ispunct		:=	$816C
		.export	_isspace	; vectored
_isspace		:=	$816F
		.export	_isupper	; vectored
_isupper		:=	$8172
		.export	_isxdigit	; vectored
_isxdigit		:=	$8175
		.export	_itoa	; vectored
_itoa		:=	$8178
		.export	_kbhit	; vectored
_kbhit		:=	$817B
		.export	_labs	; vectored
_labs		:=	$817E
		.export	_longjmp	; vectored
_longjmp		:=	$8181
		.export	_ltoa	; vectored
_ltoa		:=	$8184
		.export	_memchr	; vectored
_memchr		:=	$8187
		.export	_memcmp	; vectored
_memcmp		:=	$818A
		.export	_memcpy	; vectored
_memcpy		:=	$818D
		.export	_memmove	; vectored
_memmove		:=	$8190
		.export	_memset	; vectored
_memset		:=	$8193
		.export	_mul20	; vectored
_mul20		:=	$8196
		.export	_mul40	; vectored
_mul40		:=	$8199
		.export	_ntohl	; vectored
_ntohl		:=	$819C
		.export	_ntohs	; vectored
_ntohs		:=	$819F
		.export	_os_generate_error	; vectored
_os_generate_error		:=	$81A2
		.export	_osfile_delete	; vectored
_osfile_delete		:=	$81A5
		.export	_osfile_load	; vectored
_osfile_load		:=	$81A8
		.export	_osfile_read	; vectored
_osfile_read		:=	$81AB
		.export	_osfile_save	; vectored
_osfile_save		:=	$81AE
		.export	_osfile_write	; vectored
_osfile_write		:=	$81B1
		.export	_osfile_write_attr	; vectored
_osfile_write_attr		:=	$81B4
		.export	_osfile_write_exec	; vectored
_osfile_write_exec		:=	$81B7
		.export	_osfile_write_load	; vectored
_osfile_write_load		:=	$81BA
		.export	_osfind	; vectored
_osfind		:=	$81BD
		.export	_stpcpy	; vectored
_stpcpy		:=	$81C0
		.export	_strcasecmp	; vectored
_strcasecmp		:=	$81C3
		.export	_strcat	; vectored
_strcat		:=	$81C6
		.export	_strchr	; vectored
_strchr		:=	$81C9
		.export	_strcmp	; vectored
_strcmp		:=	$81CC
		.export	_strcoll	; vectored
_strcoll		:=	$81CF
		.export	_strcpy	; vectored
_strcpy		:=	$81D2
		.export	_strcspn	; vectored
_strcspn		:=	$81D5
		.export	_stricmp	; vectored
_stricmp		:=	$81D8
		.export	_strlen	; vectored
_strlen		:=	$81DB
		.export	_strlen_ptr4	; vectored
_strlen_ptr4		:=	$81DE
		.export	_strlower	; vectored
_strlower		:=	$81E1
		.export	_strlwr	; vectored
_strlwr		:=	$81E4
		.export	_strncasecmp	; vectored
_strncasecmp		:=	$81E7
		.export	_strncat	; vectored
_strncat		:=	$81EA
		.export	_strncmp	; vectored
_strncmp		:=	$81ED
		.export	_strncpy	; vectored
_strncpy		:=	$81F0
		.export	_strnicmp	; vectored
_strnicmp		:=	$81F3
		.export	_strnlen	; vectored
_strnlen		:=	$81F6
		.export	_strpbrk	; vectored
_strpbrk		:=	$81F9
		.export	_strrchr	; vectored
_strrchr		:=	$81FC
		.export	_strspn	; vectored
_strspn		:=	$81FF
		.export	_strstr	; vectored
_strstr		:=	$8202
		.export	_strupper	; vectored
_strupper		:=	$8205
		.export	_strupr	; vectored
_strupr		:=	$8208
		.export	_strxfrm	; vectored
_strxfrm		:=	$820B
		.export	_system	; vectored
_system		:=	$820E
		.export	_toascii	; vectored
_toascii		:=	$8211
		.export	_tolower	; vectored
_tolower		:=	$8214
		.export	_toupper	; vectored
_toupper		:=	$8217
		.export	_udiv32by16r16	; vectored
_udiv32by16r16		:=	$821A
		.export	_ultoa	; vectored
_ultoa		:=	$821D
		.export	_umul16x16r32	; vectored
_umul16x16r32		:=	$8220
		.export	_umul16x8r32	; vectored
_umul16x8r32		:=	$8223
		.export	_umul8x8r16	; vectored
_umul8x8r16		:=	$8226
		.export	_utoa	; vectored
_utoa		:=	$8229
		.export	_wherex	; vectored
_wherex		:=	$822C
		.export	_wherey	; vectored
_wherey		:=	$822F
		.export	_xos_generate_error	; vectored
_xos_generate_error		:=	$8232
		.export	addeq0sp	; vectored
addeq0sp		:=	$8235
		.export	addeqysp	; vectored
addeqysp		:=	$8238
		.export	addysp	; vectored
addysp		:=	$823B
		.export	addysp1	; vectored
addysp1		:=	$823E
		.export	along	; vectored
along		:=	$8241
		.export	aslax1	; vectored
aslax1		:=	$8244
		.export	aslax2	; vectored
aslax2		:=	$8247
		.export	aslax3	; vectored
aslax3		:=	$824A
		.export	aslax4	; vectored
aslax4		:=	$824D
		.export	aslaxy	; vectored
aslaxy		:=	$8250
		.export	asleax1	; vectored
asleax1		:=	$8253
		.export	asleax2	; vectored
asleax2		:=	$8256
		.export	asleax3	; vectored
asleax3		:=	$8259
		.export	asleax4	; vectored
asleax4		:=	$825C
		.export	asrax1	; vectored
asrax1		:=	$825F
		.export	asrax2	; vectored
asrax2		:=	$8262
		.export	asrax3	; vectored
asrax3		:=	$8265
		.export	asrax4	; vectored
asrax4		:=	$8268
		.export	asraxy	; vectored
asraxy		:=	$826B
		.export	asreax1	; vectored
asreax1		:=	$826E
		.export	asreax2	; vectored
asreax2		:=	$8271
		.export	asreax3	; vectored
asreax3		:=	$8274
		.export	asreax4	; vectored
asreax4		:=	$8277
		.export	aulong	; vectored
aulong		:=	$827A
		.export	axlong	; vectored
axlong		:=	$827D
		.export	axulong	; vectored
axulong		:=	$8280
		.export	bcasta	; vectored
bcasta		:=	$8283
		.export	bcastax	; vectored
bcastax		:=	$8286
		.export	bcasteax	; vectored
bcasteax		:=	$8289
		.export	bnega	; vectored
bnega		:=	$828C
		.export	bnegax	; vectored
bnegax		:=	$828F
		.export	bnegeax	; vectored
bnegeax		:=	$8292
		.export	booleq	; vectored
booleq		:=	$8295
		.export	boolge	; vectored
boolge		:=	$8298
		.export	boolgt	; vectored
boolgt		:=	$829B
		.export	boolle	; vectored
boolle		:=	$829E
		.export	boollt	; vectored
boollt		:=	$82A1
		.export	boolne	; vectored
boolne		:=	$82A4
		.export	booluge	; vectored
booluge		:=	$82A7
		.export	boolugt	; vectored
boolugt		:=	$82AA
		.export	boolule	; vectored
boolule		:=	$82AD
		.export	boolult	; vectored
boolult		:=	$82B0
		.export	bpushbsp	; vectored
bpushbsp		:=	$82B3
		.export	bpushbysp	; vectored
bpushbysp		:=	$82B6
		.exportZP	c_sp
		c_sp		:=	$000050
		.export	callax	; vectored
callax		:=	$82B9
		.export	callptr4	; vectored
callptr4		:=	$82BC
		.export	checkferror	; vectored
checkferror		:=	$82BF
		.export	complax	; vectored
complax		:=	$82C2
		.export	compleax	; vectored
compleax		:=	$82C5
		.export	ctypemask	; vectored
ctypemask		:=	$82C8
		.export	ctypemaskdirect	; vectored
ctypemaskdirect		:=	$82CB
		.export	decax1	; vectored
decax1		:=	$82CE
		.export	decax2	; vectored
decax2		:=	$82D1
		.export	decax3	; vectored
decax3		:=	$82D4
		.export	decax4	; vectored
decax4		:=	$82D7
		.export	decax5	; vectored
decax5		:=	$82DA
		.export	decax6	; vectored
decax6		:=	$82DD
		.export	decax7	; vectored
decax7		:=	$82E0
		.export	decax8	; vectored
decax8		:=	$82E3
		.export	decaxy	; vectored
decaxy		:=	$82E6
		.export	deceaxy	; vectored
deceaxy		:=	$82E9
		.export	decsp1	; vectored
decsp1		:=	$82EC
		.export	decsp2	; vectored
decsp2		:=	$82EF
		.export	decsp3	; vectored
decsp3		:=	$82F2
		.export	decsp4	; vectored
decsp4		:=	$82F5
		.export	decsp5	; vectored
decsp5		:=	$82F8
		.export	decsp6	; vectored
decsp6		:=	$82FB
		.export	decsp7	; vectored
decsp7		:=	$82FE
		.export	decsp8	; vectored
decsp8		:=	$8301
		.export	enter	; vectored
enter		:=	$8304
		.export	getlop	; vectored
getlop		:=	$8307
		.export	gotox	; vectored
gotox		:=	$830A
		.export	gotoxy	; vectored
gotoxy		:=	$830D
		.export	gotoy	; vectored
gotoy		:=	$8310
		.export	idiv32by16r16	; vectored
idiv32by16r16		:=	$8313
		.export	imul16x16r32	; vectored
imul16x16r32		:=	$8316
		.export	imul8x8r16	; vectored
imul8x8r16		:=	$8319
		.export	imul8x8r16m	; vectored
imul8x8r16m		:=	$831C
		.export	incax1	; vectored
incax1		:=	$831F
		.export	incax2	; vectored
incax2		:=	$8322
		.export	incax3	; vectored
incax3		:=	$8325
		.export	incax4	; vectored
incax4		:=	$8328
		.export	incax5	; vectored
incax5		:=	$832B
		.export	incax6	; vectored
incax6		:=	$832E
		.export	incax7	; vectored
incax7		:=	$8331
		.export	incax8	; vectored
incax8		:=	$8334
		.export	incaxy	; vectored
incaxy		:=	$8337
		.export	inceaxy	; vectored
inceaxy		:=	$833A
		.export	incsp1	; vectored
incsp1		:=	$833D
		.export	incsp2	; vectored
incsp2		:=	$8340
		.export	incsp3	; vectored
incsp3		:=	$8343
		.export	incsp4	; vectored
incsp4		:=	$8346
		.export	incsp5	; vectored
incsp5		:=	$8349
		.export	incsp6	; vectored
incsp6		:=	$834C
		.export	incsp7	; vectored
incsp7		:=	$834F
		.export	incsp8	; vectored
incsp8		:=	$8352
		.export	init_stack	; vectored
init_stack		:=	$8355
		.export	laddeq	; vectored
laddeq		:=	$8358
		.export	laddeq0sp	; vectored
laddeq0sp		:=	$835B
		.export	laddeq1	; vectored
laddeq1		:=	$835E
		.export	laddeqa	; vectored
laddeqa		:=	$8361
		.export	laddeqysp	; vectored
laddeqysp		:=	$8364
		.export	ldaidx	; vectored
ldaidx		:=	$8367
		.export	ldau00sp	; vectored
ldau00sp		:=	$836A
		.export	ldau0ysp	; vectored
ldau0ysp		:=	$836D
		.export	ldaui0sp	; vectored
ldaui0sp		:=	$8370
		.export	ldauidx	; vectored
ldauidx		:=	$8373
		.export	ldauiysp	; vectored
ldauiysp		:=	$8376
		.export	ldax0sp	; vectored
ldax0sp		:=	$8379
		.export	ldaxi	; vectored
ldaxi		:=	$837C
		.export	ldaxidx	; vectored
ldaxidx		:=	$837F
		.export	ldaxysp	; vectored
ldaxysp		:=	$8382
		.export	ldeax0sp	; vectored
ldeax0sp		:=	$8385
		.export	ldeaxi	; vectored
ldeaxi		:=	$8388
		.export	ldeaxidx	; vectored
ldeaxidx		:=	$838B
		.export	ldeaxysp	; vectored
ldeaxysp		:=	$838E
		.export	leaa0sp	; vectored
leaa0sp		:=	$8391
		.export	leaaxsp	; vectored
leaaxsp		:=	$8394
		.export	leave	; vectored
leave		:=	$8397
		.export	leave0	; vectored
leave0		:=	$839A
		.export	leave00	; vectored
leave00		:=	$839D
		.export	leavey	; vectored
leavey		:=	$83A0
		.export	leavey0	; vectored
leavey0		:=	$83A3
		.export	leavey00	; vectored
leavey00		:=	$83A6
		.export	lsubeq	; vectored
lsubeq		:=	$83A9
		.export	lsubeq0sp	; vectored
lsubeq0sp		:=	$83AC
		.export	lsubeq1	; vectored
lsubeq1		:=	$83AF
		.export	lsubeqa	; vectored
lsubeqa		:=	$83B2
		.export	lsubeqysp	; vectored
lsubeqysp		:=	$83B5
		.export	memcpy_getparams	; vectored
memcpy_getparams		:=	$83B8
		.export	memcpy_upwards	; vectored
memcpy_upwards		:=	$83BB
		.export	mul8x16	; vectored
mul8x16		:=	$83BE
		.export	mul8x16a	; vectored
mul8x16a		:=	$83C1
		.export	mulax10	; vectored
mulax10		:=	$83C4
		.export	mulax3	; vectored
mulax3		:=	$83C7
		.export	mulax5	; vectored
mulax5		:=	$83CA
		.export	mulax6	; vectored
mulax6		:=	$83CD
		.export	mulax7	; vectored
mulax7		:=	$83D0
		.export	mulax9	; vectored
mulax9		:=	$83D3
		.export	negax	; vectored
negax		:=	$83D6
		.export	negeax	; vectored
negeax		:=	$83D9
		.export	osfile_alloc_block	; vectored
osfile_alloc_block		:=	$83DC
		.export	osfile_callosfile	; vectored
osfile_callosfile		:=	$83DF
		.export	osfile_retA	; vectored
osfile_retA		:=	$83E2
		.export	osfile_ret_read_delete_load	; vectored
osfile_ret_read_delete_load		:=	$83E5
		.export	osfile_retdword	; vectored
osfile_retdword		:=	$83E8
		.export	osfile_store_attr	; vectored
osfile_store_attr		:=	$83EB
		.export	osfile_store_exec	; vectored
osfile_store_exec		:=	$83EE
		.export	osfile_store_fn	; vectored
osfile_store_fn		:=	$83F1
		.export	osfile_store_len	; vectored
osfile_store_len		:=	$83F4
		.export	osfile_store_load	; vectored
osfile_store_load		:=	$83F7
		.export	osfile_write_X_start	; vectored
osfile_write_X_start		:=	$83FA
		.export	popa	; vectored
popa		:=	$83FD
		.export	popax	; vectored
popax		:=	$8400
		.export	popeax	; vectored
popeax		:=	$8403
		.export	poplsargs	; vectored
poplsargs		:=	$8406
		.export	popptr1	; vectored
popptr1		:=	$8409
		.export	popsargsudiv16	; vectored
popsargsudiv16		:=	$840C
		.export	popsreg	; vectored
popsreg		:=	$840F
		.export	preservezp	; vectored
preservezp		:=	$8412
		.export	print0	; vectored
print0		:=	$8415
		.export	printhex	; vectored
printhex		:=	$8418
		.export	printstr	; vectored
printstr		:=	$841B
		.exportZP	ptr1
		ptr1		:=	$000058
		.exportZP	ptr2
		ptr2		:=	$00005A
		.exportZP	ptr3
		ptr3		:=	$00005C
		.exportZP	ptr4
		ptr4		:=	$00005E
		.export	push0	; vectored
push0		:=	$841E
		.export	push0ax	; vectored
push0ax		:=	$8421
		.export	push1	; vectored
push1		:=	$8424
		.export	push2	; vectored
push2		:=	$8427
		.export	push3	; vectored
push3		:=	$842A
		.export	push4	; vectored
push4		:=	$842D
		.export	push5	; vectored
push5		:=	$8430
		.export	push6	; vectored
push6		:=	$8433
		.export	push7	; vectored
push7		:=	$8436
		.export	pusha	; vectored
pusha		:=	$8439
		.export	pusha0	; vectored
pusha0		:=	$843C
		.export	pusha0sp	; vectored
pusha0sp		:=	$843F
		.export	pushaFF	; vectored
pushaFF		:=	$8442
		.export	pushax	; vectored
pushax		:=	$8445
		.export	pushaysp	; vectored
pushaysp		:=	$8448
		.export	pushb	; vectored
pushb		:=	$844B
		.export	pushbidx	; vectored
pushbidx		:=	$844E
		.export	pushbsp	; vectored
pushbsp		:=	$8451
		.export	pushbysp	; vectored
pushbysp		:=	$8454
		.export	pushc0	; vectored
pushc0		:=	$8457
		.export	pushc1	; vectored
pushc1		:=	$845A
		.export	pushc2	; vectored
pushc2		:=	$845D
		.export	pusheax	; vectored
pusheax		:=	$8460
		.export	pushl0	; vectored
pushl0		:=	$8463
		.export	pushlysp	; vectored
pushlysp		:=	$8466
		.export	pushptr1
pushptr1		:=	$00A43F
		.export	pushptr1idx	; vectored
pushptr1idx		:=	$8469
		.export	pushw	; vectored
pushw		:=	$846C
		.export	pushw0sp	; vectored
pushw0sp		:=	$846F
		.export	pushwidx	; vectored
pushwidx		:=	$8472
		.export	pushwysp	; vectored
pushwysp		:=	$8475
		.export	putchar	; vectored
putchar		:=	$8478
		.exportZP	regbank
		regbank		:=	$000064
		.exportZP	regsave
		regsave		:=	$000054
		.export	regswap	; vectored
regswap		:=	$847B
		.export	regswap1	; vectored
regswap1		:=	$847E
		.export	regswap2	; vectored
regswap2		:=	$8481
		.export	resteax	; vectored
resteax		:=	$8484
		.export	restorezp	; vectored
restorezp		:=	$8487
		.export	return0	; vectored
return0		:=	$848A
		.export	return1	; vectored
return1		:=	$848D
		.export	rwcommon	; vectored
rwcommon		:=	$8490
		.export	saveeax	; vectored
saveeax		:=	$8493
		.export	screensize	; vectored
screensize		:=	$8496
		.export	shlax1	; vectored
shlax1		:=	$8499
		.export	shlax2	; vectored
shlax2		:=	$849C
		.export	shlax3	; vectored
shlax3		:=	$849F
		.export	shlax4	; vectored
shlax4		:=	$84A2
		.export	shlaxy	; vectored
shlaxy		:=	$84A5
		.export	shleax1	; vectored
shleax1		:=	$84A8
		.export	shleax2	; vectored
shleax2		:=	$84AB
		.export	shleax3	; vectored
shleax3		:=	$84AE
		.export	shleax4	; vectored
shleax4		:=	$84B1
		.export	shrax1	; vectored
shrax1		:=	$84B4
		.export	shrax2	; vectored
shrax2		:=	$84B7
		.export	shrax3	; vectored
shrax3		:=	$84BA
		.export	shrax4	; vectored
shrax4		:=	$84BD
		.export	shraxy	; vectored
shraxy		:=	$84C0
		.export	shreax1	; vectored
shreax1		:=	$84C3
		.export	shreax2	; vectored
shreax2		:=	$84C6
		.export	shreax3	; vectored
shreax3		:=	$84C9
		.export	shreax4	; vectored
shreax4		:=	$84CC
		.exportZP	sreg
		sreg		:=	$000052
		.export	staspidx	; vectored
staspidx		:=	$84CF
		.export	stax0sp	; vectored
stax0sp		:=	$84D2
		.export	staxspidx	; vectored
staxspidx		:=	$84D5
		.export	staxysp	; vectored
staxysp		:=	$84D8
		.export	steax0sp	; vectored
steax0sp		:=	$84DB
		.export	steaxspidx	; vectored
steaxspidx		:=	$84DE
		.export	steaxysp	; vectored
steaxysp		:=	$84E1
		.export	subeq0sp	; vectored
subeq0sp		:=	$84E4
		.export	subeqysp	; vectored
subeqysp		:=	$84E7
		.export	subysp	; vectored
subysp		:=	$84EA
		.export	swapstk	; vectored
swapstk		:=	$84ED
		.exportZP	tmp1
		tmp1		:=	$000060
		.exportZP	tmp2
		tmp2		:=	$000061
		.exportZP	tmp3
		tmp3		:=	$000062
		.exportZP	tmp4
		tmp4		:=	$000063
		.export	tolowerdirect	; vectored
tolowerdirect		:=	$84F0
		.export	tosadd0ax	; vectored
tosadd0ax		:=	$84F3
		.export	tosadda0	; vectored
tosadda0		:=	$84F6
		.export	tosaddax	; vectored
tosaddax		:=	$84F9
		.export	tosaddeax	; vectored
tosaddeax		:=	$84FC
		.export	tosand0ax	; vectored
tosand0ax		:=	$84FF
		.export	tosanda0	; vectored
tosanda0		:=	$8502
		.export	tosandax	; vectored
tosandax		:=	$8505
		.export	tosandeax	; vectored
tosandeax		:=	$8508
		.export	tosaslax	; vectored
tosaslax		:=	$850B
		.export	tosasleax	; vectored
tosasleax		:=	$850E
		.export	tosasrax	; vectored
tosasrax		:=	$8511
		.export	tosasreax	; vectored
tosasreax		:=	$8514
		.export	tosdiv0ax	; vectored
tosdiv0ax		:=	$8517
		.export	tosdiva0	; vectored
tosdiva0		:=	$851A
		.export	tosdivax	; vectored
tosdivax		:=	$851D
		.export	tosdiveax	; vectored
tosdiveax		:=	$8520
		.export	toseq00	; vectored
toseq00		:=	$8523
		.export	toseqa0	; vectored
toseqa0		:=	$8526
		.export	toseqax	; vectored
toseqax		:=	$8529
		.export	toseqeax	; vectored
toseqeax		:=	$852C
		.export	tosge00	; vectored
tosge00		:=	$852F
		.export	tosgea0	; vectored
tosgea0		:=	$8532
		.export	tosgeax	; vectored
tosgeax		:=	$8535
		.export	tosgeeax	; vectored
tosgeeax		:=	$8538
		.export	tosgt00	; vectored
tosgt00		:=	$853B
		.export	tosgta0	; vectored
tosgta0		:=	$853E
		.export	tosgtax	; vectored
tosgtax		:=	$8541
		.export	tosgteax	; vectored
tosgteax		:=	$8544
		.export	tosicmp	; vectored
tosicmp		:=	$8547
		.export	tosicmp0	; vectored
tosicmp0		:=	$854A
		.export	tosint	; vectored
tosint		:=	$854D
		.export	toslcmp	; vectored
toslcmp		:=	$8550
		.export	tosle00	; vectored
tosle00		:=	$8553
		.export	toslea0	; vectored
toslea0		:=	$8556
		.export	tosleax	; vectored
tosleax		:=	$8559
		.export	tosleeax	; vectored
tosleeax		:=	$855C
		.export	toslong	; vectored
toslong		:=	$855F
		.export	toslt00	; vectored
toslt00		:=	$8562
		.export	toslta0	; vectored
toslta0		:=	$8565
		.export	tosltax	; vectored
tosltax		:=	$8568
		.export	toslteax	; vectored
toslteax		:=	$856B
		.export	tosmod0ax	; vectored
tosmod0ax		:=	$856E
		.export	tosmoda0	; vectored
tosmoda0		:=	$8571
		.export	tosmodax	; vectored
tosmodax		:=	$8574
		.export	tosmodeax	; vectored
tosmodeax		:=	$8577
		.export	tosmul0ax	; vectored
tosmul0ax		:=	$857A
		.export	tosmula0	; vectored
tosmula0		:=	$857D
		.export	tosmulax	; vectored
tosmulax		:=	$8580
		.export	tosmuleax	; vectored
tosmuleax		:=	$8583
		.export	tosne00	; vectored
tosne00		:=	$8586
		.export	tosnea0	; vectored
tosnea0		:=	$8589
		.export	tosneax	; vectored
tosneax		:=	$858C
		.export	tosneeax	; vectored
tosneeax		:=	$858F
		.export	tosor0ax	; vectored
tosor0ax		:=	$8592
		.export	tosora0	; vectored
tosora0		:=	$8595
		.export	tosorax	; vectored
tosorax		:=	$8598
		.export	tosoreax	; vectored
tosoreax		:=	$859B
		.export	tosrsub0ax	; vectored
tosrsub0ax		:=	$859E
		.export	tosrsuba0	; vectored
tosrsuba0		:=	$85A1
		.export	tosrsubax	; vectored
tosrsubax		:=	$85A4
		.export	tosrsubeax	; vectored
tosrsubeax		:=	$85A7
		.export	tosshlax	; vectored
tosshlax		:=	$85AA
		.export	tosshleax	; vectored
tosshleax		:=	$85AD
		.export	tosshrax	; vectored
tosshrax		:=	$85B0
		.export	tosshreax	; vectored
tosshreax		:=	$85B3
		.export	tossub0ax	; vectored
tossub0ax		:=	$85B6
		.export	tossuba0	; vectored
tossuba0		:=	$85B9
		.export	tossubax	; vectored
tossubax		:=	$85BC
		.export	tossubeax	; vectored
tossubeax		:=	$85BF
		.export	tosudiv0ax	; vectored
tosudiv0ax		:=	$85C2
		.export	tosudiva0	; vectored
tosudiva0		:=	$85C5
		.export	tosudivax	; vectored
tosudivax		:=	$85C8
		.export	tosudiveax	; vectored
tosudiveax		:=	$85CB
		.export	tosuge00	; vectored
tosuge00		:=	$85CE
		.export	tosugea0	; vectored
tosugea0		:=	$85D1
		.export	tosugeax	; vectored
tosugeax		:=	$85D4
		.export	tosugeeax	; vectored
tosugeeax		:=	$85D7
		.export	tosugt00	; vectored
tosugt00		:=	$85DA
		.export	tosugta0	; vectored
tosugta0		:=	$85DD
		.export	tosugtax	; vectored
tosugtax		:=	$85E0
		.export	tosugteax	; vectored
tosugteax		:=	$85E3
		.export	tosule00	; vectored
tosule00		:=	$85E6
		.export	tosulea0	; vectored
tosulea0		:=	$85E9
		.export	tosuleax	; vectored
tosuleax		:=	$85EC
		.export	tosuleeax	; vectored
tosuleeax		:=	$85EF
		.export	tosulong	; vectored
tosulong		:=	$85F2
		.export	tosult00	; vectored
tosult00		:=	$85F5
		.export	tosulta0	; vectored
tosulta0		:=	$85F8
		.export	tosultax	; vectored
tosultax		:=	$85FB
		.export	tosulteax	; vectored
tosulteax		:=	$85FE
		.export	tosumod0ax	; vectored
tosumod0ax		:=	$8601
		.export	tosumoda0	; vectored
tosumoda0		:=	$8604
		.export	tosumodax	; vectored
tosumodax		:=	$8607
		.export	tosumodeax	; vectored
tosumodeax		:=	$860A
		.export	tosumul0ax	; vectored
tosumul0ax		:=	$860D
		.export	tosumula0	; vectored
tosumula0		:=	$8610
		.export	tosumulax	; vectored
tosumulax		:=	$8613
		.export	tosumuleax	; vectored
tosumuleax		:=	$8616
		.export	tosxor0ax	; vectored
tosxor0ax		:=	$8619
		.export	tosxora0	; vectored
tosxora0		:=	$861C
		.export	tosxorax	; vectored
tosxorax		:=	$861F
		.export	tosxoreax	; vectored
tosxoreax		:=	$8622
		.export	tsteax	; vectored
tsteax		:=	$8625
		.export	udiv16	; vectored
udiv16		:=	$8628
		.export	udiv32	; vectored
udiv32		:=	$862B
		.export	udiv32by16r16	; vectored
udiv32by16r16		:=	$862E
		.export	udiv32by16r16m	; vectored
udiv32by16r16m		:=	$8631
		.export	umul16x16r16	; vectored
umul16x16r16		:=	$8634
		.export	umul16x16r16m	; vectored
umul16x16r16m		:=	$8637
		.export	umul16x16r32	; vectored
umul16x16r32		:=	$863A
		.export	umul16x16r32m	; vectored
umul16x16r32m		:=	$863D
		.export	umul8x16r16	; vectored
umul8x16r16		:=	$8640
		.export	umul8x16r16m	; vectored
umul8x16r16m		:=	$8643
		.export	umul8x16r24	; vectored
umul8x16r24		:=	$8646
		.export	umul8x16r24m	; vectored
umul8x16r24m		:=	$8649
		.export	umul8x8r16	; vectored
umul8x8r16		:=	$864C
		.export	umul8x8r16m	; vectored
umul8x8r16m		:=	$864F
		.export	utscopy	; vectored
utscopy		:=	$8652
		.export	utsdata
utsdata		:=	$00AFD4
		.export	utsteax	; vectored
utsteax		:=	$8655
		.export	xosfile_ret_read_delete_load	; vectored
xosfile_ret_read_delete_load		:=	$8658
