
// Imports

	.globl	text_test
	
// Exports

	.globl	_start
	
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE
	bl	text_test
	
halt:	
	b	halt
