
// Imports

	.globl	draw_string

// Exports

	.globl	draw_textline

// Data
	
	.section .data
	.align	2

Offset:
	.int	4	// x-offset of first row of text
	.int	4	// y-offset of rirst row of text

LineWidth:
	.int	79	// Number of characters per line

LineBuffer:
	.zero	81	// Buffer for up to a single screen-line of text
	
	
// Code

	.section .text
	.align 2
	
// draw_textline_nowrap: draw a string located at r0 on row r1 and column r2
// using colors r3. Line wrapping not supported by this method.
//
//	r0 . address of null-terminated string to draw
//	r1 . row to start on
//	r2 . column to start on
//	r3 . bg color (top 16 bits) and fg color (bottom 16 bits)
	
draw_textline_nowrap:	
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

// draw_textline: draw a string located at r0 on row r1 and column r2 with
// colors r3. If necessary, wrap the line intelligently to the next row and
// start back at column 0.	
//
//	r0 . location of the string to draw
//	r1 . row to start on
//	r2 . column to start on
//	r3 . bg color (top 16 bits) and fg color (bottom 16 bits)
	
draw_textline:
	push	{r4, r5, r6, r7, r8, r9, r10, lr}

	mov	r4, r0			// r4 . location of string
	mov	r5, r1			// r5 . row
	mov	r6, r2			// r6 . column
	mov	r7, r3			// r7 . color
	
	// Copy one line of text to the line buffer

	mov	r10, #0			// r10 . found null char yet?
	
dt_buffer_loop$:
	ldr	r8, =LineBuffer		// r8 . address of line buffer

	ldr	r9, =LineWidth		// r9 . number of characters to copy
	ldr	r9, [r9]
	sub	r9, r6
	
dt_charcopy_loop$:
	ldrb	r0, [r4], #1		// r0 = next char to copy
	strb	r0, [r8]
	
	cmp	r0, #0			// If null char, set flag and flush
	moveq	r10, #1
	beq	dt_flush_buffer$

	cmp	r0, #10			// If newline character, put a null
	moveq	r0, #0			// character and flush
	strb	r0, [r8]
	beq	dt_flush_buffer$		
	
	subs	r9, #1			// If end of line, flush
	beq	dt_flush_buffer$

	add	r8, #1			// Else, march forward in buffer and
	b	dt_charcopy_loop$	// loop back to charcopy 
	
dt_flush_buffer$:	
	ldr	r0, =LineBuffer		// Draw the line buffer to the screen
	mov	r1, r5
	mov	r2, r6
	mov	r3, r7
	bl	draw_textline_nowrap

	add	r5, #1			// Go to the next line
	mov	r6, #0			// Go to the first column

	cmp	r10, #0			// If r10 (found null char) not set,
	beq	dt_buffer_loop$		// loop back again

	// Done

	pop	{r4, r5, r6, r7, r8, r9, r10, pc}
