# Developer: Jiajie Dang
# Email: djjkobe@gmail.com
=====================================
.data
flyx: .word 0
flyy: .word 3
newflyx: .word 0
newflyy: .word 30 
cur_x:	.word	32
cur_y:	.word	4
new_x:	.word	32
new_y:	.word	32
col_red: 	.word	1
col_ylw:	.word	2
col_grn:	.word	3
col_blk:	.word	0
leftFly: .word 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
rightFly: .word 61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61
m1: .asciiz "Game forfeited. Your score was "
m2: .asciiz "Game finished. Your score was"
.text
li $t8,0
# create a fly at (0,3)
li $v0,42
li $a1,64
syscall
add $s3,$0,$a0
li $v0,42
li $a1,2
syscall
beq $a0,0,oneway
add $a1,$0,$s3
li $a0,4
li $a2,2
jal setLED
la $a0,leftFly
mul $a1,$a1,4
add $a0,$a0,$a1

li $a1,4
sw $a1,0($a0)
j combine	
oneway:
add $a1,$0,$s3
li $a0,60
li $a2,2
jal setLED
la $a0,rightFly
mul $a1,$a1,4
add $a0,$a0,$a1

li $a1,60
sw $a1,0($a0)	
combine:
li $fp,0
	# draw the LED
	lw	$a0, cur_x
	lw	$a1, cur_y
	lw	$a2, col_grn
	jal	_setLED
	
		
	

_poll:
	beq $t8,28,_exit
	li	$t0, 0xFFFF0000
	lw	$t1, ($t0)
	andi	$t1, $t1, 1
	beq	$t1, $zero, moveFly
	
	# key was pressed
	li	$t0, 0xFFFF0004
	lw	$t1, ($t0)
	
	# 66 - C, 224 - U, 225 - D, 
	# 226 - L, 227 - R
	beq	$t1, 66,  PRINT_C_KEY
	beq	$t1, 224, PRINT_U_KEY
	beq	$t1, 225, PRINT_D_KEY
	beq	$t1, 226, PRINT_L_KEY
	beq	$t1, 227, PRINT_R_KEY
moveFly:	
	beq $fp,64,attention
	j attentionback
	attention:
	li $fp,0
	
	attentionback:
	la $a0,leftFly
	mul $a1,$fp,4
	add $a0,$a0,$a1
	lw $t0,0($a0)
	add $s0,$0,$t0
	add $s1,$0,$fp
	addi $fp,$fp,1
	beq $s0,32,_exit
	beq $s0,3,rightturn

	li $t7,640
	add $a3,$0,$a0
		
	li $v0,30
	syscall 
	add $k1,$a0,$0
	
begincircle:
	li $v0,30
	syscall
	add $t9,$a0,$0
	sub $t9,$t9,$k1
	bleu   $t9,$t7,begincircle
	
	

	
	# update LED
	add	$t2,$0,$s0 
	
	addi	$t2, $t2, 1
	
	
	add $a0,$0,$a3
	sw	$t2, 0($a0)
	jal	UpdateLED1


############################################
	rightturn:
	
	
	
	
	subi $fp,$fp,1
	la $a0,rightFly
	mul $a1,$fp,4
	add $a0,$a0,$a1
	lw $t0,0($a0)
	add $s0,$0,$t0
	add $s1,$0,$fp
	addi $fp,$fp,1
	beq $s0,32,_exit
	beq $s0,61,_poll
	
	li $t7,640
	add $a3,$0,$a0

		li $v0,30
	syscall 
	add $k1,$a0,$0
	
begincircle1:
	li $v0,30
	syscall
	add $t9,$a0,$0
	sub $t9,$t9,$k1
	bleu   $t9,$t7,begincircle1
	
	# update LED
	add	$t2,$0,$s0 
	
	subi	$t2, $t2, 1
	
	
	add $a0,$0,$a3
	sw	$t2, 0($a0)
	jal	UpdateLED2	
	
	
	j	_poll
		
		
								
PRINT_C_KEY:
	
	
	
	j	_exit1

PRINT_U_KEY:
	# update LED
	lw	$t2, cur_y
	beq	$t2, 0, HIT_TOP
	subi	$t2, $t2, 1
	j	STORE_U_Y
	HIT_TOP:
	li	$t2, 63
	STORE_U_Y:	
	sw	$t2, new_y
	jal	UpdateLED
	
	j moveFly
	
PRINT_D_KEY:
	# update LED
	lw	$t2, cur_y
	beq	$t2, 63, HIT_BOTTOM
	addi	$t2, $t2, 1
	j	STORE_D_Y
	HIT_BOTTOM:
	li	$t2, 0
	
	STORE_D_Y:
	sw	$t2, new_y
	jal	UpdateLED
	j moveFly

#################################################
PRINT_L_KEY:
 lw $a0, cur_y

 
 add $s1,$0,$a0
 la $a1,leftFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
 lw $a1,0($a1)
 blt $a1,7,moveFly
 addi $t8,$t8,1
 add $s0,$0,$a1
 lw $a2,col_red
 subi $t5,$s0,31
 sub  $t5,$0,$t5
 j drawLine1

drawLine1:
redo1:
jal _setLED1
addi $s0,$s0,1
beq $s0,31,breakout1
j redo1


breakout1:
li $v0,32
li $a0,200
syscall

 lw $a0, cur_y
 add $s1,$0,$a0
lw $a0, cur_y
 add $s1,$0,$a0
 la $a1,leftFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
 lw $a1,0($a1)
 add $s0,$0,$a1
subi $t5,$s0,31


li $a2,0
j drawLine21
drawLine21:
redo21:
jal _setLED1
addi $s0,$s0,1
beq $s0,31,generateTwoMore1
j redo21



generateTwoMore1:
lw $a0, cur_y
 add $s1,$0,$a0
 la $a1,leftFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
li $s5,3
sw $s5,0($a1)

li $a1,2
li $v0,42
syscall
beq $a0,1,leftside
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,rightFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,61,donotadd12
li $a1,60
sw $a1,0($t0)
li $a0,60
add $a1,$0,$s7
li $a2,2
jal setLED
donotadd12:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,rightFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,61,moveFly
li $a1,60
sw $a1,0($t0)
li $a0,60
add $a1,$0,$s7
li $a2,2
jal setLED


lw $s5,cur_y
mul $s5,$s5,4
la $a0,rightFly
add $a0,$a0,$s5
li $a1,61
sw $a1,0($a0)
j moveFly

leftside:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,leftFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,3,donotadd22
li $a1,4
sw $a1,0($t0)

li $a0,4
add $a1,$0,$s7
li $a2,2
jal setLED
donotadd22:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,leftFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,3,moveFly
li $a1,4
sw $a1,0($t0)
li $a0,4
add $a1,$0,$s7
li $a2,2
jal setLED


j moveFly
###################################################################

PRINT_R_KEY:			
 lw $a0, cur_y

 
   add $s1,$0,$a0
 la $a1,rightFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
 lw $a1,0($a1)
 bgt $a1,57,moveFly
 addi $t8,$t8,1
 add $s0,$0,$a1
 lw $a2,col_red
 subi $t5,$s0,31
 
 j drawLine


drawLine:
redo:
jal _setLED1
subi $s0,$s0,1
beq $s0,33,breakout
j redo


breakout:
li $v0,32
li $a0,200
syscall

 lw $a0, cur_y
 add $s1,$0,$a0
lw $a0, cur_y
 add $s1,$0,$a0
 la $a1,rightFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
 lw $a1,0($a1)
 add $s0,$0,$a1
subi $t5,$s0,31


li $a2,0
j drawLine2
drawLine2:
redo2:
jal _setLED1
subi $s0,$s0,1
beq $s0,33,generateTwoMore
j redo2



generateTwoMore:
lw $a0, cur_y
 add $s1,$0,$a0
 la $a1,rightFly
 mul $a0,$a0,4
 add $a1,$a1,$a0
 li $s5,61
 sw $s5,0($a1)

li $a1,2
li $v0,42
syscall
beq $a0,0,leftside1
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,rightFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,61,donotadd1
li $a1,60
sw $a1,0($t0)

li $a0,60
add $a1,$0,$s7
li $a2,2
jal setLED
donotadd1:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,rightFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,61,moveFly
li $a1,60
sw $a1,0($t0)
li $a0,60
add $a1,$0,$s7
li $a2,2
jal setLED



j moveFly

leftside1:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,leftFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,3,donotadd2
li $a1,4
sw $a1,0($t0)

li $a0,4
add $a1,$0,$s7
li $a2,2
jal setLED
donotadd2:
li $a1,64
li $v0,42
syscall
add $s7,$0,$a0
la $t0,leftFly
mul $a0,$a0,4
add $t0,$t0,$a0
lw $t5,0($t0)
bne $t5,3,moveFly
li $a1,4
sw $a1,0($t0)
li $a0,4
add $a1,$0,$s7
li $a2,2
jal setLED



j moveFly




_exit:
	la $a0,m2
	li $v0,4
	syscall
	add $a0,$0,$t8
	li $v0,1
	syscall
	li	$v0, 10
	syscall

_exit1:
	la $a0,m1
	li $v0,4
	syscall
	add $a0,$0,$t8
	li $v0,1
	syscall
	
	li $v0,10
	syscall


UpdateLED:
	subi	$sp, $sp, 8
	sw	$ra, 0($sp)
	sw	$t1, 4($sp)

	# clear cur position
	lw	$a0, cur_x
	lw	$a1, cur_y
	lw	$a2, col_blk
	jal	_setLED
	
	# draw new postion
	lw	$a0, new_x
	lw	$a1, new_y
	lw	$a2, col_grn
	jal	_setLED

	# update cur position 
	lw	$t1, new_x
	sw	$t1, cur_x
	lw	$t1, new_y
	sw	$t1, cur_y

	lw	$ra, 0($sp)
	lw	$t1, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra

setLED:
	subi	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)

	jal	_setLED

	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t3, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra

	# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=orange, 3=green
	#
	# warning:   x, y and color are assumed to be legal values (0-63,0-63,0-3)
	# arguments: $a0 is x, $a1 is y, $a2 is color 
	# trashes:   $t0-$t3
	# returns:   none
	#
_setLED:
	
	
	# byte offset into display = y * 16 bytes + (x / 4)
	sll	$t0,$a1,4      # y * 16 bytes
	srl	$t1,$a0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008	# base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$a0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
				
_getLED:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll  $t0,$a1,4      # y * 16 bytes
	srl  $t1,$a0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$a0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	jr   $ra




UpdateLED1:
	subi	$sp, $sp, 8
	sw	$ra, 0($sp)
	sw	$t1, 4($sp)

	# clear cur position
	
	lw	$a2, col_blk
	jal	setLED1
	
	# draw new postion
	addi    $s0,$s0,1
	lw	$a2, col_ylw
	jal	setLED1

	# update cur position 
	

	lw	$ra, 0($sp)
	lw	$t1, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra

UpdateLED2:
	subi	$sp, $sp, 8
	sw	$ra, 0($sp)
	sw	$t1, 4($sp)

	# clear cur position
	
	lw	$a2, col_blk
	jal	setLED1
	
	# draw new postion
	subi    $s0,$s0,1
	lw	$a2, col_ylw
	jal	setLED1

	# update cur position 
	

	lw	$ra, 0($sp)
	lw	$t1, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra


setLED1:
	subi	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)

	jal	_setLED1

	lw	$ra, 0($sp)
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t3, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra

	# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=orange, 3=green
	#
	# warning:   x, y and color are assumed to be legal values (0-63,0-63,0-3)
	# arguments: $a0 is x, $a1 is y, $a2 is color 
	# trashes:   $t0-$t3
	# returns:   none
	#
_setLED1:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll	$t0,$s1,4      # y * 16 bytes
	srl	$t1,$s0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008	# base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$s0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
				
_getLED1:
	# byte offset into display = y * 16 bytes + (x / 4)
	sll  $t0,$s1,4      # y * 16 bytes
	srl  $t1,$s0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$s0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	jr   $ra
