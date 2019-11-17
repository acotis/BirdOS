
// Imports

	.globl GetFrameBufferPointerReal
	.globl GetFrameBufferPointerQEMU
	
// Code

	.section .text
	.globl _start

_start:
	ldr	sp, =0x18000		// STACK BASE

	mov	r4, #0
	
s_str_loop$:
	teq	r4, #18
	beq	plain_loop$
	
	mov	r0, r4
	lsl	r1, r4, #3
	add	r1, #20
	mov	r2, #20	
	ldr	r3, =0x000F0FFF		// White text on black bg
	bl	draw_char

	add	r4, #1
	b	s_str_loop$

plain_loop$:
	b	plain_loop$

