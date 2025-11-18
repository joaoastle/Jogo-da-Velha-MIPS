# --- input.asm ---
# Leitura da jogada do usuário

.data
askRow: .asciiz "Linha (0-2): "
askCol: .asciiz "Coluna (0-2): "

.text

# -------------------------------------------------
# getMove
# Lê linha e coluna e retorna em $v0 e $v1
# -------------------------------------------------
getMove:
    # pergunta a linha
    li $v0, 4
    la $a0, askRow
    syscall

    li $v0, 5
    syscall
    move $v0, $v0       # linha

    # pergunta a coluna
    li $v0, 4
    la $a0, askCol
    syscall

    li $v0, 5
    syscall
    move $v1, $v0       # coluna

    jr $ra

