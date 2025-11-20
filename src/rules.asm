.data
dotCharCheck: .byte '.'

.text
.globl checkCellEmpty


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


