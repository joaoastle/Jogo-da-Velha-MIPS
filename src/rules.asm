.data
dotCharCheck: .byte '.'

.text
.globl checkCellEmpty
.globl placeMove
.globl switchPlayer
.globl checkVictory
.globl checkDraw



checkCellEmpty:
    mul $t0, $a0, 3       
    add $t0, $t0, $a1      

    la $t1, board
    add $t1, $t1, $t0

    lb $t2, 0($t1)
    lb $t3, dotCharCheck

    beq $t2, $t3, cell_free

cell_taken:
    li $v0, 0
    jr $ra

cell_free:
    li $v0, 1
    jr $ra



placeMove:
    mul $t0, $a0, 3
    add $t0, $t0, $a1       

    la $t1, board
    add $t1, $t1, $t0

    sb $a2, 0($t1)

    jr $ra



switchPlayer:
    la $t0, currentPlayer
    lb $t1, 0($t0)

    li $t2, 'X'
    li $t3, 'O'

    beq $t1, $t2, switch_to_O

switch_to_X:
    sb $t2, 0($t0)
    jr $ra

switch_to_O:
    sb $t3, 0($t0)
    jr $ra



checkVictory:
    li $v0, 0       

  
    la $t0, board     

    li $t1, 0         

check_rows:
    add $t2, $t0, $t1      
    
    lb $t3, 0($t2)         
    lb $t4, 1($t2)         
    lb $t5, 2($t2)         

    beq $t3, dotCharCheck, next_row
    bne $t3, $t4, next_row
    bne $t3, $t5, next_row

    li $v0, 1
    jr $ra

next_row:
    addi $t1, $t1, 3
    blt $t1, 9, check_rows



    li $t1, 0         

check_cols:
    la $t2, board
    add $t2, $t2, $t1   
    lb $t3, 0($t2)      
    lb $t4, 3($t2)      
    lb $t5, 6($t2)      

    beq $t3, dotCharCheck, next_col
    bne $t3, $t4, next_col
    bne $t3, $t5, next_col

    li $v0, 1
    jr $ra

next_col:
    addi $t1, $t1, 1
    blt $t1, 3, check_cols



    la $t0, board
    lb $t3, 0($t0)
    lb $t4, 4($t0)
    lb $t5, 8($t0)

    beq $t3, dotCharCheck, check_diag2
    bne $t3, $t4, check_diag2
    bne $t3, $t5, check_diag2

    li $v0, 1
    jr $ra



check_diag2:
    la $t0, board
    lb $t3, 2($t0)
    lb $t4, 4($t0)
    lb $t5, 6($t0)

    beq $t3, dotCharCheck, no_win
    bne $t3, $t4, no_win
    bne $t3, $t5, no_win

    li $v0, 1
    jr $ra


no_win:
    li $v0, 0
    jr $ra



checkDraw:
    la $t0, board
    li $t1, 9

draw_loop:
    lb $t2, 0($t0)
    beq $t2, dotCharCheck, no_draw  

    addi $t0, $t0, 1
    subi $t1, $t1, 1
    bgtz $t1, draw_loop

    li $v0, 1
    jr $ra

no_draw:
    li $v0, 0
    jr $ra






