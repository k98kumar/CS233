#include "declarations.h"

void
t4(float M1[LEN4][LEN4], float M2[LEN4][LEN4], float M3[LEN4][LEN4]) {
    for (int nl = 0; nl < ntimes / (10 * LEN4); nl ++) {
        for (int i = 0; i < LEN4; i ++) {
            #pragma clang loop vectorize_width(4)
            for (int j = 0; j < LEN4; j ++) {
                #pragma clang loop vectorize_width(4)
                for (int k = 0; k < LEN4; k ++) {
                    M3[i][k] += M1[i][j] * M2[j][k];
                }
            }
        }
        M3[0][0] ++;
    }
}
