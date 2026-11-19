# Programas en Turbo Assembler (TASM)

Repositorio con 3 programas desarrollados en lenguaje ensamblador (x86) utilizando Turbo Assembler.

## Contenido del repositorio

1. **Calculadora_hex_ver1.asm — Calculadora de Aritmética Hexadecimal Directa**
   * Lee dos bytes en formato hexadecimal (`00h`–`FFh`) y un operador (`+` o `-`).
   * Ejecuta las instrucciones `ADD` o `SUB` directamente sobre los registros y muestra el resultado en hexadecimal indicando el estado de la bandera de acarreo o préstamo (`CF`).

2. **Mascaras_logicas_ver2.asm — Operador de Máscaras Lógicas (AND / OR / XOR)**
   * Solicita un byte de datos en hexadecimal (`00h`–`FFh`), una operación lógica (`A` para `AND`, `O` para `OR`, `X` para `XOR`) y una máscara en hexadecimal.
   * Aplica la operación bit a bit y muestra el dato original, la máscara y el resultado final en formato binario de 8 bits.

3. **Contador_hex_ver3.asm — Contador Progresivo Automático en Base 16**
   * Realiza un conteo automático desde `0h` hasta `Fh` utilizando las instrucciones `LOOP`, `CMP` y `JNZ`.
   * Imprime en pantalla los 16 dígitos hexadecimales separados por espacios.

## Requisitos y ejecución

Para compilar y ejecutar cualquiera de los programas en **Turbo Assembler** (o mediante **DOSBox** en sistemas de 64 bits), utiliza los siguientes comandos:

```bash
tasm Calculadora_hex_ver1.asm
tlink Calculadora_hex_ver1.obj
Calculadora_hex_ver1.exe
```
