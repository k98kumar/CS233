.data
uniq_chars: .space 256

.text

## int
## nth_uniq_char(char *in_str, int n) {
##     if (!in_str || !n)				// nth_uniq_char: DONE
##         return -1;					// nth_uniq_char: DONE
##
##     uniq_chars[0] = *in_str;				// nth_uniq_char: ------ FINISH ------
##     int uniq_so_far = 1;				// nth_uniq_char: DONE
##     int position = 0;				// nth_uniq_char: DONE
##     in_str++;					// nth_uniq_char: DONE
##     while (uniq_so_far < n && *in_str) {		// while_begin: DONE
##         char is_uniq = 1;				// while_begin: DONE
##         for (int j = 0; j < uniq_so_far; j++) {	// for_begin: DONE | for_end: DONE
##             if (uniq_chars[j] == *in_str) {		// for_begin:
##                 is_uniq = 0;				// if_eq: DONE
##                 break; // goes to line 27		// if_eq: DONE
##             }
##         }
##         if (is_uniq) {				// if_uniq: DONE
##             uniq_chars[uniq_so_far] = *in_str;	// if_uniq: ------ FINISH ------
##             uniq_so_far++;				// if_uniq: DONE
##         }
##         position++;					// while_end: DONE
##         in_str++;					// while_end: DONE
##     }
##
##     if (uniq_so_far < n) {				// if_lt: DONE
##         position++;					// if_lt: DONE
##     }
##     return position;					// fin: DONE
## }

# given pointer | need dereference
# 1. create reg1 to store offset
# 2. increment reg1 every time
# 3. get reg2 by adding reg1 to pointer passed in
# 4. load byte into reg2 from reg2

# t0: pointer to uniq_chars array
# t1: byte load from uniq_chars
# t2: byte load from a0 (in_str)
# t3: offset amount for a0 (in_str)
# t4: uniq_so_far
# t5: is_uniq
# t6: j
# v0: position

.globl nth_uniq_char
nth_uniq_char:
	# (!in_str || !n) --> (in_str && n) --> (in_str != 0 && n != 0)
	beq	$a0,	$zero,	neg_one	# check if (in_str != 0)
	beq	$a1,	$zero,	neg_one	# check if (n != 0)

	la	$t0,	uniq_chars	# pointer to array
	move	$t3,	$zero		# init offset to 0
	add	$t2,	$a0,	$t3	# add offset to pointer
	lb	$t2,	0($t2)		# load byte
	add	$t1,	$t0,	$zero	# add array offset to pointer
	sb	$t2,	0($t1)		# store byte from t2 into array

	li	$t4,	1		# uniq_so_far = 1
	move	$v0,	$zero		# position = 0
	add	$t3,	$t3,	1	# add 1 to offset
	j	while_begin

# ---- start while block ----

while_begin:
	bge	$t4,	$a1,	if_lt	# finish if uniq_so_far > n
	add	$t2,	$a0,	$t3	# add offset to pointer
	lb	$t2,	0($t2)		# load byte
	beq	$t2,	$zero,	if_lt	# finish if value == zero
	li	$t5,	1		# set is_uniq to 1
	move	$t6,	$zero		# set j to 0
	j	for_begin

# ----  start for block  ----

for_begin:
	bge	$t6,	$t4,	if_uniq	# check if t6 is greater than or equal to t4
	add	$t2,	$a0,	$t3	# add offset to pointer
	lb	$t2,	0($t2)		# load byte from t2
	add	$t1,	$t0,	$t6	# add offset(j) to pointer
	lb	$t1,	0($t1)		# load byte from t1
	beq	$t1,	$t2,	if_eq	# check if t1 equals t2
	j	for_end

if_eq:
	move	$t5,	$zero		# assign is_uniq to 0
	j	while_end

for_end:
	add	$t6,	$t6,	1	# increment j by 1
	j	for_begin

# ----   end for block   ----

if_uniq:
	beq	$t5,	$zero,	while_end	# if is_uniq == 0 send to end of while loop
	add	$t2,	$a0,	$t3	# put address of value at offset of a0 into t2
	lb	$t2,	0($t2)		# load byte into t2 from address of t2
	add	$t1,	$t0,	$t4	# add array offset to pointer
	sb	$t2,	0($t1)		# store byte from t2 into array
	add	$t4,	$t4,	1	# increment uniq_so_far by 1
	j	while_end

while_end:
	add	$v0,	$v0,	1	# increment position by 1
	add	$t3,	$t3,	1	# increment offset by 1
	j	while_begin

# ----  end while block  ----

if_lt:
	bge	$t4,	$a1,	fin	# if uniq_so_far >= n, return position
	add	$v0,	$v0,	1	# else, add 1 to position
	j	fin			# return position

neg_one: # return -1
	li	$v0,	-1		# load -1 into position
	jr	$ra			# return position

fin:
	jr	$ra			# return position
