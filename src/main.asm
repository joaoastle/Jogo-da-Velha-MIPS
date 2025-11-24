.data 
welcomeMsg:       .asciiz "=== JOGO DA VELHA MIPS ===\n"
turnMsg:          .asciiz "Vez do jogador: "
newline:          .asciiz "\n"
cellTakenMsg:     .asciiz "Casa ocupada! Tente novamente.\n"
victoryMsg:       .asciiz "\nJOGADOR "
victoryEndMsg:    .asciiz " VENCEU!\n"
drawMsg:          .asciiz "\nEMPATE! Tabuleiro cheio.\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, welcomeMsg
    syscall

    jal initBoard

game_loop:
    jal printBoard

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






