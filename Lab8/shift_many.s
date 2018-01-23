## struct Shifter {
##     unsigned int value;
##     unsigned int *to_rotate[4];
## };
##
##
## void
## shift_many(Shifter *s, int offset) {
##     for (int i = 0; i < 4; i++) {
##         unsigned int *ptr = s->to_rotate[i];
##
##         if (ptr == NULL) {
##             continue;
##         }
##
##         unsigned char x = (i + offset) & 3;
##         *ptr = circular_shift(s->value, x);
##     }
## }

#	   int	  int *	  int *   int *   int *
#	+ ----- + ----- + ----- + ----- + ----- +
#	| , , , | , , , | , , , | , , , | , , , |
#	+ ----- + ----- + ----- + ----- + ----- +
#	| , , , | , , , | , , , | , , , | , , , |
#	+ ----- + ----- + ----- + ----- + ----- +
#	 node_id  t_r[1]  t_r[1]  t_r[1]  t_r[1]
#	0	4	8	12	16	20

# s0: a0
# s1: a1
# s2: i
# s3: i*4
# s4: ptr
# s5:
# s6:
# s7:

.data

.text
SIZE4

.globl shift_many
shift_many:
    sub   $sp, $sp, 20
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)
    sw    $s1, 8($sp)
    sw    $s2, 12($sp)
    sw    $s3, 16($sp)

    move  $s0, $a0
    move  $s1, $a1

    move  $s2, $0

sm_for:
    bge   $s2, 4, sm_done

    mul   $t0, $s2, 4
    add   $t0, $t0, $s0
    lw    $s3, 4($t0)
    beq   $s3, $0, sm_cont

    lw    $a0, 0($s0)
    add   $a1, $s2, $s1
    and   $a1, $a1, 3
    jal   circular_shift
    sw    $v0, 0($s3)

sm_cont:
    add   $s2, $s2, 1
    j     sm_for

sm_done:
    lw    $ra, 0($sp)
    lw    $s0, 4($sp)
    lw    $s1, 8($sp)
    lw    $s2, 12($sp)
    lw    $s3, 16($sp)
    add   $sp, $sp, 20
    jr    $ra
