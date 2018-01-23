# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

REQUEST_JETSTREAM	= 0xffff00dc
REQUEST_STARCOIN	= 0xffff00e0

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

REQUEST_STARCOIN_INT_MASK	= 0x4000
REQUEST_STARCOIN_ACK		= 0xffff00e4

.data
# put your data things here
event_horizon_data: .space 90000

# s0: map
# s1: outer y top
# s2: outer x left
# s3:
# s4:
# s5:
# s6:
# s7:

# t0:
# t1:
# t2:
# t3:
# t4:
# t5:
# t6: reserved for arctan
# t7: reserved for arctan
# t8: Bot X position
# t9: Bot Y position

.text

MID = 149
NEG360 = -360
NEG270 = -270
NEG180 = -180
NEG90 = -90
ANGLE0 = 0
POS90 = 90
POS180 = 180
POS270 = 270
POS360 = 360
ABSOLUTE = 1
POS_MAX_VEL = 10
POS_MIN_VEL = 1
NEG_MIN_VEL = -1
NEG_MAX_VEL = -10

main:
	# put your code here :)

	sub	$sp,	$sp,	36
	sw	$s0,	0($sp)		# store current data in register
	sw	$s1,	4($sp)		#	|	|	|
	sw	$s2,	8($sp)		#	|	|	|
	sw	$s3,	12($sp)		#	|	|	|
	sw	$s4,	16($sp)		#	|	|	|
	sw	$s5,	20($sp)		#	|	|	|
	sw	$s6,	24($sp)		#	|	|	|
	sw	$s7,	28($sp)		#	V	V	V
	sw	$ra,	32($sp)		# store current data in register

	la	$s0,	event_horizon_data
	sw	$s0,	REQUEST_JETSTREAM

	#li	$t4, BONK_MASK		# timer interrupt enable bit
	#or	$t4, $t4, 1		# global interrupt enable
	#mtc0	$t4, $12		# set interrupt mask (Status register)

	li      $t7,	1
	sw	$t7,	VELOCITY

        mult    $s1,    150,    300
        add     $s1,    $s1,    1
        add     $s1,    $s1,    $s0
        li      $s2,    150

        move    $t1,    $zero
        move    $t2,    $zero

        j       y_axis

y_axis:
        lw      $t0,    0($s1)
        bge     $t0,    2,      set_y_diam
        add     $s1,    $s1,    1
        add     $t1,    $t1,    1

set_y_diam:
        sub     $s1,    150,    $t1
        j       x_axis

x_axis:
        lw      $t0,    0($s2)
        bge     $t0,    2,      set_x_diam
        add     $s2,    $s2,    300
        add     $t2,    $t2,    1

set_x_diam:
        sub     $s2,    150,    $t1
        j       start

start:




deriv:


check_quad: # checks which quadrant bot is in
        li      $t7,	0
        sw	$t7,	VELOCITY
        lw	$t8,	BOT_X
        lw	$t9,	BOT_Y
        ble	$t8,	MID,	quad_23
        j	quad_14

quad_23:
        ble	$t9,	MID,	quad_2
        j	quad_3

quad_14:
        ble	$t9,	MID,	quad_1
        j	quad_4

quad_1:
        sub     $a0,    299,    $s2
        li      $a1,    150
        j       angle_together

quad_2:
        li      $a0,    150
        li      $a1,    $s1
        j       angle_together

quad_3:
        li      $a0,    $s2
        li      $a1,    150
        j       angle_together

quad_4:
        li      $a0,    150
        sub     $a1,    299,    $s1
        j       angle_together

angle_together:
        sub     $a0,    $t8,    $a0
        sub     $a1,    $t9,    $a1
        jal     sb_arctan
        sw 	$v0,	ANGLE
	li      $v0,	ABSOLUTE
	sw	$v0,	ANGLE_CONTROL
        li      $v0,	3
        sw	$v0,	VELOCITY
        j       check_until

check_until: # checks which quadrant bot is in
        ble	$t8,	MID,	until_23
        j	until_14

quad_23:
        ble	$t9,	MID,	until_2
        j	until_3

quad_14:
        ble	$t9,	MID,	until_1
        j	until_4

until_1:
        lw	$t9,	BOT_Y
        bne     $t9,    150,    until_1
        j       start

until_2:
        lw	$t8,	BOT_X
        bne     $t9,    150,    until_2
        j       start

until_3:
        lw	$t9,	BOT_Y
        bne     $t9,    150,    until_3
        j       start

until_4:
        lw	$t8,	BOT_X
        bne     $t9,    150,    until_4
        j       start


loop_again:
	j	check_quad

	lw	$s0,	0($sp)
	lw	$s1,	4($sp)
	lw	$s2,	8($sp)
	lw	$s3,	12($sp)
	lw	$s4,	16($sp)
	lw	$s5,	20($sp)
	lw	$s6,	24($sp)
	lw	$s7,	28($sp)
	lw	$ra,	32($sp)
	add	$sp,	$sp,	36

# -----------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# returns the arctangent
# v0
# t0 t1
# a0 a1
# f0 f1 f2 f3 f4 f5 f6 f7 f8
# -----------------------------------------------------------------------

sb_arctan:
	li	$v0, 0		# angle = 0;

	abs	$t0, $a0	# get absolute values
	abs	$t1, $a1
	ble	$t1, $t0, no_TURN_90

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t0, $a1	# int temp = y;
	neg	$a1, $a0	# y = -x;
	move	$a0, $t0	# x = temp;
	li	$v0, 90		# angle = 90;

no_TURN_90:
	bgez	$a0, pos_x 	# skip if (x >= 0)

	## if (x < 0)
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1

	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three	# load 3.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five	# load 5.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t0, $f6
	add	$v0, $v0, $t0	# angle += delta

	jr 	$ra
