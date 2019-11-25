
// Imports

	.globl	text_test

	.globl	set_cursor
	.globl	newline
	.globl	print

	.globl	int_to_str

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

	// Insane workaround to having my code being put on 4 different
	// CPU's by QEMU??????

	ldr	r0, =Counter
	ldr	r1, [r0]
	add	r2, r1, #1
	str	r2, [r0]

	//cmp	r1, #0
	//bne	halt

	ldr	r0, =Number
	bl	int_to_str
	
	ldr	r0, =Number
	ldr	r1, =0x0000F0F0
	bl	print
	bl	newline
	b	halt

	
	ldr	r1, =Cursor
	ldr	r2, [r1, #4]
	ldr	r1, [r1]

	ldr	r3, =0x0000F0F0
	
	bl	draw_textline

	//b	halt
	
	ldr	r2, =Cursor		// Store new cursor position
	mov	r0, #20
	mov	r1, #20
	str	r0, [r2]
	str	r1, [r2, #4]

	

	b	halt
		
	
halt:	
	b	halt

