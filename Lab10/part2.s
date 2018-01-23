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
# s3:
# s4:
# s5:
# s6:
# s7:

# t0:
# t1: counting
# t2: counting
# t3: reserved for deriv : a^2
# t4: reserved for deriv : b^2
# t5: reserved for deriv : x/y
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

	# la	$s0,	event_horizon_data
	# sw	$s0,	REQUEST_JETSTREAM

	li 	$t4, BONK_MASK		# bonk interrupt bit
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)

	li	$a0, 10
	sw	$a0, VELOCITY		# drive

infinite:
	j      infinite

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
