
// Imports

	.globl	GetScreenByteWidth
	.globl	GetFrameBufferPointer

	.globl	print		// for testing
	.globl	newline
	.globl	int_to_str

// Exports

	.globl	Mandelbrot

// Data

	.section .data
	.align	2
	
Number:
	.zero 9

	
// Code

	.section .text
	.align 	2


// enable_vfp: run some weird code that apparently enables that ARM floating
// point unit.	Copied from pg 2-3 of https://static.docs.arm.com/ddi0463/f/DDI0463F_cortex_a7_fpu_r0p5_trm.pdf.

enable_vfp:
	MRC	p15, 0, r0, c1, c1, 2
	ORR	r0, r0, #3<<10 	// enable fpu
	MCR	p15, 0, r0, c1, c1, 2

	LDR	r0, =(0xF << 20)
	MCR	p15, 0, r0, c1, c0, 2

	MOV	r3, #0x40000000
	VMSR	FPEXC, r3

	mov	pc, lr
	
	
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

	
// make_color: make a color out of a scalar. Start with black, then drift 
// through blue, green, and finally red.
//
//	r0 . the scalar (range: 0 - 93)
	
make_color:
	blue	.req r1
	green	.req r2
	red	.req r3

	subs	blue, r0, #31		// blue = dist from r0 to 31
	rsblos	blue, blue, #0
	cmp	blue, #31		// blue = max(blue, 31)
	movhi	blue, #31
	rsb	blue, #31		// blue = 31 - blue

	subs	green, r0, #62		// green = dist from r0 to 31
	rsblos	green, green, #0
	cmp	green, #31		// green = max(green, 31)
	movhi	green, #31
	rsb	green, #31		// green - 31 - green

	subs	red, r0, #62		// red = dist that r0 is above 62
	movlo	red, #0
	cmp	red, #31
	movhi	red, #31
	
	mov	r0, blue
	add	r0, green, lsl #6
	add	r0, red, lsl #11

	bx	lr

	.unreq	blue
	.unreq	green
	.unreq	red


// compute_escape: compute 93 - x, where x is the escape time of the complex
// number represented by (s0 + s1 * i). may trash any other s registers.
	
;; compute_escape:
;; 	mov	r0, #93

;; ce_loop$:	
;; 	fmuls	s2, s0, s0		// if |z| > 2, it's escaped
;; 	fmuls	s3, s1, s1
;; 	fadds	s2, s2, s3
;; 	fsqrts	s2, s2

;; 	mov	r1, #2
;; 	vmov	s3, r1
	
	
	
// Mandelbrot: draw a Mandelbrot fractal on the screen.

Mandelbrot:
	push	{r4, r5, r6, lr}

	bl	enable_vfp
	
	mov	r4, #100
	mov	r5, #94
	
m_loop$:
	mov	r0, r5
	bl	make_color
	mov	r2, r0

	mov	r0, r4
	mov	r1, r5
	bl	put_color

	subs	r5, #1
	bne	m_loop$


	mov	r1, #0x1000000
	//lsl	r1, #23
	vmov	s0, r1
	vmov	s1, r1
	fadds	s2, s0, s1
	vmov	r1, s2

	ldr	r0, =Number
	bl	int_to_str

	ldr	r0, =Number
	ldr	r1, =0x0F0F
	bl	print
	bl	newline
	
	pop	{r4, r5, r6, pc}
