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
    jr $ra
