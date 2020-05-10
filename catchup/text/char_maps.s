
// Exports

	.globl	CharacterMaps
	.globl	CharacterHeight

// Examples

//	01234567
//    0	........ 
//    1	.111111.	+ Non-descender sits with bottom on row A
//    2	.1......
//    3	.1......	+ Outer border of character is left empty
//    4	.1......
//    5	.11111..	+ 8 bits wide, 16 bits tall
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

//	01234567
//    0	........ 
//    1	........	+ Short character tops out at line 5
//    2	........
//    3	........
//    4	........
//    5	..1111..
//    6	.1....1.
//    7	.111111.
//    8	.1......
//    9	.1....1.
//    A	..1111..
//    B	........
//    C	........
//    D	........
//    E	........
//    F	........


	
// Character maps
	
	.section .data
	.align 	4
	
CharacterMaps:
	// 0 - Stripe (should basically never be displayed)
	.byte 0b11111111
	.byte 0b11111110
	.byte 0b11111100
	.byte 0b11111001
	.byte 0b11110011
	.byte 0b11100111
	.byte 0b11001111
	.byte 0b10011111
	.byte 0b00111111
	.byte 0b01111111
	.byte 0b11111111
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// ...31 unprintable characters...
	.zero 16 * 31
	
	// 32 - Space (empty)
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

	// 33 - Exclamation mark
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 34 - Double quote
	.byte 0b00000000
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00100100
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

	// 35 - Pound sign
	.byte 0b00000000
	.byte 0b00010010
	.byte 0b00010010
	.byte 0b01111110
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b01111110
	.byte 0b01001000
	.byte 0b01001000
	.byte 0b01001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 36 - Dollar sign
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00111100
	.byte 0b01001010
	.byte 0b01001000
	.byte 0b00111000
	.byte 0b00001100
	.byte 0b00001010
	.byte 0b00001010
	.byte 0b01001010
	.byte 0b00111100
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 37 - Percent sign
	.byte 0b00000000
	.byte 0b00000010
	.byte 0b01100110
	.byte 0b01101100
	.byte 0b00001100
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00110000
	.byte 0b00110110
	.byte 0b01100110
	.byte 0b01000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 38 - Ampersand
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00011000
	.byte 0b00101000
	.byte 0b00101010
	.byte 0b01000100
	.byte 0b01000100
	.byte 0b01001010
	.byte 0b00110010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 39 - Single quote
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
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

	// 40 - Left parenthesis
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 41 - Right parenthesis
	.byte 0b00000000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 42 - Asterisk
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00111100
	.byte 0b00011000
	.byte 0b00100100
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

	// 43 - Plus sign
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b01111100
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 44 - Comma
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
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00110000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 45 - Minus sign
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 46 - Period
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
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 47 - Forward slash
	.byte 0b00000000
	.byte 0b00000010
	.byte 0b00000110
	.byte 0b00000100
	.byte 0b00001100
	.byte 0b00001000
	.byte 0b00011000
	.byte 0b00010000
	.byte 0b00110000
	.byte 0b00100000
	.byte 0b01100000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// 48 - Digit 0
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01001010
	.byte 0b01010010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 49 - Digit 1
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

	// 50 - Digit 2
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

	// 51 - Digit 3
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

	// 52 - digit 4
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

	// 53 - Digit 5
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

	// 54 - Digit 6
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

	// 55 - Digit 7
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

	// 56 - Digit 8
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

	// 57 - Digit 9
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

	// 58 - Colon
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 59 - Semicolon
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 60 - Less-than sign
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000110
	.byte 0b00011000
	.byte 0b01100000
	.byte 0b01100000
	.byte 0b00011000
	.byte 0b00000110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 61 - Equals sign
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 62 - Greater-than sign
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01100000
	.byte 0b00011000
	.byte 0b00000110
	.byte 0b00000110
	.byte 0b00011000
	.byte 0b01100000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 63 - Question mark
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01100010
	.byte 0b01000010
	.byte 0b00000110
	.byte 0b00001100
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 64 - At symbol
	.byte 0b00000000
	.byte 0b00011100
	.byte 0b00100010
	.byte 0b01000010
	.byte 0b01001110
	.byte 0b01010010
	.byte 0b01010010
	.byte 0b01001100
	.byte 0b01000000
	.byte 0b00100010
	.byte 0b00011100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// 65 - Capital letter A
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

	// 66 - Capital letter B
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

	// 67 - Capital letter C
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
	
	// 68 - Capital letter D
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

	// 69 - Capital letter E
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
	
	// 70 - Capital letter F
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

	// 71 - Capital letter G
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01001100
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

	// 72 - Capital letter H
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111110
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 73 - Capital letter I
	.byte 0b00000000
	.byte 0b00111110
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 74 - Capital letter J
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b01001000
	.byte 0b00110000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 75 - Capital letter K
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000100
	.byte 0b01001000
	.byte 0b01010000
	.byte 0b01100000
	.byte 0b01100000
	.byte 0b01010000
	.byte 0b01001000
	.byte 0b01000100
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 76 - Capital letter L
	.byte 0b00000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
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

	// 77 - Capital letter M
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01100110
	.byte 0b01011010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 78 - Capital letter N
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01100010
	.byte 0b01100010
	.byte 0b01010010
	.byte 0b01010010
	.byte 0b01001010
	.byte 0b01001010
	.byte 0b01000110
	.byte 0b01000110
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 79 - Capital letter O
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

	// 80 - Capital letter P
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 81 - Capital letter Q
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01001010
	.byte 0b01001010
	.byte 0b01000100
	.byte 0b00111110
	.byte 0b00000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 82 - Capital letter R
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b01010000
	.byte 0b01001000
	.byte 0b01000100
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 83 - Capital letter S
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b00110000
	.byte 0b00001100
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 84 - Capital letter T
	.byte 0b00000000
	.byte 0b01111111
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 85 - Capital letter U
	.byte 0b00000000
	.byte 0b01000010
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

	// 86 - Capital letter V
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 87 - Capital letter W
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01011010
	.byte 0b01100110
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 88 - Capital letter X
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 89 - Capital letter Y
	.byte 0b00000000
	.byte 0b01000001
	.byte 0b00100010
	.byte 0b00100010
	.byte 0b00010100
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 90 - Capital letter Z
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000100
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 91 - Left bracket
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 92 - Backslash
	.byte 0b00000000
	.byte 0b01000000
	.byte 0b01100000
	.byte 0b00100000
	.byte 0b00110000
	.byte 0b00010000
	.byte 0b00011000
	.byte 0b00001000
	.byte 0b00001100
	.byte 0b00000100
	.byte 0b00000110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 93 - Right bracket
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 94 - Caret
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00010100
	.byte 0b00010100
	.byte 0b00100010
	.byte 0b00100010
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

	// 95 - Underscore
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
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 96 - Tick mark
	.byte 0b00000000
	.byte 0b00010000
	.byte 0b00001000
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

	// 97 - Lower case a
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 98 - Lower case b
	.byte 0b00000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01011100
	.byte 0b01100010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 99 - Lower case c
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 100 - Lower case d
	.byte 0b00000000
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00111010
	.byte 0b01000110
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 101 - Lower case e
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01111110
	.byte 0b01000000
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 102 - Lower case f
	.byte 0b00000000
	.byte 0b00001110
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b01111110
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 103 - Lower case g
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b00000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000

	// 104 - Lower case h
	.byte 0b00000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 105 - Lower case i
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 106 - Lower case j
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00011000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b10001000
	.byte 0b01110000
	.byte 0b00000000
	.byte 0b00000000

	// 107 - Lower case k
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000100
	.byte 0b01001000
	.byte 0b01010000
	.byte 0b01110000
	.byte 0b01001000
	.byte 0b01000100
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 108 - Lower case l
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00110000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b01111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 109 - Lower case m
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b01001001
	.byte 0b01001001
	.byte 0b01001001
	.byte 0b01001001
	.byte 0b01001001
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 110 - Lower case n
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 111 - Lower case o
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
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

	// 112 - Lower case p
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111100
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01111100
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b00000000

	// 113 - Lower case q
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111110
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00111110
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b00000000

	// 114 - Lower case r
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b01000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 115 - Lower case s
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00111100
	.byte 0b01000010
	.byte 0b00110000
	.byte 0b00001100
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 116 - Lower case t
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b01111100
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00001100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 117 - Lower case u
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
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

	// 118 - Lower case v
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00100100
	.byte 0b00011000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 119 - Lower case w
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01011010
	.byte 0b01100110
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 120 - Lower case x
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b00100100
	.byte 0b00011000
	.byte 0b00011000
	.byte 0b00100100
	.byte 0b01000010
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 121 - Lower case y
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b01000010
	.byte 0b00100010
	.byte 0b00011110
	.byte 0b00000010
	.byte 0b00000010
	.byte 0b01000010
	.byte 0b00111100
	.byte 0b00000000

	// 122 - Lower case z
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b01111110
	.byte 0b00000100
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b01111110
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 123 - Left brace
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00100000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00010000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 124 - Vertical pipe
	.byte 0b00000000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 125 - Right brace
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00010000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00000100
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00001000
	.byte 0b00010000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000

	// 125 - Tilda
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00110000
	.byte 0b01000010
	.byte 0b00001100
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	.byte 0b00000000
	
	// Unprintable char (DEL)
	.space 16

	// Extended ascii range
	.space 16 * 128

	
	
CharacterHeight:
	.int 16
