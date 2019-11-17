
// Imports

	.globl GetFrameBufferPointerQEMU
	.globl GetScreenByteWidthQEMU
	
	.globl CharacterMaps
	.globl CharacterSize
	
// Exports

	.globl draw_char

// Code
	
	.section .text
	.align 2

// draw_char: Draw ascii character r0 with its top-left corner at (r1, r2)
// using background color r2-left-half and foreground color r2-right-half
//	
//	r0 . id of character to draw
//	r1 . x position of top-left corner
//	r2 . y position of top-left corner
//	r3 . background color (left 16 bits) and foreground color (right 16)

draw_char:
	push	{r4, r5, r6, lr}

	push	{r0, r1, r2, r3}	
	bl	GetFrameBufferPointerQEMU
	mov	r4, r0			// r4 . Pointer to frame buffer
	bl	GetScreenByteWidthQEMU
	mov	r5, r0			// r5 . Screen byte-width (QEMU)
	pop	{r0, r1, r2, r3}

	mla	r4, r2, r5, r4		// r4 = frame buffer + y-offset
	add	r4, r1, lsl #1		// r4 . frame buffer + total offset

	lsr	r2, r3, #16		// r2 . background color
	lsl	r3, #16			// r3 . foreground color
	lsr	r3, #16
	
	ldr	r1, =CharacterSize	// r1 = character size
	ldr	r1, [r1]
	mul	r0, r1			// r0 = char offset
	ldr	r1, =CharacterMaps	// r1 = char base
	add	r1, r0			// r1 . char base + char offset

	mov	r0, #0			// r0 . 0 (counts up to 12)
dc_row_loop$:
	teq	r0, #12
	beq	dc_row_loop_end$
	
	ldr	r6, [r1, r0]		// r6 . next row of character bitmap

	tst	r6, #0x80		// Draw this row of the character
	streqh	r2, [r4, #0]
	strneh	r3, [r4, #0]
	tst	r6, #0x40
	streqh	r2, [r4, #2]
	strneh	r3, [r4, #2]
	tst	r6, #0x20
	streqh	r2, [r4, #4]
	strneh	r3, [r4, #4]
	tst	r6, #0x10
	streqh	r2, [r4, #6]
	strneh	r3, [r4, #6]
	tst	r6, #0x8
	streqh	r2, [r4, #8]
	strneh	r3, [r4, #8]
	tst	r6, #0x4
	streqh	r2, [r4, #10]
	strneh	r3, [r4, #10]
	tst	r6, #0x2
	streqh	r2, [r4, #12]
	strneh	r3, [r4, #12]
	tst	r6, #0x1
	streqh	r2, [r4, #14]
	strneh	r3, [r4, #14]

	add	r0, #1			// Count to the next row of bitmap
	add	r4, r5			// Go to next row of frame buffer
	
	b	dc_row_loop$
	
dc_row_loop_end$:	
	pop	{r4, r5, r6, pc}
	

	
