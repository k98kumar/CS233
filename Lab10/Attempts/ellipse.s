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
three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0
SPACE:  .asciiz " "
NEWLINE: .asciiz "\n"
OPEN:	.asciiz "("
CLOSE:	.asciiz ")"
COMMA:	.asciiz ","

# s0: map
# s1: outer y top
# s2: outer x left
# s3: Bot X position
# s4: Bot Y position
# s5:
# s6:
# s7:

# t0: constants
# t1: counting
# t2: counting
# t3: reserved for deriv : a^2
# t4: reserved for deriv : b^2
# t5: reserved for deriv : x/y
# t6: reserved for arctan
# t7: reserved for arctan
# t8:
# t9:

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
RELATIVE = 0
POS_MAX_VEL = 10
POS_MIN_VEL = 1
NEG_MIN_VEL = -1
NEG_MAX_VEL = -10

main:
	# put your code here :)

	li      $t7,	0
	sw	$t7,	VELOCITY

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

        # li      $t1,    149
        # li      $t2,    300
        # mul     $s1,    $t1,    $t2
        # add     $s1,    $s1,    1
        # add     $s1,    $s1,    $s0
        # li      $s2,    150
        # add     $s2,    $s2,    $s0

        li      $t1,    149
        li      $t2,    300
        mul     $s2,    $t1,    $t2
        add     $s2,    $s2,    1
        add     $s2,    $s2,    $s0
        li      $s1,    150
        add     $s1,    $s1,    $s0

        move    $t1,    $zero
        move    $t2,    $zero

	# li 	$t4, BONK_MASK		# bonk interrupt bit
	# or	$t4, $t4, 1		# global interrupt enable
	# mtc0	$t4, $12		# set interrupt mask (Status register)

        j       y_axis

# -----------------------
# START SETTING DIAMETERS
# -----------------------
y_axis:
        # start syscall
        # li      $v0,    1
        # move    $a0,    $t1
        # syscall
        # li      $v0,    4
        # la      $t0,    SPACE
        # move    $a0,    $t0
        # syscall
        # end syscall

        lbu     $t0,    0($s1)
        beq     $t0,    2,      set_y_diam
        add     $s1,    $s1,    300
        add     $t1,    $t1,    1
        j       y_axis

set_y_diam:
        # start syscall
        # li      $v0,    4
        # la      $t0,    NEWLINE
        # move    $a0,    $t0
        # syscall
        # end syscall

        li      $s1,    150
        sub     $s1,    $s1,    $t1

        # start syscall
        li      $v0,    1
        move    $a0,    $s1
        syscall
        li      $v0,    4
        la      $t0,    NEWLINE
        move    $a0,    $t0
        syscall
        # end syscall

        j       x_axis

x_axis:
        # start syscall
        # li      $v0,    1
        # move    $a0,    $t2
        # syscall
        # li      $v0,    4
        # la      $t0,    SPACE
        # move    $a0,    $t0
        # syscall
        # end syscall

        lbu     $t0,    0($s2)
        beq     $t0,    2,      set_x_diam
        add     $s2,    $s2,    1
        add     $t2,    $t2,    1
        j       x_axis

set_x_diam:
        # start syscall
        # li      $v0,    4
        # la      $t0,    NEWLINE
        # move    $a0,    $t0
        # syscall
        # end syscall

        li      $s2,    150
        sub     $s2,    $s2,    $t2

        # start syscall
        li      $v0,    1
        move    $a0,    $s2
        syscall
	li      $v0,    4
        la      $t0,    NEWLINE
        move    $a0,    $t0
        syscall
        # end syscall

        j       start
# ---------------------
# END SETTING DIAMETERS
# ---------------------

# --------------------
# START GETTING ANGLES
# --------------------
start:
        li      $t7,	0
        sw      $t7,	VELOCITY
        j       deriv

deriv:

	# start syscall
	move 	$a0,	$v0
	li      $v0,    1
	syscall
	li      $v0,    4
	la      $t0,    NEWLINE
	move    $a0,    $t0
	syscall
	# end syscall

        lw	$s3,	BOT_X # s2
        lw	$s4,	BOT_Y # s1
        li      $t2,    150		#Originally 150
        sub     $s3,    $s3,    $t2     # x
        sub     $s4,    $s4,    $t2     # y
	div 	$t4,	$t4,	2
        mul     $t3,    $s2,    $s2     # x_axis^2
        mul     $t4,    $s1,    $s1     # y_axis^2
        # move    $t3,    $s2             # x_axis
        # move    $t4,    $s1             # y_axis
        # beq     $s3,    $zero,  x_zero

        beq     $s4,    $zero,  y_zero
        div     $t5,    $s3,    $s4     # x / y
	div     $a1,    $t4,    $t3     # (y_axis^2) / (x_axis^2)
	# div     $a1,    $t3,    $t4     # (x_axis^2) / (y_axis^2)
        mul     $a1,    $a1,    $t5     # (x * y_axis^2) / (y * x_axis^2)
        li      $t4,    -1
        mul     $a1,    $a1,    $t4     # - (x * y_axis^2) / (y * x_axis^2)

        li      $a0,    1
        jal     sb_arctan
        sw	$v0,	ANGLE
        li      $s7,	ABSOLUTE
        sw	$s7,	ANGLE_CONTROL
	li      $t7,	10
        sw      $t7,	VELOCITY
        j       deriv

y_zero:
        blt     $s3,    $zero,  x_neg
        j       x_pos

        x_neg:
		# start syscall
		# li      $v0,    1
		# move    $a0,    $s3
		# syscall
		# li      $v0,    4
		# la      $t0,    NEWLINE
		# move    $a0,    $t0
		# syscall
		# end syscall

                li      $v0,    NEG90
                sw	$v0,	ANGLE
                li      $s7,	ABSOLUTE
                sw	$s7,	ANGLE_CONTROL
                j       deriv

        x_pos:
		# start syscall
	        # li      $v0,    1
	        # move    $a0,    $s3
	        # syscall
	        # li      $v0,    4
	        # la      $t0,    NEWLINE
	        # move    $a0,    $t0
	        # syscall
	        # end syscall

                li      $v0,    POS90
                sw	$v0,	ANGLE
                li      $s7,	ABSOLUTE
                sw	$s7,	ANGLE_CONTROL
                j       deriv
# ------------------
# END GETTING ANGLES
# ------------------

# ---------------------
# START GO TO JETSTREAM
# ---------------------
find_jetstream:
	lw	$s3,	BOT_X		# Get X coordinate
	lw	$s4,	BOT_Y		# Get Y coordinate
	li 	$t8,	150		# Get ready for subtraction
	sub 	$t8,	$s3,	150	# Subtract
	li 	$t9,	150		# Get ready for subtraction
	sub 	$t9,	$s4,	150	# Subtract
	move 	$a0,	$t8		# Move X coord to argument
	move 	$a1,	$t9		# Move Y coord to argument
	jal 	sb_arctan		# Get angle
	sw 	$v0,	ANGLE		# Store angle
	li 	$v0,	ABSOLUTE	#
	sw 	$v0,	ANGLE_CONTROL	# Set angle control to absolute
	li 	$v0,	10		#
	sw 	$v0,	VELOCITY	# Set velocity to 10
	#j 	reach_jetstream		# check if at jetstream

reach_jetstream:
	lw	$s3,	BOT_X		# Get X coordinate
	lw	$s4,	BOT_Y		# Get Y coordinate
	mul 	$s4,	$s4,	300	# Get jetstream array coordinate
	add 	$s3,	$s3,	$s4	#		|
	add 	$s3,	$s3,	$s0	#		|
	lbu 	$t0,	0($s0)		# Get value at coordinate
	bne 	$t0,	2,	reach_jetstream	# Check if on jetstream
	li 	$t0,	0
	sw 	$t0,	VELOCITY	# Set velocity to 10
	j 	deriv
# -------------------
# END GO TO JETSTREAM
# -------------------


# -------------
# START RESTORE
# (never used)
# -------------
loop_again:

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
# -----------
# END RESTORE
# -----------

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

	# jr 	$ra
	bgt 	$s4,	$zero,	tan_quad
	jr 	$ra

tan_quad:
	#mul 	$v0,	$v0,	-1
	add 	$v0,	$v0,	180
	jr 	$ra
