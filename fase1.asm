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
    ; call delay_4seg
    
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
    
    ; Loop fase 1
atualiza_jogo_fase1:
    
    ; Mostra o score no cabe?alho da fase
    call exibe_score
    
    ; Parametros para exibicao das vidas restantes
    mov BX, 130                ; Deslocamento inicial X
    mov DX, 0                  ; Deslocamento inicial Y
    mov SI, OFFSET nave_vidas  ; Carrega o offset da sprite em SI
    mov AX, nave_vidas_linhas  ; Carrega em AX o numero de linhas 
    mov aux_linhas, AX         ; Carrega o numero de linhas da sprite em aux_linhas
    mov AX, nave_vidas_colunas ; Carrega em AX o numero de colunas
    mov aux_colunas, AX        ; Carrega o numero de colunas da sprite em aux_colunas
    
    xor AX, AX                ; Zera AX
    mov AL, vidas             ; Carrega em AL o numero de vidas
    mov CX, AX                ; Carrega em CX o numero de vidas para o loop 
numero_vidas:
    call desenha_sprite ; Desenha a nave da vida (Entrada BX: Deslocamento)
    add BX, 30              ; Espacamento entre as naves
    loop numero_vidas       ; Ate nao ter mais vidas decrementa CX
    
    call calcula_timer
    call exibe_timer
    
    ; -------------------- Movimenta nave Jet ----------------------- ;
    
    call le_tecla
        
    ; Compara para verificar se foi pressionado seta para cima
    cmp AH, 48h
    jnz cmpesquerda1
    jmp seta_cima1
    
cmpesquerda1:
    ; Compara para verificar se foi pressionado seta para esquerda
    cmp AH, 4Bh
    jnz cmpbaixo1
    jmp seta_esquerda1
    
cmpbaixo1:
    ; Compara para verificar se foi pressionado seta para baixo
    cmp AH, 50h
    jnz cmpdireita1
    jmp seta_baixo1

cmpdireita1:   
    ; Compara para verificar se foi pressionado seta para direita
    cmp AH, 4Dh
    jnz verificacao_fimfim
    jmp seta_direita1
    
verificacao_fimfim:
    jmp verificacao_fim1
    
seta_cima1:
    mov AX, jet_y
    cmp AX, 7
    jnz cima1
    jmp verificacao_fim1
cima1:
    
    dec jet_y
    
    ; Limpar linha
    mov DX, jet_y             
    add DX, sprites_menu_l     
    mov SI, OFFSET limpa_sm_h 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX       
    mov aux_linhas, 1         
    mov BX, jet_x             
    call desenha_sprite
               
    ; Desenha sprite 
    sub DX, sprites_menu_l     
    mov SI, OFFSET nave_jet 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX      
    mov AX, sprites_menu_l
    mov aux_linhas, AX        
    mov BX, jet_x             
    call desenha_sprite

    jmp verificacao_fim1
    
seta_baixo1:
    mov AX, jet_y
    cmp AX, 187
    jnz baixo1
    jmp verificacao_fim1
    
baixo1:
    ; Limpar linha
    mov DX, jet_y                  
    mov SI, OFFSET limpa_sm_h 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX       
    mov aux_linhas, 1         
    mov BX, jet_x             
    call desenha_sprite
    
    ; Desenha sprite   
    inc jet_y
    mov DX, jet_y
    mov SI, OFFSET nave_jet 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX      
    mov AX, sprites_menu_l
    mov aux_linhas, AX        
    mov BX, jet_x             
    call desenha_sprite
    
    jmp verificacao_fim1
    
seta_esquerda1:
    mov AX, jet_x
    cmp AX, 0
    jnz esquerda1
    jmp verificacao_fim1
    
esquerda1:
    ; Limpar linha
    mov DX, jet_y   
    mov SI, OFFSET limpa_sm_v 
    mov AX, sprites_menu_l    
    mov aux_linhas, AX       
    mov aux_colunas, 1         
    mov BX, jet_x   
    add BX, sprites_menu_c
    dec BX
    call desenha_sprite
    
    ; Desenha sprite   
    dec jet_x
    mov DX, jet_y
    mov SI, OFFSET nave_jet 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX      
    mov AX, sprites_menu_l
    mov aux_linhas, AX        
    mov BX, jet_x             
    call desenha_sprite
    
    jmp verificacao_fim1
    
seta_direita1:
    mov AX, jet_x
    cmp AX, 291
    jnz direita1
    jmp verificacao_fim1
    
direita1:
    ; Limpar linha
    mov DX, jet_y   
    mov SI, OFFSET limpa_sm_v 
    mov AX, sprites_menu_l    
    mov aux_linhas, AX       
    mov aux_colunas, 1         
    mov BX, jet_x   
    call desenha_sprite
    
    ; Desenha sprite   
    inc jet_x
    mov DX, jet_y
    mov SI, OFFSET nave_jet 
    mov AX, sprites_menu_c    
    mov aux_colunas, AX      
    mov AX, sprites_menu_l
    mov aux_linhas, AX        
    mov BX, jet_x             
    call desenha_sprite
    
    jmp verificacao_fim1
    
    ; -------------------- Verificacao fim de jogo ------------------ ;
    
verificacao_fim1:
    mov AX, tempo_valor
    cmp AX, 0
    jz fim_fase1
    
    mov AL, vidas
    cmp AL, 0
    jz fim_fase1
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