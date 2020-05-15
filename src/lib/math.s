
// Exports
    
    .globl  f32_to_int
    .globl  int_to_f32

    .globl  sine
    .globl  cosine

// Code

    .section .text
    .align 4


// sine: Compute the sine of the floating point register s0 in single-
// precision. Store the result in s0. 
//
//  s0 . Input value x
//
//  s0 < sin(x)

sine:
    // Move s0 to within [-pi, +pi]

    ldr         r0, =0b01000000010010010000111111011010 // pi
    vmov        s1, r0

    vdiv.f32    s2, s0, s1      // s2 = s0 / pi
    vcvt.s32.f32 s2, s2         // s2 . number of multiples of pi below s0
    vcvt.f32.s32 s2, s2

    vmul.f32    s1, s1, s2      // s1 = nearest multiple of pi below s0
    vsub.f32    s0, s0, s1      // Subtract those multiples of pi

    // If we subtracted an odd number of pi's, reverse the sign of s0

    vcvt.s32.f32 s2, s2
    vmov        r0, s2
    tst         r0, #1
    vnegne.f32  s0, s0

    // Compute the Maclaurin sum

    ret     .req s0             // Starts off at x
    x_sqr   .req s1             // (value x^2)
    term    .req s2

    vmov        term, s0        // First term is x
    vmul.f32    x_sqr, s0, s0
 
    // Second term is -x^3 / 6

    vmul.f32    term, x_sqr
    mov         r0, #6
    vmov        s3, r0
    vcvt.f32.s32 s3, s3
    vdiv.f32    term, term, s3
    vsub.f32    ret, term

    // Third term is x^5 / 120

    vmul.f32    term, x_sqr
    mov         r0, #20
    vmov        s3, r0
    vcvt.f32.s32 s3, s3
    vdiv.f32    term, term, s3
    vadd.f32    ret, term

    // Fourth term is -x^7 / 5040

    vmul.f32    term, x_sqr
    mov         r0, #42
    vmov        s3, r0
    vcvt.f32.s32 s3, s3
    vdiv.f32    term, term, s3
    vsub.f32    ret, term

    // Fifth term is x^9 / 362880

    vmul.f32    term, x_sqr
    mov         r0, #72
    vmov        s3, r0
    vcvt.f32.s32 s3, s3
    vdiv.f32    term, term, s3
    vadd.f32    ret, term

    bx          lr



// cosine: Compute the cosine of the floating point number stored in s0.
// Store the result in s0.
//
//  s0 . number x to take the cosine of
//
//  s0 < cosine(x)
//
// We will be implementing this as sin(s0 + pi/2). See the sine function
// above for the real computational work.

cosine:
    ldr         r0, =0b00111111110010010000111111011010 // pi/2
    vmov        s1, r0
    vadd.f32    s0, s0, s1
    b           sine            // Tail-chaining for efficiency
    
