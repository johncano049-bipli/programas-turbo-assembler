; ============================================================
; Programa 1: Calculadora de Aritmetica Hexadecimal Directa
; Lee dos bytes en hexadecimal (00h-FFh) y un operador (+ / -)
; Ejecuta ADD o SUB sobre registros y muestra el resultado en hex
; controlando el acarreo (CF) / prestamo.
; ============================================================
.model small
.stack 100h

.data
msg1   db 'Ingrese primer valor hexadecimal (00-FF): $'
msg2   db 13,10,'Ingrese segundo valor hexadecimal (00-FF): $'
msg3   db 13,10,'Operador (+ o -): $'
msgr   db 13,10,13,10,'Resultado (hex): $'
msgc   db 13,10,'Acarreo/Prestamo (CF): $'
msgh   db 'h$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- primer operando ---
    lea dx, msg1
    mov ah, 9
    int 21h
    call leer_byte
    mov bl, al              ; BL = operando 1

    ; --- segundo operando ---
    lea dx, msg2
    mov ah, 9
    int 21h
    call leer_byte
    mov bh, al              ; BH = operando 2

    ; --- operador ---
    lea dx, msg3
    mov ah, 9
    int 21h
pedir_op:
    mov ah, 8               ; lectura sin eco
    int 21h
    cmp al, '+'
    je  es_suma
    cmp al, '-'
    je  es_resta
    jmp pedir_op            ; caracter invalido: volver a pedir

es_suma:
    mov dl, al
    mov ah, 2               ; eco del operador
    int 21h
    mov al, bl
    add al, bh              ; ADD directo sobre registros
    jmp guardar

es_resta:
    mov dl, al
    mov ah, 2
    int 21h
    mov al, bl
    sub al, bh              ; SUB directo sobre registros

guardar:
    mov ch, 0
    adc ch, 0               ; CH = CF (acarreo en suma / prestamo en resta)
    mov bl, al              ; BL = resultado

    ; --- mostrar resultado ---
    lea dx, msgr
    mov ah, 9
    int 21h
    mov al, bl
    call imprimir_byte
    lea dx, msgh
    mov ah, 9
    int 21h

    lea dx, msgc
    mov ah, 9
    int 21h
    mov al, ch
    call imprimir_nibble    ; imprime 0 o 1

    mov ax, 4C00h           ; salir a DOS
    int 21h
main endp

; ------------------------------------------------------------
; leer_nibble: lee un digito hex (0-9, A-F, a-f), eco, devuelve AL=0..15
; ------------------------------------------------------------
leer_nibble proc
    push dx
ln_otra:
    mov ah, 8
    int 21h
    mov dl, al
    cmp al, '0'
    jb  ln_otra
    cmp al, '9'
    jbe ln_num
    cmp al, 'A'
    jb  ln_otra
    cmp al, 'F'
    jbe ln_may
    cmp al, 'a'
    jb  ln_otra
    cmp al, 'f'
    ja  ln_otra
    sub al, 87              ; 'a' - 10
    jmp ln_eco
ln_may:
    sub al, 55              ; 'A' - 10
    jmp ln_eco
ln_num:
    sub al, '0'
ln_eco:
    push ax
    mov ah, 2               ; eco del caracter (en DL)
    int 21h
    pop ax
    pop dx
    ret
leer_nibble endp

; ------------------------------------------------------------
; leer_byte: lee dos digitos hex y devuelve el byte en AL
; ------------------------------------------------------------
leer_byte proc
    push bx
    push cx
    call leer_nibble
    mov cl, 4
    shl al, cl
    mov bl, al
    call leer_nibble
    or  al, bl
    pop cx
    pop bx
    ret
leer_byte endp

; ------------------------------------------------------------
; imprimir_nibble: imprime AL (0..15) como un digito hex
; ------------------------------------------------------------
imprimir_nibble proc
    push ax
    push dx
    and al, 0Fh
    cmp al, 9
    jbe in_dig
    add al, 7
in_dig:
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    pop dx
    pop ax
    ret
imprimir_nibble endp

; ------------------------------------------------------------
; imprimir_byte: imprime AL como dos digitos hex
; ------------------------------------------------------------
imprimir_byte proc
    push ax
    push cx
    push ax
    mov cl, 4
    shr al, cl
    call imprimir_nibble
    pop ax
    call imprimir_nibble    ; usa solo el nibble bajo
    pop cx
    pop ax
    ret
imprimir_byte endp

end main
