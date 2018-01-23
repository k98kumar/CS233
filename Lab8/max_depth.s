.data

.text

## struct Node {
##     int node_id;            // Unique node ID
##     struct Node **children; // pointer to null terminated array of children node pointers
## };
##
## int
## max_depth(Node *current) {
##     if (current == NULL)
##         return 0;
##
##     int cur_child = 0;
##     Node *child = current->children[cur_child];
##     int max = 0;
##     while (child != NULL) {
##         int depth = max_depth(child);
##         if (depth > max)
##             max = depth;
##         cur_child++;
##         child = current->children[cur_child];
##     }
##     return 1 + max;
## }

#	   int	 Node **
#	+ ----- + ----- +
#	| , , , | , , , |
#	+ ----- + ----- +
#	| , , , | , , , |
#	+ ----- + ----- +
#	 node_id children
#	0	4	8

# t0: max
# t1: cur_child
# t2: get address | &current->children[cur_child]
# t3: load word   | current->children[cur_child]
# t4: multiply cur_child by 4
# t5: depth

.globl max_depth
max_depth:

	sub	$sp,	$sp,	32
	sw	$ra,	0($sp)		# store current data in register
	sw	$s0,	4($sp)		#	|	|	|
	sw	$s1,	8($sp)		#	|	|	|
	sw	$s2,	12($sp)		#	|	|	|
	sw	$s3,	16($sp)		#	|	|	|
	sw	$s4,	20($sp)		#	|	|	|
	sw	$s5,	24($sp)		#	V	V	V
	sw	$s6,	28($sp)		# store current data in register

	move	$s6,	$a0

	move	$s0,	$zero		# prepping for return 0 | Also works for max

	beq	$s6,	$zero,	fin_1	# if current == NULL

	move	$s1,	$zero		# cur_child = 0

	lw	$t0,	4($s6)
	mul	$t1,	$s1,	4
	add	$t2,	$t1,	$t0
	lw	$s3,	0($t2)		# current->children[0]
	# max already set to 0

	j	while

while:
	beq	$s3,	$zero,	fin_2

	move	$a0,	$s3
	jal	max_depth
	move	$s5,	$v0

	ble	$s5,	$s0,	while_end
	move	$s0,	$s5
	j	while_end

while_end:
	add	$s1,	$s1,	1

	lw	$t0,	4($s6)
	mul	$t1,	$s1,	4
	add	$t2,	$t1,	$t0
	lw	$s3,	0($t2)		# current->children[0]

	j	while

fin_1:
	move	$t0,	$s0

	lw	$ra,	0($sp)
	lw	$s0,	4($sp)
	lw	$s1,	8($sp)
	lw	$s2,	12($sp)
	lw	$s3,	16($sp)
	lw	$s4,	20($sp)
	lw	$s5,	24($sp)
	lw	$s6,	28($sp)
	add	$sp,	$sp,	32

	move	$v0,	$t0
	jr	$ra

fin_2:
	move	$t0,	$s0

	lw	$ra,	0($sp)
	lw	$s0,	4($sp)
	lw	$s1,	8($sp)
	lw	$s2,	12($sp)
	lw	$s3,	16($sp)
	lw	$s4,	20($sp)
	lw	$s5,	24($sp)
	lw	$s6,	28($sp)
	add	$sp,	$sp,	32

	add	$v0,	$t0,	1
	jr	$ra
