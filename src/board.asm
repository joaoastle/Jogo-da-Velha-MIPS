# --- board.asm ---
# Funções do tabuleiro:
# initBoard   -> enche a matriz com '-'
# printBoard  -> imprime a matriz 3x3 formatada

.data
board: .space 9     # 9 bytes (3x3)

.text

# -------------------------------------------------
# initBoard
# Preenche board[0..8] com '-'
# -------------------------------------------------
initBoard:
    li $t0, 0              # índice
    la $t1, board          # endereço base

init_loop:
    li $t2, '-'            # caractere vazio
    sb $t2, 0($t1)         # escreve no board

    addi $t1, $t1, 1       # avança ponteiro
    addi $t0, $t0, 1       # incrementa índice
    blt $t0, 9, init_loop  # até 9 posições

    jr $ra


# -------------------------------------------------
# printBoard
# Imprime o tabuleiro na tela
# -------------------------------------------------
printBoard:
    la $t0, board      # base do board
    li $t1, 0          # índice

print_loop:
    lb $a0, 0($t0)     # pega caractere
    li $v0, 11         # imprime char
    syscall

    # imprime espaço
    li $a0, ' '
    li $v0, 11
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1

    # quebra linha a cada 3
    rem $t2, $t1, 3
    bne $t2, 0, continue

    # nova linha
    li $a0, '\n'
    li $v0, 11
    syscall

continue:
    blt $t1, 9, print_loop

    # linha extra no final
    li $a0, '\n'
    li $v0, 11
    syscall

    jr $ra

