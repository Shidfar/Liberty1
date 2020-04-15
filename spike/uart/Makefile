# ------------------ High Level Config ------------------ #

## Executable file name.
EXECUTABLE = main
## Microcontroller Model
MCU_NAME = atmega328p
## AVR Dude programmer
PROGRAMMER_NAME = arduino
## Port
PORT_PATH = /dev/ttyACM0

# ------------------------------------------------------- #
#					###		###		###					  #
# ------------------------ Config ----------------------- #

## Binaries directory.
BIN = bin
## Build path.
BUILD = build

## Dependancies to track.
DEPS = uart.h
## C sources and Assembly sources
CSOURCES = main.c uart.c
ASOURCES =

## C compiler.
CC = avr-gcc
## C++ compiler.
CXX = avr-g++

# Programs and commands.
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
NM = avr-nm
AVRDUDE = avrdude

# -> AVR variables.
## MCU name.
MCU = ${MCU_NAME}

## Processor frequency.
F_CPU = 16000000

# Debugging format.
#     Native formats for AVR-GCC's -g are dwarf-2 [default] or stabs.
#     AVR Studio 4.10 requires dwarf-2.
#     AVR [Extended] COFF format requires stabs, plus an avr-objcopy run.
DBG = -gdwarf-2

# Optimization level, can be [0, 1, 2, 3, s].
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = -Os

## Output format. (can be srec, ihex, binary).
FORMAT = ihex

# <- EOF AVR variables.

## Defines. -D and -U options.
CDEFS = -DF_CPU=$(F_CPU)UL

# Includes. -I options.
_CINCS = . /usr/local/avr/avr/include/
CINCS = $(patsubst %,-I%,$(_CINCS))

# Compiler flag to set the C Standard level.
#     c89   = "ANSI" C
#     gnu89 = c89 plus GCC extensions
#     c99   = ISO C99 standard (not yet fully implemented)
#     gnu99 = c99 plus GCC extensions
CSTANDARD = -std=gnu99

## C-flags.
CFLAGS = $(DBG) $(CDEFS) $(CINCS) $(OPT) \
		-funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums \
		-Wall -Wstrict-prototypes \
		-Wa,-adhlns=$(patsubst %,$(BUILD)/%,$(<:.c=.lst)) \
		$(CSTANDARD)
## Assembly-flags
AFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs

## Compiler flags to generate dependency files.
GENDEPFLAGS = -MD -MP -MF build/$(@F).d

# Combine all necessary flags and optional flags.
# Add target processor to flags.
ALL_CFLAGS = -mmcu=$(MCU) -I. $(CFLAGS) $(GENDEPFLAGS)
ALL_ASFLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(AFLAGS)

## Define all Object & Listing files
_OBJECTS = $(CSOURCES:.c=.o) $(ASOURCES:.S=.o)
OBJECTS = $(patsubst %,$(BUILD)/%,$(_OBJECTS))
_LISTS = $(CSOURCES:.c=.lst) $(ASOURCES:.S=.lst)
LISTS = $(patsubst %,$(BUILD)/%,$(_LISTS))

# ------------------------------------------------------- #
#					###		###		###					  #
# ---------------------- Libraries ---------------------- #

## > Minimalistic printf version
PRINTF_LIB_MIN = -Wl,-u,vfprintf -lprintf_min
## > Floating point printf version (requires MATH_LIB = -lm below)
PRINTF_LIB_FLOAT = -Wl,-u,vfprintf -lprintf_flt
### = If this is left blank, then it will use the Standard printf version.
PRINTF_LIB =
# PRINTF_LIB = $(PRINTF_LIB_MIN)
# PRINTF_LIB = $(PRINTF_LIB_FLOAT)

## > Minimalistic scanf version
SCANF_LIB_MIN = -Wl,-u,vfscanf -lscanf_min

## > Floating point + %[ scanf version (requires MATH_LIB = -lm below)
SCANF_LIB_FLOAT = -Wl,-u,vfscanf -lscanf_flt

### = If this is left blank, then it will use the Standard scanf version.
SCANF_LIB =
#SCANF_LIB = $(SCANF_LIB_MIN)
#SCANF_LIB = $(SCANF_LIB_FLOAT)

MATH_LIB = -lm

# ------------------------------------------------------- #
#					###		###		###					  #
# ------------------- External Memory ------------------- #

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# used for variables (.data/.bss) and heap (malloc()).
#EXTMEMOPTS = -Wl,-Tdata=0x801100,--defsym=__heap_end=0x80ffff

# 64 KB of external RAM, starting after internal RAM (ATmega128!),
# only used for heap (malloc()).
#EXTMEMOPTS = -Wl,--defsym=__heap_start=0x801100,--defsym=__heap_end=0x80ffff

EXTMEMOPTS =

# ------------------------------------------------------- #
#					###		###		###					  #
# ----------------------- Linker ------------------------ #

#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(BUILD)/$(EXECUTABLE).map,--cref
LDFLAGS += $(EXTMEMOPTS)
LDFLAGS += $(PRINTF_LIB) $(SCANF_LIB) $(MATH_LIB)

# ------------------------------------------------------- #
#					###		###		###					  #
# ------------------- Utils variables ------------------- #
# Display size of file.
ELFFILE = ${BIN}/${EXECUTABLE}.elf
HEXFILE = ${BIN}/${EXECUTABLE}.hex

HEXSIZE = $(SIZE) --target=$(FORMAT) $(HEXFILE)
ELFSIZE = $(SIZE) -A $(ELFFILE)
AVRMEM = avr-mem.sh $(ELFFILE) $(MCU)
# ------------------------------------------------------- #
#            ###             ###           ###            #
# ------------ Programming Options (avrdude) ------------ #

# Programming hardware: alf avr910 avrisp bascom bsd
# dt006 pavr picoweb pony-stk200 sp12 stk200 stk500
#
# Type: avrdude -c ?
# to get a full listing.
#
AVRDUDE_PROGRAMMER = ${PROGRAMMER_NAME}

# com1 = serial port. Use lpt1 to connect to parallel port.
# programmer connected to serial device
AVRDUDE_PORT = ${PORT_PATH}

AVRDUDE_WRITE_FLASH = -U flash:w:${BIN}/${EXECUTABLE}.hex
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:${BIN}/${EXECUTABLE}.eep


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

AVRDUDE_FLAGS = -p $(MCU) \
				-P $(AVRDUDE_PORT) \
				-c $(AVRDUDE_PROGRAMMER) \
				-b 115200 #57600 \
				$(AVRDUDE_NO_VERIFY) $(AVRDUDE_VERBOSE) $(AVRDUDE_ERASE_COUNTER)

# ------------------------------------------------------- #

info:
	@echo $(OBJECTS)
	@echo $(LISTS)

all: init \
	prebuild \
	build \
	postbuild

init: \
	gccversion
	@echo ""
	@echo " ## Initializing..."
	@if [ ! -d "bin" ]; then \
		echo " > mkdir bin"; mkdir bin; \
	else echo " > bin folder exists."; \
	fi
	@if [ ! -d "build" ]; then \
		echo " > mkdir build"; mkdir build; \
	else echo " > build folder exists."; \
	fi
	@sleep 1
	@echo ""

gccversion:
	@echo ""
	@$(CC) --version

prebuild: \
	sizebefore
	@echo " ## Building Objects..."

build: \
	build-elf \
	build-hex \
	build-eep \
	build-lss \
	build-sym

postbuild: \
	sizeafter
	@echo " ## Done building objects..."

#$(OBJECTS)
#	$(CC) -o ${BIN}/${EXECUTABLE} $(OBJECTS) $(CFLAGS)

build-elf: ${BIN}/${EXECUTABLE}.elf
build-hex: ${BIN}/${EXECUTABLE}.hex
build-eep: ${BIN}/${EXECUTABLE}.eep
build-lss: ${BIN}/${EXECUTABLE}.lss
build-sym: ${BIN}/${EXECUTABLE}.sym

# --------------------- Fun utils: --------------------- #

sizebefore:
	@echo $(ELFFILE);
	@if test -f $(ELFFILE); then \
		echo; echo "Size before: "; $(ELFSIZE); \
		$(AVRMEM) 2>/dev/null; echo; \
	fi

sizeafter:
	@if test -f $(ELFFILE); then \
		echo; echo "Size after: "; $(ELFSIZE); \
		$(AVRMEM) 2>/dev/null; echo; \
	fi

# ------------------------------------------------------- #
#            ###             ###           ###            #
# ------------------------ Upload ----------------------- #

HEXFILE = ${BIN}/${EXECUTABLE}.hex
EEPFILE = ${BIN}/${EXECUTABLE}.eep

upload: $(HEXFILE) $(EEPFILE)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)

# ------------------------------------------------------- #
#            ###             ###           ###            #
# ----------------------- CleanUp ----------------------- #

.PHONY: clean

clean:
	rm -rf ${BIN}
	rm -rf ${BUILD}

# ------------------------------------------------------- #
#            ###             ###           ###            #
# ------------------- Transformations ------------------- #

## C
.SECONDARY : ${BUILD}/${EXECUTABLE}.elf
.PRECIOUS : $(OBJECTS)
$(BUILD)/%.o: %.c $(DEPS)
	$(CC) -c $(ALL_CFLAGS) $< -o $@
#	$(CC) -c -o $@ $< $(CFLAGS)

$(BIN)/%.elf: $(OBJECTS)
	@echo
	@echo " ## Linking .o files into " $@
	$(CC) $(ALL_CFLAGS) $^ --output $@ $(LDFLAGS)

$(BIN)/%.hex: $(BIN)/%.elf
	@echo
	@echo "Creating .hex from ELF file" $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

$(BIN)/%.eep: $(BIN)/%.elf
	@echo
	@echo "Creating .eep from ELF file" $@
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

$(BIN)/%.lss: $(BIN)/%.elf
	@echo
	@echo "Create extended listing file (.lss) from ELF output file." $@
	$(OBJDUMP) -h -S $< > $@

$(BIN)/%.sym: $(BIN)/%.elf
	@echo
	@echo "Create a symbol (.sym) table from ELF file" $@
	$(NM) -n $< > $@

## Assembler
# Compile: create assembler files from C source files.
%.s : %.c
	$(CC) -S $(ALL_CFLAGS) $< -o $@

# Assemble: create object files from assembler source files.
%.o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c $(ALL_ASFLAGS) $< -o $@

# Create preprocessed source for use in sending a bug report.
%.i : %.c
	$(CC) -E -mmcu=$(MCU) -I. $(CFLAGS) $< -o $@


## $< is the first item in the dependencies list
## special macros '$@' and '$^' are the left and right sides of the ':'
