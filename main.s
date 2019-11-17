
// Imports

	.globl GetFrameBufferPointerReal
	.globl GetFrameBufferPointerQEMU
	
// Code

	.section .text
	.globl _start

_start:
	// Color the top of the screen cyan
	
	bl	GetFrameBufferPointerQEMU
	ldr	r1, =0x07FF		// r1 . color
	mov	r2, #640		// r2 . number of pixels to write

write_iter$:
	strh	r1, [r0]
	add	r0, #2

	subs	r2, #1
	bne	write_iter$

	// Color the left side of the screen red

	bl	GetFrameBufferPointerQEMU
	ldr	r1, =0xF800
	mov	r2, #480
write_iter2$:
	strh	r1, [r0]
	add	r0, #1280

	subs	r2, #1
	bne	write_iter2$

plain_loop$:
	b	plain_loop$

