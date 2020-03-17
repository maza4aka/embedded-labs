TOOLCHAIN?=~/Library/xPacks/@xpack-dev-tools/arm-none-eabi-gcc/*/.content/bin/arm-none-eabi

QEMU = ~/Library/xPacks/@xpack-dev-tools/qemu-arm/*/.content/bin/qemu-system-gnuarmeclipse

CC = $(TOOLCHAIN)-gcc
LD = $(TOOLCHAIN)-ld
SIZE = $(TOOLCHAIN)-size
OBJCOPY = $(TOOLCHAIN)-objcopy

BOARD ?= STM32F4-Discovery

MCU=STM32F407VG
TARGET=firmware
CPU=cortex-m4
GDB=1234

deps = \
	src/start.S src/formula.S \
	lscript.ld \

all: target

target:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -Wall src/start.S -o out/start.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU) -Wall src/formula.S -o out/formula.o

	$(CC) out/start.o out/formula.o -mcpu=$(CPU) -Wall --specs=nosys.specs -nostdlib \
				-lgcc -T./lscript.ld -o out/$(TARGET).elf

	$(OBJCOPY) -O binary -F elf32-littlearm out/$(TARGET).elf out/$(TARGET).bin

qemu:
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) \
					-d unimp,guest_errors --image out/$(TARGET).bin \
					--semihosting-config enable=on,target=native \
					-s -S # -s for -gdb tcp::1234 and -S prevents CPU from starting

debug:
	$(TOOLCHAIN)-gdb out/$(TARGET).elf -x gdb-init

clean:
	-rm out/*.o
	-rm out/*.elf
	-rm out/*.bin

#flash:
#	st-flash write out/$(TARGET).bin 0x08000000
# disable this for now...
