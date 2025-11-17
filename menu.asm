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
    mov BP, OFFSET scramble_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Ah     
    mov CX, TAM_SCRAMBLE_MENU  
    mov DH, 1        
    mov DL, 0        
    int 10h  
    
    mov BX, 1   ; Deslocamento inicial X da nave Jet
    mov DI, 319 ; Deslocamento inicial X da nave Alien           
    mov SI, 319 ; Deslocamento inicial X do Meteoro
    
    ; Loop do menu para selecionar entre jogar e sair
loop_menu:

    ; ------------------ Nave Jet -------------------;
    
    dec BX
    mov DX, 60
    mov SI, OFFSET limpa_jet_v
    mov AX, limpa_jet_v_l
    mov aux_linhas, AX
    mov AX, limpa_jet_v_c
    mov aux_colunas, AX
    call desenha_sprite
    
    inc BX
    cmp BX, 320               ; Compara com o utlimo pixel da horizontal 
    jnz nao_pula_nave_jet     ; Se igual a zero, zera BX para reiniciar
    mov BX, 0                 ; Deslocamento inicial X
    
nao_pula_nave_jet:
    mov DX, 60               ; Deslocamento inicial Y
    mov SI, OFFSET nave_jet   ; Carrega o offset da sprite em SI
    mov AX, nave_jet_linhas   ; Carrega em AX o numero de linhas 
    mov aux_linhas, AX        ; Carrega o numero de linhas da sprite em aux_linhas
    mov AX, nave_jet_colunas  ; Carrega em AX o numero de colunas
    mov aux_colunas, AX       ; Carrega o numero de colunas da sprite em aux_colunas
    call desenha_sprite
    
    
    inc BX
    
    push BX
    ; ------------------ Nave Alien -------------------;
    push AX
    mov AX, direcao_alien
    cmp AX, 0
    pop AX
    jz direita

esquerda:
    add DI, 28
    inc DI
    mov DX, 120
    mov SI, OFFSET limpa_jet_v
    mov AX, limpa_jet_v_l
    mov aux_linhas, AX
    mov AX, limpa_jet_v_c
    mov aux_colunas, AX
    mov BX, DI
    call desenha_sprite
    
    sub DI, 28
    push AX
    cmp DI, 0
    jnz nao_inverte_e
    mov AX, 0
    mov direcao_alien, AX
nao_inverte_e:
    pop AX
    
nao_pula_nave_alien_e:
    mov DX, 120                ; Deslocamento inicial Y
    mov SI, OFFSET nave_alien ; Carrega o offset da sprite em SI
    mov AX, nave_jet_linhas   ; Carrega em AX o numero de linhas 
    mov aux_linhas, AX        ; Carrega o numero de linhas da sprite em aux_linhas
    mov AX, nave_jet_colunas  ; Carrega em AX o numero de colunas
    mov aux_colunas, AX       ; Carrega o numero de colunas da sprite em aux_colunas
    mov BX, DI
    call desenha_sprite
 
    dec DI
    
direita:
    mov DX, 120
    mov SI, OFFSET limpa_jet_v
    mov AX, limpa_jet_v_l
    mov aux_linhas, AX
    mov AX, limpa_jet_v_c
    mov aux_colunas, AX
    mov BX, DI
    call desenha_sprite
    
    push AX
    cmp DI, 320
    jnz nao_inverte_d
    mov AX, 1
    mov direcao_alien, AX
nao_inverte_d:
    pop AX
    
nao_pula_nave_alien_d:
    mov DX, 120                ; Deslocamento inicial Y
    mov SI, OFFSET nave_alien ; Carrega o offset da sprite em SI
    mov AX, nave_jet_linhas   ; Carrega em AX o numero de linhas 
    mov aux_linhas, AX        ; Carrega o numero de linhas da sprite em aux_linhas
    mov AX, nave_jet_colunas  ; Carrega em AX o numero de colunas
    mov aux_colunas, AX       ; Carrega o numero de colunas da sprite em aux_colunas
    mov BX, DI
    call desenha_sprite

    inc DI
    
    ; -----------------------------------------------------------;
    pop BX
    
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