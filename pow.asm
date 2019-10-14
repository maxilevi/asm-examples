global _main
extern _printf

section .data
x dd 2
y dd 10
format db "pow(%d,%d) = %d",0

section .bss
result resd 1

section .text
_main:
    mov ebp, esp; for correct debugging
    mov ebx,1
    mov ecx,dword[y]
    cmp ecx,0
    je show_result
    multiply:
        mov eax,dword[x]
        mul ebx
        mov ebx,eax        
    LOOP multiply
    show_result:
        push ebx
        push dword[y]
        push dword[x]
        push format
        call _printf
        add esp,16
        ret
    