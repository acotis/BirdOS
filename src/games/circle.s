
// Imports

    .globl  f32_to_int
    .globl  print
    .globl  newline

// Exports 
    
    .globl  Circle

// Data

    .section .data
    .align 4

IntString:
    .space 33

// Code

    .section .text
    .align 4

Circle:         // .<expont><   m a n t i s s a   >
    ldr     r0, =0b00111111100000000000000000000000
    vmov    s0, r0

    bl      f32_to_int          // Convert float to int

    mov     r1, r0
    ldr     r0, =IntString      // Convert int to string
    mov     r2, #2
    bl      int_to_str_cbase
    
    ldr     r0, =IntString      // Print resulting string
    ldr     r1, =0x0000FFFF
    bl      print

halt:
    b       halt
