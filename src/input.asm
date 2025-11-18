.data
askRow: .asciiz "Linha (0-2): "
askCol: .asciiz "Coluna (0-2): "

.text

getMove:
    li $v0, 4
    la $a0, askRow
    syscall

    li $v0, 5
    syscall
    move $v0, $v0       

    li $v0, 4
    la $a0, askCol
    syscall

    li $v0, 5
    syscall
    move $v1, $v0      

    jr $ra

