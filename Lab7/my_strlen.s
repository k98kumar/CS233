.text

## unsigned int
## my_strlen(char *in) {
##     if (!in)
##         return 0;
##
##     unsigned int count = 0;
##     while (*in) {
##         count++;
##         in++;
##     }
##
##     return count;
## }
# $t0 for pointer (mem address) of in
# $t1 for dereferenced (value of) in
# $v0 for count

.globl my_strlen
my_strlen:
if:
	move	$t0,	$a0		# Move in to t0
	bne	$t0,	$zero,	afterif	# If (a0 == 0) move to afterif block
	li	$v0,	0		# No longer need what is stored in $t0 so overwrite
	j	fin			# Send to fin

afterif:
	li	$v0,	0		# Assign v0 to 0
	lb	$t1,	0($t0)		# dereference
	bne	$t1,	$zero,	loop	# If (in == 0) : skip to preloop block
	j	fin			# Send to fin

loop:
	add	$v0,	$v0,	1	# Increment count by 1
	add	$t0,	$t0,	1	# Increment in by 1
	lb	$t1,	0($t0)
	bne	$t1,	$zero,	loop	# Loop through again if *in is not 0
	j	fin			# Send to fin

fin:
	jr	$ra			# Finish
