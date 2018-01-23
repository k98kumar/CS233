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

# x_zero:
#         blt     $s4,    $zero,  y_neg
#         j       y_pos
#
#         y_neg:
#                 li      $v0,    POS180
#                 sw	$v0,	ANGLE
#                 li      $s7,	ABSOLUTE
#                 sw	$s7,	ANGLE_CONTROL
#                 j       deriv
#
#         y_pos:
#                 li      $v0,    ANGLE0
#                 sw	$v0,	ANGLE
#                 li      $s7,	ABSOLUTE
#                 sw	$s7,	ANGLE_CONTROL
#                 j       deriv

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
	lw	$s3,	BOT_X
	lw	$s4,	BOT_Y
	li 	$t8,	150
	sub 	$t8,	$s3,	150
	li 	$t9,	150
	sub 	$t9,	$s4,	150
	move 	$a0,	$t8
	move 	$a1,	$t9
	jal 	sb_arctan
	sw 	$v0,	ANGLE
	li 	$v0,	ABSOLUTE
	sw 	$v0,	ANGLE_CONTROL
	li 	$v0,	10
	sw 	$v0,	VELOCITY
	j 	reach_jetstream

reach_jetstream:
	lw	$s3,	BOT_X
	lw	$s4,	BOT_Y
	mul 	$s4,	$s4,	300
	add 	$s3,	$s3,	$s4
	add 	$s3,	$s3,	$s0
	lbu 	$t0,	0($s0)
	bne 	$t0,	2,	reach_jetstream
	li 	$t0,	0
	sw 	$t0,	VELOCITY
	#j 	deriv
	j interrupt_dispatch
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
# Bonk Interrupt
# -----------------------------------------------------------------------
.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180

interrupt_handler:
.set noat
	move	$k1, $at		# Save $at
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers
	sw	$a1, 4($k0)		# by storing them to a global variable

	mfc0	$k0, $13		# Get Cause register
	srl	$a0, $k0, 2
	and	$a0, $a0, 0xf		# ExcCode field
	bne	$a0, 0, non_intrpt

interrupt_dispatch:			# Interrupt:
	mfc0	$k0, $13		# Get Cause register, again
	beq	$k0, 0, done		# handled all outstanding interrupts

	and	$a0, $k0, BONK_MASK	# is there a bonk interrupt?
	bne	$a0, 0, bonk_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall
	j	done

bonk_interrupt:
	sw      $a1, 0xffff0060($zero)   # acknowledge interrupt

	li      $a1, 10                  #  ??
	sw      $a1, 0xffff0010($zero)   #  ??
	li 	$a1, 80
	sw 	$a1, ANGLE
	li 	$a1, RELATIVE
	sw 	$a1, ANGLE_CONTROL

	j       interrupt_dispatch       # see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at
	eret


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
