.syntax unified

// (a + b)/2 + c!
.global test_formula

// constants
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
