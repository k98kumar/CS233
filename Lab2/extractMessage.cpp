/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <string>
#include <bitset>
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    char *message_out = new char[length];

    // TODO: write your code here
    string concatenation = "";
    string binary_string = "";
    for (int i = 0; i <= length; i+=8) {
        for (int j = 7; j >= 0; j--) {
	    binary_string = "";
	    for (int k = i + 7; k >= i; k--) {
                bitset<8> bit_set(message_in[k]);
                string each_number = bit_set.to_string();
                binary_string += each_number[j];
	    }
	    bitset<8> bin_to_dec(binary_string);
	    int conversion = bin_to_dec.to_ulong();
	    // char letter = (char)conversion;
	    // cout << letter << endl;
	    message_out[i+(7-j)] = conversion;
	}
    }
    
    /*for (int i = 0; i <= length; i += 8) {
        for (int j = i; j <= i + 8; j ++) {
            message_out[j] = message_in
	    for (int k = 7; k >= 0; k --) {
	        message_out[j] += 
	    }
        }
    }*/
    
    return message_out;
}
