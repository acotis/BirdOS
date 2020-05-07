
// Exports

    .globl  _start
    
// Imports

    .globl  GPUInit
    .globl  GetScreenByteWidth
    .globl  GetFrameBufferPointer

// Data

String:
    .asciz  "Hello world!"
    
// Code
    
    .section .init

_start:
	ldr     sp, =0x18000		// STACK BASE

    bl      GPUInit

    // Fill part of the screen with white

    pointer .req r4
    counter .req r6
    color   .req r7

    bl      GetFrameBufferPointer   // Get pointer to the screen

    add     pointer, r0, #0xDF000   // Skip this many words
    ldr     counter, =0x2000000             
fill$:
    mov     r5, #0x80000             // Pause for a beat
    bl      countdown$

    strh    pointer, [pointer]      // Write a word
    add     pointer, #2             // Increment pointer
    subs    counter, #1             // Decrement counter
    bne     fill$

    // Now broadcast primes to indicate we're done

    ldr     r0, =0b01101010001010001010001000001010
    bl      broadcast
    
loop$:
    b       loop$


// Use the OK LED to broadcast a 32-bit number (stored in r0) on loop.
// Start with the most significant digit, use one flash for ones, two
// flashes for zeroes. This method never returns.
    
broadcast:
    signal  .req r0
    mask    .req r1
    addr    .req r2
    value   .req r3
    
    ldr     addr, =0x20200000   // Enable output to 16th GPIO pin
    mov     value, #1
    lsl     value, #18
    str     value, [addr, #4]

    mov     value, #1           // We'll be toggling GPIO pin #16
    lsl     value, #16
    
    mov     mask, #0x80000000
b_loop$:
    tst     signal, mask        // Check the current bit
    moveq   r4, #2              // For a zero, flash twice
    movne   r4, #1              // For a one, flash once
    
b_flash$:
    str     value, [addr, #40]  // Turn LED on
    mov     r5, #0x200000       // Wait for 0x200k ticks
    bl      countdown$
    str     value, [addr, #28]  // Turn LED off
    mov     r5, #0x200000       // Wait for 0x200k ticks
    bl      countdown$

    subs    r4, #1              // Repeat for each flash
    bne     b_flash$

    lsrs    mask, #1            // Update mask
    moveq   mask, #0x80000000
    moveq   r5, #0x3000000      // If cycling, wait for 0x3m ticks
    movne   r5, #0xC00000       // Else, wait for only  0xc00k ticks

    bl      countdown$
    b       b_loop$
    

// Count down the value in r5 to zero, then return. don't touch any
// other values
    
countdown$:
    subs    r5, #1
    moveq   pc, lr
    b       countdown$


// Do nothing forever

halt:
    b       halt


