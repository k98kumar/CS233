## a code generator for the ALU chain in the 32-bit ALU
## see example_generator.py for inspiration
## 
## python generator.py

from __future__ import print_function

width = 32;
print("    alu1 al0(out[0], cout[0], A[0], B[0], control[0], control]);")
for i in range(1, width):
    print("    alu1 al%d(out[%d], cout[%d], A[%d], B[%d], cout[%d], control);" % (i, i, i, i, i, i-1))

print("    or o1(chain[1], out[0], out[1]);")
for j in range(2, width):
    print("    or or%d(chain[%d], out[%d], chain[%d]);" % (j, j, j-1))

print("    not n(zero, chain[31]);")
