# recursive approach to fibonacci
.data

.text

# main is only for testing
main:
	addi $a0, $0, 7
	jal fibonacci
	add $a0, $v0, $0
	jal printResult
	j exit
fibonacci:
	addi $t2, $0, 1 # used only for checking i == 1
	beq $a0, $zero, E0 # if i == 0
	beq $a0, $t2, E1 # if i == 1
	
	# fib (n - 1)
	addi $sp, $sp, -4 # make room on stack for $ra
	sw $ra, 0($sp) # store return address
	addi $a0, $a0, -1 # i - 1
	jal fibonacci # call fibonacci(i-1)
	addi $a0, $a0, 1 # get i back to normal state
	lw $ra, 0($sp) # restore $ra
	addi $sp, $sp, 4 # restore stack pointer
	addi $sp, $sp, -4 # make room again. Probably not necessary
	sw $v0, 0($sp) # push fibonacci(i-1) on stack
	
	# fib(n-2)
	addi $sp, $sp, -4 # make room on stack for return address
	sw $ra, 0($sp) # store return address on stack
	addi $a0, $a0, -2 # i -2
	jal fibonacci # fibonacci(i-2)
	addi $a0, $a0, 2 # restore i back to normal state
	lw $ra, 0($sp) # get return addr
	add $sp, $sp, 4 # pop off stack
	
	lw $s3, 0($sp) # get result of fib(i-1)
	addi $sp, $sp, 4 # push off stack
	add $v0, $v0, $s3 # fib(i-1) + fib(i-2)
	jr $ra
E0:
	add $v0, $0, $0 # return 0
	jr $ra
E1:
	addi $v0, $0, 1 # return 1
	jr $ra
printResult:
	li $v0, 1
	syscall
exit:
	li $v0, 10
	syscall
