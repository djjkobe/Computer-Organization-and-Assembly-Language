# Jiajie Dang
# djjkobe@gmail.com
===========================

.data
buffer2:  .space 64
buffer5:  .space 64
buffer3:  .space 64
buffer4:  .space 64
buffer7: .space 64
buffer6: .space 64
buffer8: .space 64
digit_to_hex:	.byte	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
registers: .asciiz  "$zero ","$at ","$v0 ","$v1 ","$a0 ","$a1 ","$a2 ","$a3 ","$t0 ","$t1 ","$t2 ","$t3 ","$t4 ","$t5 ","$t6 ","$t7 ","$s0 ","$s1 ","$s2 ","$s3 ","$s4 ","$s5 ","$s6 ","$s7 ","$t8 ","$t9 ","$k0 ","$k1 ","$gp ","$sp ","$fp ","$ra "
newline: .asciiz "\n"
left:.asciiz "( "
right:.asciiz ")"

numbers : .word 0x00000000,0x20000000,0x00000000,0x34000000,0x8c000000,0xac000000,0x08000000,0x10000000,0x14000000
x: .word

guessanswer: .space 16
guess: .space 16
answer:.space 64  
display: .space 64
string: .asciiz "Ox"
opcodes: .asciiz "add ","addi ","or ","ori ","lw ","sw ","j ","beq ","bne "
welcome: .asciiz  "Welcome to Scrambled ASM!\n"
show1: .asciiz  "Machine code (guess the '*'): "
show2:.asciiz "Enter guess( '0' or '1') for stars (without space), '.'to end, or '?' to show answer: "
show3: .asciiz  "Correct answer is : "
show4: .asciiz "Answer: "
show5 : .asciiz "Thank you playing! Goodbye!"
y:.asciiz 
warn: .asciiz "Invalid input, try again!\n"
score: .asciiz "Your score is: "
extra: .asciiz "The correct machine code is "
.text
everythingstart:
# first I need to create a 32-byte instruction
# print the "Welcome to Scrambled Asm"
la $a0,welcome
li $v0,4
syscall
#creat a 32-bit number and store it into x
la $s0,x
li $s0,0
# randomly creat a number between [0,8]
li $v0,42
li $a1, 8
syscall
#put this number into $t9
add $t9,$t9,$a0
#check each situation to decide the opcode
beq $a0,0,case1
beq $a0,2,case2
beq $a0,6,case3
j case4
# add 
case1:
# copy mumber into $fp
li $fp,0
# if the opcode is "add"
# creat the 26-bits besides opcede and save it into x
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,5
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,5
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,11
la $s1,numbers
# $s0 contains the whole instruction
lw $t1,0($s1)
or $s0,$s0,$t1
ori $s0,$s0,0x00000020
j continue

# or
case2:
li $fp,2
#if the opcode is "or"
# store "or" into $t6
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,5
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,5
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,11
la $s1,numbers
# $s0 contains the whole instruction
lw $t1,0($s1)
or $s0,$s0,$t1
ori $s0,$s0,0x00000025
j continue

# j
case3:
li $fp,6
# if the opcode is "j"
#store "j" into $t6
la $t6,opcodes
addi $t6,$t6,24
li $v0,42
li $a1,67108863
syscall
or $s0,$s0,$a0
la $s1,numbers
# $s0 contains the whole instruction
lw $t1,24($s1)
or $s0,$s0,$t1
j continue

# rest of the case
case4:
# store the corrisponding opcodes into $t6
addi $t9,$a0,0
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,5
la $t6,opcodes
li $v0,42
li $a1,31
syscall
or $s0,$s0,$a0
sll $s0,$s0,16
la $t6,opcodes
li $v0,42
li $a1,65535
syscall
or $s0,$s0,$a0
la $s1,numbers
mul $t9,$t9,4
add $s1,$s1,$t9
lw $t1,0($s1)
#store opcode
beq $t1,0x20000000,store1
beq $t1,0x34000000,store3
beq $t1,0x8c000000,store4
beq $t1,0xac000000,store5
beq $t1,0x10000000,store7
beq $t1,0x14000000,store8
continue5:
or $s0,$s0,$t1
j continue

# right now, $s1 has the whole 32-bit numbers, and we need to save it into x
continue:
li $s1,0
move $s1,$s0
# store the instruction back into x, now x has a 32-byte instruction£¡£¡£¡£¡£¡£¡£¡
la $s0,x
sw $s1,0($s0)
# $s5 contains the address of x, $s6 contains the content of x
add $s5,$s0,$0
add $s6,$s1,$0

# change the instruction(word) into a string and store it into "answer" and "display" 
# convert1 is used to transfer word into string
jal convert1
#now we need to print the instruction

# store another one into display
la $a0,answer
li $k0,8
la $a1,display
small:
beq $k0,0,endsmallloop
lw $t5,0($a0)
sw $t5,0($a1)
add $a0,$a0,4
add $a1,$a1,4
subi $k0,$k0,1
j small
endsmallloop:
#now, in both display and answer, we have the instruction.

la $t0,answer
la $t1,display
li $a0,0
li $a1,0
li $t2,0
li $t3,0
li $t5,0

li $a0,0
#now we need to print the assembly language

# first, we need to print out the "opcode"  like "add", "or"......
move $a1,$fp
la	$a0, opcodes
# GETNAME is used to find the corresponding opcode
jal	GETNAME	
move	$t1, $v0	# t1 = returned address in v0

# print returned string
li	$v0, 4
move	$a0, $t1
syscall
#now, we have printed the opcode, we need to continue printing the rest of the assembly lanaguage
j keepgoing

# GETNAME finds an item from an array at index
# takes a0 = address of the array, a1 = index
# returns v0 = address of the item
GETNAME:
# s0 = array address
# s1 = running index
# s2 = user requested index
move	$s0, $a0
li	$s1, 0
move	$s2, $a1

# check if the 0th item is requested or not
beq	$s1, $s2, GN_ITEM_FOUND

GN_LOOP:
lb	$s3, ($s0)
beq	$s3, $zero, GN_NULL_FOUND
addi	$s0, $s0, 1	# next byte (of current string)
j	GN_LOOP

GN_NULL_FOUND:
addi	$s1, $s1, 1	# update running index
addi	$s0, $s0, 1	# next byte (start of next string)
beq	$s1, $s2, GN_ITEM_FOUND	# index match
j 	GN_LOOP	# index did not match

GN_ITEM_FOUND:
move	$v0, $s0	
jr	$ra

keepgoing:
#go to each branch and continue printing
li $v1,0
li $a0,0
li $a1,0
li $a2,0
li $a3,0
li $t0,0
li $t1,0
li $t2,0
li $t3,0
li $t4,0
li $t5,0
li $t6,0
li $t7,0
li $s0,0
li $s1,0
li $s2,0
li $s3,0
li $s4,0
li $s5,0
li $s6,0
li $s7,0
li $t8,0



beq $fp,0,addor
beq $fp,2,addor
beq $fp,7,beqbne
beq $fp,8,beqbne
beq $fp,6,jump
beq $fp,1,Addi
beq $fp,3,Addi
beq $fp,4,Lw
beq $fp,5,Lw
finalgoing:
li $v0,4
la $a0,newline
syscall


li $v0,4
la $a0,show1
syscall




la $a0,display
#move the address of the string to $s0
move $s0,$a0
oncemore:
li $v0,42
li $a1,8
syscall
beq $a0,0,oncemore
move $v0,$a0
li $k1,0
add $k1, $k1,$v0
#move the number to $t0
add $t0, $v0,$0
#start doing!
jal ReplaceChars



li $v0,4
la $a0,display
syscall
la $a0,newline
syscall

la $t5,guess

la $s0,answer
la $a0,display
li $t0,32
repeatagain:
bingoback:
beq $t0,0,bingofinish
lbu $t1,0($a0)
add $a0,$a0,1
addi $s0,$s0,1
subi $t0,$t0,1
beq $t1,0x2A,bingo
j bingoback

bingofinish:

li $v0,4
la $a0,show2
syscall

li $v0,8
li $a1,0
addi $a1, $k1,1
la $a0,guessanswer
syscall

la $a0,guessanswer
lbu $a1,0($a0)
beq $a1,0x3f,showtheguess
beq $a1,0x2e,everythingfinish
beq $a1,0x0a,warning
add $a0, $a0,$k1
subi $a0,$a0,1
lbu $t4,0($a0)
beq $t4,0,warning
beq $t4,0x0a,warning
la $a0,guessanswer
la $a1,guess

li $t7,0
calculate:
beq $k1,0,checkscore
lbu $s0,0($a0)
lbu $s1,0($a1)
beq $s0,$s1,increasetwo
backincrease:
subi $t7,$t7,1
subi $k1,$k1,1
addi $a0,$a0,1
addi $a1,$a1,1
j  calculate

increasetwo:
addi $t7,$t7,2
subi $k1,$k1,1
addi $a0,$a0,1
addi $a1,$a1,1
j calculate

checkscore:
la $a0,newline
li $v0,4
syscall
la $a0,show3
syscall

la $a0,answer
syscall
li $v0,4
la $a0,newline
syscall
la $a0,score
li $v0,4
syscall
li $v0,1
move $a0,$t7

syscall
la $a0,newline
li $v0,4
syscall
j nearlyfinish

everythingfinish:
la $a0,newline
li $v0,4
syscall
la $a0,show5
syscall
li $v0,10
syscall



bingo:
subi $s0,$s0,1
lbu $t2 ,0($s0)
addi $s0, $s0,1
sb $t2,0($t5)
addi $t5,$t5,1
j bingoback


ReplaceChars:
li $s1,0
start:
#check  
slt $s5,$s1,$t0

beq $s5,1,loop
jr $ra

loop:
#generate an random number
li $v0, 42
li $a1,32
# restrict the number to be less than the number user input

repeat:
syscall

#put the random number into $s0
add $s0,$s0,$a0

lb $t5, 0($s0)
beq $t5,0x00,temp
beq $t5,0x0a,temp
beq $t5,0x20,temp
beq $t5,0x2A,temp
li $t5,0x2A
sb $t5,0($s0)
sub $s0,$s0,$a0
addi $s1,$s1,1
j start

temp:
sb $t5,0($s0)
sub $s0,$s0,$a0
j repeat

warning:
la $a0,warn
li $v0,4
syscall
la $a0, guessanswer
li $a1,0
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
li $v0,4
la $a0,newline
j bingofinish

showtheguess:
lbu $k0,1($a0)
beq $k0,0,addnewline

addnewlineback:
li $v0,4
la $a0,show4
syscall

la $a0,guess
li $v0,4
syscall

la $a0,newline
li $v0,4
syscall

la $a0,extra
li $v0,4
syscall
la $a0,answer
syscall
la $a0,newline
syscall
j nearlyfinish2


nearlyfinish:
la $a0, guessanswer
li $a1,0
sw $a1,0($a0)
sw $a1,4($a0)

la $a0,guess
li $a1,0
sw $a1,0($a0)
sw $a1,4($a0)

la $a0,answer
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,display 
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,x
sw $a1,0($a0)
la $a0,buffer2
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,buffer3
sw $a1,0($a0)
sw $a1,4($a0)
la $a0,buffer4
sw $a1,0($a0)
sw $a1,4($a0)
la $a0,buffer5
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,buffer6
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,buffer7
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)
la $a0,buffer8
sw $a1,0($a0)
sw $a1,4($a0)
sw $a1,8($a0)
sw $a1,12($a0)

li $v0,0
li $a0,0
li $a1,0
li $a2,0
li $a3,0
li $t0,0
li $t1,0
li $t2,0
li $t3,0
li $t4,0
li $t5,0
li $t6,0
li $t7,0
li $s0,0
li $s1,0
li $s2,0
li $s3,0
li $s4,0
li $s5,0
li $s6,0
li $s7,0
li $t8,0
li $t9,0
li $k0,0
li $k1,0
li $sp,0
la $a0,newline
li $v0,4
syscall
j everythingstart



convert1:
# change and store into "answer"
la $t3,answer
lw $s5,0($s5)
move $t2, $s5      # Move the value to a different regsiter
        li $s6, 32       # Set up a loop counter
Loop:
        rol $t2, $t2, 1    # Roll the bits left by one bit - wraps highest bit to lowest bit (where we need it!)
        and $t0, $t2, 1    # Mask off low bit (logical AND with 000...0001)
        add $t0, $t0, 48   # Combine it with ASCII code for '0', becomes 0 or 1 
        sb $t0,0($t3)
     	addi $t3,$t3,1
        
        subi $s6, $s6, 1   # Decrement loop counter
        bne $s6, $zero, Loop  # Keep looping if loop counter is not zero
	addi $t3,$t3,1
	li $t0,0
	sb $t0,0($t3)

# Output third string.
       
jr $ra


addor:
la $a0,x
lw $t1,0($a0)
sll $t1,$t1,16
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME
la $s6,buffer2
addfindloop1:
lb $s7,0($v0)
beq $s7,0,addend1
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j addfindloop1
addend1:








la $a0,x
lw $t1,0($a0)
sll $t1,$t1,6
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME

addfindloop2:
lb $s7,0($v0)
beq $s7,0,addend2
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j addfindloop2
addend2:

move $a0,$s6




la $a0,x
lw $t1,0($a0)
sll $t1,$t1,11
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME

addfindloop3:
lb $s7,0($v0)
beq $s7,0,addend3
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j addfindloop3

addend3:
move $a0,$s6

la $a0, buffer2
li $v0,4
syscall
j finalgoing


beqbne:
la $a0,x
lw $t1,0($a0)
sll $t1,$t1,6
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME
la $s6,buffer6
beqfindloop1:
lb $s7,0($v0)
beq $s7,0,beqend1
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j beqfindloop1
beqend1:


la $a0,x
lw $t1,0($a0)
sll $t1,$t1,11
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME

beqfindloop2:
lb $s7,0($v0)
beq $s7,0,beqend2
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j beqfindloop2
beqend2:

li $v0,4
la $a0,buffer6
syscall

la $a0,string
li $v0,4
syscall
#
	# set default value for t0 (the variable "num")
	la		$t0,x
	lw		$t0,0($t0)
	##########################################################
	# correct answer is below
	#
	# note that $t3 is decrement by 1 byte each time through
	# the loop. this lets us work from the rightmost char in
	# the string to the leftmost char.
	#
	# also, note that $t1 was set to 8 so that we can do a
	# simple test against $0 to finish the loop.
	##########################################################
	#
	li		$t1,4				# 8 binary digits to convert
	la		$t2,digit_to_hex		# ptr to lookup table
	la		$t3,buffer5+3				# ptr to output buffer
L1:	
	andi	$t4,$t0,0xF				# extract digit
	add		$t5,$t2,$t4				# address into table
	lb		$t5,0($t5)				# table lookup
	sb		$t5,0($t3)				# set hex character in buf
	srl		$t0,$t0,4				# shift to next digit
	addi	$t3,$t3,-1				# next position in buf
	addi	$t1,$t1,-1				# loop index variable
	bne		$t1,$0,L1				# more digits?
	#
	# ok, buf now has a string for the number
	# print it to the display
	#
	la		$a0,buffer5
	li		$v0,4
	syscall
j finalgoing


jump:
la $a0,string
li $v0,4
syscall
	# set default value for t0 (the variable "num")
	la		$t0,x
	lw		$t0,0($t0)
	sll $t0,$t0,6
	srl $t0,$t0,6
	##########################################################
	# correct answer is below
	#
	# note that $t3 is decrement by 1 byte each time through
	# the loop. this lets us work from the rightmost char in
	# the string to the leftmost char.
	#
	# also, note that $t1 was set to 8 so that we can do a
	# simple test against $0 to finish the loop.
	##########################################################
	#
	li		$t1,7				# 8 binary digits to convert
	la		$t2,digit_to_hex		# ptr to lookup table
	la		$t3,buffer8+6				# ptr to output buffer
jL1:	
	andi	$t4,$t0,0xF				# extract digit
	add		$t5,$t2,$t4				# address into table
	lb		$t5,0($t5)				# table lookup
	sb		$t5,0($t3)				# set hex character in buf
	srl		$t0,$t0,4				# shift to next digit
	addi	$t3,$t3,-1				# next position in buf
	addi	$t1,$t1,-1				# loop index variable
	bne		$t1,$0,jL1				# more digits?
	#
	# ok, buf now has a string for the number
	# print it to the display
	#
	la		$a0,buffer8
	li		$v0,4
	
	syscall
	#
	# terminate the program
	#
	j finalgoing

	
Addi:
la $a0,x
lw $t1,0($a0)
sll $t1,$t1,11
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME
la $s6,buffer7
addifindloop1:
lb $s7,0($v0)
beq $s7,0,addiend1
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j addifindloop1
addiend1:


la $a0,x
lw $t1,0($a0)
sll $t1,$t1,6
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME

addifindloop2:
lb $s7,0($v0)
beq $s7,0,addiend2
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j addifindloop2
addiend2:
la $a0,buffer7
li $v0,4
syscall


la $a0,x
lh $t1,0($a0)

move $a0,$t1
li $v0,1
syscall 

j finalgoing

Lw:	
la $a0,x
lw $t1,0($a0)
sll $t1,$t1,11
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME
la $s6,buffer3
lwfindloop1:
lb $s7,0($v0)
beq $s7,0,lwend1
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j lwfindloop1
lwend1:

la $a0,buffer3
li $v0,4
syscall

la $a0,x
lh $t1,0($a0)

move $a0,$t1
li $v0,1
syscall

li $v0,4
la $a0,left
syscall


la $a0,x
lw $t1,0($a0)
sll $t1,$t1,6
srl $t1,$t1,27
move $a1,$t1
la $a0,registers
jal GETNAME
la $s6,buffer4
lwfindloop2:
lb $s7,0($v0)
beq $s7,0,lwend2
sb $s7,0($s6)
addi $s6,$s6,1
addi $v0,$v0,1
j lwfindloop2
lwend2:

la $a0,buffer4
li $v0,4
syscall

li $v0,4
la $a0,right
syscall
j finalgoing

store1:
li $fp,1
j continue5

store3:
li $fp,3
j continue5

store4:
li $fp,4
j continue5

store5:
li $fp,5
j continue5

store7:
li $fp,7
j continue5

store8:
li $fp,8
j continue5

addnewline:
li $v0,4
la $a0,newline
syscall
j addnewlineback


nearlyfinish2:
la $a0,newline
li $v0,4
syscall
la $a0,show1
li $v0,4
syscall

la $a0,display
syscall
la $a0,newline
syscall

la $a0, guessanswer
li $a1,0
sw $a1,0($a0)
sw $a1,4($a0)





j repeatagain
