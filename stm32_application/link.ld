
/**
 * Linker script for STM32F103ZE
 */

ENTRY(ResetISR);

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH =  64K
    XRAM (rwx) : ORIGIN = 0x68000000, LENGTH =   1M
}

__rom_start__   = ORIGIN(FLASH);
__rom_size__    = LENGTH(FLASH);
__ram_start__   = ORIGIN(SRAM);
__ram_size__    = LENGTH(SRAM);
__ram_end__     = __ram_start__ + __ram_size__;
__stack_end__   = __ram_end__;      /* Top of RAM */
__stack_size__  = 16K;
__stack_start__ = __stack_end__ - __stack_size__;
__heap_start__  = ORIGIN(XRAM);
__heap_end__    = ORIGIN(XRAM) + LENGTH(XRAM);
end             = __heap_start__;

SECTIONS
{
	.text :
	{
		KEEP(*(.isr_vector))
		*(.text*)
		*(.rodata*)
	} > FLASH

	.ARM.extab :
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > FLASH

	.ARM.exidx :
	{
		__exidx_start = .;
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
		__exidx_end = .;
	} > FLASH

	_etext = ALIGN(4);

	.data : AT (_etext)
	{
		. = ALIGN(4);
		_data = .;
		*(vtable)
		*(.data*)
		. = ALIGN(4);
		_edata = .;
	} > SRAM
	
	.bss (NOLOAD) :
	{
		. = ALIGN(4);
		_bss = .;
		*(.stack*)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} > SRAM

	.extdata (NOLOAD) :
	{
		*(.extdata*)
	} > XRAM
}

