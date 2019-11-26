
// Exports

	.globl	_start

// Data

	.section .data
	.align	2

Counter:
	.int	0

// Code

	.section .text
	.align	2

_start:
	// This magical code makes it so that only core 0 (primary core)
	// actually continues
	
	mrc	p15, 0, r0, c0, c0, 5	// Weird instruction to get core ID
	ands	r0, #0b11
	bne	halt


	// ...and here's the actual program itself

	address	.req r0
	counter	.req r1
	color 	.req r2
	hwords	.req r3
	
	// Read the counter from memory, increment it, and write it back.
	// Commenting out the fourth line results in only one stripe being
	// drawn, while leaving it in results in up to four stripes being
	// drawn.
	
	ldr	address, =Counter
	ldr	counter, [address]
	add	counter, #1
	str	counter, [address]

	// Use the counter to determine the starting offset from the top
	// of the screen
	
	ldr	address, =0x3C100000		// screen base address
	add	address, counter, lsl #16

	// For extra clarity, use the counter to decide what color to write

	mov	color, #0
	add	color, counter, lsl #2
	mov	r4, #4
	sub	r4, r4, counter
	add	color, r4, lsl #9
	
	// Write 4000 half-words starting at the computed offset

	mov	hwords, #4000
loop$:	
	strh	color, [address]
	add	address, #2
	subs	hwords, #1
	bne	loop$

halt:
	b	halt
