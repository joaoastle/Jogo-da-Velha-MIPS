.include "board.asm"
.include "input.asm"

.data
msgStart: .asciiz "=== Jogo da Velha em MIPS ===\n"
msgTurnX: .asciiz "Vez do jogador X\n"
msgTurnO: .asciiz "Vez do jogador O\n"

.text
main:
    li $v0, 4
    la $a0, msgStart
    syscall

    jal initBoard

game_loop:
    jal printBoard

    li $v0, 4
    la $a0, msgTurnX
    syscall


    j game_loop     


