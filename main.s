
// Imports

	.globl GetFrameBufferPointerReal
	.globl GetFrameBufferPointerQEMU
	
// Code

	.section .text
	.globl _start

_start:
	ldr	sp, =0x18000		// STACK BASE
	
	mov	r0, #0			// Stripe
	mov	r1, #20			// x-offset 20
	mov	r2, #20			// y-offset 20
	ldr	r3, =0x0000FFFF		// White text on black bg
	bl	draw_char
	
	mov	r0, #1			// Digit 0
	mov	r1, #28			// x-offset 28
	mov	r2, #20			// y-offset 20
	ldr	r3, =0x0000FFFF		// White text on black bg
	bl	draw_char
	
	mov	r0, #2			// Digit 1
	mov	r1, #36			// x-offset 36
	mov	r2, #20			// y-offset 20
	ldr	r3, =0x0000FFFF		// White text on black bg
	bl	draw_char

	mov	r0, #0			// Stripe
	mov	r1, #36			// x-offset 36
	mov	r2, #32			// y-offset 20
	ldr	r3, =0x0000FFFF		// White text on black bg
	bl	draw_char
	
	b	plain_loop$

	// Now come back and do random colors
	
	mov	r3, #0x0		// r3 . counter
color_loop$:				// r0 . address of next pixel
	bl	GetFrameBufferPointerQEMU 
	ldr	r1, =0x4B000		// r1 . number of pixels on a screen
	lsr	r2, r3, #5		// r2 . color
	
write_loop$:
	strh	r2, [r0]
	add	r0, #2
	subs	r1, #1
	bne	write_loop$

	add	r3, #1
	b	color_loop$
	
plain_loop$:
	b	plain_loop$

