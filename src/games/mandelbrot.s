
// Imports

	.globl	GetScreenByteWidth
	.globl	GetFrameBufferPointer

// Exports

	.globl	Mandelbrot

// Code	

// put_color: put color r2 (half word) at row r0, column r1, indexed from the
// center of the screen.
//
//	r0 . row number (-239 to +240)
//	r1 . col number (-319 to +320)
//	r2 . color to write
	
put_color:
	push	{r4, r5, r6, lr}
	
	rsb	r4, r0, #240		// r4 . row from top of screen down
	add	r5, r1, #320		// r5 . column from left of screen
	sub	r5, #1
	mov	r6, r2			// r6 . color
	
	bl	GetScreenByteWidth	// r4 . screen offset to write to
	mul	r4, r0
	add	r4, r5, lsl #1

	bl	GetFrameBufferPointer	// r0 = frame buffer start
	add	r0, r4			// r0 . address to write to
	strh	r6, [r0]

	pop	{r4, r5, r6, pc}

	
// Mandelbrot: draw a Mandelbrot fractal on the screen.

Mandelbrot:
	push	{r4, r5, r6, lr}

	mov	r4, #-200
	mov	r5, #-100
	ldr	r6, =0x0f0f		// greenish blue
	
m_loop$:
	mov	r0, r4
	mov	r1, r5
	mov	r2, r6
	bl	put_color

	subs	r4, #1
	//bne	m_loop$

	pop	{r4, r5, r6, pc}
