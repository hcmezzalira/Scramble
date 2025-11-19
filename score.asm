; Inicio score.asm
    ;------------------------------------------------------------------;
    ;------------Rotinas referente ao score do cabecalho---------------;
    ;------------------------------------------------------------------;

.code

; Converte o score para ASCII
score_to_ascii proc
push AX
push BX
push CX
push DX
push DI
push SI
    
    ; Carrega o score e offset da string do score
    mov AX, score_valor
    mov CX, 5
    mov DI, OFFSET score_valor_s
    mov BX, 10
    add DI, 4
    
    ; Divisao por 10 para obter o resto da divisao
loop_divisao:
    xor DX, DX
    div BX
        
    ; Converte o digito para ASCII
    add DL, '0'
    ; Salva na string
    mov [DI], DL
    ; Move o ponteiro para o pr?ximo digito ? esquerda
    dec DI
    loop loop_divisao
    
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
ret    
score_to_ascii endp

; Exibe o score (ASCII)
exibe_score proc
push AX
push CX
push BP
    
    ; Transforma o inteiro em caracter
    call score_to_ascii
    
    ; Mostra o score
    mov BP, OFFSET score_valor_s 
    mov AH, 13h                 
    mov AL, 0h                  
    xor BH, BH                  
    mov BL, 0Ah                 
    mov CX, TAM_SCORE_VALOR_S  
    mov DH, 0                   
    mov DL, 7                   
    int 10h
    
pop BP
pop CX
pop AX
ret
exibe_score endp

; Fim score.asm