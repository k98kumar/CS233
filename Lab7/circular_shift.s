.text

## unsigned int
## circular_shift(unsigned int in, unsigned char s) {
##     return (in >> 8 * s) | (in << (32 - 8 * s));
## }

.globl circular_shift
circular_shift:
	mul	$t0,	$a1,	8	# multiply s by 8
	mul	$v0,	$t0,	-1	# store -1 times s times 8 into $v0 for second part of or
	add	$v0,	$v0,	32	# overwrite $v0 with 32 added to $v0
	srl	$t0,	$a0,	$t0	# overwrite $t0 and shift in to the right
	sll	$v0,	$a0,	$v0	# overwrite $v0 and shift in to the left
	or	$v0,	$t0,	$v0	# overwrite $v0 with $t0 or $v0
	jr	$ra			# return
