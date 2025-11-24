.data
askRowMsg:    .asciiz "Digite a linha (0-2): "
askColMsg:    .asciiz "Digite a coluna (0-2): "
invalidMsg:   .asciiz "Entrada invalida! Tente novamente.\n"

.text
.globl readMove

readMove:
read_row:
    li $v0, 4
    la $a0, askRowMsg
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       

    bltz $t0, invalid_input
    bgt  $t0, 2, invalid_input

read_col:
    li $v0, 4
    la $a0, askColMsg
    syscall

    li $v0, 5
    syscall
    move $t1, $v0       

    bltz $t1, invalid_input
    bgt  $t1, 2, invalid_input

    move $v0, $t0
    move $v1, $t1
    jr $ra

invalid_input:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j read_row

