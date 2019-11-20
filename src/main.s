
// Imports

	.globl draw_textline
	
// Exports

	.globl _start
	
// String to display

	.section .data
	.align 2
Line1:
	.zero 65
Line2:
	.zero 65
Line3:
	.zero 65
Line4:
	.zero 65

String:
	.asciz "Hello world, this is a program (by Evan Rysdam). minimum. joke. kaj"
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE

	// Fill "String" with every extended-ascii char code
	
	mov	r0, #1			// r0 . offset
	mov	r1, #1			// r1 . number to write
	ldr	r2, =Line1
s_fill_loop$:	
	strb	r1, [r2, r0]

	and	r3, r1, #0b111111
	cmp	r3,     #0b111111
	addeq	r0, #1

	add	r0, #1
	add	r1, #1

	teq	r1, #256
	bne	s_fill_loop$
	
	// Draw the string as a line of text
	
	ldr	r0, =Line1
	add	r0, #1
	mov	r1, #0
	mov	r2, #1	
	ldr	r3, =0x000006FF	
	bl	draw_textline

	ldr	r0, =Line2
	mov	r1, #1
	mov	r2, #0
	ldr	r3, =0x000006FF
	bl	draw_textline

	ldr	r0, =Line3
	mov	r1, #2
	mov	r2, #0
	ldr	r3, =0x0FF0FFFF
	bl	draw_textline

	ldr	r0, =Line4
	mov	r1, #3
	mov	r2, #0
	ldr	r3, =0xFFFF0000
	bl	draw_textline

	ldr	r0, =String
	mov	r1, #5
	mov	r2, #0
	ldr	r3, =0x0000FFFF
	bl	draw_textline
	
s_plain_loop$:
	b	s_plain_loop$
