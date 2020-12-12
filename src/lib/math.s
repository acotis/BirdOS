
// Exports
    
    .globl  sine
    .globl  cosine

    .globl  break_float

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
    

// break_float: Split a floating point number into its component parts.
//
//  s0 . floating point to split
//
//  r0 < type: 0 (normal), 1 (subnormal), 2 (zero), 3 (inf), 4 (NaN)
//  r1 < sign
//  r2 < exponent if applicable, payload for NaN
//  r3 < mantissa if applicable
//
// Nota bene: the mantissa will always include the leading 1 and will
// always be 24 bits long, regardless of whether the float is normal or
// subnormal.

break_float:
    sign        .req r1
    expt        .req r2
    mantissa    .req r3

    vmov    r0, s0
    lsr     sign, r0, #31       // Extract the parts
    lsl     expt, r0, #1
    lsr     expt, #24
    lsl     mantissa, r0, #9
    lsr     mantissa, #9

    // If necessary, we can speed up the common case (normal) by one
    // instruction by doing cmn followed immediately with cmpne, then
    // re-checking the Inf/NaN case later.

    add     r0, expt, #1        // If expt is all ones, it's Inf or NaN
    cmp     r0, #256
    beq     bf_inf_or_nan$

    cmp     expt, #0            // If expt not all zeros, it's normal
    movne   r0, #0
    subne   r2, expt, #127
    orrne   r3, mantissa, #0x00800000
    movne   pc, lr

    cmp     mantissa, #0        // If mantissa all zeros, it's zero
    moveq   r0, #2
    moveq   pc, lr

    sub     expt, #127          // Else, it's subnormal
    clz     r0, mantissa
    sub     r0, #9
    sub     expt, r0
    lsl     mantissa, r0
    lsl     mantissa, #1

    mov     r0, #1
    mov     pc, lr

bf_inf_or_nan$:
    cmp     mantissa, #0        // If mantissa is zero, it's Inf
    moveq   r0, #3
    moveq   pc, lr

    mov     r0, #4              // Else, it's NaN
    mov     r2, mantissa
    mov     pc, lr
    
