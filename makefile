#
# Copyright (c) 2016 Mieszko Mazurek
#

PROJ		= arduino
PORT		= /dev/ttyACM0
CXXEXT		= cxx

SRC		= ${shell find . -name '*.c' -or -name '*.${CXXEXT}'}
OBJ		= ${SRC:./%=obj/%.o}
DEP		= ${OBJ:%.o=%.d}

ELF		= ${PROJ}.elf
HEX		= ${PROJ}.hex

FLAGS		= -DF_CPU=16000000UL -mmcu=atmega328p -O2 -Wall -Iinc/ -D__arduino_uno__
CFLAGS		= ${FLAGS} -std=gnu11
CXXFLAGS	= ${FLAGS} -std=gnu++11
LDFLAGS		= -Tldscripts/avr5.xn libavrmeos.a -mmcu=atmega328p

CC		= avr-gcc -c
CXX		= avr-g++ -c
LD		= avr-g++
CP		= avr-objcopy

all: elf

elf: ${ELF}

hex: ${HEX}

flash: ${HEX}
	@echo flash: $<
	@avrdude -F -V -P ${PORT} -c arduino -p m328p -U flash:w:$<

size: ${ELF}
	@avr-size $<

clean:
	@echo clean
	@rm -fr obj/ ${HEX} ${ELF}

${ELF}: ${OBJ}
	@echo link: $^
	@${LD} $^ -o $@ ${LDFLAGS}

${HEX}: ${ELF}
	@echo copy: $<
	@${CP} -j .text -j .data -Oihex $< $@

obj/%.${CXXEXT}.o: %.${CXXEXT}
	@echo compile: $<
	@mkdir -p ${dir $@}
	@${CXX} $< -o $@ ${CXXFLAGS} -MMD

obj/%.c.o: %.c
	@echo compile: $<
	@mkdir -p ${dir $@}
	@${CC} $< -o $@ ${CFLAGS} -MMD

-include ${DEP}
