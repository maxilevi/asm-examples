global _main
extern _printf

section .data
STRING_A dd "dsAdsAA",0
STRING_B dd "dsAdsAB",0
CHAR db "A"
formato db "%d",0

section .bss
LARGO_A resd 1
LARGO_B resd 1
RESULT1 resb 1
OCURRENCIAS resd 1
STRING_LARGO resd 1
LARGO resd 1


section .text
_main:
    mov ebp, esp; for correct debugging
    call cant_ocurrencias
    push dword[OCURRENCIAS]
    push formato
    call _printf
    add esp,8
    ret

comparar_strings:
    mov byte[RESULT1],'S'
    
    ; Calculo la longitud a
    mov eax,dword[STRING_A]
    mov dword[STRING_LARGO],eax
    call calcular_largo
    mov eax,dword[LARGO]
    mov dword[LARGO_A],eax
    
    ; Calculo la longitud b
    mov eax,dword[STRING_B]
    mov dword[STRING_LARGO],eax
    call calcular_largo
    mov eax,dword[LARGO]
    mov dword[LARGO_B],eax
    
    ; Comparo las longitudes, si son distintas entonces nunca van a ser iguales
    mov eax,dword[LARGO_B]
    cmp eax,dword[LARGO_A]
    jne no_iguales
    
    ; Comparo el string byte por byte con el CMPS
    mov ecx,dword[LARGO_A]
    mov esi,STRING_A
    mov edi,STRING_B
    REPE CMPSB
    je iguales
    
    no_iguales:
        mov byte[RESULT1],'N'
    iguales:
        ret
    
cant_ocurrencias:
    mov dword[OCURRENCIAS],0
    ; Copio la direccion del string a en string largo para poder
    mov eax,dword[STRING_A]
    mov dword[STRING_LARGO],eax
    ; Calculo el largo de STRING_A y lo uso como contador para el loop
    call calcular_largo
    mov ecx,dword[LARGO]
    inicio_loop:
        ; Agarro cada caracter y me fijo si es el mismo que CHAR 
        mov eax,dword[STRING_A + ecx]
        cmp al,byte[CHAR]
        je incrementar_ocurrencias
        jmp seguir_loop
        incrementar_ocurrencias:
            inc dword[OCURRENCIAS]
        seguir_loop:
    LOOP inicio_loop
    ret
    
; Funcion auxiliar le pasas un string y te dice el largo
calcular_largo:
    ; Uso el ecx como contador
    mov ecx,0
    loop_longitud:
        mov eax,dword[STRING_LARGO + ecx]
        cmp al,0 ; Aca comparo para ver si el caracter nulo, el "\0"
        je termino_longitud
        inc ecx
        jmp loop_longitud
    termino_longitud:
        mov dword[LARGO],ecx
        ret
