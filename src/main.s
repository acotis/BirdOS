
// Imports

	.globl draw_textline
	
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
	mov	r1, #0
	mov	r2, #0	
	ldr	r3, =0x00000FFF	
	bl	draw_textline

	ldr	r0, =String
	mov	r1, #2
	mov	r2, #0
	ldr	r3, =0x0000F000
	bl	draw_textline

	ldr	r0, =String
	mov	r1, #1
	mov	r2, #0
	ldr	r3, =0x0000FFFF
	bl	draw_textline
	
plain_loop$:
	b	plain_loop$
