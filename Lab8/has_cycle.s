.data

.text
SIZE_4 = 4
## struct Node {
##     int node_id;            // Unique node ID
##     struct Node **children; // pointer to null terminated array of children node pointers
## };
##
## int
## has_cycle(Node *root, int num_nodes) {
##     if (!root)
##         return 0;
##
##     Node *stack[num_nodes];
##     stack[0] = root;
##     int stack_size = 1;
##
##     int discovered[num_nodes];
##     for (int i = 0; i < num_nodes; i++) {
##         discovered[i] = 0;
##     }
##
##     while (stack_size > 0) {
##         Node *node_ptr = stack[--stack_size];
##
##         if (discovered[node_ptr->node_id]) {
##             return 1;
##         }
##         discovered[node_ptr->node_id] = 1;
##
##         for (Node **edge_ptr = node_ptr->children; *edge_ptr; edge_ptr++) {
##             stack[stack_size++] = *edge_ptr;
##         }
##     }
##
##     return 0;
## }

#	   int	 Node **
#	+ ----- + ----- +
#	| , , , | , , , |
#	+ ----- + ----- +
#	| , , , | , , , |
#	+ ----- + ----- +
#	 node_id children
#	0	4	8

# t0: memory allocating offsets	| i
# t1: memory allocating offsets	| 1
# t2: discovered + offset	|
# t3: stacksize * 4 | node_ptr
# t4: node_ptr->node_id
# t5: pointer to discovered[node_ptr->node_id]
# t6: discovered[node_ptr->node_id]
# t7: pointer to pointer to t9
# t8: pointer to t9
# t9: node_ptr->children
# s0: root pointer
# s1: num_nodes
# s2: stack
# s3: discovered
# s4: stack_size
# s5:
# s6:

.globl has_cycle
has_cycle:
	bne	$a0,	$zero,	validInput
	li 	$v0	0
	jr 	$ra

	validInput:

	mul	$s6,	$a1,	8
	add	$s6,	$s6,	32
	sub	$sp,	$sp,	$s6	# allocate memory

	sw	$s0,	0($sp)		# store current data in register
	sw	$s1,	4($sp)		#	|	|	|
	sw	$s2,	8($sp)		#	|	|	|
	sw	$s3,	12($sp)		#	|	|	|
	sw	$s4,	16($sp)		#	|	|	|
	sw	$s5,	20($sp)		#	|	|	|
	sw	$s6,	24($sp)		#	V	V	V
	sw	$ra,	28($sp)		# store current data in register

	move	$s0,	$a0		# move first argument to s register
	move	$s1,	$a1		# move second argument to s register

	# mul	$t0,	$a1,	SIZE_4
	# sub	$sp,	$sp,	$t0
	# add	$t0,	$t0,	32
	add	$s2,	$sp,	32
	sw	$s0,	0($s2)
	li	$s4,	1

	mul	$t1,	$a1,	SIZE_4
	# sub	$sp,	$sp,	$t1
	add	$s3,	$t1,	$s2
	# add	$s3,	$sp,	$t1

	move	$t0,	$zero

	j	for_1

for_1:
	bge	$t0,	$s1,	while
	mul	$t0,	$t0,	SIZE_4
	add	$t2,	$s3,	$t0
	sw	$zero,	0($t2)
	add	$t0,	$t0,	1
	j	for_1

while:
	ble	$s4,	$zero,	return0
	sub	$s4,	$s4,	1
	mul	$t3,	$s4,	SIZE_4
	add	$t3,	$t3,	$s2	# t3 = node_ptr = stack[--stack_size]
	lw	$t4,	0($t3)		# t4 = node_ptr address
	#add	$t5,	$t4,	$s3	# t5 = pointer to discovered[node_ptr->node_id]
	lw	$t6,	0($t4)		# t6 = discovered[node_ptr->node_id]
	mul	$t5,	$t6,	4
	add	$t6,	$t5,	$s3
	lw	$t7,	0($t6)
	bne	$t7,	$zero,	return1	# if t6 == 0
	li	$t1,	1		# t1 = 1
	sw	$t1,	0($t6)		# discovered[node_ptr->node_id] = 1

	add	$t7,	$t4,	4	# t7 = pointer to t8
	lw	$t8,	0($t7)		# t8 = pointer to t9 - **edge_ptr
	lw	$t9,	0($t8)		# t9 = pointer to node_ptr->children - *edge_ptr


	j	for_2

for_2:
	beq	$t9,	$zero,	while

	mul	$t7,	$s4,	4

	add	$s5,	$s2,	$t7
	sw	$t9,	0($s5)
	add	$s4,	$s4,	1
	add	$t8,	$t8,	4
	lw	$t9,	0($t8)
	j	for_2

return0:
	move	$t0,	$s6
	lw	$s0,	0($sp)		# store current data in register
	lw	$s1,	4($sp)		#	|	|	|
	lw	$s2,	8($sp)		#	|	|	|
	lw	$s3,	12($sp)		#	|	|	|
	lw	$s4,	16($sp)		#	|	|	|
	lw	$s5,	20($sp)		#	|	|	|
	lw	$s6,	24($sp)		#	V	V	V
	lw	$ra,	28($sp)		# store current data in register
	add	$sp,	$sp,	$t0	#

	move	$v0,	$zero
	jr	$ra

return1:
	move	$t0,	$s6
	lw	$s0,	0($sp)		# store current data in register
	lw	$s1,	4($sp)		#	|	|	|
	lw	$s2,	8($sp)		#	|	|	|
	lw	$s3,	12($sp)		#	|	|	|
	lw	$s4,	16($sp)		#	|	|	|
	lw	$s5,	20($sp)		#	|	|	|
	lw	$s6,	24($sp)		#	V	V	V
	lw	$ra,	28($sp)		# store current data in register
	add	$sp,	$sp,	$t0	#

	li	$v0,	1
	jr	$ra
