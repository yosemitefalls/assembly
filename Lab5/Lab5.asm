############################################################################
# Created by: Bernstein, Aidan
# 1676767
# 1 december 2018
#
# Assignment: Lab 5: Subroutines
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: This program will display a string and prompt the user to type the same string in a
#given time limit. It will check if this string is identical to the given one and
#whether the user made the time limit. If the user types in the prompt incorrectly or
#does not finish the prompt in the given time limit, the game is over.
#
# Notes: This program is intended to be run from the MARS IDE.
############################################################################0 
#--------------------------------------------------------------------
.text
# register use age
# input: $a0 - address of type prompt printed to user
# $a1 - time type prompt was given to user
# $a2 - contains amount of time allowed for response
# $t0-t7 - used as temp registers to store a variety things
# $ra - used in jump and links as well stack
# sp - used for stack
# v0 - used to fail or succeed value
#-------------------------------------------------------------
give_type_prompt:		#PRINTS PROMPT STORES TIME IN V0
	move $t1, $a0		#stores intial string in temp register $t0
	li   $v0, 4		
	la   $a0, prompt	#print prompt
	syscall
	li   $v0, 4
	la   $a0, ($t1)		#print the string 
	syscall
	li   $v0 30		#set time stamp to initial
	syscall
	move $v0 $a0		#store initial time stamp in $v0
	jr   $ra		#return to call
check_user_input_string:	#scan user input store it - decipher time it took to type took to long, 
	move $t6, $a0		#store initial time in temp reg
	move $t0 $a1		#store initial string in temp reg 
	la   $a0, buffer	#load allocated space
	li   $a1, 100		#allocate space
	li   $v0, 8		#8 scans string- the integer and save it in $t0
	syscall			
	move $t4, $a0		#move user input in temp reg
	li   $v0 30
	syscall			#get end user time
	sub $t5, $a0, $t0	#subtract  end time and start time to get total time
	bgt $t5, $a2, FAILED	#if total time is greater alloted time branch
	b ELSE			#if not branch
FAILED:				#YOU FAILED IF TIME TOO LONG
	li $v0, 0
	jr $ra			#return with fail condition stored
ELSE:
	move $a0, $t6		#put em bacmin	
	move $a1, $t4		#put em back in
	addi $sp, $sp, -4 	#save space on the stack (push) for the $ra
	sw   $ra, 0($sp) 	#save $ra								 									
	jal  compare_strings	#JUMP AND LINK to compare string
	lw   $ra, 0($sp) 	#restore $ra
	addi $sp, $sp, 4	#return the space on the stack (pop)
	jr   $ra		#return
compare_strings:		#COMPARE STRINGS... ITERATE THROUGH EACH STRING STORING EACH CHAR OF BOTH STRINGS INTO A0-A1. IF 
	move $t6, $a0		#store a temp of string in t6
	move $t7, $a1		#store a temp of string in t7
start_loop: 
	lb   $t0 ($t6)		#store char in t0
	lb   $t1 ($t7)		#store char in t1
	beqz $t0 end_loop 	#if $t0 is null branch 
 	beqz $t1 end_loop	#if #t1 is null branch
	lb   $a1, ($t7)		#load iterated char
	lb   $a0, ($t6)		#load iterated char
	add  $t6, $t6, 1	#iterate
	add  $t7, $t7, 1 	#iterate
	addi $sp, $sp, -4 	#save space on the stack (push) for the $ra
	sw   $ra, 0($sp) 	#save $ra
	jal compare_chars
	lw   $ra, 0($sp) 	#restore $ra
 	addi $sp, $sp, 4	#return the space on the stack (pop)
 	beqz $v0, end_loop	#if vo is zero after entering compare chars exit
	b         start_loop	
end_loop:			#end loop and return
	jr $ra
compare_chars:			#FIGURES OUT IF BOTH CHARS STORED AT THE TIME ARE EQUAL, IF NOT RETURN 0 
	bne $a0, $a1 NOTEQUAL	#if not equal branch
	li  $v0, 1 
	jr  $ra
NOTEQUAL:			#stores 0 in v0- lose game
	li  $v0, 0
	jr  $ra

#-------------------------------------------------------------------

	.data
prompt: .asciiz     		"Type Prompt: "

buffer: .space 101 		#1024 maximum, plus a terminator
