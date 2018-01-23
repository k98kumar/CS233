// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator

#include <cstdio>
using std::printf;

int
main() {
    int width = 32;
    printf("    alu1 al0(out[0], cout[0], A[0], B[0], control[0], control]);\n");

    for (int i = 1; i < width; i ++) {
        printf("    alu1 al%d(out[%d], cout[%d], A[%d], B[%d], cout[%d], control);\n", i, i, i, i, i, i-1);
    }

    printf("\n    or or1(chain[1], out[0], out[1]);\n");

    for (int j = 2; j < width; j ++) {
        printf("    or or%d(chain[%d], out[%d], chain[%d]);\n", j, j, j, j-1);
    }
}
