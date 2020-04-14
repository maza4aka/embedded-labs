.syntax unified
.cpu cortex-m4
// .fpu softvfp
.thumb

.section .rodata
image: .incbin "out/kernel.bin", 0x10000 // strip first useless bytes
image_end:

boot: .asciz "loading program image to SRAM.\n"
boot_finish: .asciz "loading finished! calling loaded program...\n"


.globl _bootloader

.type _bootloader, %function

.section .text

_bootloader:
  push { lr }

  ldr r1, =boot
  bl print_asciz

  ldr r1, =image
  ldr r2, =__ram_start
  ldr r3, =image_end

  _loop_: // loading program to RAM
    ldr r0, [r1], #4
    str r0, [r2], #4
    cmp r3, r1
    bhi _loop_

  ldr r1, =boot_finish
  bl print_asciz

  // call loaded code
  ldr r0, =__ram_start+1 // thumb instructions
  blx r0

  pop { pc }
  .size _bootloader, .-_bootloader

