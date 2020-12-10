
// Exports

    .globl  uint_to_str
    .globl  uint_to_str_cbase
    .globl  int_to_str
    .globl  int_to_str_cbase

// Data

    .section .data
    .align 2

Powers:                 // Used by a helper method
    .space 33*4
    
// Code

    .section .text
    .align  2


// fill_in_powers: private method. Fill out the Powers table with powers 
// of r0, up to a limit of r1. If the next power doesn't fit in a 32-bit
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


// uint_to_str_cbase: convert the uint r1 into a string in base r2 and
// store the result in memory location r0.
//
//  r0 . the address to store the string at
//  r1 . the int to convert
//  r2 . the base to use

uint_to_str_cbase:
    push    {r4, r5, r6, lr}

    address .req r4
    value   .req r5
    base    .req r6

    mov     address, r0             // Move values out of the way
    mov     value, r1
    mov     base, r2

    mov     r0, base                // Fill out powers table
    mov     r1, value
    bl      fill_in_powers

    power_p .req r0
    power   .req r1
    digit   .req r2

utsc_digits_loop$:
    ldr     power, [power_p]        // Get the next power
    sub     power_p, #4             //   (and decrement power pointer)
    mov     digit, #0               // Initialize next digit at 0
    
utsc_digit_loop$:
    cmp     value, power            // If value < power, break
    blo     utsc_digit_loop_end$

    sub     value, power            // Else, subtract one of power,
    add     digit, #1               //   increment digit value,
    b       utsc_digit_loop$        //   and loop back around

utsc_digit_loop_end$:
    cmp     digit, #9               // convert to ascii
    addle   digit, #48              // (ascii value of '0')
    addhi   digit, #55              // (ascii value of 'A' - 10)

    strb    digit, [address], #1    // Store result in the string
    
    cmp     power, #1               // If power isn't 1, go to next digit
    bne     utsc_digits_loop$

    mov     digit, #0               // Else, insert a null terminator
    strb    digit, [address]        // and return

    pop     {r4, r5, r6, pc}

    .unreq  address
    .unreq  value
    .unreq  base
    .unreq  power_p
    .unreq  power
    .unreq  digit
    

// uint_to_str: convert the uint r1 into a string and store the result in
// memory location r0.
//  
//  r0 . the address to store the result-string at
//  r1 . the int to convert

uint_to_str:
    mov     r2, #0x10
    b       uint_to_str_cbase


// int_to_str_cbase: convert the int r1 into a string in base r2 and
// store the result in memory location r0.
//
//  r0 . the address to store the result-string at
//  r1 . the int to convert
//  r2 . the base to use

int_to_str_cbase:
    cmp     r1, #0                  // If r1 > 0, tailcall uint
    bge     uint_to_str_cbase
    
    mov     r3, #45                 // Else:
    strb    r3, [r0], #1            //   put a dash in the string,
    neg     r1, r1                  //   negate the value,
    b       uint_to_str_cbase       //   and tailcall uint


// int_to_str: convert the int t1 into a string and store the result in
// memory location r0.

int_to_str:
    mov     r2, #0x10
    b       int_to_str_cbase
