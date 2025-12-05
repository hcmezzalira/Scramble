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
    
    ; Altera fase para 1 (utilizado na soma dos pontos de sobrevivencia)
    mov fase, 1
    mov tempo_valor, tempo_fases

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
    mov BL, 0Eh     
    mov CX, TAM_FASE1_LOGO  
    mov DH, 9       
    mov DL, 0        
    int 10h
    
    ; Delay de 4 segundos inicio da fase 
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

    ; Mostra palavra score no cabecalho da fase
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
   
    ; Desenha nave na posicao inicial
    mov jet_x, 10
    mov jet_y, 100
    
    ; Preenche fundo do planeta cor azul (y >= 139)
    mov AX, 0A000h
    mov ES, AX

    mov BX, 320 ; Numero de pixels eixo x
    mov SI, 139 ; Altura inicial 

pinta_linha_y1:
    mov AX, SI     
    mul BX            
    mov DI, AX         

    mov CX, 320        
    mov AL, 9   ; Cor 
    cld                
    rep stosb          

    inc SI             
    cmp SI, 200        
    jl pinta_linha_y1
    
    ; Desenha nave jet posicao inicial
    mov SI, OFFSET nave_jet ; Move para SI o offset da sprite
    mov AX, sprites_menu_c  ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX     ; Move para aux_colunas o AX
    mov AX, sprites_menu_l  ; Move para AX o numero de linhas da sprite
    mov aux_linhas, AX      ; Move para aux_linhas o AX
    mov BX, jet_x           ; Move para BX a posicao X
    mov DX, jet_y           ; Move para DX a posicao Y
    call desenha_sprite
    
    ; Loop fase 1
atualiza_jogo_fase1:  
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
    
    ; Desenha o mundo
    call desenha_superficie_fase1
    
    ; Movimenta a nave
    call move_nave
    
    ;--------------------Tiros---------------------;
    
    ;-------Atira (se disponivel)--------;
    
    mov AX, 0A000h
    mov ES, AX
    
    call le_tecla
    cmp AL, LF
    jnz sem_tiro
    
    cmp tiro1y, 0
    jnz tiro1_ativo
    
    mov AX, jet_x
    mov tiro1x, AX
    add tiro1x, 31
    
    mov AX, jet_y
    mov tiro1y, AX
    add tiro1y, 6
    
tiro1_ativo:
    
    cmp tiro2y, 0
    jnz sem_tiro
    
    mov AX, jet_x
    mov tiro2x, AX
    add tiro2x, 31
    
    mov AX, jet_y
    mov tiro2y, AX
    add tiro2y, 6
    
sem_tiro:
    
    ; Movimenta tiro
    
    cmp tiro1y, 0
    jz sem_tiro1
    
    mov AX, tiro1y
    mov DX, tiro1x
    call calcula_posicao
    ;mov ES:[DI], 0
    
    add tiro1x, 2
    mov DX, tiro1x
    mov AX, tiro1y
    
    call calcula_posicao
    
    mov ES:[DI], 0Fh
    
    cmp tiro1x, 320
    jl sem_tiro1
    mov tiro1y , 0
    
sem_tiro1:
    
    ;------------Verificacao Fim Fase-----------;
    
    ; Verifica o fim do jogo (tempo e vidas)
verificacao_fim1:
    mov AL, vidas
    cmp AL, 0
    jz fim_fase1
    
    ; Verifica se o tempo acabou e passa para proxima fase
    mov AX, tempo_valor
    cmp AX, 0
    jnz cont_fase1
    call fase2
    jmp fim_fase1
    
cont_fase1:
    jmp atualiza_jogo_fase1
        
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
