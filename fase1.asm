; Inicio fase1.asm
    ;------------------------------------------------------------------;
    ;--------------------Rotinas referente a Fase 1--------------------;
    ;------------------------------------------------------------------;

fase1 proc
push AX
push BX
push CX
push DX
push BP
push DI
push SI
push ES

; Limpa a tela Pixel por Pixel
;cld
;mov AX, 0A000h 
;mov ES, AX 
;xor DI, DI 
;mov AL, 0 
;mov CX, 320*200 
;rep stosb
    
    ; Limpa a tela
    mov AL, 13h
    mov AH, 0
    int 10h
    
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX
    
    ; Mostra o logo da Fase 1
    mov BP, OFFSET fase1_logo   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_FASE1_LOGO  
    mov DH, 9       
    mov DL, 0        
    int 10h
    
    ; Delay de 4 segundos
    call delay_4seg
    
    ; Limpa a tela
    mov AL, 13h
    mov AH, 0
    int 10h
    
    mov AX, 0040h
    mov ES, AX
    mov AX, ES:[006Ch]
    add AX, 18
    mov proximo_tempo, AX
    
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX
    
    ; Mostra palavra score no cabe?alho da fase
    mov BP, OFFSET score   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_SCORE  
    mov DH, 0       
    mov DL, 0        
    int 10h
    
    ; Mostra o score no cabe?alho da fase
    call exibe_score
    
    xor AX, AX
    mov BX, 130             ; Deslocamento inicial X
    mov AL, vidas           ; Carrega em AL o numero de vidas
    mov CX, AX              ; Carrega em CX o numero de vidas para o loop 
    
numero_vidas:
    call desenha_nave_vidas ; Desenha a nave da vida (Entrada BX: Deslocamento)
    add BX, 30          ; Espacamento entre as naves
    loop numero_vidas       ; Ate nao ter mais vidas decrementa CX
    
    ; Mostra palavra tempo no cabecalho da fase
    mov BP, OFFSET tempo   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_TEMPO  
    mov DH, 0       
    mov DL, 32        
    int 10h
    
atualiza_jogo_fase1:
    call calcula_timer
    call exibe_timer
    mov AX, tempo_valor
    cmp AX, 0
    jg atualiza_jogo_fase1    
        
fim_fase1:
    
pop ES
pop SI
pop DI
pop BP
pop DX
pop CX
pop BX
pop AX  
ret
fase1 endp

; Fim fase1.asm