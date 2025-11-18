# projeto: Jogo da Velha em MIPS
# autor: João

.data
msgStart: .asciiz "Jogo da Velha em MIPS iniciado...\n"

.text
main:
    # printar mensagem inicial
    li $v0, 4
    la $a0, msgStart
    syscall

    # encerrar programa
    li $v0, 10
    syscall

