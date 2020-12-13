
// Exports

.globl  MathDemo

// Imports

.globl  uint_to_str         // Library: string/int
.globl  uint_to_str_cbase
.globl  int_to_str
.globl  int_to_str_cbase

.globl  print               // Library: text/cursor
.globl  newline

.globl  break_float         // Library: math
.globl  log

// Data

.section .data
.align 4

String:
    .space 100

// Code

.section .text
.align 4

MathDemo:
    push    {r4, r5, r6, lr}

    ldr     r0, =0b01000000000000000000000000000000
    mov     r0, #5
    vmov    s0, r0
    vcvt.f32.s32 s0, s0
    bl      log

    ldr     r0, =String
    bl      f32_to_str_decimal

    ldr     r0, =String
    ldr     r1, =0x0000f000
    bl      print

    pop     {r4, r5, r6, pc}
    

    sign    .req r4
    expt    .req r5
    mant    .req r6

    ldr     r0, =0b01000000000000000000000000000000
    vmov    s0, r0
    bl      break_float

    mov     sign, r1
    mov     expt, r2
    mov     mant, r3

    mov     r1, r0              // Convert type
    ldr     r0, =String
    bl      uint_to_str

    ldr     r0, =String         // Print type
    ldr     r1, =0x0000f000
    bl      print

    ldr     r0, =String         // Convert sign
    mov     r1, sign
    bl      uint_to_str

    ldr     r0, =String
    ldr     r1, =0x0000257D     // Print sign
    bl      print

    ldr     r0, =String         // Convert expt
    mov     r1, expt
    mov     r2, #10
    bl      int_to_str_cbase

    ldr     r0, =String         // Print expt
    ldr     r1, =0x0000f000
    bl      print

    ldr     r0, =String         // Convert mantissa
    mov     r1, mant
    mov     r2, #2
    bl      uint_to_str_cbase

    ldr     r0, =String
    ldr     r1, =0x0000257D     // Print mantissa
    bl      print

    pop     {r4, r5, r6, pc}
