#include <bitset>

/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned binary_11 = 0xAAAAAAAA;
unsigned binary_12 = 0x55555555;
unsigned binary_21 = 0xCCCCCCCC;
unsigned binary_22 = 0x33333333;
unsigned binary_31 = 0xF0F0F0F0;
unsigned binary_32 = 0x0F0F0F0F;
unsigned binary_41 = 0xFF00FF00;
unsigned binary_42 = 0x00FF00FF;
unsigned binary_51 = 0xFFFF0000;
unsigned binary_52 = 0x0000FFFF;

unsigned countOnes(unsigned input) {

	unsigned a = input & binary_11;
	unsigned b = input & binary_12;
	a >>= 1;
	input = a + b;
	
	a = input & binary_21;
	b = input & binary_22;
	a >>= 2;
	input = a + b;
	
	a = input & binary_31;
	b = input & binary_32;
	a >>= 4;
	input = a + b;
	
	a = input & binary_41;
	b = input & binary_42;
	a >>= 8;
	input = a + b;
	
	a = input & binary_51;
	b = input & binary_52;
	a >>= 16;
	return a + b;
	
	

	return input;
}
