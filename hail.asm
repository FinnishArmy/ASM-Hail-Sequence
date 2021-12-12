#Washington State University
#11/6/2020
#Ronny Z Valtonen
#Computer Organization

.data
prompt:
	.asciiz "Enter starting N: "
	
iterationResult:
	.asciiz "Iterations: "
 
.text
main:
#Ask the user for an integer
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	move $s7, $v0	   # Move the integer to s1.
	
	add $s3, $s3, 1 # Compare the number of iterations.
	
	move $s4, $s7	   # This is the current iterations.
	
mainLoop:
	# Print current iterations.
	move $a0, $s4
	li $v0, 1
	syscall
	
	# Add a space.
	li $a0, 32
	li $v0, 11
	syscall
	
	beq $s4, $s3, printResult # Exit the loop if s4 is equal to 1.
		
	andi $t8, $s4, 1   
	beq $t8, $zero, evenFunction #If t1 is equal to 0, branch to even function.
	move $a0, $s4 	   #Set the value of s4, for odd function.
	jal oddFunction 	   #Call odd function
	move $s4, $v0      #Return value for odd funciton.
	j iterate #Loop
	
evenFunction:
	srl $s4, $s4, 1	   # Shift right so we can divide by two.
iterate:
	add $s2, $s2, 1   #Loop counter iterations.
	j mainLoop

#N*3+1
oddFunction:
	sw $s2, 4($sp)	   # Save to s2
	sw $ra, 0($sp)	   # Save to ra
	
	move $s1, $a0	   # Store to s1
	move $s2, $zero	   # s2 will be my result
	add $t0, $zero, 3 # Loop 3 times
	
oddLoop:
	add $s2, $s2, $s7  # Add itself 3 times to multiply by 3
	addi $t0, $t0, -1  # Needed for looping
	
	bne $t0, $zero, oddLoop # Branch if not equal to zero
	add $s2, $s2, 1   # Add 1
	
calcForOddFinished:
	move $v0, $s2	   # Store final result
	lw $s2, 4($sp)	   # Load s2
	lw $ra, 0($sp)	   # Load ra
	jr $ra

# Prints the result and calls the exit function
printResult:
	# Print New Line
	li $a0, 10
	li $v0, 11
	syscall

	# Print Iteration Text
	la $a0, iterationResult
	li $v0, 4
	syscall
	
	# Print Iterations
	move $a0, $s2
	addiu $a0, $a0, 1
	li $v0, 1
	syscall 
	
	j exit

# Exit the program
exit:
        li $v0, 10
        syscall
