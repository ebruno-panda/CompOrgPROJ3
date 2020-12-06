#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	whoops: .asciiz "NaN"
	userInput:  .space 1001 #take in a word

.text
	main:	
		move $t4, $zero # $t4 = 0 for current character
		move $t6, $zero # $t6 = 0 for non blank character count
		
		move $t0, $zero #sum tracker
		move $t1, $zero #len(userInput)
		
		#subprograms
		jal yoink
		jal iterar
		jal finalizer

	yoink:
		#gets user input
		li $v0, 8
		la $a0, userInput
		li $a1, 1001		
		syscall

