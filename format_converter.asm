global _main
extern _printf
extern _scanf
extern _gets

section .data
; Constantes
zero_ascii equ 48
operacion_minima dd 1
operacion_maxima dd 8
operacion_bin_BCD dd 1
operacion_hex_BCD dd 2
operacion_bin_BPF dd 3
operacion_hex_BPF dd 4
operacion_dec_hex_BCD dd 5
operacion_dec_bin_BCD dd 6
operacion_dec_hex_BPF dd 7
operacion_dec_bin_BPF dd 8
mensaje_inicial db "Seleccione el tipo de operacion:",10,\
                   "1 - Ingresar configuracion binaria de un BCD empaquetado de 4 bytes y mostrar en decimal",10,\
                   "2 - Ingresar configuracion hexadecimal de un BCD empaquetado de 4 bytes y mostrar en decimal",10,\
                   "3 - Ingresar configuracion binaria de un BPF C/S de 16 bits y mostrar en decimal",10,\
                   "4 - Ingresar configuracion hexadecimal de un BPF C/S de 16 bits y mostrar en decimal",10,\
                   "5 - Ingresar un numero decimal y mostrar configuracion hexadecimal del BCD empaquetado de 4 bytes",10,\
                   "6 - Ingresar un numero decimal y mostrar configuracion binaria del BCD empaquetado de 4 bytes",10,\
                   "7 - Ingresar un numero decimal y mostrar configuracion hexadecimal del BPF C/S de 16 bits",10,\
                   "8 - Ingresar un numero decimal y mostrar configuracion binaria del BPF C/S de 16 bits",10,0
formato_elegir_operacion db "%d"
seleccion_operacion db "Se eligio la operacion %d",10,0
operacion_invalida db "Operacion fuera de rango, vuelva a elegir",10,0
ingresar_operacion_bin_BCD dd "Ingrese configuracion binaria de un BCD empaquetado de 4 bytes",10,0
mostrar_numero_formato dd "Su numero es: %d",10,0
; Tabla para hacer conversiones

section .bss
; Reservo este espacio para representar un binario en texto
binario_string resb 32
string_largo_ptr resd 1
string_largo resd 1
tipo_operacion resd 1
numero_ingresado resd 1
binario_en_memoria resd 1
bcd_en_memoria
decimal_en_memoria

section .text
_main:
    mov ebp, esp; for correct debugging
    call mostrar_mensaje_inicial_y_elegir_operacion
    call ejecutar_operacion
    ret
    
mostrar_mensaje_inicial_y_elegir_operacion:
    mov eax,mensaje_inicial
    call imprimir_mensaje
    
    jmp elegir_operacion

    elegir_operacion:
        push tipo_operacion
        push formato_elegir_operacion
        call _scanf
        add esp,8
        
        mov eax,dword[tipo_operacion]
        cmp eax,dword[operacion_minima]
        jl seleccion_de_operacion_invalida
        cmp eax,dword[operacion_maxima]
        jg seleccion_de_operacion_invalida
        jmp seleccion_de_operacion_valida
    
    seleccion_de_operacion_invalida:
        push operacion_invalida
        call _printf
        add esp,4
        jmp elegir_operacion
   
    seleccion_de_operacion_valida:
        push dword[tipo_operacion]
        push seleccion_operacion
        call _printf
        add esp,8
        ret
        
ejecutar_operacion:
    mov eax,dword[tipo_operacion]
    
    cmp eax,dword[operacion_bin_BCD]
    je ejecutar_operacion_bin_BCD
    cmp eax,dword[operacion_hex_BCD]
    je ejecutar_operacion_hex_BCD
    cmp eax,dword[operacion_bin_BPF]
    je ejecutar_operacion_bin_BPF
    cmp eax,dword[operacion_hex_BPF]
    je ejecutar_operacion_hex_BPF
    cmp eax,dword[operacion_dec_hex_BCD]
    je ejecutar_operacion_dec_hex_BCD
    cmp eax,dword[operacion_dec_bin_BCD]
    je ejecutar_operacion_dec_bin_BCD
    cmp eax,dword[operacion_dec_hex_BPF]
    je ejecutar_operacion_dec_hex_BPF
    cmp eax,dword[operacion_dec_bin_BPF]
    je ejecutar_operacion_dec_bin_BPF
    terminar_operacion:
        ret
    
ejecutar_operacion_bin_BCD:
    ; Imprimimos mensaje para ingresar
    mov eax, ingresar_operacion_bin_BCD
    call imprimir_mensaje
    
    ; Recibimos el string en binario
    call recibir_string_stdin
   
    ; Pasamos el string de ceros y unos a memoria
    ; Ponemos en ebx la cantidad de bits del string
    mov ebx,32
    call string_binario_a_numero
    
    ; Del binario en memoria agarramos el valor del BCD
    mov eax, dword[binario_en_memoria]
    mov dword[bcd_en_memoria], eax
    call BCD_a_decimal
    
    ; Mostramos el resultado
    mov eax, dword[decimal_en_memoria]
    call mostrar_numero
    
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


;;;;;;;; Funciones Auxiliares ;;;;;;;;

; Devuelve en decimal_en_memoria el valor del BCD en bcd_en_memoria
BCD_a_decimal:
    ; Es un BCD empaquetado de 4 bytes entonces tiene 7 nibbles para numeros y el ultimo para signo
    ; Voy a asumir que el numero que se ingresa esta en big endian (porque el bcd lo vimos asi en clase)
    ; aunque intel sea little endian
    mov ecx,7
    mov dword[decimal_en_memoria],0
    ; Mi idea es usar una mask de 4 bits (1111) para ir agarrando cada nibble y sumarlo al numero con su base.
    ; En cada iteracion del loop hago un shift a la derecha de la mask para pasar al otro nible
    mov ebx, F000h
    BCD_a_decimal_loop:
        ; Cargo el numero
        mov eax,dword[bcd_en_memoria]
        ; Le aplico la mask
        and eax,ebx
        ; Hago un shift para tener el numero "real"
        
        ; Lo multiplico por su potencia en base 10
        
        ; Finalmente lo añado
        add dword[decimal],eax
        ; Muevo la mask 4 bits
        shr ebx,4
    loop BCD_a_decimal_loop
    ret

; Convierte un string en binario a un numero en la memoria
; Va por cada digito y lo añade a un lugar de la memoria usando el left shift
string_binario_a_numero:
    mov dword[binario_en_memoria],0
    mov ecx,0
    binario_a_numero_loop:
        mov al,byte[binario_string + ecx]
        ; Si llegamos al fin del string finalizamos
        cmp al,0
        je fin_binario_a_numero_loop
        sub eax,zero_ascii
        shl al,cl
        add word[binario_en_memoria],ax
        inc ecx
        cmp ecx,ebx
        je fin_binario_a_numero_loop
        jmp binario_a_numero_loop
    fin_binario_a_numero_loop:
    ret

; Recibe en eax un numero y lo muestra por pantalla
mostrar_numero:
    push eax
    push mostrar_numero_formato
    call _printf
    add esp,8
    ret

; Recibe en eax la direccion del mensaje a imprimir y lo imprime
imprimir_mensaje:
    push eax
    call _printf
    add esp,4
    ret

; Recibe un puntero al string en string_largo_ptr y guarda el largo en la variable string_largo
calcular_largo:
    ; Uso el ecx como contador
    mov ecx,0
    loop_longitud:
        mov eax,dword[string_largo_ptr]
        add eax,ecx
        mov eax,[eax]
        ; Aca comparo para ver si es el caracter nulo, el "\0"
        cmp al,0
        je termino_longitud
        inc ecx
        jmp loop_longitud
    termino_longitud:
        mov dword[string_largo],ecx
        ret

recibir_string_stdin:
    push binario_string
    call _gets
    add esp,4
    ret
    