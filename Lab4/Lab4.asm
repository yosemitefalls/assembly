############################################################################
# Created by: Bernstein, Aidan
# 1676767
# 14 November 2018
#
# Assignment: Lab 4: ASCII Decimal to 2SC
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: take two strings convert to twos complement add them print as decimal, morse code, twos compliment and original decimal value. 
#
# Notes: This program is intended to be run from the MARS IDE.
############################################################################
#pseudo code:
#load the arguments and store them in temporary registers
#while(intx<ascibitlength) (
#reverse
#
#convert from asci to decimal (subracting 48) (loop through asci chars and grab each bit)
#x++
#)
# convert both temp regs to string
#set flag if theres a char before the argument (the minus sign)
#then print the temp stored values with prefix-- 
# You entered the decimal numbers: tempreg1, tempreg2 /n

#if minus flag is triggered(
#convert the temp values to twos compliment by--
#invert value of each bit - then add 1 bit) (store in s0)

#else(
#not negative so remains in binary
#store in s0)
#
#add s1 and s2 and store that value in $s0
#
#store s0 in in $t3 and convert to decimal--
#flag if 1 is at the beggining
#invert bits then add 1 
#if 1 flag triggers (
#convert to string
#add - prefix to t3
# else(
#convert t3 to string
#print t3 with prefix)
#The sum in decimal is: /n
#t3
#convert s0 to string
#print s0 with prefix
#The sum in two’s complement binary is: /n so
#print -- program is finished running --
# REGISTER USAGE
# $t0: address of second character from user input,
# $t7 stores the first argument from user input - also 
#used in the the for loop
# holds value of 0xFFFFFFFF for sign extension
# $s0: stores 2SC sum of user inputs
# t1 # values at adress for first second program argument 
#also used a temporary variable throughout the program
# t2 primarily used as temporary variable for coounter
# t3 temp variable
# t4 used as temp variable
# t5 used as temp variable
# t6 used as temp variable
main: 
	li $v0, 4                       #prints 1st prompt
	la $a0, prompt
	syscall
	la $t0, ($a1) 	                #t0 contains list of addresses
	lw  $t1, ($t0)                  # address of first program argument string loaded into t1
	lw $t7, ($t0)                   #store original argument in adress for use in SECOND SET OF IF STATEMENTS<-
	li $v0, 4                       #call to print string
	la $a0, ($t1)                   #prints contents of adress of t1 
	syscall

	li      $v0,4                   #code 4 == print string
	la      $a0,space               #$a0 == address of the string
	syscall                       
	la $t0, ($a1)                   #t0 contains list of addresses
	lw  $t1, 4($t0)                 # address of first program argument string but shifted to the right four in order to grab second argument
	li $v0, 4        
	la $a0, ($t1)			#prints the second arg
	syscall
	li $v0, 4
	la $a0, newLine			#print newLine
	syscall
	li $v0, 4			#print next prompt
	la $a0, prompt1
	syscall
	lb $t2, 1($t1)                  #load value of bit at space 1
	bnez $t2, negSingleCharCondition#if the space is anything besides 0, IE if it is anything besides the single digit number it self	
	lb $t2, ($t1)                   #single char condition
	subi $t2, $t2, 48               #account for asci value by subtracting 48
	move $s1, $t2 			#store in s1		
	b ByPassBlocks

negSingleCharCondition:        	#if number is one digit and negative
	lb $t2, ($t1)			#load negative place
	subi $t3, $t2, 45               #subtract 45 (value of asci negative sign)
	lb $t4, 2($t1)			#check if theres a third digit
	or $t4, $t4, $t3
	bnez $t4, doubleCharCondition   #if theres a third digit and negative then branch
	lb $t2, 1($t1)			#load ones place
	subi $t2, $t2, 48               #account for asci value by subtracting 48
	mul $t2, $t2, -1		#change value to negative
	move $s1, $t2			#store in s1
	b ByPassBlocks
doubleCharCondition: 	 	#two digits 
	lb $t2, 2($t1)     		#load ones place
	bnez $t2, doubleNegCharCondition  #if negative place is 0 and enter if negative(2d) branch
	lb $t2, 1($t1)  	 #load ones place
	lb $t3,  ($t1)  	#load tens place
	subi $t2, $t2, 48	 #account for asci value by subtracting 48
	subi $t3, $t3, 48	 #account for asci value by subtracting 48
	mul $t3, $t3, 10 	#multiply tens place by ten
	add $t3, $t3, $t2 	#add tens place and ones place
	move $s1, $t3      	#store in s1
	b ByPassBlocks
doubleNegCharCondition:
	lb $t2, 2($t1)  	 #load ones place
	lb $t3, 1($t1)  	#load tens place
	subi $t2, $t2, 48 	#account for asci value by subtracting 48
	subi $t3, $t3, 48        #account for asci value by subtracting 48
	mul $t3, $t3, 10	 #multiply tens place by ten
	add $t3, $t3, $t2	#add tens place and ones place
	mul $t3, $t3, -1 	 #change back to negative
	move $s1, $t3    	#store in s1
	b ByPassBlocks
#---------------------------------------------------------------------------------------------------------------------------
ByPassBlocks:  	 #SAME CODE AS PREVIOUS IF STATEMENTS EXCEPT SO COMMENTS WILL BE MINIMAL-- ONLY DIFFERENCE IS WE ACCESS THE ORIGNAL PROGRAM ARGUMENT AND STORING IN S2
	lb $t2, 1($t7)  	 #LOAD 
	bnez $t2, negSingleCharCondition1 # if left bit ==0  enter if not branch to check if negative
	lb $t2, ($t7)             #single char condition
	subi $t2, $t2, 48               #account for asci value by subtracting 48
	move $s2, $t2 			#store in s2			
	b ByPassBlocks1
negSingleCharCondition1:   	  #negative and tens place	
	lb $t2, ($t7)	 	
	subi $t3, $t2, 45
	lb $t4, 2($t7)
	or $t4, $t4, $t3
	bnez $t4, doubleCharCondition1
	lb $t2, 1($t7)
	subi $t2, $t2, 48 	 #account for asci value by subtracting 48
	mul $t2, $t2, -1
	move $s2, $t2
	b ByPassBlocks1
doubleCharCondition1: 
	lb $t2, 2($t7)     
	bnez $t2, doubleNegCharCondition1  #if negative place is 0 and enter if negative(2d) branch
	lb $t2, 1($t7)   	#load ones place
	lb $t3,  ($t7)  	#load tens place
	subi $t2, $t2, 48 	#account for asci value by subtracting 48
	subi $t3, $t3, 48	 #account for asci value by subtracting 48
	mul $t3, $t3, 10 	#multiply tens place by ten
	add $t3, $t3, $t2 	#add tens place and ones place
	move $s2, $t3
	b ByPassBlocks1
doubleNegCharCondition1:
	lb $t2, 2($t7)   	#load ones place
	lb $t3, 1($t7)  	#load tens place
	subi $t2, $t2, 48 	#account for asci value by subtracting 48
	subi $t3, $t3, 48	 #account for asci value by subtracting 48
	mul $t3, $t3, 10 	#multiply tens place by ten
	add $t3, $t3, $t2 	#add tens place and ones place
	mul $t3, $t3, -1
	move $s2, $t3
	b ByPassBlocks1
#-----------------------------------------------------------------------------------------------------------------------
ByPassBlocks1:
	     add $s0, $s1, $s2	
             bltz $s0, lessThenZero   #if the value is less then zero branch to negative cases
             div $t1, $s0, 10         #divide by ten to see if there is a tens place
             bnez $t1, twoDigit		#if dividing by ten returned a number (not zero) then we known its double digit and branch
             add $s0, $s0, 48		#add 48 to account for asci
             li      $v0, 11           #code 4 == print string
             move     $a0, $s0		#print the sum
             syscall
             b byPassBlocks2        
twoDigit:				#POSITIVE two digit case
	    
             add 	$s0, $s1, $s2	#add s1 and s2 to get the sum 
             blt    	$s0, 100, ThreeDigit2
	     li     	 $v0, 4          
             la     	$a0, binaryOne  
             syscall
             subi 	$s0, $s0, 100
             b ThreeDigit2
ThreeDigit2:
             div 	$t2, $s0, 10	#figure out number in tens place
             rem 	$t3, $s0, 10    #figures out number in ones place
             add 	$t2, $t2, 48	#account for ascii by adding 48
             add 	$t3, $t3, 48	#account for ascii by adding 48
             li     	 $v0, 11         # code 4 == print string
             move    	$a0, $t2	#print tens place
             syscall
             li      	$v0, 11       	#code 4 == print string
             move     $a0, $t3     	#print ones place
             syscall
             b byPassBlocks2
lessThenZero:        			#NEGATIVE SUM CASES - SAME AS POSITIVE HOWEVER WE PRINT NEGATIVE SIGN - 
              div 	$t1, $s0, 10       #figure out if two digits
              bnez 	$t1, twoDigit1 	#if two digits branch
              li 	$t4, 45		#load value of - sign
              li      $v0, 11       	#code 4 == print string
              move     $a0, $t4		#print minus sign
              syscall
              mul 	$s0, $s0, -1	#change negative sum to positive for the sake prinintg and accounting for ascii
              add 	$s0, $s0, 48	#add 48 to account ofr ascii
              li      $v0, 11       	#code 4 == print string
              move     $a0, $s0		#print nnumber
              syscall
              b byPassBlocks2
twoDigit1:   
	   add 	$s0, $s1, $s2     
	   li	 $t4, 45           	 #store negative character in t4
           li      $v0, 11           
           move     $a0, $t4    	 #print negative character
           syscall
	   mul $s0, $s0, -1 
	   blt    $s0, 100, ThreeDigit3
	   li      $v0, 4          
           la     $a0, binaryOne  
           syscall
           subi $s0, $s0, 100
	   b ThreeDigit3
ThreeDigit3:				#negative and two digits
          
                 			#change sum to positive
           div $t2, $s0, 10       	#find tens
           rem $t3, $s0, 10		#find ones
           add $t2, $t2, 48		#account for asci
           add $t3, $t3, 48		#account ofr asscii
           li      $v0, 11      	#code 4 == print string
           move    $a0, $t2		#print tens
           syscall
           li      $v0, 11       	#code 4 == print string
           move     $a0, $t3		#prints ones
           syscall
           b byPassBlocks2
#------------------------------------------------------------------------------------------------------------
byPassBlocks2:
        li $v0, 4		#print new line
        la $a0, newLine
        syscall
        li $v0, 4		#print prompt
        la $a0, prompt2
        syscall
	add $s0, $s1, $s2
	li $t1, 0x80000000	#store value for sake of maskng
	li $t4, 0		#starting value to increment from
	li $t2, 32		#number of increments
	li $t3, 1
	li $t7, 1
	li $t6, 0	
start_loop:			#this loop gooes 32 toops with a maks to determiine if there is a one in the plac.e If there is it prints if not prints 0			
	sle  $t3, $t4, 31	# if t4 is greater then t0 change t1 to 1 
	beqz $t3, end_loop      # if t1 == 1 end loops 
	and $t6, $t1, $s0 	#mask
	bnez $t6, if1          
	li    $v0, 4      
        la    $a0, binaryZero
	syscall
	srl $t1, $t1, 1
	add $t4, $t4, 1
	b start_loop
        if1:			#print 1 or not
	li      $v0, 4      
	la     $a0, binaryOne	
	syscall
	srl $t1, $t1, 1
	add $t4, $t4, 1		#iterates
	b start_loop		#restarts loop
	
end_loop:			#THIS IS EXTRA CREDIT PORTION
	li  $v0, 4
	la $a0, newLine
	syscall
	li $v0, 4
	la $a0, morseCode	#PRINT PROMPT
	syscall
	#more num  + 6 x
	add $t5, $s1, $s2
	add $t1, $s1, $s2
	div $t3, $t1,10
	rem  $t5, $t5, 10	#Determine tens and ones
	bgez   $t1, notNegative	#IF negative print morse 1 and negative sign
	li  $v0, 4
	la  $a0, negativeSign
	syscall
	add $t5, $s1, $s2
	add $t3, $s1, $s2
	mul $t3, $t3, -1
	mul $t5, $t5, -1
	div $t3, $t3,10
	blt  $t3, 10, hundred	#if hundred print 1 and subtract ten from div number 
	li $v0, 4
	la $a0, one
	syscall
	li $v0, 4
	la $a0, space
	syscall
	subi $t3, $t3, 10
	b hundred
hundred:
	rem  $t5, $t5, 10
	b notNegative
notNegative:			#does same things tha previous did but to positive numbers
	blt  $t3, 10, hundred1
	li $v0, 4
	la $a0, one
	syscall
	li $v0, 4
	la $a0, space
	syscall
	subi $t3, $t3, 10
	b hundred1
hundred1:			#does smae things for 100 but with positive number
	add $t6, $s1, $s2
	subi $t6, $t3, 0 
	bnez $t6, theOne
	b skip
theOne:				#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 1 
	bnez $t6, theTwo
	li $v0, 4
	la $a0, one
	syscall
	b skip
	li   $v0, 4
	la $a0, space
	syscall
theTwo:				#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 2
	bnez $t6, theThree
	li $v0, 4
	la $a0, two
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theThree:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 3
	bnez $t6, theFour 
	li $v0, 4
	la $a0, three
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theFour:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 4
	bnez $t6, theFive 
	li $v0, 4
	la $a0, four
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip	
theFive:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 5
	bnez $t6, theSix 
	li $v0, 4
	la $a0, five
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theSix:				#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 6
	bnez $t6, theSeven 
	li $v0, 4
	la $a0, six
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theSeven:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 7
	bnez $t6, theEight 
	li $v0, 4
	la $a0, seven
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theEight:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	subi $t6, $t3, 8
	bnez $t6, theNine
	li $v0, 4
	la $a0, eight 
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
theNine:			#SUBTRACT BY NUMBER TO DETERMINE WHAT NUMBER IT IS THEN PRINT THE MORSE CODE FOR IT
	bnez $t6, skip
	subi $t6, $t3, 9
	li $v0, 4
	la $a0, nine
	syscall
	li   $v0, 4
	la $a0, space
	syscall
	b skip
#-------------------
skip:			#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	li $t6, 0
	subi $t6, $t5, 0 
	bnez $t6, theOne1
	li $v0, 4
	la $a0, zero
	syscall
	b exit
theOne1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 1 
	bnez $t6, theTwo1
	li $v0, 4
	la $a0, one
	syscall
	b exit
theTwo1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 2
	bnez $t6, theThree1
	li $v0, 4
	la $a0, two
	syscall
	b exit
	theThree1:
	subi $t6, $t5, 3
	bnez $t6, theFour1 
	li $v0, 4
	la $a0, three
	syscall
	b exit
theFour1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 4
	bnez $t6, theFive1 
	li $v0, 4
	la $a0, four
	syscall
	b exit
theFive1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 5
	bnez $t6, theSix1
	li $v0, 4
	la $a0, five
	syscall
	b exit
theSix1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 6
	bnez $t6, theSeven1 
	li $v0, 4
	la $a0, six
	syscall
	b exit
theSeven1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 7
	bnez $t6, theEight1 
	li $v0, 4
	la $a0, seven
	syscall
	b exit
theEight1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 8
	bnez $t6, theNine1
	li $v0, 4
	la $a0, eight 
	syscall
	b exit
theNine1:		#DETERMINES WHAT TO PRINT IN IN REGARDS TO MORSE IN THE ONES PLACE
	subi $t6, $t5, 9
	li $v0, 4
	la $a0, nine
	syscall
	b exit
exit:			#exit program
	li $v0, 4
	la $a0 newLine
	syscall 
       	li      $v0,10       
	syscall


            .data
space:      .asciiz      " "
newLine:    .asciiz     "\n"
test:       .asciiz     "TEST"
test1:      .asciiz     "TEST1"
test2:      .asciiz     "TEST2"
test3:      .asciiz     "TEST3"
prompt:     .asciiz     "You entered the decimal numbers:\n"
prompt1:    .asciiz     "\nThe sum in decimal is:\n"
prompt2:    .asciiz     "\nThe sum in two's complement binary is:\n"
zero:       .asciiz     "-----"
one:        .asciiz     ".----"
two:        .asciiz     "..---"
three:      .asciiz     "...--"
four:       .asciiz     "....-"
five:       .asciiz     "....."
six:        .asciiz     "-...."
seven:      .asciiz     "--..."
eight:      .asciiz     "---.."
nine:       .asciiz     "----."
binaryOne:  .asciiz     "1"
binaryZero: .asciiz     "0"
morsecodehax: .asciiz   "----.....-----"
negativeSign: .asciiz   "-"
morseCode:    .asciiz   "\nThe sum in Morse code is:\n"