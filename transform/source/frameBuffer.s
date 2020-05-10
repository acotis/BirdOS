/******************************************************************************
*	frameBuffer.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the screen01 operating system.
*	See main.s for details.
*
*	frameBuffer.s contains code that creates and manipulates the frame buffer.
******************************************************************************/

// Exports 

.globl GPUInit
.globl GetFrameBufferPointer

// Data

.section .data
.align 12

FrameBufferInfo:
	.int 1024	/* #0 Width */
	.int 768	/* #4 Height */
	.int 1024	/* #8 vWidth */
	.int 768	/* #12 vHeight */
	.int 0		/* #16 GPU - Pitch */
	.int 16		/* #20 Bit Dpeth */
	.int 0		/* #24 X */
	.int 0		/* #28 Y */
	.int 0		/* #32 GPU - Pointer */
	.int 0		/* #36 GPU - Size */

// Code

.section .text
.align  2

GPUInit:
	push    {lr}	
	ldr     r0,=FrameBufferInfo

	add     r0,#0x40000000
	mov     r1,#1
	bl      MailboxWrite
	
	mov     r0,#1
	bl      MailboxRead
		
	teq     r0,#0
	movne   r0,#0
    moveq   r0, #1

	pop {pc}


GetFrameBufferPointer:
    ldr     r0, =FrameBufferInfo
    ldr     r0, [r0, #0x20]
    mov     pc, lr
