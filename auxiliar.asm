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
    ;jmp verificacao_fim1
    
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

calcula_posicao proc
    ; Entrada:
    ;   AX = Y
    ;   DX = X
    ; Sa??da:
    ;   DI = posi????o na VRAM (A000:DI)

    push ax
    push dx

    mov di, ax          ; DI = Y
    shl di, 6           ; DI = Y * 64
    shl ax, 8           ; AX = Y * 256
    add di, ax          ; DI = Y * 320
    add di, dx          ; DI = Y * 320 + X

    pop dx
    pop ax
    ret
calcula_posicao endp

desenha_superficie_fase1 proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es

    mov ax, SEG _DATA
    mov ds, ax

    mov ax, 0A000h
    mov es, ax

    ;-------------------------------------------
    ; Posi????o inicial da superf??cie na tela
    ; (inferior da tela: Y = 180)
    ;-------------------------------------------
    mov ax, 120
    mov dx, 0
    call calcula_posicao 

    ;-------------------------------------------
    ; Configura????o inicial da superf??cie
    ;-------------------------------------------
    cmp fase, 1
    jz mundo_fase1
    mov si, OFFSET fase2_superficie
    jmp mundo_fase2
mundo_fase1:
    mov si, OFFSET fase1_superficie
mundo_fase2:
    
    mov bx, 490                 ; largura total da superf??cie
    mov cx, 20                  ; altura total

    mov bp, desloc_superficie   ; deslocamento horizontal

sup_linha:
    push cx
    push si
    push di

    mov cx, 320                 ; largura vis??vel (tela)
    mov dx, bp                  ; deslocamento dentro da linha
    add si, dx

sup_coluna:
    lodsb                       ; l?? byte da superf??cie
    stosb                       ; escreve no v??deo

    inc dx
    cmp dx, bx
    jb sup_ok

    ; loop horizontal (reinicia a linha)
    sub dx, bx
    sub si, bx

sup_ok:
    loop sup_coluna

    pop di
    add di, 320                 ; pr??xima linha
    pop si
    add si, 490                 ; pr??xima linha do sprite
    pop cx
    loop sup_linha

    ;-------------------------------------------
    ; Atualiza deslocamento (velocidade)
    ;-------------------------------------------
    mov ax, bp
    add ax, 1                   ; VELOCIDADE
                                
    cmp ax, 490
    jb sup_scroll_ok
    xor ax, ax

sup_scroll_ok:
    mov desloc_superficie, ax

    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
desenha_superficie_fase1 endp

desenha_superficie_fase3 proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es

    mov ax, SEG _DATA
    mov ds, ax

    mov ax, 0A000h
    mov es, ax

    ;-------------------------------------------
    ; Posi????o inicial da superf??cie na tela
    ; (inferior da tela: Y = 87)
    ;-------------------------------------------
    mov ax, 87
    mov dx, 0
    call calcula_posicao 

    ;-------------------------------------------
    ; Configura????o inicial da superf??cie
    ;-------------------------------------------

    mov si, OFFSET fase3_superficie
    
    mov bx, 480                 ; largura total da superf??cie
    mov cx, 112                 ; altura total

    mov bp, desloc_superficie   ; deslocamento horizontal

sup_linha3:
    push cx
    push si
    push di

    mov cx, 320                 ; largura vis??vel (tela)
    mov dx, bp                  ; deslocamento dentro da linha
    add si, dx

sup_coluna3:
    lodsb                       ; l?? byte da superf??cie
    stosb                       ; escreve no v??deo

    inc dx
    cmp dx, bx
    jb sup_ok3

    ; loop horizontal (reinicia a linha)
    sub dx, bx
    sub si, bx

sup_ok3:
    loop sup_coluna3

    pop di
    add di, 320                 ; pr??xima linha
    pop si
    add si, 480                 ; pr??xima linha do sprite
    pop cx
    loop sup_linha3

    ;-------------------------------------------
    ; Atualiza deslocamento (velocidade)
    ;-------------------------------------------
    mov ax, bp
    add ax, 1                   ; VELOCIDADE
                                
    cmp ax, 480
    jb sup_scroll_ok3
    xor ax, ax

sup_scroll_ok3:
    mov desloc_superficie, ax

    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
desenha_superficie_fase3 endp

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