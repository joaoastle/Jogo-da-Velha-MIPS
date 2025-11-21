.data
dotCharCheck: .byte '.'
currentPlayer: .byte 'X'      

.text
.globl checkCellEmpty
.globl placeMove
.globl switchPlayer


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




