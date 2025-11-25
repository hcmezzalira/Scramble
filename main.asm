.model small
.stack 100h

.data

; Arquivos de dados utilizados
include dados.asm     
    
.code

; Arquivos de codigo utilizados
include tempo.asm
include score.asm
include menu.asm
include fase1.asm
include fase2.asm
include fase3.asm
include sprites.asm
include auxiliar.asm

; Rotina para aguardar teclado parando o programa (Utilizada para verificar codigo)
espera_tecla proc
    mov AH, 00h
    int 16h
ret
espera_tecla endp

; Rotina para ler teclado sem parar o programa
le_tecla proc
    
    ; Verifica tecla
    xor AX, AX
    mov AH, 01h
    int 16h
    jz sem_tecla
    
    ; Caso alguma tecla for detectada
    mov AH, 00h
    int 16h
    ret
    
    ; Caso nenhuma tecla for detectada
sem_tecla:
    xor AX, AX
    ret
    
le_tecla endp

; Proc para inserir espera de 4 segundos (Utilizado no inicio das fases)
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
    add BX, DELAY_INICIO_FASE ; DELAY_INICIO_FASE = 73 ticks, referente a 4 segundos
    
    ;Compara tick atual com o tick final
espera_loop:
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
    
    ; Entra no menu
    call menu_loop
        
    mov AH, 4Ch
    int 21h
end main