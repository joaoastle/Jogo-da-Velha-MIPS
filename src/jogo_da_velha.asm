############################################################
# JOGO DA VELHA EM MIPS — ARQUIVO ÚNICO
############################################################

############################################################
# DATA SECTION
############################################################
.data

# Mensagens
welcomeMsg:       .asciiz "=== JOGO DA VELHA MIPS ===\n"
turnMsg:          .asciiz "Vez do jogador: "
newline:          .asciiz "\n"
cellTakenMsg:     .asciiz "Casa ocupada! Tente novamente.\n"
victoryMsg:       .asciiz "\nJOGADOR "
victoryEndMsg:    .asciiz " VENCEU!\n"
drawMsg:          .asciiz "\nEMPATE! Tabuleiro cheio.\n"

askRowMsg:        .asciiz "Digite a linha (0-2): "
askColMsg:        .asciiz "Digite a coluna (0-2): "
invalidMsg:       .asciiz "Entrada invalida! Tente novamente.\n"

# Tabuleiro
board:            .space 9      # 3x3
currentPlayer:    .byte 'X'
dotChar:          .byte '.'
dotCharCheck:     .byte '.'

############################################################
# TEXT SECTION
############################################################
.text
.globl main

############################################################
# INICIALIZAR TABULEIRO
############################################################
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


############################################################
# IMPRIMIR TABULEIRO
############################################################
printBoard:
    la $t0, board
    li $t1, 0

print_loop:
    lb $a0, 0($t0)
    li $v0, 11
    syscall

    # espaço
    li $v0, 11
    li $a0, ' '
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1

    rem $t2, $t1, 3
    bnez $t2, continue_print

    # quebra linha
    li $v0, 11
    li $a0, '\n'
    syscall

continue_print:
    blt $t1, 9, print_loop
    jr $ra


############################################################
# LEITURA DA JOGADA
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

    move $v0, $t0
    move $v1, $t1
    jr $ra

invalid_input:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j read_row


############################################################
# VERIFICAR CASA VAZIA
############################################################
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


############################################################
# COLOCAR JOGADA NO TABULEIRO
############################################################
placeMove:
    mul $t0, $a0, 3
    add $t0, $t0, $a1

    la $t1, board
    add $t1, $t1, $t0

    sb $a2, 0($t1)
    jr $ra


############################################################
# TROCAR JOGADOR
############################################################
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


############################################################
# VERIFICAR VITÓRIA
############################################################
checkVictory:
    li $v0, 0
    la $t0, board
    li $t1, 0

# Linhas
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

# Colunas
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

# Diagonal 1
    la $t0, board
    lb $t3, 0($t0)
    lb $t4, 4($t0)
    lb $t5, 8($t0)

    beq $t3, dotCharCheck, check_diag2
    bne $t3, $t4, check_diag2
    bne $t3, $t5, check_diag2

    li $v0, 1
    jr $ra

# Diagonal 2
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


############################################################
# VERIFICAR EMPATE
############################################################
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

    # Mostrar jogador
    li $v0, 4
    la $a0, turnMsg
    syscall

    la $t0, currentPlayer
    lb $t1, 0($t0)

    li $v0, 11
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Jogada
    jal readMove
    move $t2, $v0
    move $t3, $v1

validate_cell:
    move $a0, $t2
    move $a1, $t3
    jal checkCellEmpty

    beq $v0, $zero, cell_taken_msg

place_move:
    la $t0, currentPlayer
    lb $t1, 0($t0)

    move $a0, $t2
    move $a1, $t3
    move $a2, $t1
    jal placeMove

    jal checkVictory
    beq $v0, 1, someone_won

    jal checkDraw
    beq $v0, 1, draw

    jal switchPlayer
    j game_loop

cell_taken_msg:
    li $v0, 4
    la $a0, cellTakenMsg
    syscall
    j game_loop

someone_won:
    li $v0, 4
    la $a0, victoryMsg
    syscall

    la $t0, currentPlayer
    lb $t1, 0($t0)

    li $v0, 11
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, victoryEndMsg
    syscall

    li $v0, 10
    syscall

draw:
    li $v0, 4
    la $a0, drawMsg
    syscall

    li $v0, 10
    syscall
