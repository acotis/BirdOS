
// Exports

	.globl	CharacterMaps
	.globl	CharacterHeight

// Example

//	01234567
//    0	........ 
//    1	.111111.	+ Non-descender sits with bottom on row A
//    2	.1......
//    3	.1......	+ Outer border of character is left empty
//    4	.1......
//    5	.11111..
//    6	.1......
//    7	.1......
//    8	.1......
//    9	.1......
//    A	.111111.
//    B	........
//    C	........
//    D	........
//    E	........
//    F	........

	
// Character maps
	
	.section .data
	.align 	4
	
CharacterMaps:
	// 0 - Stripe
	.byte 0b11111111
	.byte 0b11111110
	.byte 0b11111100
	.byte 0b11111000
	.byte 0b11110001
	.byte 0b11100011
	.byte 0b11000111
	.byte 0b10001111
	.byte 0b00011111
	.byte 0b00111111
	.byte 0b01111111
	.byte 0b11111111
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 1 - Empty
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// 2 - Digit 0
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 3 - Digit 1
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00101000
	.byte 0b01001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 4 - Digit 2
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000100
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b01000000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 5 - Digit 3
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00001100
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 6 - digit 4
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111110
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 7 - Digit 5
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111100
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 8 - Digit 6
	.byte 0b00000000
	.byte 0b00011110
	.byte 0b00100000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 9 - Digit 7
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b00000010
	.byte 0b00000100
	.byte 0b00000100
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b00100000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 10 - Digit 8
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 11 - Digit 9
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 12 - Letter A
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111110
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 13 - Letter B
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 14 - Letter C
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// 15 - Letter D
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 16 - Letter E
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111100
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// 7 - Letter F
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111100
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
		

CharacterHeight:
	.int 16
