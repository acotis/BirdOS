
// Imports

	.globl	draw_string

// Exports

	.globl	draw_textline

// Data
	
	.section .data
	.align	2

Offset:
	.int	2	// x-offset of first row of text
	.int	4	// y-offset of rirst row of text

// Code

// draw_textline: draw a string located at r0 on row r1 and column r2 using
// colors r3.
//
//	r0 . address of null-terminated string to draw
//	r1 . row to start on
//	r2 . column to start on
//	r3 . bg color (top 16 bits) and fg color (bottom 16 bits)
	
	
draw_textline:
	push	{r4, r5, lr}

	ldr	r5, =Offset
	ldr	r4, [r5]		// r4 . x-offset of first row
	ldr	r5, [r5, #4]		// r5 . y-offset of first row
	
	lsl	r2, #3			// (character width is always 8)
	add	r2, r4			// r2 . x-offset of text

	ldr	r4, =CharacterHeight
	ldr	r4, [r4]		// r4 . character height
	mul	r1, r4			
	add	r1, r5			// r1 . y-offset of text
	
	mov	r4, r1			// Swap r1 and r2 (xy vs rc)
	mov	r1, r2
	mov	r2, r4

	bl	draw_string
	pop	{r4, r5, pc}
