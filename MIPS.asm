.data
	p_day: .space 3
	p_month: .space 3
	p_year: .space 5

	
	p_time: .asciiz "01/09/1999"
	p_time_1: .asciiz "--/--/----"
	p_convert_time: .space 20
	
	# months
	jan: .asciiz "Jan"
	feb: .asciiz "Feb"
	mar: .asciiz "Mar"
	apr: .asciiz "Apr"
	may: .asciiz "May"
	jun: .asciiz "Jun"
	jul: .asciiz "Jul"
	aug: .asciiz "Aug"
	sep: .asciiz "Sep"
	oct: .asciiz "Oct"
	nov: .asciiz "Nov"
	dec: .asciiz "Dec"
	nameOfMonth: .word jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
	daysOfMonth: .word 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	
	#weekday
	sun: .asciiz "Sun"
	mon: .asciiz "Mon"
	tues: .asciiz "Tues"
	wed: .asciiz "Wed"
	thurs: .asciiz "Thurs"
	fri: .asciiz "Fri"
	sat: .asciiz "Sat"	

	# prompt
	prompt1: .asciiz "\nNhap ngay DAY dang DD: "
	prompt2: .asciiz "\nNhap thang MONTH dang MM: "
	prompt3: .asciiz "\nNhap nam YEAR dang YYYY: "
	
	menutable: .word option1, option2, option3, option4, option5
	# menu
	MENU: .asciiz 	"\n----------Ban hay chon 1 trong cac thao tac duoi day----------\n"
	option: .asciiz	"Lua chon: "
	type: .asciiz "Loai (A/B/C): "
	result: .asciiz "\nKet qua: "
	m_continue: .asciiz "\nChon (1) de tiep tuc, (0) de thoat:  "
	leap: .asciiz " la nam nhuan."
	notleap: .asciiz " khong la nam nhuan."
	errorMessage: "\nKiem tra lai du lieu nhap vao. "
	message: "\nDu lieu nhap vao thoa man. "
	endline: .asciiz "\n"
	dateOfWeek: .asciiz "Ngay trong tuan la "
	distance:.asciiz "Khoang cach giua 2 ngay la "
.text
	.globl main

main:	
	while:
	la	$a0, p_time
	jal	Menu
	
	
	la	$a0, m_continue # If I want to continuous
	li	$v0, 4
	syscall

	li	$v0, 5
	syscall	
	beq	$v0, $0, endP
	j	while
endP:
	li	$v0, 10
	syscall
	
Menu:
	addi	$sp, $sp, -16
	sw 	$t0, 0($sp)
	sw	$ra, 4($sp)
	
	
	
	jal	Input  # Input day, month, year
	sw	$v0, 8($sp)
	
	la $a0,option
	sw $a0,12($sp)
	
	la $a0, p_time
	lw $a1, 8($sp)
	jal Strcpy	   
	
	li	$v0, 4
	la	$a0, MENU  # Print description
	syscall
	
	li $v0, 4
	lw $a0,12($sp) # Print a option
	syscall
	
	la $v0, 5 # read a int
	syscall
	
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, menutable
	add	$t0, $t0, $v0
	lw	$t0, 0($t0)
	jr	$t0
	
#---------------------------------------
option1: 
	lw $a0, 8($sp)
	li $v0, 4
	syscall

	j endM
#------------------------------------------------
option2:
	li	$v0, 4
	la	$a0, type
	syscall

	li	$v0, 12
	syscall
	
	lw	$a0, 8($sp)
	move	$a1, $v0
	jal	Convert
	sw	$v0, ($sp)
	
	la	$a0, result
	li	$v0, 4
	syscall
	
	lw	$a0, ($sp)
	li	$v0, 4
	syscall
	

	j	endM
#-------------------------------------
option3:
	li $v0, 4
	la $a0,dateOfWeek
	syscall
	lw $a0,8($sp)
	jal weekday
	move $a0,$v0
	addi $v0,$0,4
	syscall
	j endM
option4:
	jal	CheckInput  # Input day, month, 

	j endM

#-----------------------------------
option5:

	jal Input
	lw $a0,8($sp)
	add $a1,$v0,$0
	jal gettime
	add $t0,$v0,$0
	
	li $v0, 4
	la $a0,distance
	syscall
	
	addi $v0,$0,1
	addi $a0,$t0,0
	syscall
	j endM
#-----------------------------------
endM:
	# where print menu
	
	lw	$v0, 8($sp)
	lw 	$t0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 16
	jr 	$ra
#--------------------------------------------------------------

CheckInput: 	#char* Input()
	# t0 = day , t1 = month , t2 = year , t3 =dd/mm/yyyy
	addi	$sp, $sp, -40 
	sw	$ra, 36($sp)
	sw	$a0, 32($sp)
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw 	$t3, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)
	
	li	$v0, 4
	la	$a0, prompt1
	
	syscall
	la	$v0, 8
	la	$a0, p_day #  scanf p_day
	li	$a1, 3	
	syscall
	move	$t0, $a0 # s0 = a0 

	li	$v0, 4
	la	$a0, prompt2
	syscall
	la	$v0, 8
	la	$a0, p_month # scanf p_month
	li	$a1, 3	
	syscall
	move	$t1, $a0 #t1 = a0

	li	$v0, 4
	la	$a0, prompt3
	syscall
	la	$v0, 8
	la	$a0, p_year # scanf p_year
	li	$a1, 5
	syscall
	move	$t2, $a0

	lw	$a3, 12($sp)
	move	$a0, $t0
	move	$a1, $t1
	move	$a2, $t2
	
	jal	Date	
	move	$a0, $v0
	move	$t3, $v0
	jal Checkdate	# Check constraints

	bnez	$v0, exceptedCheck
	
	la	$a0, errorMessage
	li	$v0, 4
        syscall
        j endCheck
        
exceptedCheck:
	la	$a0, message
	li	$v0, 4
        syscall
	
endCheck:
	move	$v0, $t3
	
	lw	$ra, 36($sp)
	lw	$a0, 32($sp)
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t3, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 40 
	
	jr 	$ra

#--------------------------------------------------------------
Input: 	#char* Input()
	# t0 = day , t1 = month , t2 = year , t3 =dd/mm/yyyy
	addi	$sp, $sp, -40 
	sw	$ra, 36($sp)
	sw	$a0, 32($sp)
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw 	$t3, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)
	
input_againI:
	li	$v0, 4
	la	$a0, prompt1
	syscall
	la	$v0, 8
	la	$a0, p_day #  scanf p_day
	li	$a1, 3	
	syscall
	move	$t0, $a0 # s0 = a0 

	li	$v0, 4
	la	$a0, prompt2
	syscall
	la	$v0, 8
	la	$a0, p_month # scanf p_month
	li	$a1, 3	
	syscall
	move	$t1, $a0 #t1 = a0


	li	$v0, 4
	la	$a0, prompt3
	syscall
	la	$v0, 8
	la	$a0, p_year # scanf p_year
	li	$a1, 5
	syscall
	move	$t2, $a0

	lw	$a3, 12($sp)
	move	$a0, $t0
	move	$a1, $t1
	move	$a2, $t2
	
	jal	Date	
	move	$a0, $v0
	move	$t3, $v0
	jal Checkdate	# Check constraints

	bne	$v0, $0, exceptedI
	la	$a0, errorMessage
	li	$v0, 4
	syscall
	j	input_againI

	#li $v0,4
	#move $a0,$t0
	#syscall
	
exceptedI:
	move	$v0, $t3
	
	lw	$ra, 36($sp)
	lw	$a0, 32($sp)
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t3, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 40 
	
	jr 	$ra
#----------------------------------------------------------
Strcpy:  #char* Strcpy(char* dest, char* source )
	#a0 = destination , a1 = source
	addi 	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$t0, 0($sp)

	la	$s0, ($a0)
	la	$s1, ($a1)
loopS:
	lb 	$t0, 0($s1)
	beq	$t0, $0, endS
	sb	$t0, ($s0)
	addi	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j	loopS
endS:
	
	la	$v0, ($a0)

	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$t0, 0($sp)
	addi 	$sp, $sp, 16

	jr 	$ra

#------------------------------------------------------------
Date: # char* Date(char* day, char* month, char* year, char* TIME)
	# a0 = day , a1 = month , a2 = year , a3 =dd/mm/yyyy
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)

	move	$a0, $a3
	lw	$a1, 12($sp)
	jal	Strcpy
	move	$a0, $v0

	li	$t0, 47
	sb	$t0, 2($a0)
	
	la	$a0, 3($a0)
	lw	$a1, 8($sp)
	jal	Strcpy
	la	$a0, -3($v0)
	
	li	$t0, 47
	sb	$t0, 5($a0)
	
	la	$a0, 6($a0)
	lw	$a1, 4($sp)
	
	jal	Strcpy
	la	$a0, -6($v0)

	move	$v0, $a0
	

	lw	$ra, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 20
	
	jr	$ra
#------------------------------------------------------------
Day: #  int Day(char* TIME)
     # a0 = dd/mm/yyyy $v0 = word
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	li	$t1, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	move	$v0, $t0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# --------------------------------------------
Month: # int Month(char* TIME)
     # a0 = dd/mm/yyyy $v0 = word
     	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 3($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	li	$t1, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 4($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	move	$v0, $t0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# --------------------------------------------
Year:  # int Year(char* TIME)
	# a0 = dd/mm/yyyy $v0  
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	la	$a0, 6($a0)
	jal	Day
	move	$t0, $v0
	
	li	$t1, 100
	mult	$t0, $t1
	mflo	$t0

	la	$a0, 2($a0)
	jal	Day
	add	$t0, $t0, $v0

	move	$v0, $t0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
#------------------------------------------------------------------
Leapyear: # int Leapyear(char* TIME)
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$a0, 0($sp)
	
	
	jal	Year
	move	$a0, $v0
	
	
	li	$t0, 400
	div	$a0, $t0
	mfhi	$t0
	beqz 	$t0, trueL	# type 400*k , 400, 2000
	
	li	$t0, 4
	div	$a0, $t0
	mfhi	$t0
	bnez 	$t0, falseL	# type !4*k	2, 1903
	
	li	$t0, 100
	div	$a0, $t0
	mfhi	$t0
	bnez	$t0, trueL  # type 1904 type 4*k % 100 != 0
	beqz 	$t0, falseL 
		
trueL:
	addi	$v0, $0,1
	j	endL
falseL:
	addi	$v0, $0,0
endL:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$a0, 0($sp)	
	addi	$sp, $sp, 12

	jr	$ra
#---------------------------------------------------------------------

Checkdate: # int Checkdate(char* TIME)
	addi	$sp, $sp, -32
	sw	$a0, 28($sp)
	sw	$ra, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	sw	$t2, 12($sp)
	sw	$t3, 8($sp)
	sw	$t4, 4($sp)
	sw	$s0, 0($sp)
	
	lw	$a0, 28($sp)
	jal	Day
	move	$t0, $v0
	
	lw 	$a0, 28($sp)
	jal	Month
	move	$t1, $v0
	
	lw 	$a0, 28($sp)
	jal	Year
	move	$t2, $v0
		
 
	addi $t3, $0, 12
	bgt $t1, $t3, falseC # Check constraint month
	bltz $t1,falseC 
	
	la	$s0, daysOfMonth
	addi	$t3, $t1, 0
	sll	$t3, $t3, 2
	add	$s0, $s0, $t3
	lw	$t3, ($s0)    # t3 = daysOfmonth[t1] 
	
	
	blez $t0,falseC 
	
	lw $a0, 28($sp)
	jal Leapyear
	beqz $v0, februaryF  # ferb
	
	addi $t1,$t1,-2      #Is February
	bnez $t1, februaryF
	
	addi $t3, $t3, 1
februaryF:
	bgt $t0, $t3, falseC # Check constraint day
	
trueC:
	addi $v0, $0, 1
	j endC
falseC:
	addi $v0, $0, 0
endC:
	lw	$a0, 28($sp)
	lw	$ra, 24($sp)
	lw	$t0, 20($sp)
	lw	$t1, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 32

	jr 	$ra

#-----------------------------------------------------------------
# For option 2
#----------------------------------------------------------------
# -----------------------------------------------------------
Convert: #char* Convert(char* time, char type)
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$t0, 12($sp)
	sw	$t1, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)

	li	$t0, 65
	bne 	$a1, 65, typeB

	# s0 = 'MM'
	la	$s0, p_month

	# s1 = 'DD'
	la	$s1, p_day

	# $a0 = strcpy($a0, $s0)
	la 	$a1, ($s0)
	jal 	Strcpy
	move 	$a0, $v0
	la	$a0, 3($a0)

	# $a0 = strcpy($a0, $s1)
	la 	$a1, ($s1)
	jal 	Strcpy
	la 	$a0, -3($v0)
	j 	endConvert

typeB:
	bne 	$a1, 66, typeC

	jal Month
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, nameOfMonth
	add	$t0, $t0, $v0
	lw	$t0, ($t0)
	
	move $a1, $t0  # Copy month
	jal Strcpy
	
	li	$t0, 32	# space
	sb	$t0, 3($a0)
	
	la	$t0, p_day
	la	$a0, 4($a0)
	move 	$a1, $t0
	jal	Strcpy
	la	$a0, -4($v0) 
	
	li	$t0, 44	# ,
	sb	$t0, 6($a0)
	li	$t0, 32	# space
	sb	$t0, 7($a0)
	
	la 	$t1, p_year
	la	$a0, 8($a0)
	move 	$a1, $t1
	jal	Strcpy
	la	$a0, -8($v0) 
	
	li	$t0, 0	# \0
	sb	$t0, 12($a0)
	
	j 	endConvert

typeC:
	
	la	$t0, p_day
	move 	$a1, $t0
	jal	Strcpy
	
	li	$t0, 32	# space
	sb	$t0, 2($a0)
	
	jal Month
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, nameOfMonth
	add	$t0, $t0, $v0
	lw	$t0, ($t0)
	
	la $a0, 3($a0)
	move $a1, $t0  # Copy month
	jal Strcpy
	la $a0, -3($a0)
	

	li	$t0, 44	# ,
	sb	$t0, 6($a0)
	li	$t0, 32	# space
	sb	$t0, 7($a0)
	
	la 	$t1, p_year
	la	$a0, 8($a0)
	move 	$a1, $t1
	jal	Strcpy
	la	$a0, -8($v0) 
	
	li	$t0, 0	# \0
	sb	$t0, 12($a0)
	

endConvert:
	
	move	$v0, $a0
	lw	$ra, 16($sp)
	lw	$t0, 12($sp)
	lw	$t1, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addi	$sp, $sp, 20

	jr 	$ra


#-------------------------------------------------------------
#for option 3
#-------------------------------------------------------------
#-------------------------------------------------------------
weekday: #char * weekday(char *time)
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	

	lw $a0,4($sp)
	jal Day
	add $t0,$v0,$0 #day

	lw $a0,4($sp)
	jal Month
	add $t1,$v0,$0 #month


	lw $a0,4($sp)
	jal Year
	add $t2,$v0,$0 #year

	addi $t4,$t2,-1
	addi $t3,$0,4
	div $t4,$t3
	mflo $t3

	addi $t4,$0,365
	mult $t2,$t4
	mflo $v0
	add $v0,$v0,$t3
	
	addi $t4,$0,2
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,3
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	sw $v0,24($sp)
	lw $a0,4($sp)
	jal Leapyear
	add $a0,$v0,$0
	lw $v0,24($sp)
	beq $a0,$0,step1
	addi $v0,$v0,1
step1:
	addi $v0,$v0,28
	addi $t4,$0,4
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,5
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,6
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,7
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,8
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,9
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,10
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,11
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,12
	bne $t1,$t4,wkd
	addi $v0,$v0,30

wkd:
	add $v0,$t0,$v0
	addi $t4,$0,7
	addi $v0,$v0,-2
	div $v0,$t4
	mfhi $a0
	#add $a0,$v0,$0
	jal printweekday
	
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,28
	
	jr $ra	


#----------------------------------------------------------------
printweekday: #void printweekday(int day)
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t0,8($sp)

	addi $t0,$0,0
	beq $a0,$t0,sunday	
	addi $t0,$0,1
	beq $a0,$t0,monday
	addi $t0,$0,2
	beq $a0,$t0,tuesday
	addi $t0,$0,3
	beq $a0,$t0,wedday
	addi $t0,$0,4
	beq $a0,$t0,thursday
	addi $t0,$0,5
	beq $a0,$t0,friday
	addi $t0,$0,6
	beq $a0,$t0,satday
sunday:
	la $a0,sun
	j endpwd
monday:
	la $a0,mon
	j endpwd
tuesday:
	la $a0,tues
	j endpwd
wedday: 
	la $a0,wed
	j endpwd
thursday:
	la $a0,thurs
	j endpwd
friday:
	la $a0,fri
	j endpwd
satday:
	la $a0,sat
	j endpwd
endpwd:
	move $v0,$a0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t0,8($sp)
	addi $sp,$sp,12
	
	jr $ra	
#--------------------------------------------------------
#for option 5
#--------------------------------------------------------

dayoder: #int dayoderinyear(char *time)
	
	
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	

	lw $a0,4($sp)
	jal Day
	add $t0,$v0,$0 #day

	lw $a0,4($sp)
	jal Month
	add $t1,$v0,$0 #month


	lw $a0,4($sp)
	jal Year
	add $t2,$v0,$0 #year

	add $v0,$0,$0
	
	addi $t4,$0,2
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,3
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	sw $v0,24($sp)
	lw $a0,4($sp)
	jal Leapyear
	add $a0,$v0,$0
	lw $v0,24($sp)
	beq $a0,$0,step2
	addi $v0,$v0,1
step2:
	addi $v0,$v0,28
	addi $t4,$0,4
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,5
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,6
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,7
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,8
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,9
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,10
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,11
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,12
	bne $t1,$t4,doiy
	addi $v0,$v0,30

doiy:
	add $v0,$t0,$v0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,28
	
	jr $ra
#-----------------------------------------------------
gettime: #int gettime(char *time1,char *time2)
	addi $sp,$sp,-32
	sw $a0,0($sp)
	sw $a1,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)
	sw $t4,24($sp)
	sw $ra,28($sp)
	
	la $a0,endline
	addi $v0,$0,4
	syscall	

	lw $a0,0($sp)
	jal dayoder
	add $t0,$v0,$0
	

	lw $a0,4($sp)
	jal dayoder
	add $t1,$v0,$0

	

	lw $a0,0($sp)
	jal Year
	add $t2,$v0,$0

	
	
	lw $a0,4($sp)
	jal Year
	add $t3,$v0,$0
	
	add $a0,$t2,$0
	add $a1,$t3,$0
	jal exleapyear
	add $a1,$v0,$0

	slt $t4,$t3,$t2
	beq $t4,$0,smaller
	addi $t4,$0,365
	sub $v0,$t2,$t3
	mult $v0,$t4
	mflo $v0
	sub $v0,$v0,$t1
	add $v0,$v0,$t0
	j endgt
smaller:
	beq $t2,$t3,equal
	addi $t4,$0,365
	sub $v0,$t3,$t2
	mult $v0,$t4
	mflo $v0
	sub $v0,$v0,$t0
	add $v0,$v0,$t1
	j endgt
equal:
	slt $t4,$t0,$t1
	bne $t4,$0,smaller1
	sub $v0,$t0,$t1
	j endgt
smaller1:
	sub $v0,$t1,$t0
endgt:

	addi $t4,$0,365
	add $v0,$a1,$v0
	div $v0,$t4
	mflo $v0
	
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2,16($sp)
	lw $t3,20($sp)
	lw $t4,24($sp)
	lw $ra,28($sp)
	addi $sp,$sp,32
	
	jr $ra
#-----------------------------------------------------
leapyear1: #int leapyear(int year)
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$a0, 0($sp)
	
	
	li	$t0, 400
	div	$a0, $t0
	mfhi	$t0
	beqz 	$t0, trueL1	# type 400*k , 400, 2000
	
	li	$t0, 4
	div	$a0, $t0
	mfhi	$t0
	bnez 	$t0, falseL1	# type !4*k	2, 1903
	
	li	$t0, 100
	div	$a0, $t0
	mfhi	$t0
	bnez	$t0, trueL1# type 1904 type 4*k % 100 != 0
	beqz 	$t0, falseL1 
		
trueL1:
	addi	$v0, $0,1
	j	endL1
falseL1:
	addi	$v0, $0,0
endL1:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$a0, 0($sp)	
	addi	$sp, $sp, 12

	jr	$ra
#-----------------------------------------------------
exleapyear: #int exleapyear(int year1,int year2)
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t2,20($sp)
	sw $t3,24($sp)
		


	add $t3,$0,$0
	slt $t0,$a0,$a1
	beq $t0,$0,exl1
	add $t0,$a0,$0
	add $t1,$a1,$0
	j calexly
exl1:
	add $t0,$a1,$0
	add $t1,$a0,$0
calexly:
	slt $t2,$t0,$t1
	beq $t2,$0,endexly
	
	add $a0,$t0,$0
	jal leapyear1
	beq $v0,$0,nly
	addi $t3,$t3,1
nly:
	addi $t0,$t0,1
	j calexly
endexly:
	
	add $v0,$t3,$0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	addi $sp,$sp,28

	jr $ra
