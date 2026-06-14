; BBC MOS vector and entry point symbols
; (c) Dominic Beesley 2005

.import OSCLI
.import OSBYTE
.import OSWORD
.import OSWRCH
.import OSNEWL
.import OSASCI
.import OSRDCH
.import OSFILE
.import OSARGS
.import OSBGET
.import OSBPUT
.import OSGBPB
.import OSFIND
.import NVRDCH
.import NVWRCH
.import GSREAD
.import GSINIT
.import OSEVEN
.import OSRDRM

.import USERV
.import BRKV
.import IRQ1V
.import IRQ2V
.import CLIV
.import BYTEV
.import WORDV
.import WRCHV
.import RDCHV
.import FILEV
.import ARGSV
.import BGETV
.import BPUTV
.import GBPBV
.import FINDV
.import FSCV
.import EVNTV
.import UPTV
.import NETV
.import VDUV
.import KEYV
.import INSV
.import REMV
.import CNPV
.import IND1V
.import IND2V
.import IND3V
.import _OSASCI
.import _OSWRCH
.import VDU_WKSP

EVNTV_ESCAPE = 6