# ---- Display info during parsing phase ----
SILENT:=$(findstring s,$(word 1, $(MAKEFLAGS)))
ifneq ($(SILENT),s)
    $(info Using Makefile: $(realpath $(firstword $(MAKEFILE_LIST))) $(MAKECMDGOALS))
endif

ifneq ($(shell echo),)
  CMD_EXE = 1
endif

ifeq ($(SILENT),s)
    QUIET = 1
endif

ifdef QUIET
    .SILENT:
    PQ = "QUIET=1"
    PD = --no-print-directory
endif

CBMS = c128   \
       c16    \
       c64    \
       c65    \
       cbm510 \
       cbm610 \
       cx16   \
       mega65 \
       pet    \
       plus4  \
       vic20

GEOS = geos-apple \
       geos-cbm

TARGETS = agat         \
          apple2       \
          apple2enh    \
          atari        \
          atarixl      \
          atari2600    \
          atari5200    \
          atari7800    \
          atmos        \
          creativision \
          $(CBMS)      \
          $(GEOS)      \
          gamate       \
          kim1         \
          lynx         \
          nes          \
          none         \
          osic1p       \
          pce          \
          rp6502       \
          sim6502      \
          sim65c02     \
          supervision  \
          sym1         \
          telestrat    \
          bbc          \
          bbc-clib

TARGETTEST = none     \
             sim6502  \
             sim65c02

DRVTYPES = emd \
           joy \
           mou \
           ser \
           tgi

OUTPUTDIRS := lib                                                                             \
              asminc                                                                          \
              cfg                                                                             \
              include                                                                         \
              $(subst ../,,$(filter-out $(wildcard ../include/*.*),$(wildcard ../include/*))) \
              $(subst ../,,$(wildcard ../target/*/drv/*))                                     \
              $(subst ../,,$(wildcard ../target/*/util))

.PHONY: all mostlyclean clean install zip lib libtest $(TARGETS)

.SUFFIXES:

ifdef CMD_EXE
  DIRLIST = $(strip $(foreach dir,$1,$(wildcard $(dir))))
  MKDIR = mkdir $(subst /,\,$1)
  RMDIR = $(if $(DIRLIST),rmdir /s /q $(subst /,\,$(DIRLIST)))
else
  MKDIR = mkdir -p $1
  RMDIR = $(RM) -r $1
endif

# Every target requires its individual vpath setting but the vpath directive
# acts globally. Therefore each target is built in a separate make instance.

ifeq ($(words $(MAKECMDGOALS)),1)
  ifeq ($(MAKECMDGOALS),$(filter $(MAKECMDGOALS),$(TARGETS)))
    TARGET = $(MAKECMDGOALS)
  endif
endif

ifndef TARGET

datadir = $(PREFIX)/share/cc65

all lib: $(TARGETS)

libtest: $(TARGETTEST)

mostlyclean:
	$(call RMDIR,../libwrk)

clean:
	$(call RMDIR,../libwrk ../lib ../target)

ifdef CMD_EXE

install:

else # CMD_EXE

INSTALL = install

define INSTALL_recipe

$(INSTALL) -d $(DESTDIR)$(datadir)/$(dir)
$(INSTALL) -m0644 ../$(dir)/*.* $(DESTDIR)$(datadir)/$(dir)

endef # INSTALL_recipe

install:


	$(foreach dir,$(OUTPUTDIRS),$(INSTALL_recipe))
	
	$(INSTALL) -d $(DESTDIR)$(datadir)/include
	$(INSTALL) -d $(DESTDIR)$(datadir)/include/oslib
	$(INSTALL) -m0644 bbc/oslib/*.h $(DESTDIR)$(datadir)/include/oslib
	$(INSTALL) -m0644 bbc/oslib/*.inc $(DESTDIR)$(datadir)/include/oslib
	$(INSTALL) -d $(DESTDIR)$(datadir)/include/oslib-clib
	$(INSTALL) -m0644 bbc-clib/oslib/*.h $(DESTDIR)$(datadir)/include/oslib-clib
	$(INSTALL) -m0644 bbc-clib/oslib/*.inc $(DESTDIR)$(datadir)/include/oslib-clib

endif # CMD_EXE

define ZIP_recipe

@cd .. && zip cc65 $(dir)/*.*

endef # ZIP_recipe

zip:
	$(foreach dir,$(OUTPUTDIRS),$(ZIP_recipe))

$(TARGETS): | ../lib
	@$(MAKE) $(PD) $@ $(PQ)

# ../lib must be created globally before doing lib targets in parallel
../lib:
	@$(call MKDIR,$@)

else # TARGET

CA65FLAGS = -g
CC65FLAGS = -g -Or -W error

EXTZP = cbm510 \
        cbm610 \
        lynx

MKINC = $(GEOS) \
        atari   \
        atarixl \
        nes

TARGETUTIL = apple2    \
             apple2enh \
             atari

GEOSDIRS = common      \
           conio       \
           disk        \
           dlgbox      \
           file        \
           graph       \
           memory      \
           menuicon    \
           mousesprite \
           process     \
           runtime     \
           system

ifeq ($(TARGET),apple2enh)
  SRCDIR = apple2
  OBJPFX = a2
  DRVPFX = a2e
else ifeq ($(TARGET),atarixl)
  SRCDIR = atari
  OBJPFX = atr
  DRVPFX = atrx
else ifeq ($(TARGET),sim65c02)
  SRCDIR = sim6502
else
  SRCDIR = $(TARGET)
endif

SRCDIRS = $(SRCDIR)

ifeq ($(TARGET),$(filter $(TARGET),$(CBMS)))
  SRCDIRS += cbm
endif

ifeq ($(TARGET),$(filter $(TARGET),$(GEOS)))
  SRCDIRS += $(addprefix $(TARGET)/,  $(GEOSDIRS))
  SRCDIRS += $(addprefix geos-common/,$(GEOSDIRS))
endif

ifeq ($(TARGET), bbc)
  SRCDIRS += bbc/oslib
endif

ifeq ($(TARGET), bbc-clib)
  # Include main bbc-clib directory for ROM-specific files
  SRCDIRS += bbc-clib
  # Exclude oslib to avoid duplicate OS function symbols with ROM stubs
  # SRCDIRS += bbc-clib/oslib  
endif

# ROM targets that use manifest-driven function selection
ROM_TARGETS = bbc-clib

# Add common library sources for all targets except ROM targets
ifeq ($(filter $(TARGET),$(ROM_TARGETS)),)
  SRCDIRS += common   \
             conio    \
             dbg      \
             em       \
             joystick \
             mouse    \
             runtime  \
             serial   \
             tgi      \
             zlib
else
  # For ROM targets, include common/runtime sources but filter based on manifests
  SRCDIRS += common runtime
  # Note: Manifest-based filtering happens after OBJS collection
endif

vpath %.s $(SRCDIRS)
vpath %.c $(SRCDIRS)

OBJS := $(patsubst %.s,%.o,$(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.s)))
OBJS += $(patsubst %.c,%.o,$(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.c)))

OBJS := $(addprefix ../libwrk/$(TARGET)/,$(sort $(notdir $(OBJS))))

# For ROM targets, filter out objects that conflict with ROM functions
ifeq ($(filter $(TARGET),$(ROM_TARGETS)),$(TARGET))
  # Exclude common runtime functions that are available in ROM
  # These correspond to functions in rom_functions.manifest
  ROM_CONFLICT_OBJS = add.o tosaddax.o tosmulax.o tossubax.o tosdivax.o \
                     div.o mul.o sub.o and.o or.o xor.o shl.o shr.o \
                     pushax.o popax.o incsp1.o incsp2.o decsp1.o decsp2.o
  OBJS := $(filter-out $(addprefix ../libwrk/$(TARGET)/,$(ROM_CONFLICT_OBJS)),$(OBJS))
endif

DEPS = $(OBJS:.o=.d)

EXTRA_SRCPAT = $(SRCDIR)/extra/%.s
EXTRA_OBJPAT = ../lib/$(TARGET)-%.o
EXTRA_OBJS := $(patsubst $(EXTRA_SRCPAT),$(EXTRA_OBJPAT),$(wildcard $(SRCDIR)/extra/*.s))
DEPS += $(EXTRA_OBJS:../lib/%.o=../libwrk/$(TARGET)/%.d)

ZPOBJ = ../libwrk/$(TARGET)/zeropage.o
ifeq ($(TARGET),$(filter $(TARGET),$(EXTZP)))
  ZPOBJ += ../libwrk/$(TARGET)/extzp.o
endif

ifeq ($(TARGET),$(filter $(TARGET),$(MKINC)))
  include $(SRCDIR)/Makefile.inc
endif

ifeq ($(TARGET),$(filter $(TARGET),$(TARGETUTIL)))
  include $(SRCDIR)/targetutil/Makefile.inc
endif

define DRVTYPE_template

$1_SRCDIR = $$(SRCDIR)/$1
$1_STCDIR = ../libwrk/$$(TARGET)
$1_DYNDIR = ../libwrk/$$(TARGET)/$1
$1_DRVDIR = ../target/$$(TARGET)/drv/$1

$1_SRCPAT = $$($1_SRCDIR)/$$(OBJPFX)%.s
$1_STCPAT = $$($1_STCDIR)/$$(OBJPFX)%-$1.o
$1_DYNPAT = $$($1_DYNDIR)/$$(OBJPFX)%.o
$1_DRVPAT = $$($1_DRVDIR)/$$(DRVPFX)%.$1

$1_SRCS := $$(wildcard $$($1_SRCDIR)/*.s)
$1_STCS = $$(patsubst $$($1_SRCPAT),$$($1_STCPAT),$$($1_SRCS))
$1_DYNS = $$(patsubst $$($1_SRCPAT),$$($1_DYNPAT),$$($1_SRCS))
$1_DRVS = $$(patsubst $$($1_DYNPAT),$$($1_DRVPAT),$$($1_DYNS))

$$($1_STCPAT): $$($1_SRCPAT)
	$$(if $$(QUIET),@echo $$(TARGET) - $$< - static)
	$$(CA65) -t $$(TARGET) -D DYN_DRV=0 $$(CA65FLAGS) --create-dep $$(@:.o=.d) -o $$@ $$<

OBJS += $$($1_STCS)
DEPS += $$($1_STCS:.o=.d)

$$($1_DYNS): | $$($1_DYNDIR)

$$($1_DRVPAT): $$($1_DYNPAT) $$(ZPOBJ) | $$($1_DRVDIR)
	$$(if $$(QUIET),@echo $$(TARGET) - $$(<F))
	$$(LD65) -o $$@ -t module $$^

$$($1_DYNDIR) $$($1_DRVDIR):
	@$$(call MKDIR,$$@)

$(TARGET): $$($1_DRVS)

DEPS += $$($1_DYNS:.o=.d)

endef # DRVTYPE_template

$(foreach drvtype,$(DRVTYPES),$(eval $(call DRVTYPE_template,$(drvtype))))

AR65 := $(if $(wildcard ../bin/ar65*),../bin/ar65,ar65)
CA65 := $(if $(wildcard ../bin/ca65*),../bin/ca65,ca65)
CC65 := $(if $(wildcard ../bin/cc65*),../bin/cc65,cc65)
LD65 := $(if $(wildcard ../bin/ld65*),../bin/ld65,ld65)

export CC65_HOME := $(abspath ..)

define ASSEMBLE_recipe

    $(if $(QUIET),@echo $(TARGET) - $<)
    $(CA65) -t $(TARGET) $(CA65FLAGS) --create-dep $(@:.o=.d) -o $@ $<

endef # ASSEMBLE_recipe

define COMPILE_recipe

    $(if $(QUIET),@echo $(TARGET) - $<)
    $(CC65) -t $(TARGET) $(CC65FLAGS) --create-dep $(@:.o=.d) --dep-target $@ -o $(@:.o=.s) $<
    $(CA65) -t $(TARGET) -o $@ $(@:.o=.s)

endef # COMPILE_recipe

../libwrk/$(TARGET)/%.o: %.s | ../libwrk/$(TARGET)
	$(ASSEMBLE_recipe)

../libwrk/$(TARGET)/%.o: %.c | ../libwrk/$(TARGET)
	$(COMPILE_recipe)

$(EXTRA_OBJPAT): $(EXTRA_SRCPAT) | ../libwrk/$(TARGET) ../lib
	$(if $(QUIET),@echo $(TARGET) - $(<F))
	@$(CA65) -t $(TARGET) $(CA65FLAGS) --create-dep $(@:../lib/%.o=../libwrk/$(TARGET)/%.d) -o $@ $<

$(EXTRA_OBJS): | ../lib

../lib/$(TARGET).lib: $(OBJS) | ../lib
	$(if $(QUIET),@echo $(TARGET) - $<)
	$(AR65) a $@ $?

../libwrk/$(TARGET) ../target/$(TARGET)/util:
	@$(call MKDIR,$@)

$(TARGET): $(EXTRA_OBJS) ../lib/$(TARGET).lib

-include $(DEPS)

endif # TARGET
