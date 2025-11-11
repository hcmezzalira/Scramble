.model small
.stack 100h

.data

    CR equ 13
    LF equ 10                       
    
    ; Mensagens do Menu
    
    scramble_menu db "                            __   __   " , CR, LF
                  db "    ___ ___________ ___ _  / /  / /__ " , CR, LF
                  db "   (_-</ __/ __/ _ `/  ' \/ _ \/ / -_)" , CR, LF
                  db "  /___/\__/_/  \_,_/_/_/_/_.__/_/\__/ " 
                                                                                                                      
                  TAM_SCRAMBLE_MENU equ $-scramble_menu 
                  
    jogar_menu_s  db "               [ Jogar ]"
                  TAM_JOGAR_MENU_S equ $-jogar_menu_s
    jogar_menu    db "               [ Jogar ]"
                  TAM_JOGAR_MENU equ $-jogar_menu
    
    sair_menu_s   db "               [ Sair  ]"
                  TAM_SAIR_MENU_S equ $-sair_menu_s
    sair_menu     db "               [ Sair  ]"
                  TAM_SAIR_MENU equ $-sair_menu
    
    ; Jogar = 1, menu selecionado = Jogar
    jogar         db 1
    
    fase1_logo    db "         _____                _ " , CR, LF
                  db "        |  ___|_ _ ___  ___  / |" , CR, LF
                  db "        | |_ / _` / __|/ _ \ | |" , CR, LF
                  db "        |  _| (_| \__ \  __/ | |" , CR, LF
                  db "        |_|  \__,_|___/\___| |_|"
                  TAM_FASE1_LOGO equ $-fase1_logo
    
    ; Ticks de delay              
    DELAY_INICIO_FASE equ 73              
    
.code

; Proc para aguardar teclado
espera_tecla proc
    mov AH, 00h
    int 16h
ret
espera_tecla endp

; Proc para inserir espera de 4 segundos
delay_4seg proc
push AX
push BX
push ES
    
    ; Configura ES para a BIOS Data Area (0040h)
    mov AX, 0040h
    mov ES, AX
        
    ; Le o tick atual
    mov BX, ES:[006Ch]
    
    ; Calcula o tick final
    add BX, DELAY_INICIO_FASE
    
    espera_loop:
        ;Compara tick atual com o tick final
        cmp ES:[006Ch], BX
        jl espera_loop

pop ES
pop BX
pop AX
ret
delay_4seg endp

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
    
    mov BP, OFFSET sair_menu_s   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_SAIR_MENU_S 
    mov DH, 18        
    mov DL, 0        
    int 10h 
    jmp fim
    
    selecao_jogar:
    mov BP, OFFSET jogar_menu_s   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 04h     
    mov CX, TAM_JOGAR_MENU_S  
    mov DH, 16        
    mov DL, 0        
    int 10h 
    
    mov BP, OFFSET sair_menu_s   
    mov AH, 13h      
    mov AL, 0h       
    xor BH, BH       
    mov BL, 0Fh     
    mov CX, TAM_SAIR_MENU_S 
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
    
    call delay_4seg
    
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

; Main, inicio do programa
main:
    mov AX, SEG _DATA
    mov DS, AX
    mov ES, AX
    
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
        
    mov AH, 4Ch
    int 21h

end main