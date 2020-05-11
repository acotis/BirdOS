
// Exports

    .globl  int_to_str
    .globl  int_to_str_cbase
    .globl  int_to_str_cbase_old

    .globl  fill_in_powers      // DEBUG ONLY!
    .globl  Powers              // DEBUG ONLY!

// Data

    .section .data
    .align 2

Powers:             // Scratch space
    .space 33*4
    
// Code

    .section .text
    .align  2


// fill_in_powers: private method. Fill out the Powers table with powers 
// of r0, up to a limit of r1. If the next power doens't fit in a 32-bit
// word, stop. Return the address of the largest power.
//
//  r0 . the base of the powers
//  r1 . the limit not to exceed
//
//  r0 < Address of the largest power in the Powers table

fill_in_powers:
    push    {r4, lr}

    base    .req r0
    limit   .req r1
    power   .req r2                 // Actual current power
    carry   .req r3                 // Catch any spillover from carry
    address .req r4

    mov     power, #1               // Initialize current power = 0
    mov     carry, #0
    ldr     address, =Powers

fip_loop$:
    str     power, [address], #4    // Store current power
    umull   power, carry, power, base   // Compute next power

    cmp     carry, #0               // If there was carry, stop
    bne     fip_end$

    cmp     power, limit            // If current power exceeds limit,
    bhi     fip_end$                // stop

    b       fip_loop$               // Else, loop back around

fip_end$:
    sub     r0, address, #4         // We went one over, so subtract one
    pop     {r4, pc}

    .unreq  base
    .unreq  limit
    .unreq  power
    .unreq  carry
    .unreq  address


// int_to_str_cbase: convert the int r1 into a string in base r2 and store
// the result in memory location r0.
//
//  r0 . the address to store the string at
//  r1 . the int to convert
//  r2 . the base to use

int_to_str_cbase:
    push    {r4, r5, r6, lr}

    address     .req r4
    value       .req r5
    base        .req r6

    mov     address, r0             // Move values out of the way
    mov     value, r1
    mov     base, r2

    mov     r0, base                // Fill out powers table
    mov     r1, value
    bl      fill_in_powers

    power_p     .req r0
    power       .req r1
    digit       .req r2

itsc_digits_loop$:
    ldr     power, [power_p]        // Get the next power
    sub     power_p, #4             //   (and decrement power pointer)
    mov     digit, #0               // Initialize next digit at 0
    
itsc_digit_loop$:
    cmp     value, power            // If value < power, break
    blo     itsc_digit_loop_end$

    sub     value, power            // Else, subtract one of power,
    add     digit, #1               //   increment digit value,
    b       itsc_digit_loop$        //   and loop back around

itsc_digit_loop_end$:
    cmp     digit, #9               // convert to ascii
    addle   digit, #48              // (ascii value of '0')
    addhi   digit, #55              // (ascii value of 'A' - 10)

    strb    digit, [address], #1    // Store result in the string
    
    cmp     power, #1               // If power isn't 1, go to next digit
    bne     itsc_digits_loop$

    mov     digit, #0               // Else, insert a null terminator
    strb    digit, [address]        // and return

    pop     {r4, r5, r6, pc}

    .unreq  address
    .unreq  value
    .unreq  base
    .unreq  power_p
    .unreq  power
    .unreq  digit
    

    
// int_to_str: convert the int r1 into a string and store the result in
// memory location r0.
//  
//  r0 . the address to store the result-string at
//  r1 . the int to convert

int_to_str:
    push    {lr}
    mov     r2, #4
    bl      int_to_str_cbase_old
    pop     {pc}

    
// int_to_str_cbase_old: convert the int r1 into a string in base 2^r2 and
// store the result at memory location r0. The "c" stands for "custom".
//
//  r0 . the memory location to store the result at
//  r1 . the number to convert
//  r2 . the base-2 logarithm of the base to use (1-5 inclusive)

int_to_str_cbase_old:
    push    {r4, r5, lr}
    
    result_addr .req r0
    number      .req r1
    baselog     .req r2
    mask        .req r3
    shift       .req r4
    digit       .req r5

    // Construct the mask

    mov     mask, #1
    lsl     mask, baselog
    sub     mask, #1
    
    // Compute the first shift by adding up copies of the one-digit shift
    // amount until the sum is 32 or above, then taking one back off

    mov     shift, #0
itsco_compute_shift:
    add     shift, baselog
    cmp     shift, #32
    blo     itsco_compute_shift

    sub     shift, baselog

    // Render each digit into ascii

itsco_digit_loop:
    and     digit, number, mask, lsl shift  // get digit
    lsr     digit, shift

    cmp     digit, #9           // convert to ascii
    addle   digit, #48          // (ascii value of '0')
    addhi   digit, #55          // (ascii value of 'A' - 10)

    strb    digit, [result_addr], #1    // write to result string

    subs    shift, baselog          // march forward
    bge     itsco_digit_loop

    // finish the string with a null byte and return

    mov     digit, #0
    strb    digit, [result_addr]
    pop     {r4, r5, pc}
