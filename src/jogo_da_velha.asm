.data
board:      .space 9        # 3x3
msgStart:   .asciiz "\n====================\n   JOGO DA VELHA\n====================\n"
msgTurn:    .asciiz "\nVez do jogador: "
msgLinha:   .asciiz "\nLinha (1 a 3): "
msgColuna:  .asciiz "\nColuna (1 a 3): "
msgInval:   .asciiz "\nJogada invalida! Tente novamente.\n"
msgWinner:  .asciiz "\nVencedor: "
msgTie:     .asciiz "\nEmpate!\n"
nl:         .asciiz "\n"

.text
main:
    # Inicializa tabuleiro com '.'
    la $t0, board
    li $t1, 9
init_loop:
    li $t2, '.'
    sb $t2, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    bnez $t1, init_loop

    # Jogador inicial = 'X'
    li $s0, 'X'

game_loop:
    # Imprime tabuleiro
    jal printBoard

readMove:
    # Mensagem do jogador
    li $v0, 4
    la $a0, msgTurn
    syscall

    li $v0, 11
    move $a0, $s0
    syscall

    # Quebra de linha após jogador
    li $v0, 4
    la $a0, nl
    syscall

    # Linha
    li $v0, 4
    la $a0, msgLinha
    syscall
    li $v0, 5
    syscall
    addi $t1, $v0, -1    # ajustar índice 0-2

    # Coluna
    li $v0, 4
    la $a0, msgColuna
    syscall
    li $v0, 5
    syscall
    addi $t2, $v0, -1    # ajustar índice 0-2

    # Validação
    blt $t1, 0, invalid
    bgt $t1, 2, invalid
    blt $t2, 0, invalid
    bgt $t2, 2, invalid

    # índice = linha*3 + coluna
    mul $t3, $t1, 3
    add $t3, $t3, $t2

    # endereço do board
    la $t4, board
    add $t4, $t4, $t3

    # verifica vazio
    lb $t5, 0($t4)
    li $t6, '.'
    bne $t5, $t6, invalid

    # grava X ou O
    sb $s0, 0($t4)

    # checa vencedor
    jal checkWinner
    bne $v0, $zero, winner_found

    # checa empate
    jal checkTie
    bne $v0, $zero, tie_game

    # alterna jogador
    li $t7, 'X'
    beq $s0, $t7, switchO
    li $s0, 'X'
    j game_loop

switchO:
    li $s0, 'O'
    j game_loop

invalid:
    li $v0, 4
    la $a0, msgInval
    syscall
    j readMove

winner_found:
    li $v0, 4
    la $a0, msgWinner
    syscall
    li $v0, 11
    move $a0, $s0
    syscall
    li $v0, 4
    la $a0, nl
    syscall
    j exit

tie_game:
    li $v0, 4
    la $a0, msgTie
    syscall
    j exit


###########################
# PRINT BOARD
###########################
printBoard:
    li $v0, 4
    la $a0, msgStart
    syscall

    la $t0, board
    li $t1, 0
print_loop:
    lb $t2, 0($t0)

    li $v0, 11
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, ' '
    syscall

    addi $t1, $t1, 1
    addi $t0, $t0, 1

    rem $t3, $t1, 3
    bne $t3, 0, continue_print

    li $v0, 4
    la $a0, nl
    syscall

continue_print:
    blt $t1, 9, print_loop
    jr $ra


###########################
# CHECK WINNER
###########################
checkWinner:
    la $t0, board

    # verifica linhas
    li $t1, 0
check_lines:
    lb $t2, 0($t0)
    lb $t3, 1($t0)
    lb $t4, 2($t0)
    li $t5, '.'
    beq $t2, $t5, next_line
    bne $t2, $t3, next_line
    bne $t2, $t4, next_line
    li $v0, 1
    jr $ra
next_line:
    addi $t0, $t0, 3
    addi $t1, $t1, 1
    blt $t1, 3, check_lines

    # verifica colunas
    la $t0, board
    li $t1, 0
check_cols:
    lb $t2, 0($t0)
    lb $t3, 3($t0)
    lb $t4, 6($t0)
    li $t5, '.'
    beq $t2, $t5, next_col
    bne $t2, $t3, next_col
    bne $t2, $t4, next_col
    li $v0, 1
    jr $ra
next_col:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    blt $t1, 3, check_cols

    # diagonal principal
    la $t0, board
    lb $t2, 0($t0)
    lb $t3, 4($t0)
    lb $t4, 8($t0)
    li $t5, '.'
    beq $t2, $t5, check_diag2
    bne $t2, $t3, check_diag2
    bne $t2, $t4, check_diag2
    li $v0, 1
    jr $ra

check_diag2:
    lb $t2, 2($t0)
    lb $t3, 4($t0)
    lb $t4, 6($t0)
    li $t5, '.'
    beq $t2, $t5, no_winner
    bne $t2, $t3, no_winner
    bne $t2, $t4, no_winner
    li $v0, 1
    jr $ra

no_winner:
    li $v0, 0
    jr $ra


###########################
# CHECK TIE
###########################
checkTie:
    la $t0, board
    li $t1, 0
tie_loop:
    lb $t2, 0($t0)
    li $t3, '.'
    beq $t2, $t3, not_tie
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    blt $t1, 9, tie_loop
    li $v0, 1
    jr $ra
not_tie:
    li $v0, 0
    jr $ra

exit:
    li $v0, 10
    syscall
