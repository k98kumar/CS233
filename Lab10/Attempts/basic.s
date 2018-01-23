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

# s0: prior direction
	# 1: right
	# 2: down
	# 3: left
	# 4: up
# s2: X position
# s3: Y position

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

	la	$t0,	event_horizon_data
	sw	$t0,	REQUEST_JETSTREAM

	#li	$t4, BONK_MASK		# timer interrupt enable bit
	#or	$t4, $t4, 1		# global interrupt enable
	#mtc0	$t4, $12		# set interrupt mask (Status register)

	li      $t7,	POS_MAX_VEL
	sw	$t7,	VELOCITY

check_quad: # checks which quadrant bot is in
	lw	$s2,	BOT_X
	lw	$s3,	BOT_Y
	ble	$s2,	MID,	quad_23
	j	quad_14

quad_23:
	ble	$s3,	MID,	quad_2
	j	quad_3

quad_14:
	ble	$s3,	MID,	quad_1
	j	quad_4


# CHECK IF BOT IS NORMAL PIXEL OR JETSTREAM PIXEL
quad_1:
	mul	$t1,	$s3,	300
	add	$t1,	$t1,	$s2
	add     $t1,	$t1,	$t0
	lb	$t2,	0($t1)		# finds map array pixel
	beq	$t2,	1,	quad_1_reverse
	j	loop_again

quad_2:
	mul	$t1,	$s3,	300
	add	$t1,	$t1,	$s2
	add	$t1,	$t1,	$t0
	lb	$t2,	0($t1)		# finds map array pixel
	beq	$t2,	1,	quad_2_reverse
	j	loop_again

quad_3:
	mul	$t1,	$s3,	300
	add	$t1,	$t1,	$s2
	add	$t1,	$t1,	$t0
	lb	$t2,	0($t1)		# finds map array pixel
	beq	$t2,	1,	quad_3_reverse
	j	loop_again

quad_4:
	mul	$t1,	$s3,	300
	add	$t1,	$t1,	$s2
	add	$t1,	$t1,	$t0
	lb	$t2,	0($t1)		# finds map array pixel
	beq	$t2,	1,	quad_4_reverse
	j	loop_again
