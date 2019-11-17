	.section .text
	.globl _start

_start:
	mov	r0, pc
	mov	r1, #2
	add	r2, r1, r1

loop:
	b	loop
