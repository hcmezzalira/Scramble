.model small
.stack 100h

.data
    
include dados.asm     
    
.code

include aux.asm
include tempo.asm
include score.asm
include menu.asm
include fase1.asm
include sprites.asm

; Proc para aguardar teclado
espera_tecla proc
    mov AH, 00h
    int 16h
ret
espera_tecla endp

le_tecla proc

    xor AX, AX
    mov AH, 01h
    int 16h
    jz sem_tecla
    
    mov AH, 00h
    int 16h
    ret
    
sem_tecla:
    xor AX, AX
    ret
    
le_tecla endp

; Proc para inserir espera de 4 segundos
delay_4seg proc
push AX
push BX
push ES
    
    ; Configura ES para a BIOS Data Area (0040h)
    mov AX, 0040h
    mov ES, AX
        
    ; Le o tick atual
    mov BX, ES:[006Ch]
    
    ; Calcula o tick final
    add BX, DELAY_INICIO_FASE
    
espera_loop:
    ;Compara tick atual com o tick final
    cmp ES:[006Ch], BX
    jl espera_loop

pop ES
pop BX
pop AX
ret
delay_4seg endp

; Main, inicio do programa
main:
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX
    
    call menu_loop
        
    mov AH, 4Ch
    int 21h
end main