; Inicio fase3.asm
    ;------------------------------------------------------------------;
    ;--------------------Rotinas referente a Fase 3--------------------;
    ;------------------------------------------------------------------;

fase3 proc
push AX
push BX
push CX
push DX
push BP
push DI
push SI
push ES
    
    mov tempo_valor, tempo_fases
    mov fase, 3

    ; Limpa a tela
    mov AL, 13h
    mov AH, 0
    int 10h
    
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX

    ; Mostra o logo da Fase 3
    mov BP, OFFSET fase3_logo   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_FASE3_LOGO  
    mov DH, 9       
    mov DL, 0        
    int 10h
    
    ;Delay de 4 segundos
    call delay_4seg
    
    ; Limpa a tela
    mov AL, 13h
    mov AH, 0
    int 10h
    
    ; Parametros do timer
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
   
    ;Desenha nave na posicao inicial
    mov jet_x, 10
    mov jet_y, 60
    
    mov SI, OFFSET nave_jet ; Move para SI o offset da sprite
    mov AX, sprites_menu_c  ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX     ; Move para aux_colunas o AX
    mov AX, sprites_menu_l  ; Move para AX o numero de linhas da sprite
    mov aux_linhas, AX      ; Move para aux_linhas o AX
    mov BX, jet_x           ; Move para BX a posicao X
    mov DX, jet_y           ; Move para DX a posicao Y
    call desenha_sprite
    
    ; Loop fase 3
atualiza_jogo_fase3:  
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX
    
    ; Calcula o timer
    call calcula_timer
    ; Exibe o timer
    call exibe_timer
    
    ; Mostra o score
    call exibe_score
    
    ; Mostra as vidas
    call desenha_vidas
    
    ; Desenha nave jet novamente (Teste)
    mov SI, OFFSET nave_jet ; Move para SI o offset da sprite
    mov AX, sprites_menu_c  ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX     ; Move para aux_colunas o AX
    mov AX, sprites_menu_l  ; Move para AX o numero de linhas da sprite
    mov aux_linhas, AX      ; Move para aux_linhas o AX
    mov BX, jet_x           ; Move para BX a posicao X
    mov DX, jet_y           ; Move para DX a posicao Y
    call desenha_sprite
    
    ; Desenha o mundo
    call desenha_superficie_fase3
    
    ; Movimenta a nave
    call move_nave
    
    ; Verifica o fim do jogo (tempo e vidas)
verificacao_fim3:
    mov AL, vidas
    cmp AL, 0
    jz fim_fase3
    
    mov AX, tempo_valor
    cmp AX, 0
    jnz cont_fase3
    jmp fim_fase3
cont_fase3:
    jmp atualiza_jogo_fase3
        
fim_fase3:
pop ES
pop SI
pop DI
pop BP
pop DX
pop CX
pop BX
pop AX  
ret
fase3 endp

; Fim fase3.asm
