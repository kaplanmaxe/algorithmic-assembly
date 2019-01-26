# an interative approach to bubble sort
# c/c++ implementation: https://codescracker.com/cpp/program/cpp-program-bubble-sort.htm
.data
	arr: .word 7,4,6,9,1,3
	N: .word 6
.text
	la $s0, arr # get address of array
	la $s1, N # get address of N
	lw $s1, 0($s1) # get value of N
	main:
		add $a0, $s0, $0 # get address of arr in param1
		add $a1, $s1, $0 # put value of N in param2
		jal bubbleSort # sort arr
		jal printValues # print the values
		li $v0, 10 # exit
		syscall
	bubbleSort:
		add $sp, $sp, -8 # make room for 3 ints on stack (i, j, tmp)
		sw $s0, 0($sp) # i
		sw $s1, 4($sp) # j
		sw $s2, 8($sp) # tmp
		add $s0, $0, $0 # use i in for loop an initiate to 0
	outerLoop:
		addi $t0, $a1, -1 # n -1
		slt $t0, $s0, $t0 # i < (n - 1)
		beq $t0, $0, return # if false exit
		add $s1, $0, $0 # set j = 0
	innerLoop:
		sub $t0, $a1, $s0 # n - i
		addi $t0, $t0, -1 # (n - i - 1)
		slt $t0, $s1, $t0 # j < (n - i - 1)
		beq $t0, $0, exitInner # if false go to next iteration of outer loop
		sll $t0, $s1, 2 # get ready to do arr[j]. Shift 4 bits cause we have ints
		addi $t1, $t0, 4 # get ready to do arr[j + 1]. Shift 4 bits cause we have ints
		add $t0, $t0, $a0 # add address of j and arr
		add $t1, $t1, $a0 # add address of j + 1 and arr
		lw $t2, 0($t0) # *arr[j]
		lw $t3, 0($t1) # *arr[j + 1]
		slt $t4, $t3, $t2 # *arr[j + 1] < *arr[j]
		bne $t4, $0, swap
		addi $s1, $s1, 1 # j++
		j innerLoop
	exitInner:
		addi $s0, $s0, 1 # i++ in outerLoop
		j outerLoop
	swap:
		add $s2, $t2 $0
		sw $t3, 0($t0) # arr[j] = arr[j+1]
		sw $s2, 0($t1) # arr[j + 1] = tmp
		addi $s1, $s1, 1 # j++. TODO: Probably could be optimized. See line 36 doing same thing
		j innerLoop
	return:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
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