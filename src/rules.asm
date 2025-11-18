    .text

checar_vitoria:
    li $v0, 0
    jr $ra


checar_empate:
    li $t0, 0

loop_empate:
    beq $t0, 9, deu_empate

    lb $t1, 0($a0)
    beq $t1, $zero, nao_empate

    addi $a0, $a0, 1
    addi $t0, $t0, 1
    j loop_empate

deu_empate:
    li $v0, 1
    jr $ra

nao_empate:
    li $v0, 0
    jr $ra

