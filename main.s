
// Imports

	.globl draw_string
	.globl draw_num_hex_32
	
// Exports

	.globl _start
	
// String to display

	.section .data
	.align 2
String:
	.byte 0x01
	.byte 0x02
	.byte 0x03
	.byte 0x04
	.byte 0x05
	.byte 0x06
	.byte 0x07
	.byte 0x08
	.byte 0x09
	.byte 0x0A
	.byte 0x0B
	.byte 0x0C
	.byte 0x0D
	.byte 0x0E
	.byte 0x0F
	.byte 0x10
	.byte 0x11
	.byte 0x00 // Null terminator
	
// Code

	.section .text
	.align 2

_start:
	ldr	sp, =0x18000		// STACK BASE
	
	ldr	r0, =String
	mov	r1, #500
	mov	r2, #460	
	ldr	r3, =0x000F0FFF	
	bl	draw_string

	ldr	r0, =0x20000000
wait_loop$:
	subs	r0, #1
	bne	wait_loop$
	
	
	mov	r4, #-1
	mov	r5, #10			// r5 . row offset
	mov	r6, #10			// r6 . column offset
memread_loop$:
	add	r4, #1
	ldrb	r0, [r4]

	teq	r0, #0x1e // letter a (maybe)
	beq	memread_do_print$

	teq	r0, #0x02 // value 2 (continued key press)
	beq	memread_do_print$

	lsls	r1, r4, #6
	beq	memread_do_print$

	ldr	r1, =0x3F006000
	cmp	r4, r1
	bhi	plain_loop$
	
	sub	r1, #10
	cmp	r4, r1
	bhi	memread_do_print$
	
	b	memread_loop$
	
memread_do_print$:	
	
	add	r1, r6, #70		// Draw r0 (contents) in right column
	mov	r2, r5
	ldr	r3, =0x0000F800
	bl	draw_num_hex_32

	mov	r0, r4			// Draw r4 (address) in left column
	mov	r1, r6
	mov	r2, r5
	ldr	r3, =0x0000FFFF
	bl	draw_num_hex_32

	add	r5, #16			// Move to next row
	cmp	r5, #460		// Move to next column if needed
	movhi	r5, #10
	addhi	r6, #150

	cmp	r6, #500
	bhi	plain_loop$
	
	b	memread_loop$

	
plain_loop$:
	b	plain_loop$

fill_screen$:
	bl	GetFrameBufferPointerQEMU
	ldr	r1, =0xFFFF
fill_loop$:
	strh	r1, [r0], #2
	b	fill_loop$
