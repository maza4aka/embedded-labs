.syntax unified
.cpu cortex-m4
// .fpu softvfp

#define SEMIHOSTING 0xAB

#define SYS_WRITE0 0x04

.thumb

.section .data
reg_hex: .asciz "R0 = 0xXXXXXXXX\n"


.globl print_asciz
.globl print_accumulator

.section .text

.type print_asciz, %function

print_asciz:
  push { lr }

  mov r0, SYS_WRITE0
  bkpt SEMIHOSTING

  pop { pc }
  .size print_asciz, .-print_asciz

.type print_accumulator, %function

print_accumulator:
  push { lr }

  mov r12, #0x0000000F
  mov r11, #14
  ldr r10, =reg_hex

  decode: mov r1, r0
  and r1, r12
  add r1, #48
  cmp r1, #58
  blt store
  add r1, #7
  store: strb r1, [r10, r11]
  lsr r0, #4
  sub r11, #1
  cmp r11, #6
  bgt decode

  mov r1, r10
  mov r0, SYS_WRITE0
  bkpt SEMIHOSTING

  pop { pc }
  .size print_accumulator, .-print_accumulator
