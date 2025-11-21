.data
welcomeMsg: .asciiz "=== JOGO DA VELHA MIPS ===\n"
turnMsg:    .asciiz "Vez do jogador: "
newline:    .asciiz "\n"

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

    beq $v0, $zero, game_loop   
    la $t0, currentPlayer
    lb $t1, 0($t0)

    move $a0, $t2
    move $a1, $t3
    move $a2, $t1
    jal placeMove

    jal switchPlayer

    j game_loop




