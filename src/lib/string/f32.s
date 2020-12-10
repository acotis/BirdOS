
// Exports

    .globl  f32_to_str_binary

// Code

// f32_to_str_binary: Convert a 32-bit floating point number into a
// string of the form 1.----e----- (sci notation, base 2). 
//
//  r0 . the address to store the result-string at
//  s0 . the 32-bit float to convert

f32_to_str_binary:
    push    {r4, r5, lr}

    address .req r4
    value   .req r5

    mov     address, r0
    vmov     value, s0

    tst     value, #0x80000000          // If value is negative,
    beq     ftsb_notneg

    bic     value, #0x80000000          //   make it positive,
    mov     r0, #45                     //   and put a minus sign in.
    strb    r0, [address], #1

ftsb_notneg:

    add     r0, address, #1             // Print mantissa
    bic     r1, value, #0xFF000000
    orr     r1, #0x00800000
    mov     r2, #2
    bl      uint_to_str_cbase

    mov     r0, #49                     // Replace beginning with "1."
    strb    r0, [address]
    mov     r0, #46
    strb    r0, [address, #1]

    add     address, #25                // Go to end of string
    mov     r0, #101                    // Write an "e"
    strb    r0, [address], #1

    lsr     value, #23                  // Extract exponent
    subs    value, #127                 // If expt is negative,
    bge     ftsb_expt_notneg

    mov     r0, #0                      //   make it positive,
    sub     value, r0, value
    mov     r0, #45                     //   and put a minus sign in
    strb    r0, [address], #1

ftsb_expt_notneg:
    
    mov     r0, address                 // Print exponent
    mov     r1, value
    mov     r2, #2
    bl      uint_to_str_cbase
    
    pop     {r4, r5, pc}

    .unreq  address
    .unreq  value
