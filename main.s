	.section .data
	.align 4

	.globl FrameBufferInfo
FrameBufferInfo:
	.int 1024	// Physical width
	.int 768	// Physical height
	.int 1024	// Virtual width
	.int 768	// Virtual height
	.int 0		// GPU pitch (filled in by GPU)
	.int 16		// Bit depth (high color)
	.int 0		// X offset
	.int 0		// Y offset
	.int 0		// Pointer to frame (filled in by GPU)
	.int 0		// Size of frame (filled in by GPU)

	

	.section .text
	.globl _start

_start:

	ldr	r0, =FrameBufferInfo
	mov	r1, r0
write_iter$:	
	str	r1, [r0]
	add	r0, #4
	b	write_iter$


	ldr	r0, =FrameBufferInfo
	add	r0, #0x40000000
	mov	r1, #1
	bl	MailboxWrite

	mov	r0, #1
	bl	MailboxRead

	// I hope the result was zero....

	ldr	r0, =FrameBufferInfo	// r0 . address of frame info
	ldr	r1, [r0, #0x20]		// r1 . address of frame
	ldr	r2, [r0, #0x24]		// r2 . size of frame
	ldr	r3, =0xFFFF		// r3 . color white
	
s_draw_loop$:
	strh	r3, [r1]

	add	r1, r1, #4
	sub	r2, r2, #1
	teq	r2, #0
	bne	s_draw_loop$
	
plain_loop$:
	b	plain_loop$

