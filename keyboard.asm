global _main
extern _printf
extern _gets
extern _scanf

section .data
nombreIngreso db "Ingrese su nombre:",10,0
apellidoIngreso db "Ingrese su apellido:",10,0
padronIngreso db "Ingrese su padron:",10,0
edadIngreso db "Ingrese su edad:",10,0
message db "El alumno %s %s de Padrón N° %d tiene %d años",0
edadformato db "%d"

section .bss
nombre resb 20
apellido resb 20
padron resd 1
edad resd 1
 
section .text
_main:
    mov ebp, esp; for correct debugging
    push nombreIngreso
    call _printf
    add esp,4
    
    push nombre
    call _gets
    add esp,4
    
    push apellidoIngreso
    call _printf
    add esp,4
    
    push apellido
    call _gets
    add esp,4
    
    push padronIngreso
    call _printf
    add esp,4
    
    push padron
    push edadformato
    call _scanf
    add esp,8
    
    push edadIngreso
    call _printf
    add esp,4
    
    push edad
    push edadformato
    call _scanf
    add esp,8
    
    push edad
    push padron
    push apellido
    push nombre
    push message
    call _printf
    add esp,20
    ret