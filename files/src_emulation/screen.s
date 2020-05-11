
// Exports

	.globl	GPUInit
	
	.globl	GetFrameBufferPointer
	.globl	GetFrameBufferPointerReal
	.globl	GetFrameBufferPointerQEMU
	
	.globl	GetScreenByteWidth
	.globl	GetScreenByteWidthReal
	.globl	GetScreenByteWidthQEMU

// Data
	
	.section .data
	.align 4
	
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
	
// Code
	
	.section .text
	.align 2

	
// MailboxWrite: Write a message to a given mailbox
//
//	r0 . The mailbox to write to
//	r1 . The message to send
	
MailboxWrite:
	// Create the message by combining (28-bit message)(4-bit mailbox id)
	
	add	r0, r0, r1		// r0 . full message to write
	ldr	r1, =0x2000B880		// r1 . address of mailbox base
	
	// Wait for the top bit of the Status field to be zero
	
mw_status_loop$:
	ldr	r2, [r1, #0x18]		// Make sure top bit of Status field
	tst	r2, #0x80000000		// is zero
	bne	mw_status_loop$

	// Write the message and return
	
	str	r0, [r1, #0x20]
	mov	pc, lr


// MailboxRead: Read a message from a given mailbox
//
//	r0 . ID of the mailbox to read from

MailboxRead:
	// Wait for the 30th bit of the Status field to be zero

	ldr	r1, =0x2000B880		// r1 . address of mailbox
mr_status_loop$:
	ldr	r2, [r1, #0x18]		// Make sure 30th bit of Status field
	tst	r2, #0x40000000		// is zero
	bne	mr_status_loop$
		
	// Read from the Read field until the mailbox is correct
	
mr_mailbox_loop$:	
	ldr	r2, [r1, #0x0]		// r2 . contents of Read field

	and	r3, r2, #0b1111		// Make sure bottom 4 bits match r0
	teq	r3, r0
	bne	mr_mailbox_loop$
	
	and	r0, r2, #0xFFFFFFF0
	mov	pc, lr


// GPUInit: Set up a frame buffer the real way. Return whatever message the
// GPU sends back.
	
GPUInit:	
	push	{lr}
	mov	r0, #1
	ldr	r1, =FrameBufferInfo
	add	r1, #0x40000000
	bl	MailboxWrite
	
	mov	r0, #1
	bl	MailboxRead

	pop	{pc}

	
// GetFrameBufferPointerReal: return the pointer to the frame buffer that the
// GPU approved of.
	
GetFrameBufferPointerReal:
	ldr	r0, =FrameBufferInfo
	ldr	r0, [r0, #0x20]
	mov	pc, lr
	
	
// GetScreenByteWidthReal: return the size of the virtual buffer that the GPU
// approved of.

GetScreenByteWidthReal:
	ldr	r0, =FrameBufferInfo
	ldr	r0, [r0, #0x10]
	mov	pc, lr

// GetFrameBufferPointerQEMU: Just return the pointer to the default frame
// buffer that QEMU provides

GetFrameBufferPointerQEMU:
	ldr	r0, =0x3C100000	// Determined manually and might be broken
	mov	pc, lr

	
// GetScreenByteWidthQEMU: just return the size of the virtual buffer that
// QEMU appears to provide

GetScreenByteWidthQEMU:
	mov	r0, #1280	// 640 pixels x 2 bytes per pixel
	mov	pc, lr


// Wrapper functions

GetScreenByteWidth:
	b	GetScreenByteWidthQEMU

GetFrameBufferPointer:
	b	GetFrameBufferPointerQEMU
	
