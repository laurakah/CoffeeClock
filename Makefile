# Hey Emacs, this is a -*- makefile -*-
#
# WinAVR makefile written by Eric B. Weddington, J�rg Wunsch, et al.
# Released to the Public Domain
# Please read the make user manual!
#
# Additional material for this makefile was submitted by:
#  Tim Henigan
#  Peter Fleury
#  Reiner Patommel
#  Sander Pool
#  Frederik Rouleau
#  Markus Pfaff
#
# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# make coff = Convert ELF to AVR COFF (for use with AVR Studio 3.x or VMLAB).
#
# make extcoff = Convert ELF to AVR Extended COFF (for use with AVR Studio
#                4.07 or greater).
#
# make program = Download the hex file to the device, using avrdude.  Please
#                customize the avrdude settings below first!
#
# make filename.s = Just compile filename.c into the assembler code only
#
# To rebuild project do "make clean" then "make all".
#

########
# Differences from WinAVR 20040720 sample:
# - DEPFLAGS according to Eric Weddingtion's fix (avrfreaks/gcc-forum)
# - F_OSC Define in CFLAGS and AFLAGS

ARCH=avr

# MCU name
MCU = atmega328p


# Main Oscillator Frequency
##F_OSC = 1843200
##F_OSC = 2000000
##F_OSC = 3686400
##F_OSC = 4000000
#F_OSC = 1000000
#F_OSC = 12000000
F_OSC   = 16000000
# Frequencies below 1,8MHz may only work in OW_ONE_BUS-Mode
##F_OSC =  1000000


# Output format. (can be srec, ihex, binary)
FORMAT = ihex


# Target file name (without extension).
TARGET = main


# List C source files here. (C dependencies are automatically generated.)
SRC = $(TARGET).c


# List Assembler source files here.
# Make them always end in a capital .S.  Files ending in a lowercase .s
# will not be considered source files but generated files (assembler
# output from the compiler), and will be deleted upon "make clean"!
# Even though the DOS/Win* filesystem matches both .s and .S the same,
# it will preserve the spelling of the filenames, and gcc itself does
# care about how the name is spelled on its command-line.
ASRC = 


# Optimization level, can be [0, 1, 2, 3, s]. 
# 0 = turn off optimization. s = optimize for size.
# (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = s

# Debugging format.
# Native formats for AVR-GCC's -g are stabs [default], or dwarf-2.
# AVR (extended) COFF requires stabs, plus an avr-objcopy run.
#DEBUG = stabs
DEBUG = dwarf-2

# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
EXTRAINCDIRS =

# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = -std=gnu99

# Place -D or -U options here
CDEFS = -DF_CPU=$(F_OSC)

# Place -I options here
CINCS = -I/Applications/Arduino.app/Contents/Java/hardware/tools/avr/avr/include


# Compiler flags.
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
CFLAGS = -g$(DEBUG)
CFLAGS += $(CDEFS) $(CINCS)
CFLAGS += -O$(OPT)
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -Wall -Wstrict-prototypes # -Werror
CFLAGS += -Wa,-adhlns=$(<:.c=.avr.lst)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
CFLAGS += $(CSTANDARD)
CFLAGS += -DF_OSC=$(F_OSC)



# Assembler flags.
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files -- see avr-libc docs [FIXME: not yet described there]
##ASFLAGS = -Wa,-adhlns=$(<:.S=.avr.lst),-gstabs
ASFLAGS = -Wa,-adhlns=$(<:.S=.avr.lst),-g$(DEBUG)
ASFLAGS += -DF_OSC=$(F_OSC)


#Additional libraries.

# Minimalistic printf version
PRINTF_LIB_MIN = -Wl,-u,vfprintf -lprintf_min

# Floating point printf version (requires MATH_LIB = -lm below)
PRINTF_LIB_FLOAT = -Wl,-u,vfprintf -lprintf_flt

PRINTF_LIB = 

# Minimalistic scanf version
SCANF_LIB_MIN = -Wl,-u,vfscanf -lscanf_min

# Floating point + %[ scanf version (requires MATH_LIB = -lm below)
SCANF_LIB_FLOAT = -Wl,-u,vfscanf -lscanf_flt

SCANF_LIB = 

MATH_LIB = -lm

# External memory options

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# used for variables (.data/.bss) and heap (malloc()).
#EXTMEMOPTS = -Wl,-Tdata=0x801100,--defsym=__heap_end=0x80ffff

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# only used for heap (malloc()).
#EXTMEMOPTS = -Wl,--defsym=__heap_start=0x801100,--defsym=__heap_end=0x80ffff

EXTMEMOPTS =

# Linker flags.
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(TARGET).$(ARCH).map,--cref
LDFLAGS += $(EXTMEMOPTS)
LDFLAGS += $(PRINTF_LIB) $(SCANF_LIB) $(MATH_LIB) -L/Applications/Arduino.app/Contents/Java/hardware/tools/avr/avr/lib




# Programming support using avrdude. Settings and variables.

# Programming hardware: alf avr910 avrisp bascom bsd 
# dt006 pavr picoweb pony-stk200 sp12 stk200 stk500
#
# Type: avrdude -c ?
# to get a full listing.
#
#AVRDUDE_PROGRAMMER = sp12
AVRDUDE_PROGRAMMER = arduino
#AVRDUDE_PROGRAMMER = stk500v2

# com1 = serial port. Use lpt1 to connect to parallel port.
AVRDUDE_PORT = /dev/cu.usbserial-A90ZRDH9   # programmer connected to serial device

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).$(ARCH).hex
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(TARGET).$(ARCH).eep


# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE_COUNTER = -y

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_NO_VERIFY = -V

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude> 
# to submit bug reports.
#AVRDUDE_VERBOSE = -v -v
AVRDUDE_VERBOSE = -v

AVRDUDE_FLAGS = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)
#AVRDUDE_FLAGS = -p $(MCU) -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS += $(AVRDUDE_NO_VERIFY)
AVRDUDE_FLAGS += $(AVRDUDE_VERBOSE)
AVRDUDE_FLAGS += $(AVRDUDE_ERASE_COUNTER)
AVRDUDE_FLAGS += -i 100 -B 100
AVRDUDE_FLAGS += -C/Applications/Arduino.app/Contents/Java/hardware/tools/avr/etc/avrdude.conf
AVRDUDE_FLAGS += -b 57600



# Simulation support using simulavr
SIMULAVR = simulavr
SIMULAVR_FLAGS = --device $(MCU)
SIMULAVR_FLAGS += --cpufrequency $(F_OSC)
SIMULAVR_FLAGS += --writetopipe 0x20,-
SIMULAVR_FLAGS += --readfrompipe 0x22,-
SIMULAVR_FLAGS += --irqstatistic
#SIMULAVR_FLAGS += --terminate exit
#SIMULAVR_FLAGS += --verbose

SIMULAVR_VCD_TRACELIST = simulavr-vcd-tracelist-$(MCU).txt
SIMULAVR_VCD_INFILE = simulavr-vcd-in.txt
SIMULAVR_VCD_OUTFILE = simulavr-vcd-out.txt

# ---------------------------------------------------------------------------

# Define directories, if needed.
DIRAVR = c:/winavr
DIRAVRBIN = $(DIRAVR)/bin
DIRAVRUTILS = $(DIRAVR)/utils/bin
DIRINC = .
DIRLIB = $(DIRAVR)/avr/lib


# Define programs and commands.
BASEDIRGCC = /Applications/Arduino.app/Contents/Java/hardware/tools/avr/bin

SHELL = sh
CC = $(BASEDIRGCC)/avr-gcc
OBJCOPY = $(BASEDIRGCC)/avr-objcopy
OBJDUMP = $(BASEDIRGCC)/avr-objdump
SIZE = $(BASEDIRGCC)/avr-size
NM = $(BASEDIRGCC)/avr-nm
AVRDUDE = $(BASEDIRGCC)/avrdude
REMOVE = rm -f
COPY = cp




# Define Messages
# English
MSG_ERRORS_NONE = Errors: none
MSG_BEGIN = -------- begin --------
MSG_END = --------  end  --------
MSG_SIZE_BEFORE = Size before: 
MSG_SIZE_AFTER = Size after:
MSG_COFF = Converting to AVR COFF:
MSG_EXTENDED_COFF = Converting to AVR Extended COFF:
MSG_FLASH = Creating load file for Flash:
MSG_EEPROM = Creating load file for EEPROM:
MSG_EXTENDED_LISTING = Creating Extended Listing:
MSG_SYMBOL_TABLE = Creating Symbol Table:
MSG_LINKING = Linking:
MSG_COMPILING = Compiling:
MSG_ASSEMBLING = Assembling:
MSG_CLEANING = Cleaning project:




# Define all object files.
OBJ = $(SRC:.c=.avr.o) $(ASRC:.S=.avr.o)

# Define all listing files.
LST = $(ASRC:.S=.avr.lst) $(SRC:.c=.avr.lst)


# Compiler flags to generate dependency files.
### GENDEPFLAGS = -Wp,-M,-MP,-MT,$(*F).o,-MF,.dep/$(@F).d
GENDEPFLAGS = -MD -MP -MF .dep/$(@F).$(ARCH).d

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = -mmcu=$(MCU) -I. $(CFLAGS) $(GENDEPFLAGS)
ALL_ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS)





# Default target.
all: begin gccversion sizebefore build sizeafter finished end

build: elf hex eep lss sym

elf: $(TARGET).$(ARCH).elf
hex: $(TARGET).$(ARCH).hex
eep: $(TARGET).$(ARCH).eep
lss: $(TARGET).$(ARCH).lss
sym: $(TARGET).$(ARCH).sym



# Eye candy.
# AVR Studio 3.x does not check make's exit code but relies on
# the following magic strings to be generated by the compile job.
begin:
	@echo
	@echo $(MSG_BEGIN)

finished:
	@echo $(MSG_ERRORS_NONE)

end:
	@echo $(MSG_END)
	@echo


# Display size of file.
HEXSIZE = $(SIZE) --target=$(FORMAT) $(TARGET).$(ARCH).hex
ELFSIZE = $(SIZE) --mcu=$(MCU) -C $(TARGET).$(ARCH).elf
sizebefore:
	@if [ -f $(TARGET).$(ARCH).elf ]; then echo; echo $(MSG_SIZE_BEFORE); $(ELFSIZE); echo; fi

sizeafter:
	@if [ -f $(TARGET).$(ARCH).elf ]; then echo; echo $(MSG_SIZE_AFTER); $(ELFSIZE); echo; fi



# Display compiler version information.
gccversion : 
	@$(CC) --version


# Create tracelist file for the target device for use with simulavr
$(SIMULAVR_VCD_TRACELIST):
	$(SIMULAVR) --device $(MCU) -o $(SIMULAVR_VCD_TRACELIST)
	cp $(SIMULAVR_VCD_TRACELIST) $(SIMULAVR_VCD_INFILE)
tracelist: $(SIMULAVR_VCD_TRACELIST)

# Run the simulator
sim: $(TARGET).$(ARCH).elf
	$(SIMULAVR) $(SIMULAVR_FLAGS) --file $(TARGET).$(ARCH).elf
# Run the simulator with VCD output
simvcd: $(TARGET).$(ARCH).elf $(SIMULAVR_VCD_TRACELIST)
	$(SIMULAVR) $(SIMULAVR_FLAGS) -c vcd:$(SIMULAVR_VCD_INFILE):$(SIMULAVR_VCD_OUTFILE) --file $(TARGET).$(ARCH).elf
simgdb: $(TARGET).$(ARCH).elf
	$(SIMULAVR) $(SIMULAVR_FLAGS) --gdbserver
debug: $(TARGET).$(ARCH).elf
	avr-gdb -ex "file $(TARGET).$(ARCH).elf" -ex "target remote :1212" -ex "load"
# Program the device.  
program: $(TARGET).$(ARCH).hex $(TARGET).$(ARCH).eep
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)



#upload: $(TARGET).$(ARCH).hex
#program: $(TARGET).$(ARCH).hex
#	uisp -dprog=stk500 -dpart=ATmega8 -v=3 --erase --upload if=$(TARGET).$(ARCH).hex
#	uisp -dprog=stk500 -dpart=ATmega8 -v=3 --verify if=$(TARGET).$(ARCH).hex

#verify: $(TARGET).$(ARCH).hex
#	uisp -dprog=stk500 -dpart=ATmega8 -v=3 --verify if=main.$(ARCH).hex



# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.
#COFFCONVERT=$(OBJCOPY) --debugging \
#--change-section-address .data-0x800000 \
#--change-section-address .bss-0x800000 \
#--change-section-address .noinit-0x800000 \
#--change-section-address .eeprom-0x810000 


coff: $(TARGET).$(ARCH).elf
	@echo
	@echo $(MSG_COFF) $(TARGET).$(ARCH).cof
	$(COFFCONVERT) -O coff-avr $< $(TARGET).$(ARCH).cof


extcoff: $(TARGET).$(ARCH).elf
	@echo
	@echo $(MSG_EXTENDED_COFF) $(TARGET).$(ARCH).cof
	$(COFFCONVERT) -O coff-ext-avr $< $(TARGET).$(ARCH).cof



# Create final output files (.hex, .eep) from ELF output file.
%.$(ARCH).hex: %.$(ARCH).elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.eep: %.elf
	@echo
	@echo $(MSG_EEPROM) $@
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Create extended listing file from ELF output file.
%.$(ARCH).lss: %.$(ARCH).elf
	@echo
	@echo $(MSG_EXTENDED_LISTING) $@
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
%.$(ARCH).sym: %.$(ARCH).elf
	@echo
	@echo $(MSG_SYMBOL_TABLE) $@
	$(NM) -n $< > $@



# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).$(ARCH).elf
.PRECIOUS : $(OBJ)
%.$(ARCH).elf: $(OBJ)
	@echo
	@echo $(MSG_LINKING) $@
	$(CC) $(ALL_CFLAGS) $(OBJ) --output $@ $(LDFLAGS)


# Compile: create object files from C source files.
%.$(ARCH).o : %.c
	@echo
	@echo $(MSG_COMPILING) $<
	$(CC) -c $(ALL_CFLAGS) $< -o $@ 


# Compile: create assembler files from C source files.
%.$(ARCH).s : %.c
	$(CC) -S $(ALL_CFLAGS) $< -o $@


# Assemble: create object files from assembler source files.
%.$(ARCH).o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c $(ALL_ASFLAGS) $< -o $@



tags:
	ctags -R /usr/lib/avr/include .

# Target: clean project.
clean: begin clean_list finished end

clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(TARGET).$(ARCH).hex
	$(REMOVE) $(TARGET).$(ARCH).eep
	$(REMOVE) $(TARGET).$(ARCH).obj
	$(REMOVE) $(TARGET).$(ARCH).cof
	$(REMOVE) $(TARGET).$(ARCH).elf
	$(REMOVE) $(TARGET).$(ARCH).map
	$(REMOVE) $(TARGET).$(ARCH).obj
	$(REMOVE) $(TARGET).$(ARCH).a90
	$(REMOVE) $(TARGET).$(ARCH).sym
	$(REMOVE) $(TARGET).$(ARCH).lnk
	$(REMOVE) $(TARGET).$(ARCH).lss
	$(REMOVE) $(OBJ)
	$(REMOVE) $(LST)
	$(REMOVE) $(SRC:.c=.$(ARCH).s)
	$(REMOVE) $(SRC:.c=.$(ARCH).d)
	$(REMOVE) .dep/*
	$(REMOVE) $(SIMULAVR_VCD_TRACELIST)
	$(REMOVE) $(SIMULAVR_VCD_INFILE)
	$(REMOVE) $(SIMULAVR_VCD_OUTFILE)



# Include the dependency files.
-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)


# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter gccversion \
build elf hex eep lss sym coff extcoff \
clean clean_list tracelist sim simvcd simgdb debug program tags

