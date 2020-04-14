TOOLCHAIN?=~/Library/xPacks/@xpack-dev-tools/arm-none-eabi-gcc/*/.content/bin/arm-none-eabi

QEMU = ~/Library/xPacks/@xpack-dev-tools/qemu-arm/*/.content/bin/qemu-system-gnuarmeclipse

CC = $(TOOLCHAIN)-gcc
CFLAGS = -x assembler-with-cpp -O0 -g3 -Wall

LD = $(TOOLCHAIN)-ld
LDFLAGS = -Wall --specs=nosys.specs -nostdlib -lgcc

SIZE = $(TOOLCHAIN)-size
OBJCOPY = $(TOOLCHAIN)-objcopy

BOARD ?= STM32F4-Discovery

MCU=STM32F407VG
TARGET=firmware
CPU=cortex-m4

all: target

utils:
	$(CC) $(CFLAGS) -mcpu=$(CPU) -c src/print.S -o out/print.o

image: utils

	$(CC) $(CFLAGS) -mcpu=$(CPU) -c src/formula.S -o out/formula.o

	$(CC) out/formula.o out/print.o $(LDFLAGS) -mcpu=$(CPU) -T./lscript_kernel.ld -o out/kernel.elf

	$(OBJCOPY) -O binary -F elf32-littlearm out/kernel.elf out/kernel.bin

target: image

	$(CC) $(CFLAGS) -mcpu=$(CPU) -c src/start.S -o out/start.o
	$(CC) $(CFLAGS) -mcpu=$(CPU) -c src/bootloader.S -o out/bootloader.o

	$(CC) out/start.o out/bootloader.o out/print.o $(LDFLAGS) -mcpu=$(CPU) -T./lscript.ld -o out/$(TARGET).elf

	$(OBJCOPY) -O binary -F elf32-littlearm out/$(TARGET).elf out/$(TARGET).bin

qemu:
	$(QEMU) --verbose --verbose 	--board $(BOARD) --mcu $(MCU) \
					-d unimp,guest_errors --image out/$(TARGET).bin \
					--semihosting-config enable=on,target=native \
					-s -S # -s for -gdb tcp::1234 and -S prevents CPU from running after start

debug:
	$(TOOLCHAIN)-gdb out/$(TARGET).elf -x gdb-init

clean:
	-rm out/*.o
	-rm out/*.elf
	-rm out/*.bin

#flash:
#	st-flash write out/$(TARGET).bin 0x08000000
# disable this for now...
