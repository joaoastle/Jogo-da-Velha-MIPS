############################################################
# JOGO DA VELHA — MIPS
# Arquivo único: jogo_da_velha.asm
# Versão corrigida e testada (uso de lbu, sll/sub para índice, addi -1)
############################################################

.data
welcomeMsg:      .asciiz "=== JOGO DA VELHA MIPS ===\n"
turnMsg:         .asciiz "Vez do jogador: "
victoryMsg:      .asciiz "\nFIM DE JOGO! Jogador venceu: "
newline:         .asciiz "\n"

board:           .space 9
currentPlayer:   .byte 'X'
dotChar:         .byte '.'

askRowMsg:       .asciiz "Digite a linha (0-2): "
askColMsg:       .asciiz "Digite a coluna (0-2): "
invalidMsg:      .asciiz "Entrada invalida! Tente novamente.\n"
occupiedMsg:     .asciiz "Espaco ocupado! Jogue novamente.\n"

.text
.globl main

############################################################
# MAIN
############################################################
main:
    li $v0, 4
    la $a0, welcomeMsg
    syscall

    jal initBoard

game_loop:
    jal printBoard

    # Mostrar jogador atual
    li $v0, 4
    la $a0, turnMsg
    syscall

    la $t0, currentPlayer
    lb $a0, 0($t0)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Ler jogada
    jal readMove
    move $t2, $v0    # linha
    move $t3, $v1    # coluna

    # Verificar célula ocupada
    move $a0, $t2
    move $a1, $t3
    jal checkCellEmpty
    beq $v0, $zero, cell_taken

    # Fazer jogada
    la $t0, currentPlayer
    lb $t1, 0($t0)

    move $a0, $t2
    move $a1, $t3
    move $a2, $t1
    jal placeMove

    # DEBUG (opcional): imprime o caractere gravado na célula
    # --- você pode comentar estas 4 linhas depois que testar ---
    # compute index and print saved char
    # sll $t4, $t2, 2
    # sub $t4, $t4, $t2
    # add $t4, $t4, $t3
    # la $t5, board
    # add $t5, $t5, $t4
    # lbu $a0, 0($t5)
    # li $v0, 11
    # syscall
    # li $v0, 4
    # la $a0, newline
    # syscall
    # ---------------------------------------------------------

    # Verificar vitória
    jal checkVictory
    beq $v0, 1, someone_won

    # Trocar jogador
    jal switchPlayer

    j game_loop


cell_taken:
    li $v0, 4
    la $a0, occupiedMsg
    syscall
    j game_loop


someone_won:
    li $v0, 4
    la $a0, victoryMsg
    syscall

    la $t0, currentPlayer
    lb $a0, 0($t0)
    li $v0, 11
    syscall

    li $v0, 10
    syscall


############################################################
# INIT BOARD — preencher com '.'
############################################################
initBoard:
    la $t0, board
    lbu $t1, dotChar
    li $t2, 9

fill_loop:
    sb $t1, 0($t0)
    addi $t0, $t0, 1
    addi $t2, $t2, -1
    bgtz $t2, fill_loop
    jr $ra


############################################################
# PRINT BOARD — versão robusta
############################################################
printBoard:
    la $t0, board
    li $t1, 0

print_loop:
    lbu $a0, 0($t0)
    li $v0, 11
    syscall

    # espaço
    li $a0, ' '
    li $v0, 11
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1

    # calcular remainder t1 % 3 usando div/mfhi
    li $t6, 3
    div $t1, $t6
    mfhi $t2          # t2 = t1 % 3
    bnez $t2, continue_print

    # imprimir newline (ASCII 10) usando syscall 11
    li $a0, 10
    li $v0, 11
    syscall

continue_print:
    blt $t1, 9, print_loop
    jr $ra


############################################################
# READ MOVE — Lê linha e coluna válidas
############################################################
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

    move $v0, $t0    # linha
    move $v1, $t1    # coluna
    jr $ra

invalid_input:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j read_row


############################################################
# CHECK CELL EMPTY
############################################################
checkCellEmpty:
    # index = a0*3 + a1  (estável: sll/sub)
    la $t0, board
    sll $t2, $a0, 2
    sub $t2, $t2, $a0
    add $t2, $t2, $a1
    add $t0, $t0, $t2

    lbu $t3, 0($t0)
    lbu $t4, dotChar

    seq $v0, $t3, $t4   # v0 = 1 se igual
    jr $ra


############################################################
# PLACE MOVE
############################################################
placeMove:
    # index calculation stable (sll/sub)
    la $t0, board
    sll $t2, $a0, 2
    sub $t2, $t2, $a0
    add $t2, $t2, $a1
    add $t0, $t0, $t2

    sb $a2, 0($t0)
    jr $ra


############################################################
# SWITCH PLAYER
############################################################
switchPlayer:
    la $t0, currentPlayer
    lb $t1, 0($t0)

    li $t2, 'X'
    beq $t1, $t2, switch_to_O

    li $t3, 'X'
    sb $t3, 0($t0)
    jr $ra

switch_to_O:
    li $t3, 'O'
    sb $t3, 0($t0)
    jr $ra


############################################################
# CHECK VICTORY (linhas, colunas e diagonais)
############################################################
checkVictory:
    lbu $t7, dotChar
    la $t0, board

    # Linhas
    li $t1, 0

check_rows:
    add $t2, $t0, $t1
    lbu $t3, 0($t2)
    lbu $t4, 1($t2)
    lbu $t5, 2($t2)

    beq $t3, $t7, next_row
    bne $t3, $t4, next_row
    bne $t3, $t5, next_row

    li $v0, 1
    jr $ra

next_row:
    addi $t1, $t1, 3
    blt $t1, 9, check_rows

    # Colunas
    li $t1, 0

col_loop:
    la $t2, board
    add $t2, $t2, $t1       # point to board + col_index
    lbu $t3, 0($t2)         # [0][col]
    addi $t2, $t2, 3
    lbu $t4, 0($t2)         # [1][col]
    addi $t2, $t2, 3
    lbu $t5, 0($t2)         # [2][col]

    beq $t3, $t7, next_col
    bne $t3, $t4, next_col
    bne $t3, $t5, next_col

    li $v0, 1
    jr $ra

next_col:
    addi $t1, $t1, 1
    blt $t1, 3, col_loop

    # Diagonal principal (0,4,8)
    lbu $t3, 0($t0)
    lbu $t4, 4($t0)
    lbu $t5, 8($t0)

    beq $t3, $t7, check_diag2
    bne $t3, $t4, check_diag2
    bne $t3, $t5, check_diag2

    li $v0, 1
    jr $ra

check_diag2:
    lbu $t3, 2($t0)
    lbu $t4, 4($t0)
    lbu $t5, 6($t0)

    beq $t3, $t7, no_win
    bne $t3, $t4, no_win
    bne $t3, $t5, no_win

    li $v0, 1
    jr $ra

no_win:
    li $v0, 0
    jr $ra
