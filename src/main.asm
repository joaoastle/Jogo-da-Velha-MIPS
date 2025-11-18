# --- main.asm ---
# Loop principal do jogo
# Chama funções de inicializar e imprimir.

.include "board.asm"
.include "input.asm"

.data
msgStart: .asciiz "=== Jogo da Velha em MIPS ===\n"
msgTurnX: .asciiz "Vez do jogador X\n"
msgTurnO: .asciiz "Vez do jogador O\n"

.text
main:
    # mensagem inicial
    li $v0, 4
    la $a0, msgStart
    syscall

    # inicializa tabuleiro
    jal initBoard

game_loop:
    # imprime tabuleiro
    jal printBoard

    # turno do jogador X
    li $v0, 4
    la $a0, msgTurnX
    syscall

    # (aqui vamos chamar a função de input depois)
    # jal getUserMove

    j game_loop      # repetir por enquanto (apenas sprint 1)


