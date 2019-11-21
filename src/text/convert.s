
// Exports

	.globl	int_to_str

// Code

	.section .text
	.align	2

// int_to_str: convert the int r1 into a string and store the result in r0.
//
//	r0 . the address to store the result-string at
//	r1 . the int to convert
	
int_to_str:
	mov	r2, #28			// r2 . 28 (counts down to 0 by 4's)
	
its_digit_loop$:
	mov	r3, #0xF		// r3 = one-digit bitmask
	lsl	r3, r2			// r3 = bitmask in the right spot
	and	r3, r1			// r3 = next digit in-place
	lsr	r3, r2			// r3 . next digit value

	cmp	r3, #9			// r3 . next digit ascii code
	addle	r3, #48			// (if numeric, add '0' = 48)
	addhi	r3, #55			// (else, add 'A' - 10 = 55)

	strb	r3, [r0], #1		// Store digit and incr pointer
	
	subs	r2, #4			// March forward one digit
	bge	its_digit_loop$		// If still on digit >= 0, loop back
	
dnh_digit_end$:	
	mov	pc, lr
