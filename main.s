
// Imports

	.globl draw_string

// Exports

	.globl _start
	
// String to display

	.section .data
	.align 2
String:
	.byte 0x01
	.byte 0x02
	.byte 0x03
	.byte 0x04
	.byte 0x05
	.byte 0x06
	.byte 0x07
	.byte 0x08
	.byte 0x09
	.byte 0x0A
	.byte 0x0B
	.byte 0x0C
	.byte 0x0D
	.byte 0x0E
	.byte 0x0F
	.byte 0x10
	.byte 0x11
	.byte 0x00 // Null terminator
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE

	ldr	r0, =String
	add	r1, #20
	mov	r2, #20	
	ldr	r3, =0x000F0FFF		// White text on black bg
	bl	draw_string

plain_loop$:
	b	plain_loop$

