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

  /* mov r0, #0xA09F // test that hex decoding below works well, I guess? */
  bl print_accumulator // prints r0 hex contents

  ldr r1, =bye
  bl print_asciz

  mov r0, SUCCESS

  pop { pc }
  .size _start, .-_start


// (a + b)/2 + c!
// .global test_formula

// defining some constants
#define _a 6
#define _b 6
#define _c 6

.type test_formula, %function

test_formula:
  push { lr }

  // calculating c!
  mov r0, _c
  bl factorial

  // saving factorial result
  push { r0 }

  // calculating (a + b)/2
  mov r1, _a
  mov r2, _b
  add r0, r1, r2
  mov r1, #2
  sdiv r0, r1

  // calculating (a + b)/2 + c!
  pop { r1 }
  add r0, r0, r1

  // return result in r0

  pop { pc }
  .size test_formula, .-test_formula

.type factorial, %function

factorial:
  push { lr }

  mov r1, #1
  .factorial_loop:
    cmp r0, 0
    beq .factorial_exit
    mul r1, r0
    sub r0, 1
    b .factorial_loop
  .factorial_exit:
  mov r0, r1

  pop { pc }
  .size factorial, .-factorial


.section .rodata

/*
 * some strings
 */
hello: .asciz "main procedure started.\n"
bye: .asciz "main procedure finished!\n"

.end
