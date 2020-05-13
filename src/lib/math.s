
// Exports

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
    vmul.f32    s1, s1, s2      // s1 = nearest multiple of pi below s0
    vsub.f32    s0, s0, s1      // Subtract those multiples of pi

    // If we subtracted an odd number of pi's, reverse the sign of s0

    vmov        s1, #0b01000000000000000000000000000000 // 2
    vdiv.f32    s1, s2, s1      // s1 = s2 / 2
    vcvt.s32.f32 s2, s1         // s2 = [s2 / 2]
    vcmp.f32    s1, s2          // check if [s2 / 2] == s2 / 2
    vmrs        APSR_nzcv, FPSCR // copy fp compare flags to regular
    vmov        s1, #0b10111111100000000000000000000000 // -1
    vmulne.f32  s0, s1          // If not, multiply s0 by -1

    // Compute the Maclaurin sum

    ret     .req s0             // Starts off at x
    x_sqr   .req s1             // (value x^2)
    term    .req s2

    vmov        term, s0        // First term is x
    vmul.f32    x_sqr, s0, s0
 
    // Second term is -x^3 / 6

    vmul.f32    term, x_sqr
    ldr         r0, =0b01000001011000000000000000000000 // 6
    vmov        s3, r0
    vdiv.f32    term, term, s3
    vsub.f32    ret, term

    // Third term is x^5 / 120

    vmul.f32    term, x_sqr
    ldr         r0, =0b01000010010100000000000000000000 // 20
    vmov        s3, r0
    vdiv.f32    term, term, s3
    vadd.f32    ret, term

    // Fourth term is -x^7 / 5040

    vmul.f32    term, x_sqr
    ldr         r0, =0b01000010110101000000000000000000 // 42
    vmov        s3, r0
    vdiv.f32    term, term, s3
    vsub.f32    ret, term

    // Fifth term is x^9 / 362880

    vmul.f32    term, x_sqr
    ldr         r0, =0b01000011010010000000000000000000 // 72
    vmov        s3, r0
    vdiv.f32    term, term, s3
    vadd.f32    ret, term
