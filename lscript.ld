/*
 * linker script for STM32 platforms.
 * define the end of RAM and limit of stack memory
 */
MEMORY
{
  /*
   * we mark flash memory as read-only, since that is where the program lives.
   * STM32 chips map their flash memory to start at 0x08000000, and we have
   * 32KB (?) of flash memory available.
   */
  FLASH ( rx ) : ORIGIN = 0x08000000, LENGTH = 1M

  /*
   * we mark the RAM as read/write, and as mentioned above it is 4KB long (?)
   * starting at address 0x20000000.
   */
  RAM ( rxw )  : ORIGIN = 0x20000000, LENGTH = 128K
}

/*
 * start of the stack address
 */
__stack_start = ORIGIN(RAM) + LENGTH(RAM);
