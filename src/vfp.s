
// Exports

    .globl  VFPInit

// Code

    .section .text
    .align 4

// enable_vfp: run some weird code that apparently enables that ARM floating
// point unit.	Copied from pg 2-3 of https://static.docs.arm.com/ddi0463/f/DDI0463F_cortex_a7_fpu_r0p5_trm.pdf.

VFPInit:
	MRC	    p15, 0, r0, c1, c1, 2
	ORR	    r0, r0, #3<<10 	// enable fpu
	MCR	    p15, 0, r0, c1, c1, 2

	LDR	    r0, =(0xF << 20)
	MCR	    p15, 0, r0, c1, c0, 2

	MOV	    r3, #0x40000000
	VMSR	FPEXC, r3

	mov	    pc, lr
