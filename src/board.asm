.data
board: .space 9     

.text

initBoard:
    li $t0, 0              
    la $t1, board          

init_loop:
    li $t2, '-'            
    sb $t2, 0($t1)         

    addi $t1, $t1, 1       
    addi $t0, $t0, 1       
    blt $t0, 9, init_loop  

    jr $ra


printBoard:
    la $t0, board      
    li $t1, 0          

print_loop:
    lb $a0, 0($t0)     
    li $v0, 11         
    syscall

    li $a0, ' '
    li $v0, 11
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1

    rem $t2, $t1, 3
    bne $t2, 0, continue

    li $a0, '\n'
    li $v0, 11
    syscall

continue:
    blt $t1, 9, print_loop

    li $a0, '\n'
    li $v0, 11
    syscall

    jr $ra

