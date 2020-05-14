
// Imports

    .globl  f32_to_int
    .globl  int_to_f32
    .globl  sine

    .globl  int_to_str_cbase
    .globl  int_to_str
    .globl  print
    .globl  newline

    .globl  GetFrameBufferPointer
    .globl  GetScreenByteWidth

// Exports 
    
    .globl  Circle

// Data

    .section .data
    .align 4

IntString:
    .space 33

Space:
    .asciz " "

// Code

    .section .text
    .align 4


Circle:
    mov         r4, #0              // Initialize counter to 0

c_loop$:
    ldr         r0, =IntString      // Convert counter to a string
    mov         r1, r4
    bl          int_to_str

    ldr         r0, =IntString      // Print the string
    ldr         r1, =0x00000FF0     // (Green text on black background)
    bl          print

    ldr         r0, =Space          // Print a space
    ldr         r1, =0x00000FF0     // (Green text on black background)
    bl          print

    mov         r5, #0x1000000      // Pause for a beat
c_pause$:
    subs        r5, #1
    bne         c_pause$

    vmov        s0, s1          // What the heck is happening here?

    add         r4, #1              // Increment counter
    cmp         r4, #5              // Repeat until counter = 5
    blt         c_loop$

halt:                               // Wait forever
    b           halt

