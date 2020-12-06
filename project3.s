#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	whoops: .asciiz "NaN"
	userInput:  .space 1001 #take in a word

.text
	main:	
		#gets user input
		li $v0, 8 #get user input (text)
		la $a0, userInput
		li $a1, 1001
		syscall
