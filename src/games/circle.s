
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
    x_pix   .req r4
    y_pix   .req r5
    offset  .req r6
    step    .req s4
    x_world .req s5

    mov         x_pix, #0           // Initialize counter to 0

    mov         r0, #50             // step = 50 (temporary)
    bl          int_to_f32
    vmov        step, s0

    mov         r0, #1              // step = 1/50
    bl          int_to_f32
    vdiv.f32    step, s0, step

    mov         r0, #0              // Set x-coord to 0
    vmov        x_world, r0

c_loop$:
    vmov        s0, x_world         // Take the sin of the x-coord
    bl          sine

    cmp         x_pix, #200
    bne         c_noprint$

    ldr         r0, =IntString
    vmov        r1, s0
    mov         r2, #2
    bl          int_to_str_cbase
    ldr         r0, =IntString
    ldr         r1, =0x0FF0
    bl          print

c_noprint$:
    vdiv.f32    s0, s0, step        // Convert to pixel value
    bl          f32_to_int          // Round to integer
    mov         y_pix, r0           // Store in y_pix

    bl          GetScreenByteWidth  // Compute pixel offset in frame buf
    mul         offset, r0, y_pix
    add         offset, x_pix, lsl #1

    bl          GetFrameBufferPointer
    add         r0, offset
    ldr         r1, =0xFFFF
    strh        r1, [r0]

    vadd.f32    x_world, step       // Increment x coord
    add         x_pix, #1           // Increment counter
    cmp         x_pix, #500         // Repeat for 500 steps
    blt         c_loop$

halt:                               // Wait forever
    b           halt

