#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    int inc = 32;
    /*
    for (int i = 0; i < SIZE; i ++) {
        for (int j = 0; j < SIZE; j ++) {
            dest[i][j] = src[j][i];
        }
    }
    */
    /*
    for (int i = 0; i < SIZE; i += inc) {
        for (int j = 0; j < SIZE; j ++) {
            // int lower = ((i + 16) < SIZE) ? (i + 16) : SIZE;
            // int lower = std::min(i + 16, SIZE);
            for (int x = i; x < std::min(i + inc, SIZE); x ++) {
                dest[j][x] = src[x][j];
            }
        }
    }
    */

    for (int i = 0; i < SIZE; i += inc) {
        for (int j = 0; j < SIZE; j += inc) {
            for (int x = i; x < min(i + inc, SIZE); x ++) {
                for (int y = j; y < min(j + inc, SIZE); y ++) {
                    dest[x][y] = src[y][x];
                }
            }
        }
    }


}
