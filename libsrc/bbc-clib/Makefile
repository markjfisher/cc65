#
# cc65 makefile for the bbc-clib (ROM stub) target
# This target provides minimal stubs that call functions in the cc65 CLIB ROM
#

.SUFFIXES: .o .s .c

#--------------------------------------------------------------------------
# Programs and flags

SYS	= bbc-clib

AS	= ca65
CC	= cc65
LD	= ld65

AFLAGS	= -t bbc
CFLAGS	= -Osir -g -T -t bbc

#--------------------------------------------------------------------------
# Rules

%.o:   	%.c
	@$(CC) $(CFLAGS) $<
	@$(AS) -o $@ $(AFLAGS) $(*).s

%.o:	%.s
	@$(AS) -g -o $@ $(AFLAGS) $<

%.emd:	%.o ../runtime/zeropage.o
	@$(LD) -t module -o $@ $^

%.joy:	%.o ../runtime/zeropage.o
	@$(LD) -t module -o $@ $^

%.mou:	%.o ../runtime/zeropage.o
	@$(LD) -t module -o $@ $^

%.ser:	%.o ../runtime/zeropage.o
	@$(LD) -t module -o $@ $^

%.tgi:	%.o ../runtime/zeropage.o
	@$(LD) -t module -o $@ $^

#--------------------------------------------------------------------------
# Object files for ROM stub target
# Only includes startup, ROM detection, error handling, and ROM stubs

S_OBJS  =       crt0.o          \
                rom_detect.o    \
                rom_error.o     \
                rom_stubs.o

#--------------------------------------------------------------------------
# Targets

.PHONY:	all clean zap

all:	$(S_OBJS)

../runtime/zeropage.o:
	$(MAKE) -C $(dir $@) $(notdir $@)

clean:
	@$(RM) $(S_OBJS)

zap:	clean