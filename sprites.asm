; Inicio sprites.asm
    ;------------------------------------------------------------------;
    ;-------Rotinas referente as rotinas graficas dos sprites----------;
    ;------------------------------------------------------------------;
    
; Desenha nave que representa as vidas
; Entradas:
; SI = offset do sprite
; DX = posicao vertical
; BX = posicao horizontal
; aux_colunas = numero de colunas
; aux_linhas = numero de linhas 
desenha_sprite proc
push AX
push BX
push CX
push DX
push DI
push SI
push BP
push ES
    
    mov AX, 0A000h ; Recebe o comeco do segmento do video 
    mov ES, AX     ; Armazena em ES
    
    mov BP, aux_linhas ; Move para BP o numero de linhas
    
linha_loop:
    push DX     ; Armazena na pilha a linha correspondente
    mov AX, DX  ; AX recebe posicao Y
    mov CX, 320 ; CX recebe 320
    mul CX      ; Multiplica AX com CX armazenando em AX
    mov DI, AX  ; Armazena em DI o resultado da multiplicacao
        
    mov CX, aux_colunas ; CX recebe 19 (colunas) 
    push BX             ; Joga BX para pilha 
    
    push AX
    
coluna_loop:
    
    mov AX, DI      ; Carrega o resultado da multiplicacao em AX
    add AX, BX      ; Soma o resultado com deslocamento X
    mov DI, AX      ; Carrega em DI o resultado da soma

    mov AL, [SI]    ; Armazena em AL o OFFSET da cor 
    mov ES:[DI], AL ; Carrega a cor no endereco correto
    sub DI, BX      ; Subtrai o deslocamento BX

    inc BX           ; Incrementa 1 em BX (eixo X)
    cmp BX, 320
    jne pula_coluna_s
    sub BX, 320
pula_coluna_s:
    inc SI           ; Incrementa 1 em SI vetor de cores
    loop coluna_loop ; Entra no loop ate todas as colunas da linha forem salvas na memoria
    
    pop AX
    pop BX         ; Retorna da pilha o valor da coluna 
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
pop BX
pop AX
ret
desenha_sprite endp

; Fim sprites.asm