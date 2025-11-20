.data
board: .space 9        
dotChar: .byte '.'

.text
.globl initBoard
.globl printBoard

initBoard:
    la $t0, board
    lb $t1, dotChar
    li $t2, 9            

fill_loop:
    sb $t1, 0($t0)
    addi $t0, $t0, 1
    subi $t2, $t2, 1
    bgtz $t2, fill_loop
    jr $ra


printBoard:
    la $t0, board         
    li $t1, 0             

print_loop:
    lb $a0, 0($t0)        
    li $v0, 11            
    syscall

    li $v0, 11
    li $a0, ' '
    syscall

    addi $t0, $t0, 1      
    addi $t1, $t1, 1

    rem $t2, $t1, 3
    bnez $t2, continue_print

    li $v0, 11
    li $a0, '\n'
    syscall

continue_print:
    blt $t1, 9, print_loop

    jr $ra

