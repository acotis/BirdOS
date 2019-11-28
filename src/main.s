
// Imports

	.globl	text_test

	.globl	set_cursor
	.globl	newline
	.globl	print

	.globl	int_to_str

	.globl	GPUInit
	.globl	GetFrameBufferPointerQEMU
	.globl	GetFrameBufferPointerReal

	.globl	Cursor // DEBUG ONLY
	
// Exports

	.globl	_start

// Data

	.section .data
	.align 2
	
Number:
	.zero 	9

Counter:
	.int	0
	
What:
	.asciz "mandelbrot function returned"
	
// Code

	.section .text
	.align 4

_start:
	ldr	sp, =0x18000		// STACK BASE

	// Check what core I am on, continue only if I'm on core 0 (primary)

	mrc	p15, 0, r0, c0, c0, 5	// Weird instruction to get core ID
	ands	r0, #0b11
	bne	halt
	
	// Actual code
	
	bl	Mandelbrot

	// Make sure we returned from that method eventually

	ldr	r0, =What
	ldr	r1, =0xFFFF0000
	bl	print
	
halt:	
	b	halt

