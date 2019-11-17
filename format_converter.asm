global _main
extern _printf
extern _scanf

section .data
; Constantes
zero_ascii equ 48
nueve_ascii equ 57
letra_a_minuscula_ascii equ 97
letra_a_mayuscula_ascii equ 65
; Operaciones
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
formato_recibir_numero db "%d"
seleccion_operacion db "Se eligio la operacion %d",10,0
operacion_invalida db "Operacion fuera de rango, vuelva a elegir",10,0
ingresar_operacion_bin_BCD db "Ingrese configuracion binaria de un BCD empaquetado de 4 bytes:",10,0
ingresar_operacion_hex_BCD db "Ingrese configuracion hexadecimal de un BCD empaquetado de 4 bytes:",10,0
ingresar_operacion_bin_BPF db "Ingrese configuracion binaria de un BPF C/S de 16 bits:",10,0
ingresar_operacion_hex_BPF db "Ingrese configuracion hexadecimal de un BPF C/S de 16 bits:",10,0
ingresar_operacion_decimal db "Ingrese un numero decimal:",10,0
mostrar_numero_formato db "El numero es: %d",10,0
mostrar_string_formato db "La configuracion es: %s",10,0
string_formato db "%s"

; Tabla de potencias de 10 para hacer conversiones
tabla_potencias_diez dd 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000
; Tabla de potencias de 16 para hacer conversiones
tabla_potencias_hex dd 1, 16, 256, 4096, 65536, 1048576, 16777216, 268435456
; Tabla de caracteres hexadecimales
tabla_caracteres_hex db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'

section .bss
; Reservo este espacio para representar un binario en texto
configuracion_string resb 33
string_largo_ptr resd 1
string_largo resd 1
tipo_operacion resd 1
numero_ingresado resd 1
hexadecimal_en_memoria resd 1
binario_en_memoria resd 1
bcd_en_memoria resd 1
decimal_en_memoria resd 1
bpf_en_memoria resd 1

section .text
_main:
    call mostrar_mensaje_inicial_y_elegir_operacion
    call ejecutar_operacion
    ret
    
mostrar_mensaje_inicial_y_elegir_operacion:
    mov eax,mensaje_inicial
    call imprimir_mensaje
    
    jmp elegir_operacion

    elegir_operacion:
        push tipo_operacion
        push formato_recibir_numero
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
        
;;; Operaciones de recibir alguna configuracion y mostrar el decimal ;;;  
     
ejecutar_operacion_bin_BCD:
    ; Imprimimos mensaje para ingresar
    mov eax, ingresar_operacion_bin_BCD
    call imprimir_mensaje
    
    call pedir_string_binario_32bits_a_numero
    
    ; Del binario en memoria agarramos el valor del BCD
    mov eax, dword[binario_en_memoria]
    call calcular_BCD_y_mostrar
    
    jmp terminar_operacion

ejecutar_operacion_hex_BCD:
    ; Imprimimos mensaje para ingresar
    mov eax, ingresar_operacion_hex_BCD
    call imprimir_mensaje
    
    call pedir_string_hexa_a_numero
    
    ; Del hexadecimal en memoria agarramos el valor del BCD
    mov eax, dword[hexadecimal_en_memoria]
    call calcular_BCD_y_mostrar
    
    jmp terminar_operacion
    
ejecutar_operacion_bin_BPF:
    ; Imprimimos mensaje para ingresar
    mov eax, ingresar_operacion_hex_BPF
    call imprimir_mensaje
    
    call pedir_string_binario_16bits_a_numero
    
    ; Del binario en memoria agarramos el valor del BPF
    mov eax, dword[binario_en_memoria]
    call calcular_BPF_y_mostrar
    
    jmp terminar_operacion

ejecutar_operacion_hex_BPF:
    ; Imprimimos mensaje para ingresar
    mov eax, ingresar_operacion_hex_BPF
    call imprimir_mensaje
    
    call pedir_string_hexa_a_numero
    
    ; Del hexadecimal en memoria agarramos el valor del BPF
    mov eax, dword[hexadecimal_en_memoria]
    call calcular_BPF_y_mostrar
    
    jmp terminar_operacion

;;; Operaciones de recibir algo en decimal y procesar ;;;

ejecutar_operacion_dec_hex_BCD:
    ; Imprimimos mensaje para ingresar
    mov eax,ingresar_operacion_decimal
    call imprimir_mensaje
    call recibir_decimal_stdin
    
    call decimal_a_BCD
    mov eax,dword[bcd_en_memoria]
    mov dword[decimal_en_memoria],eax
    
    ; Pasamos 32 bits = 4 bytes = 8 nibbles
    mov eax,8
    call decimal_a_string_hexadecimal
    
    ; Finalmente mostramos
    call mostrar_configuracion
    
    jmp terminar_operacion

ejecutar_operacion_dec_bin_BCD:
    ; Imprimimos mensaje para ingresar
    mov eax,ingresar_operacion_decimal
    call imprimir_mensaje
    call recibir_decimal_stdin
    
    ; Pasamos el decimal a un BCD
    call decimal_a_BCD
    mov eax,dword[bcd_en_memoria]
    mov dword[decimal_en_memoria],eax
    
    mov eax,32
    call decimal_a_string_binario
    
    ; Finalmente mostramos
    call mostrar_configuracion

    jmp terminar_operacion

ejecutar_operacion_dec_hex_BPF:
    ; Imprimimos mensaje para ingresar
    mov eax,ingresar_operacion_decimal
    call imprimir_mensaje
    call recibir_decimal_stdin
    
    ; Como intel ya guarda el numero en complemento a 2, no hay necesidad de hacer ninguna transformacion.
    
    ; Pasamos 16 bits = 2 bytes = 4 nibbles
    mov eax,4
    call decimal_a_string_hexadecimal

    ; Finalmente mostramos
    call mostrar_configuracion

    jmp terminar_operacion

ejecutar_operacion_dec_bin_BPF:
    ; Imprimimos mensaje para ingresar
    mov eax,ingresar_operacion_decimal
    call imprimir_mensaje
    call recibir_decimal_stdin
    
    ; Como intel ya guarda el numero en complemento a 2, no hay necesidad de hacer ninguna transformacion.
    
    ; BPF c/s 16 bits
    mov eax,16
    call decimal_a_string_binario
    
    ; Finalmente mostramos
    call mostrar_configuracion
    
    jmp terminar_operacion

;;;;;;;; Rutinas Principales ;;;;;;;;;

; Convierte en bcd_en_memoria el valor del decimal en decimal_en_memoria
decimal_a_BCD:
    ; La idea es ir dividiendo el numero original para obtener los digitos e ir poniendo uno en cada nibble
    ; mas una letra (B o F) dependiendo del signo
    mov dword[bcd_en_memoria],0
    mov ecx,0
    mov eax,dword[decimal_en_memoria]
    ; Vemos el signo. Ponemos F si es positivo o B en caso de ser negativo
    add dword[bcd_en_memoria],0fh
    cmp dword[decimal_en_memoria],0
    jge decimal_a_BCD_loop
    mov dword[bcd_en_memoria],0
    add dword[bcd_en_memoria],0bh
    ; Multiplicamos por -1 para que eax quede el valor absoluto del numero
    imul eax,-1
    decimal_a_BCD_loop:
    	; Dividimos por 10 para obtener los digitos en base 10. El resto queda en edx
        mov edx,0
        mov ebx,10
        div ebx
        ; Usamos el left shift para mover el digito hacia el nibble en el que va. ecx = nibble actual, 1 nibble = 4 bits, shift = (ecx + 1) * 4
        mov ebx,ecx
        imul ecx,4
        ; Sumamos 4 para no pisar la letra de signo
        add ecx,4
        shl edx,cl
        ; Restauramos ecx
        mov ecx,ebx
        ; Añadimos en la memoria el valor usando el OR
        or dword[bcd_en_memoria],edx
        inc ecx
        ; Si es 8 significa que hicimos todos lo nibbles entonces tenemos que cortar
        cmp ecx,8
        je decimal_a_BCD_fin
    jmp decimal_a_BCD_loop
    decimal_a_BCD_fin:
        ret

; Devuelve en configuracion_string un string que representa en hexadecimal lo que hay en decimal_en_memoria
decimal_a_string_hexadecimal:
    ; La idea es cada 4 bits aplicar una mask y obtener ese numero.
    ; Despues usarlo como indice en una tabla y mapearlo al caracter correcto
    ; Guardamos los nibbles recibidos
    mov ecx,eax
    mov edx,eax
    ; Añadimos el "\0" al string
    mov byte[configuracion_string + ecx],0
    ; Creamos la mask
    mov ebx,0Fh
    decimal_a_string_hexadecimal_loop:
        ; El loop es de (eax, 0) pero necesito que sea de [eax-1, 0] 
        ; asi que resto 1 al counter pero le sumo 1 antes de la instrucion loop
        dec ecx
        mov eax,dword[decimal_en_memoria]
        and eax,ebx
        ; Normalizo el valor
        ; Para esto hago un shift de la cantidad de bits que ya vimos
        ; En edx tengo la cantidad de nibbles
        imul ecx,-1
        add ecx,edx
        sub ecx,1
        ; Multiplico por 4
        shl ecx,2
        ; Hago el shift
        shr eax,cl
        ; Restauro
        ; Divido por 4
        shr ecx,2
        add ecx,1
        sub ecx,edx
        imul ecx,-1
        ; Ya restaure ecx al valor original
        ; Le doy el valor de la tabla
        mov al,byte[tabla_caracteres_hex + eax]
        mov byte[configuracion_string + ecx],al
        ; Muevo la mask 4 bits (1 nibble)
        shl ebx,4
        inc ecx
    loop decimal_a_string_hexadecimal_loop
    ret

; Devuelve en configuracion_string un string que representa en binario lo que hay en decimal_en_memoria
decimal_a_string_binario:
    ; La idea es:
    ; Ver el ultimo digito del numero usando una mask.
    ; Divido por 2
    ; Repetir estos pasos hasta que el numero sea 0
    
    ; Recibe en eax los bits
    mov ecx,eax
    mov eax,dword[decimal_en_memoria]
    ; Añadimos el "\0" al string
    mov byte[configuracion_string + ecx],0
    decimal_a_string_binario_loop:
        ; Armo la mask
        mov ebx,1
        mov edx,eax
        and edx,ebx
        ; Divido por 2
        shr eax,1
        ; Añado al string
        add edx,zero_ascii
        dec ecx
        mov byte[configuracion_string + ecx],dl
        inc ecx
        loop decimal_a_string_binario_loop
    decimal_a_string_binario_fin:
        ret
    

; Calcula el valor en decimal_en_memoria de un BPF c/s que esta en bpf_en_memoria
BPF_a_decimal:
    ; Un BPF c/s es basicamente un numero normal pero en complemento a 2
    ; La idea va a ser:
    ; 1. Me fijo si el bit de signo es 1 o 0
    ; Si es 0 entonces este es el numero
    ; Si es 1 entonces calculo el NOT(X) y le sumo 1 y obtengo el numero
    mov eax,dword[bpf_en_memoria]
    ; En ebx pongo la mask para checkear el bit de signo (el primer bit)
    ; 8000h en binario es 1000 0000 0000 0000
    mov ebx,8000h
    and eax,ebx
    ; Me fijo si es todo 0
    cmp eax,0
    jne BPF_a_decimal_negativo
    
    ; Es positivo, lo copio y devuelvo
    mov eax,dword[bpf_en_memoria]
    jmp BPF_a_decimal_fin
    
    BPF_a_decimal_negativo:
        ; Cai en el caso con un 1 en el bit de signo
        ; Copio denuevo el numero
        mov eax,dword[bpf_en_memoria]
        ; Es de 16 bits asi que uso ax
        ; Le aplico el NOT y le sumo 1
        not ax
        ; Tambien pude haber hecho xor ax,FFFFh como nos enseño ramiro 
        add ax,1
        ; Tenemos el numero real en eax, lo multiplicamos por -1 para indicar que es negativo
        imul eax,-1
    BPF_a_decimal_fin:
        mov dword[decimal_en_memoria],eax
        ret

; Devuelve en decimal_en_memoria el valor del BCD en bcd_en_memoria
BCD_a_decimal:
    ; Es un BCD empaquetado de 4 bytes entonces tiene 7 nibbles para numeros y el ultimo para signo
    ; Voy a asumir que el numero que se ingresa esta en big endian (porque el bcd lo vimos asi en clase)
    ; aunque intel sea little endian
    mov ecx,7
    mov dword[decimal_en_memoria],0
    ; Mi idea es usar una mask de 4 bits (1111) para ir agarrando cada nibble y sumarlo al numero con su base.
    ; En cada iteracion del loop hago un shift a la derecha de la mask para pasar al otro nible
    mov ebx, 0F0000000h
    BCD_a_decimal_loop:
        ; Cargo el numero
        mov eax,dword[bcd_en_memoria]
        ; Le aplico la mask
        and eax,ebx
        ; Hago un shift para tener el numero "real"
        ; Para esto nos fijamos el nibble que estamos viendo y lo multiplicamos por 4 (hay 4 bits en cada nibble)
        ; Guardo el valor de ecx en la parte baja de edx
        mov edx,0
        mov dl,cl
        imul ecx,4
        shr eax,cl
        ; Guardo cl multiplicado por 4 en la parte alta de edx para usarlo como offset despues
        ; A lo sumo ecx es 7 -> 7 * 4 = 28 que es menor a 256 (8 bits que tiene dh)
        mov dh,cl
        mov ecx,0
        mov cl,dl
        ; Shifteo 8 bits edx para tener el valor real de dh
        shr edx,8
        ; Le restamos 4 a edx para agarrar siempre una potencia menos ya que el signo no lo tomamos
        sub edx,4
        ; Lo multiplico por su potencia en base 10
        mov edx,dword[tabla_potencias_diez + edx]
        imul eax,edx
        ; Finalmente lo añado
        add dword[decimal_en_memoria],eax
        ; Muevo la mask 4 bits
        shr ebx,4
    loop BCD_a_decimal_loop
    ; Ahora que cree el numero busco el signo que esta en el ultimo nibble
    mov ebx,0000000Fh
    mov eax,dword[bcd_en_memoria]
    and eax,ebx
    ; Ahora comparo. Si es CAFE entonces es positivo, sino es negativo
    cmp eax,0Bh
    je BCD_a_decimal_negativo
    cmp eax,0Dh
    je BCD_a_decimal_negativo
    ; Si llegamos aca es positivo (CAFE)
    jmp BCD_a_decimal_fin
    BCD_a_decimal_negativo:
        mov eax,dword[decimal_en_memoria]
        imul eax,-1
        mov dword[decimal_en_memoria],eax
    ; Finalizo
    BCD_a_decimal_fin:
        ret

; Convierte un string en hexadecimal a un numero en la memoria
; Va por cada digito y multiplica su valor por una potencia
string_hexadecimal_a_numero:
    ; Calculamos el largo del string para leer de "atras para adelante"
    mov eax,configuracion_string
    mov dword[string_largo_ptr],eax
    call calcular_largo
    mov ebx,dword[string_largo]
    ; Armamos el contador
    mov dword[hexadecimal_en_memoria],0
    mov ecx,ebx
    string_hexadecimal_a_numero_loop:
        ; Limpiamos eax. Resto 1 al ecx y luego le sumo 1 para poder indexar bien
        dec ecx
        mov eax,0
        mov al,byte[configuracion_string + ecx]
        inc ecx
        ; Si es el find del string cortamos
        cmp al,0
        je string_hexadecimal_a_numero_loop_fin
        ; Buscamos el valor "real" del digito. Si es mayor al nueve ascii entonces es una letra
        cmp eax,nueve_ascii
        jg digito_hexadecimal_letra
        sub eax,zero_ascii
        jmp digito_hexadecimal_continuar
        digito_hexadecimal_letra:
            ; Aca comparo y me fijo si es mayuscula o minuscula
            cmp eax,letra_a_minuscula_ascii
            jge digito_hexadecimal_letra_minuscula
            ; Si llego aca es porque es mayuscula
            sub eax,letra_a_mayuscula_ascii
            jmp digito_hexadecimal_letra_continuar
            digito_hexadecimal_letra_minuscula:
                sub eax,letra_a_minuscula_ascii
            digito_hexadecimal_letra_continuar:
                ; Agrego 10 porque las letras empiezan en 10 A=10, B=11, etc
                add eax,10
        digito_hexadecimal_continuar:
        ; Lo multiplicamos por su potencia
        ; Para obtener el indice de la potencia en dl hacemos size - i - 1, i = ecx, size = ebx
        mov edx,ebx
        sub edx,ecx
        ; Cada elemento de la tabla mide 4 bytes
        imul edx,4
        mov edx,dword[tabla_potencias_hex + edx]
        imul eax,edx
        add dword[hexadecimal_en_memoria],eax
    loop string_hexadecimal_a_numero_loop
    string_hexadecimal_a_numero_loop_fin:
        ret

; Convierte un string en binario a un numero en la memoria
; Va por cada digito y lo añade a un lugar de la memoria usando el left shift
string_binario_a_numero:
    mov dword[binario_en_memoria],0
    mov ecx,0
    binario_a_numero_loop:
        ; Copiamos el caracter en el eax
        mov eax,0
        mov al,byte[configuracion_string + ecx]
        ; Si llegamos al fin del string finalizamos
        cmp al,0
        je fin_binario_a_numero_loop
        sub eax,zero_ascii
        ; Guardo temporalmente el valor del ecx en el edx para poder hacer un shift
        mov edx,ecx
        ; Le pongo los bits que tiene el string
        mov ecx,ebx
        ; Le resto los que hicimos
        sub ecx,edx
        sub ecx,1
        shl eax,cl
        ; Restauro
        mov ecx,edx
        add dword[binario_en_memoria],eax
        inc ecx
        ; Terminamos?
        cmp ecx,ebx
        je fin_binario_a_numero_loop
        jmp binario_a_numero_loop
    fin_binario_a_numero_loop:
    ret

;;;;;;;; Funciones Auxiliares ;;;;;;;;

mostrar_configuracion:
    ; Finalmente imprimimos
    mov eax,configuracion_string
    call mostrar_string
    ret

; Pide un string y lo pasa de hexa a memoria
pedir_string_hexa_a_numero:
    ; Recibimos el string en hexadecimal
    call recibir_configuracion_stdin
    
    ; Pasamos el string en hexa a numero
    call string_hexadecimal_a_numero
    ret
    
; Calcula el BPF y lo muestra
calcular_BPF_y_mostrar:
    mov dword[bpf_en_memoria], eax
    call BPF_a_decimal
    
    ; Mostramos el resultado
    mov eax, dword[decimal_en_memoria]
    call mostrar_numero
    ret

; Calcula el BCD y lo muestra
calcular_BCD_y_mostrar:
    mov dword[bcd_en_memoria], eax
    call BCD_a_decimal
    
    ; Mostramos el resultado
    mov eax, dword[decimal_en_memoria]
    call mostrar_numero
    ret
    
pedir_string_binario_32bits_a_numero:
    call recibir_configuracion_stdin
    mov ebx,32
    call string_binario_a_numero
    ret
    
pedir_string_binario_16bits_a_numero:
    call recibir_configuracion_stdin
    mov ebx,16
    call string_binario_a_numero
    ret

; Recibe en eax un string y lo muestra por pantalla
mostrar_string:
    push eax
    push mostrar_string_formato
    call _printf
    add esp,8
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

recibir_configuracion_stdin:
    push configuracion_string
    push string_formato
    call _scanf
    add esp,8
    ret
  
recibir_decimal_stdin:
    push decimal_en_memoria
    push formato_recibir_numero
    call _scanf
    add esp,8
    ret
    