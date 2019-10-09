global _main
extern _printf
extern _scanf

section .data
operacion_minima db 1
operacion_maxima db 8
operacion_bin_BCD db 1
operacion_hex_BCD db 2
operacion_bin_BPF db 3
operacion_hex_BPF db 4
operacion_dec_hex_BCD db 5
operacion_dec_bin_BCD db 6
operacion_dec_hex_BPF db 7
operacion_dec_bin_BPF db 8
mensaje_inicial db "Seleccione el tipo de operacion:",10,\
                   "1 - Ingresar configuracion binaria de un BCD empaquetado de 4 bytes y mostrar en decimal",10,\
                   "2 - Ingresar configuracion hexadecimal de un BCD empaquetado de 4 bytes y mostrar en decimal",10,\
                   "3 - Ingresar configuracion binaria de un BPF C/S de 16 bits y mostrar en decimal",10,\
                   "4 - Ingresar configuracion hexadecimal de un BPF C/S de 16 bits y mostrar en decimal",10,\
                   "5 - Ingresar un numero decimal y mostrar configuracion hexadecimal del BCD empaquetado de 4 bytes",10,\
                   "6 - Ingresar un numero decimal y mostrar configuracion binaria del BCD empaquetado de 4 bytes",10,\
                   "7 - Ingresar un numero decimal y mostrar configuracion hexadecimal del BPF C/S de 16 bits",10,\
                   "8 - Ingresar un numero decimal y mostrar configuracion binaria del BPF C/S de 16 bits",10,0
formato_elegir_operacion db "%u",0
seleccion_operacion db "Se eligio la operacion %d",10,0
operacion_invalida db "Operacion fuera de rango, vuelva a elegir",10,0
section .bss
tipo_operacion resb 1
numero_ingresado resd 1

section .text
_main:
    mov ebp, esp; for correct debugging
    call mostrar_mensaje_inicial_y_elegir_operacion
    call ejecutar_operacion
    ret
    
mostrar_mensaje_inicial_y_elegir_operacion:
    push mensaje_inicial
    call _printf
    add esp,4
    
    jmp elegir_operacion

    elegir_operacion:
        push tipo_operacion
        push formato_elegir_operacion
        call _scanf
        add esp,8
        
        mov al,byte[tipo_operacion]
        cmp al,byte[operacion_minima]
        jl seleccion_de_operacion_invalida
        ja seleccion_de_operacion_invalida
        jmp seleccion_de_operacion_valida
    
    seleccion_de_operacion_invalida:
        push operacion_invalida
        call _printf
        add esp,4
        jmp elegir_operacion
   
    seleccion_de_operacion_valida:
        push tipo_operacion
        push seleccion_operacion
        call _printf
        add esp,8
        ret
        
ejecutar_operacion:
    mov al,byte[tipo_operacion]
    cmp al,byte[operacion_bin_BCD]
    je ejecutar_operacion_bin_BCD
    cmp al,byte[operacion_hex_BCD]
    je ejecutar_operacion_hex_BCD
    cmp al,byte[operacion_bin_BPF]
    je ejecutar_operacion_bin_BPF
    cmp al,byte[operacion_hex_BPF]
    je ejecutar_operacion_hex_BPF
    cmp al,byte[operacion_dec_hex_BCD]
    je ejecutar_operacion_dec_hex_BCD
    cmp al,byte[operacion_dec_bin_BCD]
    je ejecutar_operacion_dec_bin_BCD
    cmp al,byte[operacion_dec_hex_BPF]
    je ejecutar_operacion_dec_hex_BPF
    cmp al,byte[operacion_dec_bin_BPF]
    je ejecutar_operacion_dec_bin_BPF
    terminar_operacion:
        ret
    
ejecutar_operacion_bin_BCD:
    jmp terminar_operacion

ejecutar_operacion_hex_BCD:
    jmp terminar_operacion
    
ejecutar_operacion_bin_BPF:
    jmp terminar_operacion

ejecutar_operacion_hex_BPF:
    jmp terminar_operacion

ejecutar_operacion_dec_hex_BCD:
    jmp terminar_operacion

ejecutar_operacion_dec_bin_BCD:
    jmp terminar_operacion

ejecutar_operacion_dec_hex_BPF:
    jmp terminar_operacion

ejecutar_operacion_dec_bin_BPF:
    jmp terminar_operacion

