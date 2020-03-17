.syntax unified
.cpu cortex-m4
// .fpu softvfp
.thumb

/*
 * global memory locations
 */
.global vtable
.global __hard_reset__

// vector table
.type vtable, %object

vtable:
  .word __stack_start
  .word __hard_reset__+1
  .size vtable, .-vtable

.type __hard_reset__, %function

__hard_reset__:
  // initialise stack here
  ldr sp, =__stack_start
  bl main
  b __hard_reset__
  .size __hard_reset__, .-__hard_reset__

.type main, %function

main:
  push { lr }
  _loop_:
    bl test_formula
    b _loop_
  pop { pc }
  .size main, .-main
