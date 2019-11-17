
	.section .text
	.align 2

	.globl MailboxWrite
	.globl MailboxRead
	
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
