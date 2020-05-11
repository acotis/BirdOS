
// Imports

    .globl  draw_string

// Exports

    .globl  draw_textline

// Data
    
    .section .data
    .align  2

Offset:
    .int    4   // x-offset of first row of text
    .int    4   // y-offset of rirst row of text

LineWidth:
    .int    79  // Number of characters per line

LineBuffer:
    .zero   81  // Buffer for up to a single screen-line of text
    
    
// Code

    .section .text
    .align 2
    
// draw_textline_nowrap: draw a string located at r0 on row r1 and column
// r2 using colors r3. Line wrapping not supported by this method. This
// method is a convenience method built on top of <draw_string>, which 
// does the same thing but needs pixel coordinates instead of character
// coordinates.
//
//  r0 . address of null-terminated string to draw
//  r1 . row to start on
//  r2 . column to start on
//  r3 . bg color (top 16 bits) and fg color (bottom 16 bits)
    
draw_textline_nowrap:   
    push    {r4, r5, lr}

    ldr     r5, =Offset
    ldr     r4, [r5]            // r4 . x-offset of first row
    ldr     r5, [r5, #4]        // r5 . y-offset of first row
    
    lsl     r2, #3              // (character width is always 8)
    add     r2, r4              // r2 . x-offset of text

    ldr     r4, =CharacterHeight
    ldr     r4, [r4]            // r4 . character height
    mul     r1, r4          
    add     r1, r5              // r1 . y-offset of text
    
    mov     r4, r1              // Swap r1 and r2 (xy vs rc)
    mov     r1, r2
    mov     r2, r4

    bl      draw_string
    pop     {r4, r5, pc}

// draw_textline: draw a string located at r0 on row r1 and column r2 with
// colors r3. If necessary, wrap the line intelligently to the next row
// and start back at column 0.  
//
//  r0 . location of the string to draw
//  r1 . row to start on
//  r2 . column to start on
//  r3 . bg color (top 16 bits) and fg color (bottom 16 bits)
//
// Return the row and column directly after that of the last character,
// wrapping to a new line if necessary.
//  
//  r0 < row of next character slot
//  r1 < column of next character slot
    
draw_textline:
    push    {r4, r5, r6, r7, r8, lr}

    // Copy one line of text to the line buffer

    mov     r4, r0              // r4 . location of string to draw
    mov     r6, #0              // r6 . found null char yet?
    
dt_buffer_loop$:
    ldr     r5, =LineBuffer     // r5 . address of line buffer

    ldr     r7, =LineWidth      // r7 . number of characters to copy
    ldr     r7, [r7]
    sub     r7, r2

    mov     r8, r2              // r8 . copy of current column
    
dt_charcopy_loop$:
    ldrb    r0, [r4], #1        // r0 = next char to copy
    strb    r0, [r5]
    
    cmp     r0, #0              // If null char, set flag and flush
    moveq   r6, #1
    beq     dt_flush_buffer$

    cmp     r0, #10             // If newline character, write a null
    moveq   r0, #0              // character and flush
    strb    r0, [r5]
    beq     dt_flush_buffer$        
    
    subs    r7, #1              // If the buffer is full, flush
    beq     dt_flush_buffer$

    add     r5, #1              // Else, march forward in buffer,
    add     r8, #1              // increment the column copy, and
    b       dt_charcopy_loop$   // loop back to charcopy 
    
dt_flush_buffer$:
    push    {r1, r2, r3}
    ldr     r0, =LineBuffer     // Draw the line buffer to the screen
    bl      draw_textline_nowrap
    pop     {r1, r2, r3}
    
    cmp     r6, #0              // If r10 (found null char) not set,
    addeq   r1, #1              // increment row, go to first col,
    moveq   r2, #0              // and loop back around.
    beq     dt_buffer_loop$

    // Otherwise, don't modify the row and column. They represent the
    // screen coordinates where the null character would have been
    // printed, which is exactly the next available character slot
    // *including wrapping to the next line if necessary* (I'm a genius,
    // aren't I?)

    mov     r0, r1              // Return row and column
    mov     r1, r8              // (Use column tracker from before)

    pop     {r4, r5, r6, r7, r8, pc}
