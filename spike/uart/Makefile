## Dependancies to track.
DEPS = uart.h
## Binaries directory.
BIN = bin
## Build path.
BUILD = build
## Executable file name.
EXECUTABLE = main

## C compiler.
CC = avr-gcc
## C++ compiler.
CXX = avr-g++

# -> AVR variables.
## MCU name.
MCU = atmega328p

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

CSOURCES = main.c uart.c
ASOURCES =
_OBJECTS = $(CSOURCES:.c=.o) $(ASOURCES:.S=.o)
OBJECTS = $(patsubst %,$(BUILD)/%,$(_OBJECTS))
_LISTS = $(CSOURCES:.c=.lst) $(ASOURCES:.S=.lst)
LISTS = $(patsubst %,$(BUILD)/%,$(_LISTS))

info:
	@echo $(OBJECTS)
	@echo $(LISTS)

all: build

init:
	mkdir build bin

build: $(OBJECTS)
	$(CC) -o ${BIN}/${EXECUTABLE} $(OBJECTS) $(CFLAGS)

$(BUILD)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)


.PHONY: clean

clean:
	rm -rf ${BIN}
	rm -rf ${BUILD}

## $< is the first item in the dependencies list
## special macros '$@' and '$^' are the left and right sides of the ':'
