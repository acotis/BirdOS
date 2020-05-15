
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

    mov         x_pix, #50          // Initialize counter to 0

    mov         r0, #50             // step = 50 (temporary)
    vmov        step, r0
    vcvt.f32.s32 step, step

    mov         r0, #1              // step = 1/50
    vmov        s0, r0
    vcvt.f32.s32 s0, s0
    vdiv.f32    step, s0, step

    mov         r0, #0              // Set x-coord to 0
    vmov        x_world, r0
    vcvt.f32.s32 x_world, x_world

c_loop$:
    vmov        s0, x_world         // Take the sin of the x-coord
    bl          cosine

    vdiv.f32    s0, s0, step        // Convert to pixel value
    vcvt.s32.f32 s0, s0
    vmov        y_pix, s0           // Store in y_pix
    rsb         y_pix, #300

    bl          GetScreenByteWidth  // Compute pixel offset in frame buf
    mul         offset, r0, y_pix
    add         offset, x_pix, lsl #1

    bl          GetFrameBufferPointer
    add         r0, offset
    ldr         r1, =0xFFFF
    strh        r1, [r0]

    vadd.f32    x_world, step       // Increment x coord
    add         x_pix, #1           // Increment counter
    cmp         x_pix, #600         // Repeat for 500 steps
    blt         c_loop$

halt:                               // Wait forever
    b           halt

