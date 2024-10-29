OUTPUT_ARCH( "riscv" )
ENTRY(_start)


/* SECTIONS {
	.memory : {
		. = 0x00000;
		start*(.text);
		*(.text);
		*(*);
		end = .;
	}
} */



SECTIONS
{
  . = 0x00000000;
  .text.init : { *(.text.init)} 
  .text.own  : { *(.text.own )} 
  .text : { *(.text) }  
  .tohost ALIGN(0x1000) : { *(.tohost) }  
  .data ALIGN(0x1000) : { *(.data) }
  .bss : { *(.bss) }
  _end = .;
}


/* SECTIONS {
	.memory : {
		. = 0x0000000; /* due to TD v3.0.987 bug */
/*		*(.init);
		*(.text);
		*(*);
		. = ALIGN(4);
		end = .;
	}
} */

