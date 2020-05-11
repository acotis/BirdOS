
// Imports

    .globl  print
    .globl  newline
    .globl  int_to_str_cbase

// Exports 

    .globl  Primes

// Data

    .section .data
    .align 2

primes_table:
    .space 101*4

IntString:
    .space 33

space:
    .asciz " "

// Code

    .section .text
    .align 4


// remainder: return r0 modulo r1 (i.e. r0 % r1). This implementation is
// rather inefficient.
//
//  r0 . number to take modulo of
//  r1 . number to take modulo by

remainder:
    subs    r0, r1              // Subtract one multiple
    bgt     remainder           // If still pos, repeat
    addlt   r0, r1              // If neg, undo last cycle
    mov     pc, lr              // Return


// any_divides: return 1 if any prime in the table so far divides r0,
// else 0.
//
//  r0 . number to check for divisibility by any prime

any_divides:
    push    {r4, r5, lr}

    value   .req r4
    prime_p .req r5

    mov     value, r0
    ldr     prime_p, =primes_table

ad_loop$:
    ldr     r1, [prime_p], #4       // Load next prime
    cmp     r1, #0                  // If zero, 
    moveq   r0, #0                  //   return 0
    popeq   {r4, r5, pc}

    mov     r0, value               // Compute the remainder
    bl      remainder

    cmp     r0, #0                  // If zero, return 1
    moveq   r0, #1
    popeq   {r4, r5, pc}
    
    b       ad_loop$                // Loop around

    .unreq  value
    .unreq  prime_p


// Primes: Display the first 100 primes.

Primes:
    push    {r4, r5, r6, lr}

    count   .req r4
    next    .req r5
    prime_p .req r6

    mov     count, #100             // Print 100 primes
    mov     next, #2                // Check 2 for primality first
    ldr     prime_p, =primes_table

p_loop$:
    mov     r0, next                // Check this number for primality
    bl      any_divides

    cmp     r0, #1                  // If not prime,
    beq     p_not_prime$            //   skip prime stuff

                                    // Prime stuff:
    str     next, [prime_p], #4     //   Store this prime, incr pointer
    subs    count, #1               //   Decr count
    beq     p_print$                //   If done, go to printing stage

p_not_prime$:
    add     next, #1                // Incr N
    b       p_loop$                 // Loop around

p_print$:
    ldr     prime_p, =primes_table

p_print_loop$:
    ldr     r1, [prime_p], #4       // Load next prime
    cmp     r1, #0                  // If it's zero,
    popeq   {r4, r5, r6, pc}        //   return

    ldr     r0, =IntString          // Convert to base-10 integer string
    mov     r2, #10
    bl      int_to_str_cbase

    ldr     r0, =IntString          // Print it out
    ldr     r1, =0x0000FFFF
    bl      print

    ldr     r0, =space              // Print a space
    ldr     r1, =0x0000FFFF
    bl      print

    b       p_print_loop$           // Loop around
