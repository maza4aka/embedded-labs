.syntax unified
.cpu cortex-m4
// .fpu softvfp
.thumb

.section .rodata
.align 8
// check section sizes after making changes to kernel!
image: .incbin "out/kernel.bin", 0x10000, 0x2B2 // strip useless bytes
.align 8 // this should work
image_end:
.equ image_size, image_end-image

boot: .asciz "loading program image to SRAM.\n"
boot_finish: .asciz "loading finished! calling loaded program...\n"


.globl _bootloader

.type _bootloader, %function

.section .text

_bootloader:
  push { lr }

  ldr r1, =boot
  bl print_asciz

  ldr r10, =image_size
  ldr r11, =image

  ldr r0, =__ram_start

  _loop_: // loading program to RAM

    ldrh r12, [r11, r10]
    strh r12, [r0, r10]

    sub r10, #2
    cmp r10, #0
    bne _loop_

  ldr r1, =boot_finish
  bl print_asciz

  // call loaded code
  ldr r0, =__ram_start+1 // thumb instructions
  blx r0

  pop { pc }
  .size _bootloader, .-_bootloader

