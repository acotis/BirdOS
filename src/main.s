
// Exports

    .globl  _start
    
// Imports

    .globl  GPUInit             // Screen
    .globl  VFPInit             // Floating-point unit

    .globl  print               // Cursor abstraction
    .globl  tab_to
    .globl  newline

    .globl  int_to_str          // Number formattting
    .globl  int_to_str_cbase    
    .globl  f32_to_str_binary

    .globl  sine                // Math library
    .globl  cosine

    .globl  StringDemo


// Data

    .section .data
    .align 4

xString:
    .asciz "Value of x"

SineString:
    .asciz "Value of sin(x)"

CosineString:
    .asciz "Value of cosine(x)"

FloatString:
    .space 100


// Code (init)
    
    .section .init
    .align 4

_start:
    b       main


// Code (main)

    .section .text
    .align 2

main:
    ldr     sp, =0x18000            // STACK BASE

    bl      GPUInit                 // Init a frame buffer
    bl      VFPInit                 // Init floating-point unit

    bl      StringDemo

    b       halt


sine_demo:
    // Print column headers

    ldr     r0, =xString            // First header
    ldr     r1, =0xFFFF
    bl      print

    mov     r0, #20                 // Tab to column 20
    bl      tab_to

    ldr     r0, =SineString         // Second header
    ldr     r1, =0xFFFF
    bl      print

    mov     r0, #40                 // Tab to column 40
    bl      tab_to

    ldr     r0, =CosineString       // Third header
    ldr     r1, =0xFFFF
    bl      print

    bl      newline

    // Initialize s4 (value of x) and s5 (multiplier)

    mov     r0, #40                 // s4 = 4
    vmov    s4, r0
    vcvt.f32.s32 s4, s4

    mov     r0, #2                  // s5 = 2
    vmov    s5, r0
    vcvt.f32.s32 s5, s5

    // Sine loop

    counter .req r4
    color   .req r5
    
    mov     counter, #40            // Initialize the counter to 40
m_loop$:
    subs    counter, #1             // Tick down the counter
    beq     halt

    tst     counter, #1                     // Select the color:
    ldreq   color, =0b0010010101111101      //   even: gentle blue
    ldrne   color, =0b1111101010010000      //   odd: gentle red
    //                (red)(grn)(blue)

    vmov    s0, s4                  // Convert s4
    ldr     r0, =FloatString        
    bl      f32_to_str_decimal

    ldr     r0, =FloatString        // Print s4
    mov     r1, color
    bl      print

    mov     r0, #20                 // Tab to column 20
    bl      tab_to

    vmov    s0, s4                  // Convert sin(s4)
    bl      sine
    ldr     r0, =FloatString
    bl      f32_to_str_decimal

    ldr     r0, =FloatString        // Print sin(s4)
    mov     r1, color
    bl      print

    mov     r0, #40                 // Tab to column 40
    bl      tab_to

    vmov    s0, s4
    bl      cosine
    ldr     r0, =FloatString
    bl      f32_to_str_decimal

    ldr     r0, =FloatString
    mov     r1, color
    bl      print

    bl      newline                 // Go to the next line
    vdiv.f32 s4, s4, s5             // Divide s4 by 2

    b       m_loop$                 // Loop
    

// Do nothing forever

halt:
    b       halt


