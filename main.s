
// Imports

	.globl GetFrameBufferPointerReal
	.globl GetFrameBufferPointerQEMU
	
// Code

	.section .text
	.globl _start

_start:
	// Color the top of the screen cyan
	

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

