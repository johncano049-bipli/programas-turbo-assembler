; ============================================================
; Programa 2: Operador de Mascaras Logicas (AND / OR / XOR)
; Lee un byte en hexadecimal, una operacion logica y una mascara
; (hex). Aplica AND / OR / XOR y muestra el resultado en binario
; de 8 bits.
; ============================================================
.model small
.stack 100h

.data
operacion db ?
msg1   db 'Ingrese byte de datos en hexadecimal (00-FF): $'
msg2   db 13,10,'Operacion: (A)ND limpiar, (O)R encender, (X)OR invertir: $'
msg3   db 13,10,'Ingrese mascara en hexadecimal (00-FF): $'
msgd   db 13,10,13,10,'Dato      (bin): $'
msgm   db 13,10,'Mascara   (bin): $'
msgr   db 13,10,'Resultado (bin): $'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- dato ---
    lea dx, msg1
    mov ah, 9
    int 21h
    call leer_byte
    mov bl, al              ; BL = dato

    ; --- operacion ---
    lea dx, msg2
    mov ah, 9
    int 21h
pedir_op:
    mov ah, 8               ; lectura sin eco
    int 21h
    and al, 0DFh            ; pasar a mayuscula
    cmp al, 'A'
    je  op_ok
    cmp al, 'O'
    je  op_ok
    cmp al, 'X'
    je  op_ok
    jmp pedir_op
op_ok:
    mov operacion, al
    mov dl, al
    mov ah, 2               ; eco
    int 21h

    ; --- mascara ---
    lea dx, msg3
    mov ah, 9
    int 21h
    call leer_byte
    mov bh, al              ; BH = mascara

    ; --- mostrar dato y mascara ---
    lea dx, msgd
    mov ah, 9
    int 21h
    mov al, bl
    call imprimir_binario

    lea dx, msgm
    mov ah, 9
    int 21h
    mov al, bh
    call imprimir_binario

    ; --- aplicar operacion logica ---
    mov al, bl
    cmp operacion, 'A'
    je  hacer_and
    cmp operacion, 'O'
    je  hacer_or
    xor al, bh              ; XOR: invertir bits
    jmp mostrar
hacer_and:
    and al, bh              ; AND: apagar bits
    jmp mostrar
hacer_or:
    or  al, bh              ; OR: encender bits

mostrar:
    mov bl, al
    lea dx, msgr
    mov ah, 9
    int 21h
    mov al, bl
    call imprimir_binario

    mov ax, 4C00h
    int 21h
main endp

; ------------------------------------------------------------
; imprimir_binario: imprime AL como 8 bits
; ------------------------------------------------------------
imprimir_binario proc
    push ax
    push bx
    push cx
    push dx
    mov bl, al
    mov cx, 8
ib_loop:
    shl bl, 1               ; el bit alto pasa a CF
    mov dl, '0'
    adc dl, 0               ; '0' + CF
    mov ah, 2
    int 21h
    loop ib_loop
    pop dx
    pop cx
    pop bx
    pop ax
    ret
imprimir_binario endp

; ------------------------------------------------------------
; leer_nibble: lee un digito hex (con eco), devuelve AL=0..15
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
    sub al, 87
    jmp ln_eco
ln_may:
    sub al, 55
    jmp ln_eco
ln_num:
    sub al, '0'
ln_eco:
    push ax
    mov ah, 2
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

end main
