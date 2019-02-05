.data
    array: .word 23, 10, 20, 11, 12, 6, 7

.text
    .globl main
    main:
        la $t0, array
        addi $a0, $t0, 0
        addi $a1, $zero, 7
        jal pancakeSort
        addi $a1, $0, 7
       	jal printValues # print the values
        li $v0, 10
        syscall
    pancakeSort:
        addi $sp, $sp, -12 # two vars on stack
        sw $s0, 0($sp) # size
        sw $s1, 4($sp) # mi
        sw $ra, 8($sp)
        add $s0, $0, $a1 # size = n
    pancakeLoop:
        addi $t0, $0, 1 # store value of 1
        slt $t0, $t0, $s0 # 1 < size
        beq $t0, $0, returnPancakeSort
        add $a1, $s0, $0 # size as second param
        jal findMax # call findMax
        add $s1, $v0, $0 # mi = findMax(arr, size)
        bne $s0, $s1, pancakeFlip
        addi $s0, $s0, -1 # s--
        j pancakeLoop
    pancakeFlip:
        add $a1, $s1, $0 # mi should be second param
        jal flip
        addi $t0, $s0, -1 # size - 1
        add $a1, $t0, $0
        jal flip
        addi $s0, $s0, -1 # s--
        j pancakeLoop
    returnPancakeSort:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $ra, 8($sp)
        addi $sp, $sp, 12
        jr $ra
    findMax:
        addi $sp, $sp, -12
        sw $s0, 0($sp) # max
        sw $s1, 4($sp) # mi
        sw $s2, 8($sp) # i
        lw $s0, 0($a0) # max = arr[0]
        add $s1, $0, $0 # mi = 0
        addi $s2, $0, 1
    findMaxLoop:
        slt $t0, $s2, $a1 # i < N
        beq $t0, $0, returnFindMax
        sll $t0, $s2, 2 # i * 4
        add $t0, $a0, $t0 # get addr of arr[i]
        lw $t0, 0($t0) # arr[i]
        sll $t1, $s1, 2 # mi * 4
        add $t1, $a0, $t1 # get addr of arr[mi]
        lw $t1, 0($t1) # arr[mi]
        slt $t2, $t1, $t0 # arr[mi] < arr[i]
        bne $t2, $0, findMaxUpdateIndex
        addi $s2, $s2, 1 # ++i
        j findMaxLoop
    findMaxUpdateIndex:
    	add $s1, $s2, $0 # mi = i
    	addi $s2, $s2, 1 # ++i
    	j findMaxLoop
    returnFindMax:
    	add $v0, $s1, $0
    	lw $s0, 0($sp)
    	lw $s1, 4($sp)
    	lw $s2, 8($sp)
    	addi $sp, $sp, 12
    	jr $ra
    flip:
    	addi $sp, $sp, -8
    	sw $s0, 0($sp) # temp
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
    	
    