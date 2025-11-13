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
    
    ; Loop do menu para selecionar entre jogar e sair
loop_menu:
    call menu_cor
    call espera_tecla
        
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
    jz loop_menu
    mov jogar, 0
    jmp loop_menu
    
    ; Compara / altera a posicao em destaque
seta_cima:
    cmp jogar, 1
    jz loop_menu
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
    mov DH, 16        
    mov DL, 0        
    int 10h 
    
    mov BP, OFFSET sair_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_SAIR_MENU 
    mov DH, 18        
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
    mov DH, 16        
    mov DL, 0        
    int 10h 
    
    mov BP, OFFSET sair_menu   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_SAIR_MENU 
    mov DH, 18        
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