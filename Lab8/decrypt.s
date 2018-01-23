.data

.text

##void decrypt(uint8_t *ciphertext, uint8_t *plaintext, uint8_t *key, uint8_t rounds){
##    uint8_t A[16], B[16], C[16], D[16];
##    key_addition(ciphertext, &key[16 * rounds], C);
##    inv_shift_rows((uint32_t *)C, (uint32_t *)B);
##    inv_byte_substitution(B, A);
##    for (uint32_t k = rounds - 1; k > 0; k--){
##        key_addition(A, &key[16 * k], D);
##        inv_mix_column(D, C);
##        inv_shift_rows((uint32_t *)C, (uint32_t *)B);
##        inv_byte_substitution(B, A);
##    }
##    key_addition(A, key, plaintext);
##    return;
##}

.globl decrypt
decrypt:
    # Your code goes here :)
    #There is the stack mem and the saved reg
    sub $sp, $sp, 100
 	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)


    #Args, except rounds
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    #stored in s7
    move $s7, $a3

    #A,B,C D loc
    add $s3, $sp, 36
    add $s4, $sp, 52
    add $s5, $sp, 68
    add $s6, $sp, 84

    move $a0, $s0
    mul $t0, $s7,16
    add $a1,$s2 ,$t0
    move $a2, $s5
    jal key_addition

    move $a0, $s5
    move $a1, $s4
    jal inv_shift_rows

    move $a0,$s4
    move $a1,$s3
    jal inv_byte_substitution

    #Rounds - 1
    sub $s7, $s7, 1
for_loop:
    ble $s7, 0,end_for_loop

    move $a0, $s3
    mul $t0, $s7,16
    add $a1, $s2,$t0
    move $a2, $s6
    jal key_addition

    move $a0, $s6
    move $a1, $s5
    jal inv_mix_column

    move $a0, $s5
    move $a1, $s4
    jal inv_shift_rows

    move $a0,$s4
    move $a1,$s3
    jal inv_byte_substitution

    sub $s7, $s7, 1
    j for_loop
end_for_loop:

    move $a0, $s3
    move $a1, $s2
    move $a2, $s1
    jal key_addition

 	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
    add $sp, $sp, 100

    jr $ra
