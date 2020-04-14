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

.section .interrupt_vector

vtable:
  .word __stack_start
  .word __hard_reset__+1
  .size vtable, .-vtable

.section .rodata

start: .asciz "starting!\n"
reset: .asciz "reset...\n"

// startup code
.type __hard_reset__, %function

.section .text

__hard_reset__:
  // first .word from vtable is used by sp on startup

  // message on start
  ldr r1, =start
  bl print_asciz

  _reset_:
    bl _bootloader
    ldr sp, =__stack_start

    // message on reset
    ldr r1, =reset
    bl print_asciz

    b _reset_

  .size __hard_reset__, .-__hard_reset__

