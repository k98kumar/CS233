.text

## void
## key_addition(unsigned char *in_one, unsigned char *in_two, unsigned char *out) {
##     for (unsigned int i = 0; i < 16; i++) {
##         out[i] = in_one[i] ^ in_two[i];
##     }
## }

# t0: increment
# t1: 16
# t2: load byte from in_one
# t3: load byte from in_two
# t4: traverse out
# t5: output of each

.globl key_addition
key_addition:
	li	$t0,	0		# assign $0 to 0
	li	$t1,	16		# assign $1 to 16
	j	loop			# jump to loop block

loop:
	lb	$t2,	0($a0)		# assign temp
	lb	$t3,	0($a1)		# assign temp
	xor	$t4,	$t2,	$t3
	sb	$t4,	0($a2)		# store char to out
	add	$a0,	$a0,	1	# increment out pointer
	add	$a1,	$a1,	1	# increment in_one pointer
	add	$a2,	$a2,	1	# increment in_two pointer
	add	$t0,	$t0,	1	# increment counter
	blt	$t0,	$t1,	loop	# if $t0 is less that $t1, go to exp block
	j	fin			# finish

fin:
	add	$a0,	$a0,	-16
	add	$a1,	$a1,	-16
	add	$a2,	$a2,	-16
	jr	$ra
