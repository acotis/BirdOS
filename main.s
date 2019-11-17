
// Imports

	.globl GetFrameBufferPointerReal
	.globl GetFrameBufferPointerQEMU
	
// Code

	.section .text
	.globl _start

_start:
	bl	GetFrameBufferPointerQEMU
	ldr	r1, =0x000F000F
write_iter$:
	str	r1, [r0]
	add	r0, #4
	b	write_iter$

plain_loop$:
	b	plain_loop$

