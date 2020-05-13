
// Imports

    .globl  GetScreenByteWidth
    .globl  GetFrameBufferPointer

    .globl  print       // for testing
    .globl  newline
    .globl  int_to_str
    .globl  int_to_str_cbase_old
    
// Exports

    .globl  Mandelbrot

// Data

    .section .data
    .align  2

s0:
    .asciz  "s0 = "
s1:
    .asciz  "s1 = "
s2:
    .asciz  "s2 = "

nothing:
    .asciz  ""
    
space:
    .asciz  " "
    
Number:
    .zero   35

    
// Code

    .section .text
    .align  2

    
// put_color: put color r2 (half word) at row r0, column r1, indexed from the
// center of the screen.
//
//  r0 . row number (-239 to +240)
//  r1 . col number (-319 to +320)
//  r2 . color to write
    
put_color:
    push    {r4, r5, r6, lr}
    
    rsb     r4, r0, #240        // r4 . row from top of screen down
    add     r5, r1, #320        // r5 . column from left of screen
    sub     r5, #1
    mov     r6, r2              // r6 . color
    
    bl      GetScreenByteWidth  // r4 . screen offset to write to
    mul     r4, r0
    add     r4, r5, lsl #1

    bl      GetFrameBufferPointer   // r0 = frame buffer start
    add     r0, r4              // r0 . address to write to
    strh    r6, [r0]

    pop     {r4, r5, r6, pc}

    
// make_color: make a color out of a scalar. Start with black, then drift 
// through blue, green, and finally red.
//
//  r0 . the scalar (range: 0 - 93)
    
make_color:
    blue    .req r1
    green   .req r2
    red .req r3

    subs    blue, r0, #31       // blue = dist from r0 to 31
    rsblos  blue, blue, #0
    cmp     blue, #31           // blue = max(blue, 31)
    movhi   blue, #31
    rsb     blue, #31           // blue = 31 - blue

    subs    green, r0, #62      // green = dist from r0 to 31
    rsblos  green, green, #0
    cmp     green, #31          // green = max(green, 31)
    movhi   green, #31
    rsb     green, #31          // green - 31 - green

    subs    red, r0, #62        // red = dist that r0 is above 62
    movlo   red, #0
    cmp     red, #31
    movhi   red, #31
    
    mov     r0, blue
    add     r0, green, lsl #6
    add     r0, red, lsl #11

    bx      lr

    .unreq  blue
    .unreq  green
    .unreq  red


// compute_escape: compute 93 - x, where x is the escape time of the
// mandelbrot sequence with c = (s0 + s1 i). if the sequence remains bounded
// after 93 iterations of the mandelbot map, return 0. registers s2-s5
// are trashed.
    
compute_escape:
    push    {lr}

    mov     r0, #93

    mov     r1, #0x00000000     // floating-point 0
    mov     r2, #0x40000000     // floating-point 2
    
    vmov    s2, r1              // z = (s2 + s3*i) = 0
    vmov    s3, r1

ce_loop:

    vmul.f32 s4, s2, s2         // square z
    vmls.f32 s4, s3, s3
    vmul.f32 s5, s2, s3
    vmla.f32 s5, s2, s3
    vmov    s2, s4
    vmov    s3, s5

    vadd.f32 s2, s0             // add c
    vadd.f32 s3, s1

    vmul.f32 s4, s2, s2         // s4 = |z|
    vmla.f32 s4, s3, s3
    vsqrt.f32 s4, s4

    vmov    s5, r2
    vcmp.f32 s4, s5             // if s4 > 2, break out
    vmrs    APSR_nzcv, FPSCR    // copy fp compare flags to regular
    bhi     ce_loop_end         // compare flags

    subs    r0, #1              // (if on 93rd cycle, break out) 
    beq     ce_loop_end    

    b       ce_loop             // March forward

ce_loop_end:    
    pop     {pc}


// fmul: s0 *= r0. trashes s1.

fmul:
    push    {lr}

    tst     r0, #0x80000000
    beq     fmul_positive
    rsb     r0, r0, #0
    vneg.f32 s0, s0

fmul_positive:  
    vmov    s1, s0          // s1 . number to add multiples of
    mov     r1, #0          // s0 . accumulator
    vmov    s0, r1

f_loop:
    cmp     r0, #0          // if done, return
    popeq   {pc}
    
    vadd.f32 s0, s1         // add another multiple, loop back
    sub     r0, #1
    b       f_loop

    
    
// Mandelbrot: draw a Mandelbrot fractal on the screen.

Mandelbrot:
    push    {r4, r5, r6, lr}
    
    // put 1/128 into s6

    ldr r0, =0x3c000000 
    vmov    s6, r0

    
    // Loop over each pixel on the screen
    
    ldr r4, =-239           // r4 . row
m_rowloop:
    ldr r5, =-319           // r5 . column

m_colloop:  
    vmov    s0, s6
    mov     r0, r4
    bl      fmul

    vmov    s2, s0
    vmov    s0, s6
    mov     r0, r5
    bl      fmul

    vmov    s1, s2
    
    bl      compute_escape  // compute the escape number
    bl      make_color      // make the appropriate color
    mov     r2, r0
    mov     r0, r4
    mov     r1, r5
    bl      put_color

    add     r5, #1
    cmp     r5, #320
    ble     m_colloop

    add     r4, #1
    cmp     r4, #240
    ble     m_rowloop
    
    pop     {r4, r5, r6, pc}


// helper function for debugging
//
//  r0 . string to print before number
//  r1 . number to print
//  r2 . colors to use
    
print_float:
    push    {r4, r5, lr}

    number .req r4
    colors .req r5
    
    mov     number, r1
    mov     colors, r2

    // print before-string
    
    mov     r1, colors
    bl      print

    // convert to binary string
    
    ldr     r0, =Number
    mov     r1, number
    mov     r2, #1
    bl      int_to_str_cbase_old

    //b pf_end
    
    // move mantissa bits over by 2

    ldr     r0, =Number
    mov     r1, #31
pf_mantissa_loop:
    ldrb    r2, [r0, r1]
    add     r1, #2
    strb    r2, [r0, r1]
    sub     r1, #3

    cmp     r1, #8
    bhi     pf_mantissa_loop

    // move exponent bits over by 1

pf_exponent_loop:   
    ldrb    r2, [r0, r1]
    add     r1, #1
    strb    r2, [r0, r1]
    sub     r1, #2

    cmp     r1, #0
    bhi     pf_exponent_loop

    // put spaces in their places

    mov     r1, #32         // ascii value of ' '
    strb    r1, [r0, #1]
    strb    r1, [r0, #10]


pf_end:
    ldr     r0, =Number
    mov     r1, colors
    bl      print
    bl      newline
    
    pop     {r4, r5, pc}


halt:
    b       halt
