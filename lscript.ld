/*
 * linker script (for STM32)
 */

MEMORY
{
  FLASH ( rx ) : ORIGIN = 0x08000000, LENGTH = 1M /* from 0x08000000 to 0x080FFFFF*/

  SRAM ( rxw ) : ORIGIN = 0x20000000, LENGTH = 128K /* from 0x20000000 to 0x2001FFFF, sp points to 0x20020000 at startup */
}

__stack_start = ORIGIN(SRAM) + LENGTH(SRAM);
