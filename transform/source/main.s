/******************************************************************************
*	main.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the screen01 operating system, that 
*	creates a frame buffer and continually renders to it.
*
*	main.s contains the main operating system, and IVT code.
******************************************************************************/

// Exports

.globl _start

// Code

.section .init

_start:
    b main

.section .text

main:
	mov     sp, #0x8000
	bl      GPUInit

    pointer .req r0
    color   .req r1
    x       .req r2
    y       .req r3

render$:
    bl      GetFrameBufferPointer

	mov     y, #768
drawRow$:
    mov     x, #1024
drawPixel$:
    strh    color,[pointer]
    add     pointer, #2
    subs    x,#1
    bne     drawPixel$

    add     color,#1
    subs    y,#1
    bne     drawRow$

	b       render$

