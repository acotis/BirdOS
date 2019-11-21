
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
	.asciz "Hello world, this is a program (by Evan Rysdam). minimum. joke. kaj. Also, now I've implemented smart line-wrapping, so I don't have to constantly split the strings I want to split into lots of pieces. It just handles it automatically. I can even put in newline characters myself,\nlike this."
	
String2:
	.asciz "\"Shh,\" he said. \"It goes without saying!\"."

String3:
	.asciz "\"Ain't\" isn't a word."

String4:
	.asciz "0         1         2         3         4         5         6         7        0123456789012345678901234567890123456789012345678901234567890123456789012345678"
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE

	// Fill "String" with every extended-ascii char code
	
	mov	r0, #32			// r0 . offset (skip unprintables)
	mov	r1, #32			// r1 . number to write
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
	add	r0, #32
	mov	r1, #0
	mov	r2, #32	
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

	ldr	r0, =String2
	mov	r1, #11
	mov	r2, #0
	ldr	r3, =0x0000FFFF
	bl	draw_textline

	ldr	r0, =String3
	mov	r1, #13
	mov	r2, #0
	ldr	r3, =0x0000FFFF
	bl	draw_textline

	ldr	r0, =String4
	mov	r1, #15
	mov	r2, #0
	ldr	r3, =0x4208F800
	bl	draw_textline
	
s_plain_loop$:
	b	s_plain_loop$
