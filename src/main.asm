.data
welcomeMsg: .asciiz "=== JOGO DA VELHA MIPS ===\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, welcomeMsg
    syscall

    jal initBoard

    jal printBoard

    li $v0, 10
    syscall



