.syntax unified
.cpu cortex-m4
// .fpu softvfp
.thumb

.section .rodata
.align 8
// check section sizes after making changes to kernel!
image: .incbin "out/kernel.bin", 0x10000, 0x2DA // strip useless bytes
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
  ldr r12, =image_end

  ldr r0, =__ram_start
  add r10, r0 // image end address in SRAM

  _loop_: // loading program to RAM

    ldmdb r12!, {r1, r2}
    stmdb r10!, {r1, r2}

    cmp r10, r0
    bhi _loop_

  ldr r1, =boot_finish
  bl print_asciz

  // call loaded code
  ldr r0, =__ram_start+1 // thumb instructions
  blx r0

  pop { pc }
  .size _bootloader, .-_bootloader

