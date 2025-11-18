.data
infoMsg: .asciiz "Arquitetura do projeto carregada.\n"

.text
.globl printArchitectureInfo

printArchitectureInfo:
    li $v0, 4
    la $a0, infoMsg
    syscall
    jr $ra
