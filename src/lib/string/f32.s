
// Exports

    .globl  f32_to_str_binary
    .globl  f32_to_str_decimal

// Imports

    .globl  uint_to_str_cbase       // Library: string/int
    .globl  int_to_str_cbase
    
    .globl  break_float             // Library: math

// Code

// f32_to_str_binary: Convert a 32-bit floating point number into a
// string of the form 1.----e----- (sci notation, base 2). 
//
//  r0 . the address to store the result-string at
//  s0 . the 32-bit float to convert

f32_to_str_binary:
    push    {r4, r5, lr}

    address .req r4
    value   .req r5

    mov     address, r0
    vmov     value, s0

    tst     value, #0x80000000          // If value is negative,
    beq     ftsb_notneg$

    bic     value, #0x80000000          //   make it positive,
    mov     r0, #45                     //   and put a minus sign in.
    strb    r0, [address], #1

ftsb_notneg$:

    add     r0, address, #1             // Print mantissa
    bic     r1, value, #0xFF000000
    orr     r1, #0x00800000
    mov     r2, #2
    bl      uint_to_str_cbase

    mov     r0, #49                     // Replace beginning with "1."
    strb    r0, [address]
    mov     r0, #46
    strb    r0, [address, #1]

    add     address, #25                // Go to end of string
    mov     r0, #101                    // Write an "e"
    strb    r0, [address], #1

    lsr     value, #23                  // Extract exponent
    sub     value, #127

    mov     r0, address                 // Print exponent
    mov     r1, value
    mov     r2, #2
    bl      int_to_str_cbase
    
    pop     {r4, r5, pc}

    .unreq  address
    .unreq  value


// f32_to_str_decimal: Convert a 32-bit float into a string of the form
// -.------e--. Use exactly 7 sigfigs.
//
//  r0 . the address to store the result-string at
//  s0 . the 32-bit float to convert

f32_to_str_decimal:
    push            {r4, lr}
    mov             r4, r0

    bl              break_float             // Get components

    // If it's negative, put an equals sign and make it positive.

    cmp             r1, #0                  // If positive,
    beq             ftsd_notneg$            //   skip this part

    mov             r1, #45                 // Else:
    strb            r1, [r4], #1            //   put a negative sign
    vneg.f32        s0, s0                  //   and make it positive

    // The state of the registers is now:
    //
    //   r0 . type of float (normal, subnormal, zero, inf, nan)
    //   r1 . scratch
    //   r2 . expt or payload of float as applicable
    //   r3 . mantissa of float if applicable
    //   r4 . address to store the string at

ftsd_notneg$:
    cmp             r0, #0                  // If it's normal, jump to the
    beq             ftsd_normal$            //   main method

    cmp             r0, #1                  // If it's subnormal, jump to
    beq             ftsd_subnormal$         //   the subnormal handler

    cmp             r0, #2                  // If it's zero, jump to the
    beq             ftsd_zero$              //   zero handler
    
    cmp             r0, #3                  // If it's inf, jump to the
    beq             ftsd_inf$               //   inf handler

    mov             r1, #'N'                // Else, write "NaN" and ret
    strb            r1, [r4], #1
    mov             r1, #'a'
    strb            r1, [r4], #1
    mov             r1, #'N'
    strb            r1, [r4], #1
    mov             r1, #0
    strb            r1, [r4], #1
    pop             {r4, pc}

ftsd_subnormal$:
    mov             r1, #'s'                // Write "subnormal" and ret
    strb            r1, [r4], #1
    mov             r1, #'u'
    strb            r1, [r4], #1
    mov             r1, #'b'
    strb            r1, [r4], #1
    mov             r1, #'n'
    strb            r1, [r4], #1
    mov             r1, #'o'
    strb            r1, [r4], #1
    mov             r1, #'r'
    strb            r1, [r4], #1
    mov             r1, #'m'
    strb            r1, [r4], #1
    mov             r1, #'a'
    strb            r1, [r4], #1
    mov             r1, #'l'
    strb            r1, [r4], #1
    mov             r1, #0
    strb            r1, [r4], #1
    pop             {r4, pc}

ftsd_zero$:
    mov             r1, #'0'
    strb            r1, [r4], #1
    mov             r1, #0
    strb            r1, [r4], #1
    pop             {r4, pc}

ftsd_inf$:
    mov             r1, #'I'
    strb            r1, [r4], #1
    mov             r1, #'n'
    strb            r1, [r4], #1
    mov             r1, #'f'
    strb            r1, [r4], #1
    mov             r1, #0
    strb            r1, [r4], #1
    pop             {r4, pc}

ftsd_normal$:
    address     .req r4
    expt        .req r1
    dig_count   .req r2
    value       .req s0
    place_val   .req s1
    next_pv     .req s2
    ten         .req s3

    mov             expt, #0                // expt = 0

    mov             r3, #1                  // place_val = 1
    vmov            place_val, r3           
    vcvt.f32.s32    place_val, place_val

    mov             r3, #10                 // ten = 10
    vmov            ten, r3                 
    vcvt.f32.s32    ten, ten

    // We need the largest multiple of 10 which is smaller than value.
    // So, first ascend powers of 10 until you cannot go higher, then
    // descend until you needn't go lower. This will yield the desired
    // power.

ftsd_rising_loop$:
    vmul.f32        next_pv, place_val, ten // if next_place_val > value:
    vcmp.f32        next_pv, value
    vmrs            APSR_nzcv, FPSCR
    bgt             ftsd_falling_loop$      //   break

    vmov            place_val, next_pv      // else, ascend one power
    add             expt, #1
    b               ftsd_rising_loop$       //   and loop

ftsd_falling_loop$:
    vcmp.f32        place_val, value        // if place_val <= value:
    vmrs            APSR_nzcv, FPSCR
    ble             ftsd_print$             //   break

    vdiv.f32        place_val, place_val, ten // else, descend one power
    sub             expt, #1
    b               ftsd_falling_loop$      //   and loop

ftsd_print$:
    mov             dig_count, #0

    .unreq      next_pv
    digit       .req s2

ftsd_mant_loop$:
    vdiv.f32        digit, value, place_val // get next digit
    vcvt.s32.f32    digit, digit
    vmov            r3, digit
    add             r3, #48                 // add ascii '0'
    strb            r3, [address], #1       // store digit

    cmp             dig_count, #0           // if this is first digit:
    bne             ftsd_not_first$
    mov             r3, #46                 //   store a decimal point
    strb            r3, [address], #1

ftsd_not_first$:
    cmp             dig_count, #6           // if done:
    beq             ftsd_expt$              //    break

    add             dig_count, #1           // else, add one to count,

    vcvt.f32.s32    digit, digit            //   subtract from value,
    vmul.f32        digit, place_val
    vsub.f32        value, digit
    vdiv.f32        place_val, place_val, ten //   go to next place val,

    b               ftsd_mant_loop$         //   and loop

ftsd_expt$:
    mov             r3, #101
    strb            r3, [address], #1

    // Address and expt are already in r0 and r1, so we can just jump
    // to int_to_str_cbase after specifing base 10. And yes, we pop *lr*
    // and not pc because of the tail-chain call.

    mov             r0, address
    pop             {r4, lr}
    mov             r2, #10
    b               int_to_str_cbase

    .unreq      address
    .unreq      expt
    .unreq      dig_count
    .unreq      value
    .unreq      place_val
    .unreq      digit
    .unreq      ten
