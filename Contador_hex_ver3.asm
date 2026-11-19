    ; ============================================================
; Programa 3: Contador Progresivo Automatico en Base 16
; Cuenta de 0h a Fh usando LOOP, CMP y JNZ, mostrando los 16
; digitos hexadecimales de forma limpia.
; ============================================================
.model small
.stack 100h

.data
titulo db 'Contador hexadecimal 0h - Fh:',13,10,'$'
sep    db ' $'
fin db 13,10,'Fin del conteo.',13,10,'$'


.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, titulo
    mov ah, 9
    int 21h

    mov bl, 0               ; contador inicia en 0h
    mov cx, 16              ; 16 iteraciones para LOOP

contar:
    mov al, bl
    cmp al, 9
    jbe es_digito
    add al, 7               ; ajuste para A-F
es_digito:
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h                 ; imprime el digito hex

    cmp bl, 0Fh             ; ultimo valor? no imprimir separador
    jz  sin_sep
    lea dx, sep
    mov ah, 9
    int 21h
sin_sep:
    inc bl
    loop contar             ; CX-1, repite mientras CX != 0

    cmp bl, 10h             ; verificacion final: debe valer 10h
    jnz error

    lea dx, fin
    mov ah, 9
    int 21h
error:
    mov ax, 4C00h
    int 21h
main endp
end main
