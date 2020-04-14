/*
 * kernel program linker script (for STM32)
 */

MEMORY
{
  SRAM ( rxw ) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* __stack_start = ORIGIN(SRAM) + LENGTH(SRAM); */


SECTIONS
{
  .text : {
	  /* . = ALIGN(4); */

	  /* *(.text) */
	  *(.text*)
	  /* *(.rodata) */
	  *(.rodata*)

  } > SRAM
}
