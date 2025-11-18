    .text

limpar_tabuleiro:
    li $t0, 0

loop_clear:
    beq $t0, 9, fim_clear
    sb $zero, 0($a0)
    addi $a0, $a0, 1
    addi $t0, $t0, 1
    j loop_clear

fim_clear:
    jr $ra


mostrar_tabuleiro:
    jr $ra
