    .include "board.asm"
    .include "input.asm"
    .include "rules.asm"
    .include "arquitetura.asm"

    .data
tabuleiro:  .space 9       
msg_inicio: .asciiz "\n=== JOGO DA VELHA ===\n"
msg_turnoX: .asciiz "\nVez do jogador X\n"
msg_turnoO: .asciiz "\nVez do jogador O\n"
msg_final:  .asciiz "\nJogo encerrado!\n"
msg_empate: .asciiz "\nEmpate! Deu velha!\n"

    .text
    .globl main

main:
    la $a0, tabuleiro
    jal limpar_tabuleiro

    li $v0, 4
    la $a0, msg_inicio
    syscall

    li $s0, JOGADOR_X

loop


