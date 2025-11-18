; Inicio menu.asm
    ;------------------------------------------------------------------;
    ;--------------------Rotinas referente ao menu---------------------;
    ;------------------------------------------------------------------;

.code

menu_loop proc
    ; Modo video 320x200
    mov AL, 13h
    mov AH, 0
    int 10h
    
    ; Desenha logo do Scramble no menu
    mov BP, OFFSET scramble_menu ; Move para BP o offset do Logo Scramble
    xor AL, AL                   ; Zera AL
    mov AH, 13h                  ; Move 13h para AH utilizado na interrupcao 
    xor BH, BH                   ; Zera BH
    mov BL, 0Ah                  ; Adiciona 0Ah (Cor verde claro) para o  BL
    mov CX, TAM_SCRAMBLE_MENU    ; Move o tamanho do Logo Scramble para CX
    mov DH, 1                    ; Deslocamento vertical
    mov DL, 0                    ; Deslocamento horizontal
    int 10h  
    
    mov BX, 1   ; Deslocamento inicial X da nave Jet
    mov DI, 291 ; Deslocamento inicial X da nave Alien           
    mov SI, 291 ; Deslocamento inicial X do Meteoro
    
    mov AX, sprites_menu_l     ; Move para AX o numero de linhas das sprites do menu
    mov aux_linhas, AX         ; Move para aux_linhas o AX
    
    ; Loop do menu para selecionar entre jogar e sair e movimentar os sprites
loop_menu:
    
    ; Movimentos das sprites
    ; ------------------ Nave Jet -------------------;
    
    ; Limpa coluna
    mov DX, 60                 ; Move 60 (posicao Y) para DX
    mov SI, OFFSET limpa_sm_v  ; Move para SI o offset da sprite
    mov AX, 1                  ; Move 1 (numero de colunas) para AX
    mov aux_colunas, AX        ; Move para aux_colunas o AX
    call desenha_sprite
    
    ; Verificacao de ultima linha
    inc BX                ; Incrementa BX para verificar o final da linha e desenhar a sprite na proxima coluna
    cmp BX, 320           ; Compara com o utlimo pixel da horizontal 
    jnz nao_pula_nave_jet ; Se igual a 320 (ultimo pixel da linha) continua, se diferente pula para o desenho da sprite
    mov BX, 0             ; Volta o deslocamento inicial X para 0
    
    ; Desenha Nave Jet
nao_pula_nave_jet:
    mov SI, OFFSET nave_jet ; Move para SI o offset da sprite
    mov AX, sprites_menu_c  ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX     ; Move para aux_colunas o AX
    call desenha_sprite
    
    push BX ; Salva na pilha a posicao da nave Jet
    
    ; ------------------ Nave Alien -------------------;
    
    mov AX, direcao_alien ; Move para AX a direcao da nave Alien
    cmp AX, 0             ; Compara para verificar a direcao
    jz direita            ; Se for igual a zero a nave esta indo para a direita, se for diferente a nave esta indo para esquerda

    ; Desenhar nave indo da Direita para a Esquerda
esquerda:
    ; Limpa coluna
    add DI, 28                ; Adiciona 29 (numero de colunas da sprite - 1) a DI (posicao X) para limpar a ultima coluna da sprite
    mov DX, 120               ; Move 120 para DX (posicao Y)
    mov SI, OFFSET limpa_sm_v ; Move para SI o offset da sprite
    mov AX, 1                 ; Move para 1 (numero de colunas) para AX
    mov aux_colunas, AX       ; Move para aux_colunas o AX
    mov BX, DI                ; Move para BX o DI (posicao X)
    call desenha_sprite
    
    ; Verificacao de primeira linha
    dec DI                ; Decrementa DI para verificar o inicio da linha e desenhar a sprite na proxima coluna
    sub DI, 28            ; Subtrai 29 (numero de colunas da sprite - 1) para verificar o inicio da linha
    cmp DI, 0             ; Compara para verificar se chegou ao inicio
    jnz nao_inverte_e     ; Se igual a 0 inverte a direcao, se diferente pula e mantem a mesma direcao
    mov AX, 0             ; Move 0 (0 = Direita para Esquerda) para AX
    mov direcao_alien, AX ; Move AX para direcao_alien 
nao_inverte_e:
    
    ; Desenha Nave Alien
nao_pula_nave_alien_e:
    mov DX, 120               ; Move 120 para DX (posicao Y)
    mov SI, OFFSET nave_alien ; Move para SI o offset da sprite
    mov AX, sprites_menu_c    ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX       ; Move para aux_colunas o AX
    mov BX, DI                ; Move para BX o DI (posicao X)
    call desenha_sprite

    ; Pula para segue_menu
    jmp segue_menu
    
    ; Desenhar nave indo da Esquerda para a Direita
direita:
    ; Limpar coluna
    mov DX, 120               ; Move 120 para DX (posicao Y)
    mov SI, OFFSET limpa_sm_v ; Move para SI o offset da sprite
    mov AX, 1                 ; Move para 1 (numero de colunas) para AX
    mov aux_colunas, AX       ; Move para aux_colunas o AX
    mov BX, DI                ; Move para BX o DI (posicao X)
    call desenha_sprite
    
    inc DI                ; Incrementa DI para verificar o fimda linha e desenhar a sprite na proxima coluna
    cmp DI, 290           ; Compara DI com 290 (ultima coluna valida antes de inverter direcao)
    jnz nao_inverte_d     ; Se igual a 290 inverte a direcao, se diferente pula e mantem a mesma direcao
    mov AX, 1             ; Move 1 (1 = Esquerda para Direita) para AX
    mov direcao_alien, AX ; Move AX para direcao_alien
nao_inverte_d:
    
nao_pula_nave_alien_d:
    mov DX, 120               ; Move 120 para DX (posicao Y)
    mov SI, OFFSET nave_alien ; Move para SI o offset da sprite
    mov AX, sprites_menu_c    ; Move para AX o numero de colunas da sprite
    mov aux_colunas, AX       ; Move para aux_colunas o AX
    mov BX, DI                ; Move para BX o DI (posicao X)
    call desenha_sprite

segue_menu:
    
    ; ------------------ Meteoro -------------------;
    
    ; Limpa
    mov DX, 100               ; posi??o vertical do meteoro
    mov SI, OFFSET limpa_sm_v 
    mov AX, 1                 ; limpa 1 coluna
    mov aux_colunas, AX
    mov BX, meteoro_menu_x
    call desenha_sprite

    ; Move meteoro (da direita para a esquerda)
    dec meteoro_menu_x
    mov AX, meteoro_menu_x
    cmp AX, 0               ; quando a sprite saiu da tela
    jnz meteoro_nao_reseta
    mov meteoro_menu_x, 319 ; reaparece na direita
meteoro_nao_reseta:

    ; Desenha meteoro
    mov BX, meteoro_menu_x
    mov DX, 100               ; posi??o Y
    mov SI, OFFSET meteoro    ; sprite do meteoro
    mov AX, sprites_menu_c    ; 29 colunas
    mov aux_colunas, AX
    call desenha_sprite
    
    pop BX
    
    ; -----------------------------------------------------------;
    
    ; Delay para as sprites do menu
    push AX
    push CX
    push DX
    mov AH, 86h
    mov CX, delay_b
    mov DX, delay_a
    int 15h
    pop DX
    pop CX
    pop AX
    
    call menu_cor
    call le_tecla
        
    ; Compara para verificar se foi pressionado enter
    cmp AL, 13
    jz opcao_selecionada
        
    ; Compara para verificar se foi pressionado seta para baixo
    cmp AH, 50h
    jz seta_baixo
        
    ; Compara para verificar se foi pressionado seta para cima
    cmp AH, 48h
    jz seta_cima
        
    ; Nenhuma tecla valida foi pressionada, espera por outra tecla
    jmp loop_menu
    
    ; Compara / altera a posicao em destaque
seta_baixo:
    cmp jogar, 0
    jnz nao_loop_menu1
    jmp loop_menu
nao_loop_menu1:
    mov jogar, 0
    jmp loop_menu
    
    ; Compara / altera a posicao em destaque
seta_cima:
    cmp jogar, 1
    jnz nao_loop_menu2
    jmp loop_menu
nao_loop_menu2:
    mov jogar, 1
    jmp loop_menu
    
    ; Seleciona a posicao em destaque
opcao_selecionada:
    cmp jogar, 1
    jz jogar_opcao
        
    ; Sai do programa
    mov AH, 4Ch
    int 21h
        
jogar_opcao:
    call fase1
    
menu_loop endp

; Proc para alterar a cor do Jogar e Sair no menu
menu_cor proc
push AX
push BX
push CX
push DX
push BP

    ; Compara para verificar qual esta selecionado
    cmp jogar, 1
    jz selecao_jogar
    mov BP, OFFSET jogar_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_JOGAR_MENU  
    mov DH, 20        
    mov DL, 0        
    int 10h 
    
    mov BP, OFFSET sair_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_SAIR_MENU 
    mov DH, 22        
    mov DL, 0        
    int 10h 
    jmp fim
    
selecao_jogar:
    mov BP, OFFSET jogar_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_JOGAR_MENU  
    mov DH, 20        
    mov DL, 0        
    int 10h 
    
    mov BP, OFFSET sair_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_SAIR_MENU 
    mov DH, 22        
    mov DL, 0        
    int 10h 

fim:
pop BP
pop DX
pop CX
pop BX
pop AX
ret
menu_cor endp

; Fim menu.asm