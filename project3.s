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

		la $t2, userInput #assigns input to address
		jr $ra #jumps back to part of main, calling on iterar next

	iterar:
		lb $t3, ($t2) #each bit of input in $t2 is looked at in $t3
		beqz $t3, regulator #if end of string, get ready to end program
		j charspecs #look at what type of character is being loaded

	charspecs:
		beq $t3, 0x9, tabberspace # If *tab* is detected, go to function tabberspace (and treat both the same)
		beq $t3, 0x20, tabberspace # If *space* is detected, go to function tabberspace (and treat both the same)
		beq $t3, 0xA, EnterAlert #If *Enter* is detected, go to function EnterAlert

		#NOTE: t5 is used as an evaluator type boolean ; based on order of ASCII table numbers, uppercase letters, and lowercase letters will ...
		# ... be dealt with respectively due to the nature of how "slt" works

		#Determines if character type is "number"
		slt $t5, $t3, 0x30 #is ascii < 0?
	        beq $t5, 1, hmm #if t5 is one, character is invalid		
       	        slt $t5, $t3, 0x3A #if ascii value < ":", it's a lowercase letter
       	        beq $t5, 1, charNconv #if t5 is one then go to charNconv

		#Determines if character type is "uppercase"
		slt $t5, $t3, 0x41 #is ascii < "A"?
	        beq $t5, 1, hmm #if t5 is one, character is invalid
       	        slt $t5, $t3, 0x5B #if ascii value < "[", it's an uppercase letter
       	        beq $t5, 1, charUconv #if t5 is one then go to charUconv

		#Determines if character type is "lowercase"
		slt $t5, $t3, 0x61 #is ascii < "a"?
	        beq $t5, 1, hmm #if t5 is one, character is invalid
                slt $t5, $t3, 0x7B #if ascii value < "{", it's a lowercase letter
                beq $t5, 1, charLconv #if t5 is one then go to charLconv

		#End of input
                j EnterAlert #reached end of input after considering all possibilities, so go to EnterAlert


	charNconv:
		addi $t3, $t3, -48 # convert to integer	
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"


	charUconv:
		addi $t3, $t3, -55 # convert: ‘A’=10,‘B’=11,etc
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"


	charLconv:
		addi $t3, $t3, -87 # convert: ‘a’=10,‘b’=11,etc
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"


	EnterAlert:
		addi $t1, $t1, 1 #counts character in input individually
		addi $t2, $t2, 1 #moves to next character
		
		beq $t3, 0xA, iterar #value 'ENTER' will be sorted out in iterar and ~eventually~ to function finalizer
		beq $t1, 5, hmm #if input counter exceeds 4, branches to function "hmm" to deal with this instance

		j iterar #back to center function


	tabberspace:
		add $t4, $zero, 0 #are there characters that are not blank?
		beqz $t6, EnterAlert
		
		#else, there are spaces/tabs after other characters
		add $t7, $zero, 1
		j EnterAlert


	hmm:
		la $a0, whoops #calls invalde message
		li $v0, 4
		syscall


	impostor:
		#Again, $t5 is referenced to determine N in baseN
		slt $t5, $t3, 30 #Not right base? then...
		beqz $t5, hmm #invalid base, there for input is invalid
		
		#wrong charcater type alert. Impostor(s) detected. Count all
		add $t4, $zero, 1
		add $t6, $zero, 1


		#blanks in between impostors --> REPORT
		beq $t7, 1, hmm
		j EnterAlert
	
