global _main
extern _printf

section .data
message db "Organizacion del Computador",0 

section .bss

section .text
_main:
    push message
    call _printf
    add esp,4
    ret