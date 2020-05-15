
// Imports

	.globl	GetFrameBufferPointer
	.globl	GetScreenByteWidth
	
	.globl	CharacterMaps
	.globl	CharacterHeight
	
// Exports

	.globl	draw_char
	.globl	draw_string
	.globl	draw_num_hex_32

// Code
	
	.section .text
	.align	2

// draw_char: Draw ascii character r0 with its top-left corner at (r1, r2)
// using background color r2-left-half and foreground color r2-right-half
//	
//	r0 . id of character to draw
//	r1 . x position of top-left corner
//	r2 . y position of top-left corner
//	r3 . background color (left 16 bits) and foreground color (right 16)

draw_char:
	push	{r4, r5, r6, r7, lr}

	push	{r0, r1, r2, r3}
	bl	GetFrameBufferPointer
	mov	r5, r0			// r5 = Pointer to frame buffer
	bl	GetScreenByteWidth
	mov	r6, r0			// r6 . Screen byte-width (real?)
	pop	{r0, r1, r2, r3}

	mla	r5, r2, r6, r5		// r5 += offset due to y-pos (r2)
	add	r5, r1, lsl #1		// r5 += offset due to x-pos (r1)
					// r5 . frame buffer + total offset

	ldr	r4, =CharacterHeight	// r4 = char height
	ldr	r4, [r4]		//
	mov	r1, r4			// r1 . char height
	mul	r0, r4			// r0 = char memory offset

	ldr	r4, =CharacterMaps	// r4 = char base
	add	r4, r0			// r4 . char base + char offset
	
	lsr	r2, r3, #16		// r2 . background color
	lsl	r3, #16			// r3 . foreground color
	lsr	r3, #16

	mov	r0, #0			// r0 . 0 (counts up to char height)
	
dc_row_loop$:
	teq	r0, r1
	beq	dc_row_loop_end$
	
	ldr	r7, [r4, r0]		// r7 . next row of character bitmap

	tst	r7, #0x80		// Draw this row of the character
	streqh	r2, [r5, #0]
	strneh	r3, [r5, #0]
	tst	r7, #0x40
	streqh	r2, [r5, #2]
	strneh	r3, [r5, #2]
	tst	r7, #0x20
	streqh	r2, [r5, #4]
	strneh	r3, [r5, #4]
	tst	r7, #0x10
	streqh	r2, [r5, #6]
	strneh	r3, [r5, #6]
	tst	r7, #0x8
	streqh	r2, [r5, #8]
	strneh	r3, [r5, #8]
	tst	r7, #0x4
	streqh	r2, [r5, #10]
	strneh	r3, [r5, #10]
	tst	r7, #0x2
	streqh	r2, [r5, #12]
	strneh	r3, [r5, #12]
	tst	r7, #0x1
	streqh	r2, [r5, #14]
	strneh	r3, [r5, #14]

	add	r0, #1			// Count to the next row of bitmap
	add	r5, r6			// Go to next row of frame buffer
	
	b	dc_row_loop$
	
dc_row_loop_end$:	
	pop	{r4, r5, r6, r7, pc}
	

// draw_string: draw a null-terminatred string located at memory location r0
// beginning at x-offset r1 and y-offset r2 with colors r3	
//
//	r0 . Memory location of the string
//	r1 . x-offset of first character
//	r2 . y-offset of first character
//	r3 . BG color (top 16 bits) and FG color (bottom 16 bits)

draw_string:
	push	{r4, r5, r6, r7, lr}

	mov	r4, r0			// r4 . Memory location of the string
	mov	r5, r1			// r5 . x-offset
	mov	r6, r2			// r6 . y-offset
	mov	r7, r3			// r7 . colors

ds_char_loop$:
	ldrb	r0, [r4]
	teq	r0, #0
	beq	ds_char_end$
	
	mov	r1, r5
	mov	r2, r6
	mov	r3, r7
	bl	draw_char

	add	r4, #1
	add	r5, #8
	b	ds_char_loop$

ds_char_end$:
	pop	{r4, r5, r6, r7, pc}
