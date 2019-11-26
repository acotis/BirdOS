
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
	.asciz "Hello"
	
// Code

	.section .text
	.align 4

_start:
	ldr	sp, =0x18000		// STACK BASE

	// Check what core I am on, continue only if I'm on core 0 (primary)

	mrc	p15, 0, r0, c0, c0, 5	// Weird instruction to get core ID
	ands	r0, #0b11
	bne	halt
	
	
	//ldr	r0, =Counter
	//ldr	r1, [r0]
	//add	r2, r1, #1
	//str	r2, [r0]

	//cmp	r1, #0
	//bne	halt

	
	// Actual code

	mov	r1, r0
	
	ldr	r0, =Number
	bl	int_to_str
	
	ldr	r0, =Number
	ldr	r1, =0x0000F0F0
	bl	print
	bl	newline
	b	halt
	
	
halt:	
	b	halt

