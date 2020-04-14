.syntax unified
.cpu cortex-m4
// .fpu softvfp

#define SEMIHOSTING 0xAB

#define SYS_WRITE0 0x04

.thumb


.globl print_asciz

.section .text

.type print_asciz, %function

print_asciz:
  push { lr }

  mov r0, SYS_WRITE0
  bkpt SEMIHOSTING

  pop { pc }
  .size print_asciz, .-print_asciz

