
// Exports

    .globl  _start
    
// Imports

    .globl  GPUInit
    .globl  GetFrameBufferPointer
    .globl  text_test

// Data

    .section .data
    .align 4

String:
    .asciz "Hello world!"

// Code
    
    .section .init
    .align 4

_start:
    b       main


    .section .text
    .align 2

main:
    ldr     sp, =0x18000            // STACK BASE

    bl      GPUInit

    bl      text_test
    b       halt
    

    // Initialize a frame buffer

    GPU_response    .req r4
    FB_pointer      .req r5

    bl      GPUInit                 // Initialize a frame buffer
    mov     GPU_response, r0        // Remember the GPU's response in r4

    bl      GetFrameBufferPointer   // Get pointer to the screen
    mov     FB_pointer, r0          // Remember the pointer in r5

    // Fill the first N pixels of the framebuffer with rainbow colors

    ldr     r1, =0x21000            // Color only this many pixels
fill$:
    strh    r0, [r0]                // Write a word
    add     r0, #2                  // Increment pointer
    subs    r1, #1                  // Decrement counter
    bne     fill$

    // Now use the OK LED to broadcast some debug information
    
    mov     r0, GPU_response        // Put last 8 bits of the GPU's
    and     r0, #0xFF               // response in r0
    
    cmp     FB_pointer, #0          // If FB_pointer isn't 0, set 9th
    addne   r0, #0x100              // bit to 1; else, set it to 0.

    mov     r1, #9                  // Broadcast 9 bits of r0 on the
    bl      broadcast               // OK LED
    
    b       halt                    // Halt


// Use the OK LED to broadcast some bits from a 32-bit number on loop.
// It starts with the most significant bit, and uses one flash for a one
// and two flashes for a zero. This method never returns.
//
//     r0 . message to broadcast
//     r1 . number of bits to broadcast
    
broadcast:
    signal      .req r0         // Bits to broadcast
    maskreset   .req r1         // Mask corresponding to top bit
    mask        .req r2         // Current mask
    addr        .req r3         // Address of GPIO controller
    value       .req r4         // GPIO message to toggle OK LED
    timer       .req r5         // Timer used in timing the flashes
    flashcount  .req r6         // Used in a loop later on
    
    ldr     addr, =0x20200000   // Enable output to 16th GPIO pin
    mov     value, #1
    lsl     value, #18
    str     value, [addr, #4]

    mov     value, #1           // We'll be toggling GPIO pin #16
    lsl     value, #16
    
    mov     mask, #1            // Slighly ugly code to get the value
    sub     r1, #1              // [1 << (r1-1)] into maskreset, which
    lsl     maskreset, mask, r1 // is r1.

    mov     mask, maskreset
b_loop$:
    tst     signal, mask        // Check the value of the current bit
    moveq   flashcount, #2      // For a zero, flash twice
    movne   flashcount, #1      // For a one, flash once
    
b_flash$:
    str     value, [addr, #40]  // Turn LED on
    mov     timer, #0x200000    // Wait for 0x200k ticks
    bl      countdown$

    str     value, [addr, #28]  // Turn LED off
    mov     timer, #0x200000    // Wait for 0x200k ticks
    bl      countdown$

    subs    flashcount, #1      // Repeat for each flash
    bne     b_flash$

    lsrs    mask, #1            // Update mask to cover the next bit.
    moveq   mask, maskreset     // If this was the last bit, reset the
    moveq   timer, #0x3000000   // mask and wait 0x3m ticks.
    movne   timer, #0xC00000    // Else, wait for only 0xc00k ticks.
    bl      countdown$

    b       b_loop$             // Repeat forever
    

// Count down the value in r5 to zero, then return. Don't touch any
// other values
    
countdown$:
    subs    r5, #1
    moveq   pc, lr
    b       countdown$


// Do nothing forever

halt:
    b       halt


