####################################################################################
# Created by: Bernstein, Aidan
# 1676767
# 5 November 2018
#
# Assignment: Lab 3: Hello Looping in MIPS
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: This program will prompt the user for a number. Next, the
# program will iterate through a set of integers (starting at 0, ending at the number
# input by the user) and print to the console one of four outputs depending on the
# number. If the number is evenly divisible by 5 (with no remainder), then the output
# is “Flux.” If the number is evenly divisible by 7, then the output is “Bunny.” If the
# number is divisible by both 5 and 7, then the output should be “Flux Bunny”. Lastly,
# if the output is not divisible by either 5 or 7, then the number itself should be
# printed.
#
# Notes: This program is intended to be run from the MARS IDE.
####################################################################################

# REGISTER USAGE
# $t0: user input
# $t2: store mod info
# $t3: store mod info
# $t4: loop counter
# $v0: system execute calls

main:					#asks users for int scans int prints info and users int
	li   $v0, 4			# 4 prints- asci prompt, asks user for int (string)
	la   $a0, prompt 		
	syscall
	
 	li   $v0, 5			# 5 scans interger- the integer and save it in $t0
	syscall			
 	move $t0, $v0			# REGISTER $t0 used to store integer froom $v0

	li   $t4, 0			# loads 0 into t4 for looping purposes
	
start_loop:				# LOOP STARTS HERE -- X = 0, X< USER INPUT - S$, X++  loops through userinput number 	
								
	sle  $t1, $t4, $t0		# if t4 is greater then t0 change t1 to 1 
	beqz $t1, end_loop      	# if t1 == 1 end loops 
	
	rem  $t2, $t4, 5		# store mod in t2
	rem  $t3, $t4, 7		# store mod in t3
	add  $t1, $t3, $t2		# arithmatic add t3 and t2 into t1
	bnez $t1, FluxCondition 	# if t1 equals zero (both mods are 0) enter branch, not go to flux condtion branc
	li   $v0, 4           
	la   $a0, FluxBunny 		# print Flux Bunny
	syscall
	
	li   $v0, 4           
	la   $a0, newLine 		# add a new line
	syscall
	
	addi $t4, $t4, 1 
	b start_loop			# iterate one t4 and restartloop
	
FluxCondition: 				#should flux be printed?
	rem  $t1, $t4, 5		# mod5 of t4 store in t1
	bnez $t1, BunnyCondition	# if t1 == 0 enter branch if not branch to BunnyCondtion
	li   $v0, 4           
	la   $a0, Flux 			# Print Flux
	syscall
	
	li   $v0, 4           		# print new line
	la   $a0, newLine 
	syscall
	
	addi $t4, $t4, 1 		# iterate one t4 and restartloop
	b start_loop
	
BunnyCondition:				#should Bunny be printed?
	rem  $t1, $t4, 7		# find mod7 of t4 store in t1
	bnez $t1, Else			# if t1 == 0 enter branch if not branch to else
	li   $v0, 4           
	la   $a0, Bunny 		# print Bunny
	syscall
	
	li   $v0, 4           
	la   $a0, newLine 		# print new line
	syscall
	
	addi $t4, $t4, 1 		# iterate one t4 and restartloop
 	b start_loop
	

Else:					#did no mods work? print out iteration number
	li   $v0, 1 
	add  $a0, $t4, $zero 		# prints t4 
	syscall
	
	li   $v0, 4           
	la   $a0, newLine 		# print new line
	syscall
	
	addi $t4, $t4, 1 		# iterate one t4 and restartloop
	b start_loop
end_loop:				# Exit the program

	li   $v0, 10			#v - 10 terminate execution
	syscall

.data
prompt:    .asciiz "Please input a positive integer: "
Flux:      .asciiz "Flux"
Bunny:     .asciiz "Bunny"
FluxBunny: .asciiz "Flux Bunny"
newLine:   .asciiz "\n" 
