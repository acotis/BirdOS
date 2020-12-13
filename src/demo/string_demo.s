
// Exports

    .globl  StringDemo

// Imports

    .globl  print               // Library: text
    .globl  newline
    .globl  tab_to
    .globl  set_cursor

    .globl  uint_to_str_cbase   // Library: string/int
    .globl  uint_to_str
    .globl  int_to_str_cbase
    .globl  int_to_str

    .globl  f32_to_str_binary   // Library: string/f32
    .globl  f32_to_str_decimal

    .globl  break_float         // Library: math (temporary)

// Data

.section .data
.align 2

NumString:
    .space  100

.align 2

Floats:
    .word   0b00111111100000000000000000000000
    .word   0b10111111100000000000000000000000
    .word   0b01111111100000000000000000000000
    .word   0b11111111100000000000000000000000
    .word   0b00000000000000000000000000000001
    .word   0b10000000000000000000000000000001
    .word   0b00000000000000000000000000000000
    .word   0b10000000000000000000000000000000
    .word   0b01111111011111111111111111111111
    .word   0b11111111011111111111111111111111
    .word   0b01111111100000000000010000000000
    .word   0b11111111111111111111111111111110
    .word   0b11111111100000000000000000000001
    .word   0b01000000010010010000111111011011
    .word   3

Descriptions:
    .asciz  "Number 1"
    .asciz  "Number -1"
    .asciz  "Positive infinity"
    .asciz  "Negative infinity"
    .asciz  "Smallest positive number (subnormal)"
    .asciz  "Largest negative number (subnormal)"
    .asciz  "Positive zero"
    .asciz  "Negative zero"
    .asciz  "Largest finite number"
    .asciz  "Smallest finite number"
    .asciz  "Positive NaN"
    .asciz  "Negative NaN"
    .asciz  "Another negative NaN"
    .asciz  "Pi"
    

// Code

.section .text
.align 4


// column_count: Loop from r0 to r1 printing numbers in base r2 in a
// vertical row left-aligned to column r3. Values for r2:
//
//      1:  uint_to_str
//      -1: int_to_str
//      n:  uint_to_str_cbase (base = n)
//      -n: int_to_str_cbase (base = n)
//
//  r0 . smallest number
//  r1 . largest number
//  r2 . base (or special value)
//  r3 . column of alignment

column_count:
    push    {r4, r5, r6, r7, lr}

    num     .req r4
    max     .req r5
    base    .req r6
    column  .req r7

    mov     num, r0                 // Move args to preserved registers
    mov     max, r1
    mov     base, r2
    mov     column, r3

    mov     r0, #0                  // Reset cursor to (0, 0)
    mov     r1, #0
    bl      set_cursor

cc_loop$:
    ldr     r0, =NumString          // Load up arguments
    mov     r1, num
    mov     r2, base

    cmp     r2, #1                  // If r2 = 1, call uint_to_str
    beq     cc_uint$
    cmp     r2, #-1                 // If r2 = -1, call int_to_str
    beq     cc_int$
    cmp     r2, #0                  // If r2 > 0, call uint_to_str_cbase
    bgt     cc_uint_cbase$
    b       cc_int_cbase$           // Else, call int_to_str_cbase

cc_uint$:
    bl      uint_to_str
    b       cc_print$

cc_int$:
    bl      int_to_str
    b       cc_print$

cc_uint_cbase$:
    bl      uint_to_str_cbase
    b       cc_print$

cc_int_cbase$:
    neg     r2, r2                  // Else, call int_to_str_cbase
    bl      int_to_str_cbase

cc_print$:
    mov     r0, column
    bl      tab_to

    ldr     r0, =NumString
    ldr     r1, =0x0000FFFF
    bl      print
    bl      newline

    cmp     num, max                // If done, return
    popeq   {r4, r5, r6, r7, pc}

    add     num, #1                 // Else, tick counter and loop
    b       cc_loop$                
    

StringDemo:
    push    {r4, r5, lr}

    // Test conversion from ints/uints to string.

    mov     r0, #0                  // base 10 uint: 0 to 40
    mov     r1, #40
    mov     r2, #10
    mov     r3, #0
    bl      column_count

    mov     r0, #-20                // base 10 int: -20 to 20
    mov     r1, #20
    mov     r2, #-10
    mov     r3, #4
    bl      column_count

    ldr     r0, = 2147483630        // base 16 int: large numbers
    ldr     r1, =-2147483630
    mov     r2, #-1
    mov     r3, #9
    bl      column_count

    mov     r0, #-8                 // base 2 int: -8 to 17
    mov     r1, #17
    mov     r2, #-2
    mov     r3, #20
    bl      column_count

    mov     r0, #-3                 // base 16 uint: -3 to 37
    mov     r1, #37
    mov     r2, #1
    mov     r3, #27
    bl      column_count

    // Test converstion from f32's to strings.

    mov     r0, #0
    mov     r1, #0
    bl      set_cursor

    ldr     r4, =Floats
    ldr     r5, =Descriptions
sd_floats_loop$:
    ldr     r0, [r4]                // Load value just to see if it's 3
    teq     r0, #3
    beq     sd_floats_end$

    mov     r0, #40                 // Tab to column 40
    bl      tab_to

    // Here follows a stupid hack designed to print the value as-is such
    // that it has width 32 even if it begins with leading zeros.

    ldr     r0, =NumString          // Print number with artificial 1 at
    ldr     r1, [r4]                //   the front of it
    orr     r1, #0x80000000
    mov     r2, #2
    bl      uint_to_str_cbase

    ldr     r0, =NumString          // If the number really began with 1:
    ldr     r1, [r4]
    tst     r1, #0x80000000
    bne     sd_float_print$         //   go to print

    mov     r1, #48                 // Else, put a 0 at the front of the
    strb    r1, [r0]                //   string

sd_float_print$:
    ldr     r0, =NumString
    ldr     r1, =0x000007ff
    bl      print

    // Print the expt part again in darker blue.

    mov     r0, #41                 // Tab to column 41
    bl      tab_to

    ldr     r0, =NumString          // Put a null terminator after the
    mov     r1, #0                  //   exponent part
    strb    r1, [r0, #9]

    add     r0, #1                  // Print beginning at the expt part
    ldr     r1, =0x0000033f
    bl      print

    // Print out the decimal version of the float.

    ldr     r0, =NumString          // Convert to string
    ldr     r1, [r4]
    vmov    s0, r1
    bl      f32_to_str_decimal

    mov     r0, #74                 // Tab to column 74
    bl      tab_to

    ldr     r0, =NumString          // Print it in yellow
    ldr     r1, =0x0000ffc0
    bl      print

    // Print out the verb description of this number.

    mov     r0, #88                 // Tab to column 88
    bl      tab_to

    mov     r0, r5                  // Print description in green
    ldr     r1, =0x000007c0
    bl      print

    // Tick the loop.

    bl      newline                 // Print a newline
    add     r4, #4                  // Go to next float

sd_desc_incr$:                      // Get next description
    ldrb    r0, [r5], #1
    cmp     r0, #0
    bne     sd_desc_incr$

    b       sd_floats_loop$

sd_floats_end$:
    pop     {r4, r5, pc}

