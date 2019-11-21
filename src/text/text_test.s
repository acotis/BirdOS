
// Imports

	.globl	set_cursor
	.globl	newline
	.globl	print

	.globl	int_to_str
	
// Exports
	
	.globl	text_test

	
// Strings to display

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
	.asciz "Hello world, this is a program (by Evan Rysdam). minimum. joke. kaj. Also, now I've implemented smart line-wrapping, so I don't have to constantly split the strings I want to split into lots of pieces. It just handles it automatically. I can even put in newline characters myself,\nlike this.\n\n"
	
String2:
	.asciz "\"Shh,\" he said. \"It goes without saying!\".\n\n"

String3:
	.asciz "\"Ain't\" isn't a word."

String4:
	.ascii "0         1         2         3         4         "
        .ascii "5         6         7        "
	.ascii "01234567890123456789012345678901234567890123456789"
	.asciz "01234567890123456789012345678"

String5:
	.asciz "Right arrow -->"

String6:	
	.asciz "<-- left arrow"

IntString:
	.zero 9
	
// Code

	.section .text
	.align	2
	
text_test:
	push	{r4, lr}
	
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
	
	// Print the ascii lines

	mov	r0, #0			// Set cursor to row 0 col 32
	mov	r1, #32
	bl	set_cursor
	
	ldr	r0, =Line1		// Print ascii line 1
	add	r0, #32			// (Skip unprintable characters)
	ldr	r1, =0x000006FF	
	bl	print
	bl	newline
	
	ldr	r0, =Line2		// Print ascii line 2
	ldr	r1, =0x000006FF
	bl	print
	bl	newline

	ldr	r0, =Line3		// Print ascii line 3
	ldr	r1, =0x0FF0FFFF
	bl	print
	bl	newline

	ldr	r0, =Line4		// Print ascii line 4
	ldr	r1, =0xFFFF0000
	bl	print
	bl	newline
	bl	newline


	// Print strings 1 and 2
	
	ldr	r0, =String		// Print string 1
	ldr	r1, =0x0000FFFF
	bl	print

	ldr	r0, =String2		// Print string 2
	ldr	r1, =0x0000FFFF
	bl	print

	// Print row after string 2
	
	mov	r4, r1			// Convert row to string
	mov	r1, r0
	ldr	r0, =IntString
	bl	int_to_str	
	
	ldr	r0, =IntString		// Print at a given row and column
	mov	r1, #11
	mov	r2, #44
	ldr	r3, =0xF0000000
	bl	draw_textline

	// Print column after string 2
	
	mov	r1, r4	
	ldr	r0, =IntString
	bl	int_to_str

	ldr	r0, =IntString
	mov	r1, #11
	mov	r2, #54
	ldr	r3, =0x000FFFFF
	bl	draw_textline


	// Print string 3
	
	ldr	r0, =String3
	ldr	r1, =0x0000FFFF
	bl	print

	// Print row after string 3
	
	mov	r4, r1
	mov	r1, r0
	ldr	r0, =IntString
	bl	int_to_str
	
	ldr	r0, =IntString
	mov	r1, #13
	mov	r2, #24
	ldr	r3, =0xF0000000
	bl	draw_textline
	
	// Print column after string 3
	
	mov	r1, r4
	ldr	r0, =IntString
	bl	int_to_str

	ldr	r0, =IntString
	mov	r1, #13
	mov	r2, #34
	ldr	r3, =0x000FFFFF
	bl	draw_textline
	
	// Print strings 4-6
	
	bl	newline
	bl	newline
	
	ldr	r0, =String4
	ldr	r1, =0x4208F800
	bl	print

	ldr	r0, =String5
	ldr	r1, =0x000007E0
	bl	print

	ldr	r0, =String6
	ldr	r1, =0x0000FFC0
	bl	print

	pop	{r4, pc}
