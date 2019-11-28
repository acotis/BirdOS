
// Exports

	.globl	int_to_str
	.globl	int_to_str_cbase
	
// Code

	.section .text
	.align	2

	
// int_to_str: convert the int r1 into a string and store the result in
// memory location r0.
//	
//	r0 . the address to store the result-string at
//	r1 . the int to convert
	
int_to_str2:
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



int_to_str:
	push	{lr}
	mov	r2, #4
	bl	int_to_str_cbase
	pop	{pc}


	
// int_to_str_cbase: convert the int r1 into a string in base 2^r2 and store
// the result at memory location r0. The "c" stands for "custom".
//
//	r0 . the memory location to store the result at
//	r1 . the number to convert
//	r2 . the base-2 logarithm of the base to use (1-5 inclusive)

int_to_str_cbase:
	push	{r4, r5, lr}
	
	result_addr .req r0
	number .req r1
	baselog .req r2
	mask .req r3
	shift .req r4
	digit .req r5

	// Construct the mask

	mov	mask, #1
	lsl	mask, baselog
	sub	mask, #1
	
	// Compute the first shift by adding up copies of the one-digit shift
	// amount until the sum is 32 or above, then taking one back off

	mov	shift, #0
itsc_compute_shift:
	add	shift, baselog
	cmp	shift, #32
	blo	itsc_compute_shift

	sub	shift, baselog

	// Render each digit into ascii

itsc_digit_loop:
	and	digit, number, mask, lsl shift	// get digit
	lsr	digit, shift

	cmp	digit, #9			// convert to ascii
	addle	digit, #48			// (ascii value of '0')
	addhi	digit, #55			// (ascii value of 'A' - 10)

	strb	digit, [result_addr], #1	// write to result string

	subs	shift, baselog			// march forward
	bge	itsc_digit_loop

	// finish the string with a null byte and return

	mov	digit, #0
	strb	digit, [result_addr]
	pop	{r4, r5, pc}
