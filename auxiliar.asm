; Inicio auxiliar.asm
    ;------------------------------------------------------------------;
    ;-----------Rotinas referente a Movimentacao das naves-------------;
    ;------------------------------------------------------------------;
    
move_nave proc
push AX
push BX
push CX
push DX
push BP
push DI
push SI
push ES

    ; Verifica se alguma tecla foi pressionada
    call le_tecla
        
    ; Compara para verificar se foi pressionado seta para cima
    cmp AH, 48h
    jnz cmpesquerda1 ; Se n?o foi pressionado seta para cima
    jmp seta_cima1 ; Se foi pressionado seta para cima
    
cmpesquerda1:
    ; Compara para verificar se foi pressionado seta para esquerda
    cmp AH, 4Bh
    jnz cmpbaixo1 ; Se n?o foi pressionado seta para esquerda
    jmp seta_esquerda1 ; Se foi pressionado seta para esquerda
    
cmpbaixo1:
    ; Compara para verificar se foi pressionado seta para baixo
    cmp AH, 50h
    jnz cmpdireita1 ; Se n?o foi pressionado seta para baixo
    jmp seta_baixo1 ; Se foi pressionado seta para baixo

cmpdireita1:   
    ; Compara para verificar se foi pressionado seta para direita
    cmp AH, 4Dh
    jnz verificacao_fimfim ; Se n?o foi pressionado seta para direita
    jmp seta_direita1 ; Se foi pressionado seta para direita
    
    ; Retorna
verificacao_fimfim:
    jmp move_fim
    
    ; Se seta cima pressionada (decrementa y)
seta_cima1:
    mov AX, jet_y
    cmp AX, 7
    jnz cima1
    jmp move_fim
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

    jmp move_fim
    
    ; Se seta baixo pressionada (incrementa y)
seta_baixo1:
    mov AX, jet_y
    cmp AX, 187
    jnz baixo1
    jmp move_fim
    
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
    
    jmp move_fim
    
    ; Se seta esquerda pressionada (decrementa x)
seta_esquerda1:
    mov AX, jet_x
    cmp AX, 0
    jnz esquerda1
    jmp move_fim
    
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
    
    jmp move_fim
    
    ; Se seta direita pressionada (incrementa X)
seta_direita1:
    mov AX, jet_x
    cmp AX, 291
    jnz direita1
    jmp move_fim
    
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
    
move_fim:
pop ES
pop SI
pop DI
pop BP
pop DX
pop CX
pop BX
pop AX 
ret
move_nave endp


; Calcula pixel na posicao exata da memoria
; Entradas:
; AX = Posicao Y
; DX = posicao X
; Saidas: 
; DI = Posicao na memoria 
calcula_posicao proc
push AX
push DX

    mov DI, AX
    shl DI, 6
    shl AX, 8
    add DI, AX
    add DI, DX

pop DX
pop AX
ret
calcula_posicao endp

; Desenha superficie da fase 1 e 2
desenha_superficie_fase1 proc
push AX
push BX
push CX
push DX
push SI
push DI
push DS
push ES

    mov AX, SEG _DATA
    mov DS, AX

    mov AX, 0A000h
    mov ES, AX

    mov AX, 120          ; Posicao inicial Y
    mov DX, 0            ; Posicao inicial Y
    call calcula_posicao 

    ; ---------- Verifica qual fase desenhar ----------- ;
    cmp fase, 1
    jz mundo_fase1
    mov SI, OFFSET fase2_superficie ; Move para SI o offset da sprite da superficie 2
    jmp mundo_fase2
mundo_fase1:
    mov SI, OFFSET fase1_superficie ; Move para SI o offset da sprite da superficie 1
mundo_fase2:
    ; -------------------------------------------------- ;
    
    mov BX, 490 ; Tamanho X da superficie
    mov CX, 20  ; Tamanho Y da spuerficie

    mov BP, deslocamento ; BP guarda o deslocamento horizontal da superficie

linha_superficie:
push CX
push SI
push DI

    mov CX, 320 ; Move 320 (largura da tela) para CX
    mov DX, BP  ; DX recebe o deslocamento horizontal
    add SI, DX  ; Ajusta SI conforme o deslocamento atual

coluna_superficie:
    lodsb ; AL <- DS:[SI], SI++
    stosb ; ES:[DI] <- AL, DI++

    inc DX                 ; Avanca o deslocamento
    cmp DX, BX             ; Verifica o final da sprite
    jb continua_superficie ; Se nao chegou ao final avanca

    sub DX, BX ; Volta DX para dentro da largura
    sub SI, BX ; Ajusta SI para simular sprite circular

continua_superficie:
    loop coluna_superficie ; Ate desenhar os 320 pixels da linha

    ; Proxima linha da tela
pop DI
    add DI, 320
    
    ; Proxima linha da sprite
pop SI
    add SI, 490
    
    ; Ate todas as linhas da sprite
pop CX
    loop linha_superficie

    mov AX, BP
    add AX, 1  ; Altera a velocidade da superficie
                                
    cmp AX, 490          ; Verifica limete da largura da sprite
    jb scroll_superficie
    xor AX, AX           ; Se passou, reinicia o deslocamento

scroll_superficie:
    mov deslocamento, AX ; Salva novo deslocamento para o proximo frame

pop ES
pop DS
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
ret
desenha_superficie_fase1 endp

; Desenha superficie da fase 3
desenha_superficie_fase3 proc
push AX
push BX
push CX
push DX
push SI
push DI 
push DS
push ES
    
    mov AX, SEG _DATA
    mov DS, AX

    mov AX, 0A000h
    mov ES, AX

    mov AX, 111          ; Posicao inicial Y
    mov DX, 0            ; Posicao inicial X
    call calcula_posicao

    mov SI, OFFSET fase3_superficie ; Move para SI o offset da sprite 
    
    mov BX, 480 ; Tamanho X da superficie
    mov CX, 92  ; Tamanho Y da superficie

    mov BP, deslocamento ; BP guarda o deslocamento horizontal da superficie

linha_superficie3:
push CX
push SI
push DI

    mov CX, 320 ; Move 320 (largura da tela) para CX
    mov DX, BP  ; DX recebe o deslocamento horizontal
    add SI, DX  ; Ajusta SI conforme o deslocamento atual

coluna_superficie3:
    lodsb ; AL <- DS:[SI], SI++
    stosb ; ES:[DI] <- AL, DI++

    inc DX                  ; Avanca o deslocamento
    cmp DX, BX              ; Verifica o final da sprite
    jb continua_superficie3 ; Se nao chegou ao final avanca

    sub DX, BX ; Volta DX para dentro da largura
    sub SI, BX ; Ajusta SI para simular sprite circular

continua_superficie3:
    loop coluna_superficie3 ; Ate desenhar os 320 pixels da linha

    ; Proxima linha da tela
pop DI
    add DI, 320
    
    ; Proxima linha da sprite
pop SI
    add SI, 480
    
    ; Ate todas as linhas da sprite
pop CX
    loop linha_superficie3

    
    mov AX, BP
    add AX, 1  ; Altera a velocidade da superficie

    cmp AX, 480           ; Verifica limete da largura da sprite
    jb scroll_superficie3
    xor AX, AX            ; Se passou, reinicia o deslocamento

scroll_superficie3:
    mov deslocamento, AX ; Salva novo deslocamento para o proximo frame

pop ES
pop DS
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
ret
desenha_superficie_fase3 endp

; Rotina que desenha as vidas no cabecalho
desenha_vidas proc
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
ret
desenha_vidas endp
    
; Fim auxiliar.asm