.syntax unified
.cpu cortex-m4
// .fpu softvfp

#define SUCCESS #0

.thumb


.globl _start

.section .text

.type _start, %function

_start: // _start must be the first thing in .text section
  push { lr }

  ldr r1, =hello
  bl print_asciz

  bl test_formula // result is returned in r0

  bl print_accumulator // prints r0 hex contents

  ldr r1, =bye
  bl print_asciz

  mov r0, SUCCESS

  pop { pc }
  .size _start, .-_start


// (a - b)*3 + 2^c

#define A 4
#define B 3
#define C 2

.type test_formula, %function

test_formula:
  push { lr }

  mov r0, A
  mov r1, B
  sub r0, r1

  mov r1, #3
  muls r0, r1

  mov r1, #1
  lsl r1, C

  add r0, r1

  // return result in r0

  pop { pc }
  .size test_formula, .-test_formula


.section .rodata

/*
 * some strings
 */
hello: .asciz "main procedure started.\n"
bye: .asciz "main procedure finished!\n"

.end
