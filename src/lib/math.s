
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


// Here follow the conversions between floating points and integers.
// Reminder: a 32-bit float has the following structure:
//
//      0b 0 10000001 10001010010111000000110
//         |     |               |
//       sign exponent        mantissa
//
// The exponent field is "biased" in the sense that a value of N for the
// exponent field translates to an exponent of N-127. The value of the
// float is:
//
//      (-1)^sign * 2^(exponent-127) * 1.(bits of mantissa)
//
// This makes the necessary computation fairly easy to see: simply append
// the bits of the mantissa to a 1 on the left, then shift by the value
// (exponent - 127 - 23), then multiply by -1 if necessary. Since the
// recovered mantissa always begins with a 1, this will occur exactly when 
// the recovered exponent is more than 7.


// f32_to_int: convert the float in s0 to a signed int in r0. Round toward
// zero. In the event of overflow, return zero.
//
//  s0 . the float to convert to an int
//
// Return:
//
//  r0 < the integer value of the float
//

f32_to_int:
    value       .req r0
    exponent    .req r1

    vmov    value, s0
    ldr     r2, =0x007FFFFF         // Mask for the mantissa
    and     value, r2               // Extract the mantissa
    orr     value, #0x00800000      // Add the extra bit

    vmov    exponent, s0
    ldr     r2, =0x7FE00000         // Mask for the raw exponent
    and     exponent, r2            // Extract the raw exponent
    lsr     exponent, #23           // Get rid of the zeros on the right
    sub     exponent, #150          // Convert to shift value

    cmp     exponent, #7            // If shift > 7, overflow will
    movgt   r0, #0                  // occur, so return 0
    bxgt    lr

    cmp     exponent, #0            // Apply exponential shift...
    lslgt   value, exponent         //   left for positive exponent
    rsblt   exponent, #0            //   right for negative exponent
    lsrlt   value, exponent

    vmov    r1, s0
    tst     r1, #0x80000000         // Extract the sign
    rsbne   r0, #0                  // If sign bit is 1, negate r0

    bx      lr


// int_to_f32: Convert a signed integer to a floating point number. 
// Precision may be lost, but there is no risk of overflow.
//
//  r0 . the integer to convert
//
// Returns:
//
//  s0 < that integer as a floating point

int_to_f32:
    sign    .req r1
    expt    .req r2
    
    cmp     r0, #0              // Extract the sign of r0
    movge   sign, #0            // Create the sign bit already in the
    movlt   sign, #0x80000000   //   correct position
    rsblt   r0, #0              // Purge the sign from r0

    clz     expt, r0            // Leading zeros of r0
    lsl     r0, expt            // (Cut the leading 0's out)
    lsl     r0, #1
    lsr     r0, #9              // Move the mantissa into position

    rsb     expt, #31           // True exponent (shift factor)
    add     expt, #127          // Raw exponent
    lsl     expt, #23           // Move the exponent into position

    orr     expt, sign          // ORR all the components together and
    orr     r0, expt            // return
    vmov    s0, r0

    bx      lr
