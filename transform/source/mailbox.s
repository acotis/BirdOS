/******************************************************************************
*	mailbox.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the screen01 operating system.
*	See main.s for details.
*
*	mailbox.s contains code that interacts with the mailbox for communication
*	with various devices.
******************************************************************************/

/* NEW
* GetMailboxBase returns the base address of the mailbox region as a physical
* address in register r0.
* C++ Signature: void* GetMailboxBase()
*/
.globl GetMailboxBase
GetMailboxBase: 
	ldr r0,=0x2000B880
	mov pc,lr

/* NEW
* MailboxWrite writes the value given in the top 28 bits of r0 to the channel
* given in the low 4 bits of r1.
* C++ Signature: void MailboxWrite(u32 value, u8 channel)
*/
.globl MailboxWrite
MailboxWrite: 
    add     r0, r1
    ldr     r1, =0x2000B880
		
wait1$:
    ldr     r2,[r1,#0x18]

    tst     r2,#0x80000000
    bne     wait1$

	str     r0,[r1,#0x20]
    mov     pc, lr

/* NEW
* MailboxRead returns the current value in the mailbox addressed to a channel
* given in the low 4 bits of r0, as the top 28 bits of r0.
* C++ Signature: u32 MailboxRead(u8 channel)
*/
.globl MailboxRead
MailboxRead: 
    ldr     r1, =0x2000B880
	
wait2$:
    ldr     r2,[r1,#0x18]
    tst     r2,#0x40000000
    bne     wait2$

    ldr     r2,[r1,#0]

    and     r3,r2,#0b1111
    teq     r3,r0
    bne     wait2$

	and     r0,r2,#0xfffffff0
    mov     pc, lr
