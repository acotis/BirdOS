
// Imports

    .globl  f32_to_int
    .globl  int_to_f32
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
    //ldr     r0, =0b11000001011010100111010111010110
    //vmov    s0, r0

    //bl      f32_to_int          // Convert float to int
    //rsb     r0, #0

    ldr     r0, =0x7FFFFFFF
    bl      int_to_f32
    vmov    r0, s0              // Flash it back for inspection

    mov     r1, r0
    ldr     r0, =IntString      // Convert int to string
    mov     r2, #2
    bl      int_to_str_cbase
    
    ldr     r0, =IntString      // Print resulting string
    ldr     r1, =0x0000FFFF
    bl      print

halt:
    b       halt
