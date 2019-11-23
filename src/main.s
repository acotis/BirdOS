
// Imports

	.globl	text_test

	.globl	set_cursor
	.globl	newline
	.globl	print

	.globl	int_to_str
	
// Exports

	.globl	_start

// Data

	.section .data
	.align 2
	
String:
	.zero 	9

What:
	.asciz "Hello"
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE

	mov	r6, #1
	
memwatch_loop$:
	mov	r0, #0
	mov	r1, #0
	bl	set_cursor
	
	ldr	r4, =0x00006000
	mov	r5, #020

	//str	r6, [r4]
	//add	r6, #1
	
memdraw_loop:
	ldr	r0, =String
	mov	r1, r4
	bl	int_to_str

	ldr	r0, =String
	ldr	r1, =0x0000FFFF
	bl	print

	ldr	r0, =String
	ldr	r1, [r4]
	bl	int_to_str

	ldr	r0, =String
	ldr	r1, =0x000007FF
	bl	print

	bl	newline

	add	r4, #4
	subs	r5, #1
	bne	memdraw_loop

	b	memwatch_loop$
	
halt:	
	b	halt
