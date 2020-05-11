
// Imports

	.globl	draw_textline

// Exports

	.globl	set_cursor
	.globl	newline
	.globl	print

	.globl	Cursor // DEBUG ONLY
	
// Data

	.section .data
	.align 2

Cursor:
	.int	0	// row of cursor
	.int	0	// column of cursor

// Code

	.section .text
	.align 2

// set_cursor: set the cursor position to (r0, r1)
//
//	r0 . row
//	r1 . column
	
set_cursor:	
	ldr	r2, =Cursor
	str	r0, [r2]
	str	r1, [r2, #4]
	mov	pc, lr

// newline: move the cursor to the beginning of the next line. no args.

newline:
	ldr	r2, =Cursor
	ldr	r0, [r2]
	add	r0, #1
	str	r0, [r2]
	mov	r0, #0
	str	r0, [r2, #4]
	mov	pc, lr
	
// print: print a string with draw_textline starting at the current cursor
// position, then move the cursor forward to the end of the printed line.
//
//	r0 . address of string to draw
//	r1 . bg color (top 16 bits) and fg color (bottom 16 bits)
//
// Return the new position of the cursor:
//
//	r0 < final row position of cursor
//	r1 < final column position of cursor
	
print:
	push	{lr}
	
	mov	r3, r1			// r3 <- colors
	ldr	r1, =Cursor		// Load cursor position to (r1, r2)
	ldr	r2, [r1, #4]		
	ldr	r1, [r1]

	bl	draw_textline

	ldr	r2, =Cursor		// Store new cursor position
	str	r0, [r2]
	str	r1, [r2, #4]

	pop	{pc}
