
    	sw $s1, 4($sp) # start
    	add $s0, $0, $0 # temp = 0
    	add $s1, $0, $0 # start = 0
    flipLoop:
    	slt $t0, $s1, $a1 # start < k
    	beq $t0, $0, returnFlipLoop
    	sll $t0, $s1, 2 # start * 4
    	add $t0, $t0, $a0 # get addr of arr[start]
    	lw $t1, 0($t0) # arr[start]
    	add $s0, $t1, $0 # temp = arr[start]
    	sll $t2, $a1, 2 # k * 4
    	add $t2, $t2, $a0 # get addr of arr[k]
    	lw $t3, 0($t2) # arr[k]
    	sw $t3, 0($t0) # arr[start] = arr[k]
    	sw $s0, 0($t2) # arr[k] = temp
    	addi $s1, $s1, 1 # start++
    	addi $a1, $a1, -1 # k--
    	j flipLoop
    returnFlipLoop:
    	lw $s0, 0($sp)
    	lw $s1, 4($sp)
    	addi $sp, $sp, 8
    	jr $ra
    printValues:
	addi $sp, $sp, -8 # make room for i on stack
	sw $s0, 0($sp) # store i on stack
	sw $a0, 4($sp) # store base addr of arr
	add $s0, $0, $0 # initialize i to 0
    printLoop:
	lw $t1, 4($sp) # get base addr of arr off stac
	slt $t0, $s0, $a1 # i < N
	beq $t0, $0, returnPrintValues
	sll $t0, $s0, 2 # shift 4 bytes to get next elem
	add $t0, $t0, $t1 # get addr of arr[i]
	lw $t0, 0($t0)
	li  $v0, 1           # service 1 is print integer
	add $a0, $t0, $zero  # get ready to print val
	syscall
	addi $s0, $s0, 1 # i++
	j printLoop
    returnPrintValues:
	lw $s0, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, -8 # restore stack pointer
	jr $ra