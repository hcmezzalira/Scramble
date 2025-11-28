; Inicio fase2.asm
    ;------------------------------------------------------------------;
    ;--------------------Rotinas referente a Fase 2--------------------;
    ;------------------------------------------------------------------;

fase2 proc
push AX
push BX
push CX
push DX
push BP
push DI
push SI
push ES
    
    ; Reseta o timer
    mov tempo_valor, tempo_fases
    ; Altera fase para 2 (utilizado na soma dos pontos de sobrevivencia)
    mov fase, 2

    ; Limpa a tela
    mov AL, 13h
    mov AH, 0
    int 10h
    
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX

    ; Mostra o logo da Fase 2
    mov BP, OFFSET fase2_logo   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 06h     
    mov CX, TAM_FASE2_LOGO  
    mov DH, 9       
    mov DL, 0        
    int 10h
    
    ;Delay de 4 segundos inicio da fase
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
    mov jet_y, 100
    
    mov SI, OFFSET nave_jet ; Move para SI o offset da sprite
    mov AX, sprites_menu_c  ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX     ; Move para aux_colunas o AX
    mov AX, sprites_menu_l  ; Move para AX o numero de linhas da sprite
    mov aux_linhas, AX      ; Move para aux_linhas o AX
    mov BX, jet_x           ; Move para BX a posicao X
    mov DX, jet_y           ; Move para DX a posicao Y
    call desenha_sprite
    
    ; Preenche fundo do planeta cor azul (y >= 139)
    mov AX, 0A000h
    mov ES, AX

    mov BX, 320 ; Numero de pixels eixo X
    mov SI, 139 ; Altura inicial

pinta_linha_y2:
    mov AX, SI
    mul BX
    mov DI, AX

    mov CX, 320
    mov AL, 6   ; Cor
    cld
    rep stosb

    inc SI
    cmp SI, 200
    jl pinta_linha_y2
    
    ; Loop fase 2
atualiza_jogo_fase2:
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
    call desenha_superficie_fase1
    
    ; Movimenta a nave
    call move_nave
    
    ; Verifica o fim do jogo (tempo e vidas)
verificacao_fim2:
    mov AL, vidas
    cmp AL, 0
    jz fim_fase2
    
    mov AX, tempo_valor
    cmp AX, 0
    jnz cont_fase2
    call fase3
    jmp fim_fase2
cont_fase2:
    jmp atualiza_jogo_fase2
        
fim_fase2:
pop ES
pop SI
pop DI
pop BP
pop DX
pop CX
pop BX
pop AX  
ret
fase2 endp

; Fim fase2.asm
