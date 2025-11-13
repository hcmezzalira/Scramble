; Inicio sprites.asm
    ;------------------------------------------------------------------;
    ;-------Rotinas referente as rotinas graficas dos sprites----------;
    ;------------------------------------------------------------------;
    
; Desenha nave que representa as vidas
; Entradas:
; SI = offset do sprite
; BP = numero de linhas
; DI = numero de colunas
; AH = Posicao vertical
; AL = posicao horizontal
desenha_nave_vidas proc
push AX
push CX
push DX
push DI
push SI
push BP
push ES
    
    mov AX, 0A000h
    mov ES, AX

    mov DX, 0
    
    mov SI, OFFSET nave_vidas
    ; Contador de linhas
    mov BP, nave_linhas
    
linha_loop:
    push DX     ; Armazena da pilha a linha correspondente
    mov AX, DX  ; AX recebe posicao Y
    mov CX, 320 ; CX recebe 320
    mul CX      ; Multiplica AX com CX armazenando em AX
    mov DI, AX  ; Armazena em DI o resultado da multiplicacao
        
    mov CX, nave_colunas ; CX recebe 19 (colunas) 
    push BX              ; Joga BX para pilha 
    
coluna_loop:
    mov AL, [SI]   ; Armazena em AL o OFFSET da cor 
    push AX         ; Carrega na pilha a cor
    mov AX, DI      ; Carrega o resultado da multiplicacao em AX
    add AX, BX      ; Soma o resultado com deslocamento X
    mov DI, AX      ; Carrega em DI o resultado da soma
    pop AX          ; Retorna a cor em AL
    mov ES:[DI], AL ; Carrega a cor no endere?o correto
    sub DI, BX

    inc BX           ; Incrementa 1 em BX (eixo X)
    inc SI           ; Incrementa 1 em SI vetor de cores
    loop coluna_loop ; Entra no loop ate todas as colunas da linha forem salvas na memoria
        
    pop BX         ; Retorna o valor o valor da coluna 
    pop DX         ; Retorna da pilha o valor da linha
    inc DX         ; Incrementa DX eixo Y
    dec BP         ; Decrementa BP (Linhas)
    cmp BP, 0      ; Compara para verificar se chegou a linha 0
    jnz linha_loop ; Enquanto nao igual a zero
        
pop ES
pop BP 
pop SI
pop DI
pop DX
pop CX
pop AX
ret
desenha_nave_vidas endp
    
; Fim sprites.asm