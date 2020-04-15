CC = avr-gcc
CXX = avr-g++
CC_AR = avr-gcc-ar
MCU_NAME = atmega328p
AVRDUDE = avrdude
PROGRAMMER_NAME = arduino
F_CPU = 16000000
APP_NAME = app
BAUD_RATE = 9600

PORT_PATH = /dev/ttyACM0

BIN_PATH = bin
BUILD_PATH = build

COMMON_FLAGS = -g -flto -mmcu=${MCU_NAME}
COMMON_DEFS = -DF_CPU=$(F_CPU)UL -DARDUINO=10809 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR -DBAUD=${BAUD_RATE} -D__AVR_ATmega328P__

INCLUDE_PATHS = include/arduino \
	include/standard include/custom
INCLUDES = $(patsubst %,-I%,$(INCLUDE_PATHS))

ASSEMBLY_FLAGS = ${COMMON_FLAGS} ${COMMON_DEFS} \
	-x assembler-with-cpp -c -MMD

OPTIMIZATION = -Os
DEBUG = -gdwarf-2
C_STANDARD = -std=gnu11
C_FLAGS = ${C_STANDARD} ${OPTIMIZATION} ${COMMON_FLAGS} ${COMMON_DEFS} ${DEBUG} \
	-w -ffunction-sections -fdata-sections \
	-fno-fat-lto-objects -c -MMD
C_LINKER_FLAGS = ${OPTIMIZATION} ${COMMON_FLAGS} -w -fuse-linker-plugin -Wl,--gc-sections -L./${BUILD_PATH} -lm

CXX_STANDARD = -std=gnu++11
CXX_FLAGS = ${CXX_STANDARD} ${OPTIMIZATION} ${COMMON_FLAGS} ${COMMON_DEFS} \
	-c -w -fpermissive -fno-exceptions -ffunction-sections -fdata-sections \
	-fno-threadsafe-statics -Wno-error=narrowing -MMD

# CORE
CORE_PREFIX = __core__
CORE_DIR_PATH = ${BUILD_PATH}/core
CORE_ARCHIVE_DIR_PATH = ${CORE_DIR_PATH}/archive
CORE_ARCHIVE_PATH = ${CORE_ARCHIVE_DIR_PATH}/core.a

## ASSEMBLY
ASSEMBLY_CORE_SOURCES = include/arduino/wiring_pulse.S
ASSEMBLY_CORE_OBJECTS = $(ASSEMBLY_CORE_SOURCES:.S=.S.o) $(ASSEMBLY_CORE_SOURCES:.s=.s.o)
ASSEMBLY_CORE_PREFIXED_OBJECTS = $(patsubst %.o, ${CORE_PREFIX}/%.o, ${ASSEMBLY_CORE_OBJECTS})

## C
C_CORE_DEPENDENCIES = include/custom/uart.h
C_CORE_SOURCES = include/arduino/WInterrupts.c include/arduino/wiring_analog.c \
	include/arduino/wiring.c include/arduino/wiring_pulse.c \
	include/arduino/wiring_digital.c include/arduino/hooks.c \
	include/arduino/wiring_shift.c include/custom/uart.c
C_CORE_OBJECTS = $(C_CORE_SOURCES:.c=.c.o) $(C_CORE_SOURCES:.C=.C.o)
C_CORE_PREFIXED_OBJECTS = $(patsubst %.o, ${CORE_PREFIX}/%.o, ${C_CORE_OBJECTS})

## C++
CXX_CORE_SOURCES = include/arduino/USBCore.cpp include/arduino/HardwareSerial0.cpp \
	include/arduino/HardwareSerial2.cpp include/arduino/HardwareSerial.cpp \
	include/arduino/HardwareSerial3.cpp include/arduino/CDC.cpp \
	include/arduino/WString.cpp include/arduino/PluggableUSB.cpp \
	include/arduino/Stream.cpp include/arduino/Tone.cpp \
	include/arduino/abi.cpp include/arduino/HardwareSerial1.cpp \
	include/arduino/new.cpp include/arduino/Print.cpp include/arduino/WMath.cpp \
	include/arduino/IPAddress.cpp 
# src/main.cpp
CXX_CORE_OBJECTS = $(CXX_CORE_SOURCES:.cpp=.cpp.o) $(CXX_CORE_SOURCES:.CPP=.CPP.o)
CXX_CORE_PREFIXED_OBJECTS = $(patsubst %.o, ${CORE_PREFIX}/%.o, ${CXX_CORE_OBJECTS})

# APP
APP_PREFIX = __app__
ARCHIVE_PATH = ${BUILD_PATH}/${APP_NAME}.a
CXX_SOURCES = src/main.cpp
# src/blink.cpp
CXX_OBJECTS = $(CXX_SOURCES:.cpp=.cpp.o)
CXX_PREFIXED_OBJECTS = $(patsubst %.o, ${APP_PREFIX}/%.o, ${CXX_OBJECTS})

# AVRDUDE
AVRDUDE_FLAGS = -p $(MCU_NAME) \
				-P $(PORT_PATH) \
				-c $(PROGRAMMER_NAME) \
				-b 115200

AVRDUDE_WRITE_FLASH = -U flash:w:${BIN_PATH}/${APP_NAME}.hex
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:${BIN}/${EXECUTABLE}.eep

# Rules
.PHONY: init
init:
	@mkdir -p ${BIN_PATH} ${BUILD_PATH} ${CORE_DIR_PATH} ${CORE_ARCHIVE_DIR_PATH}

.PHONY: all
all: init \
	build-core \
	$(CXX_PREFIXED_OBJECTS) \
	link \
	obj-size \
	obj-copy

.PHONY: obj-copy
obj-copy:
	avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings \
		--change-section-lma .eeprom=0 ${BIN_PATH}/${APP_NAME}.elf ${BIN_PATH}/${APP_NAME}.eep
	avr-objcopy -O ihex -R .eeprom ${BIN_PATH}/${APP_NAME}.elf ${BIN_PATH}/${APP_NAME}.hex

.PHONY: obj-size
obj-size:
	avr-size -A ${BIN_PATH}/${APP_NAME}.elf

detect-libs:
	$(CXX) -c -g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections \
		-fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -flto -w -x c++ -E \
    	-CC -mmcu=atmega328p ${COMMON_DEFS} ${INCLUDES} \
		src/blink.cpp -o /dev/null

.PHONY: build-core
build-core: init \
	$(ASSEMBLY_CORE_PREFIXED_OBJECTS) \
	$(C_CORE_PREFIXED_OBJECTS) \
	$(CXX_CORE_PREFIXED_OBJECTS)

.PHONY: link
link:
	@echo " > ${CXX_OBJECTS}"
	# $(CC) ${C_LINKER_FLAGS} ${ARCHIVE_PATH} ${CORE_ARCHIVE_PATH} -o ${BIN_PATH}/${APP_NAME}.elf
	$(CC) ${C_LINKER_FLAGS}  \
	$(patsubst %, ${BUILD_PATH}/%, $(notdir ${CXX_OBJECTS})) ${CORE_ARCHIVE_PATH} \
		-o ${BIN_PATH}/${APP_NAME}.elf

.PHONY: upload
upload: $(HEXFILE) $(EEPFILE)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)

.PHONY: clean
clean:
	rm -rf ${BIN_PATH} ${BUILD_PATH}

${CORE_PREFIX}/%.s.o: %.s
	$(CC) ${ASSEMBLY_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)
${CORE_PREFIX}/%.S.o: %.S
	$(CC) ${ASSEMBLY_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)

${CORE_PREFIX}/%.C.o: %.C $(C_CORE_DEPENDENCIES)
	$(CC) ${C_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)
${CORE_PREFIX}/%.c.o: %.c $(C_CORE_DEPENDENCIES)
	$(CC) ${C_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)

${CORE_PREFIX}/%.cpp.o: %.cpp
	$(CXX) ${CXX_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)
${CORE_PREFIX}/%.CPP.o: %.CPP
	$(CXX) ${CXX_FLAGS} ${INCLUDES} $< -o ${CORE_DIR_PATH}/$(notdir $@)
	$(CC_AR) rcs ${CORE_ARCHIVE_PATH} ${CORE_DIR_PATH}/$(notdir $@)

${APP_PREFIX}/%.cpp.o: %.cpp
	$(CXX) ${CXX_FLAGS} ${INCLUDES} $< -o ${BUILD_PATH}/$(notdir $@)
	$(CC_AR) rcs ${ARCHIVE_PATH} ${BUILD_PATH}/$(notdir $@)
# $(CC) ${C_LINKER_FLAGS}  ${BUILD_PATH}/$(notdir $@) ${CORE_ARCHIVE_PATH} -o ${BIN_PATH}/${APP_NAME}.elf
