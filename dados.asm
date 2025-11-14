; Inicio dados.asm

.data
    
    ;------------------------------------------------------------------;
    ;--------------------------Auxiliares------------------------------;
    ;------------------------------------------------------------------;
    
    CR equ 13                ; Move o cursor para o inicio da linha
    LF equ 10                ; Move o cursor para a proxima linha
    DELAY_INICIO_FASE equ 73 ; Numero de ticks referente a 4 segundos
    aux_colunas   dw 0       ; Numero de colunas para as sprites
    aux_linhas    dw 0       ; Numero de linhas para as sprites
    A equ 0Ah
    C equ 0Ch
    D equ 0Dh
    E equ 0Eh
    delay_a       dw 30000
    delay_b       dw 00000
    
    ;------------------------------------------------------------------;
    ;------------------------Dados do Menu-----------------------------;
    ;------------------------------------------------------------------;
    
    ; Logo Scramble do menu
    scramble_menu db "                            __   __   " , CR, LF
                  db "    ___ ___________ ___ _  / /  / /__ " , CR, LF
                  db "   (_-</ __/ __/ _ `/  ' \/ _ \/ / -_)" , CR, LF
                  db "  /___/\__/_/  \_,_/_/_/_/_.__/_/\__/ "                                                                            
                  TAM_SCRAMBLE_MENU equ $-scramble_menu 
    
    ; Opcoes do menu jogar e sair
    jogar_menu    db "               [ Jogar ]"
                  TAM_JOGAR_MENU equ $-jogar_menu
    sair_menu     db "               [ Sair  ]"
                  TAM_SAIR_MENU equ $-sair_menu
                    
    ; Jogar = 1, menu selecionado = Jogar
    jogar         db 1
    
    ;------------------------------------------------------------------;
    ;----------------------Dados do Cabecalho--------------------------;
    ;------------------------------------------------------------------;
    
    ; String Score
    score         db "SCORE: "
                  TAM_SCORE equ $-score
    
    ; Score em formato inteiro
    score_valor   dw 0
                  TAM_SCORE_VALOR equ $-score_valor
                  
    ; Score em formato ASCII
    score_valor_s db "00000"
                  TAM_SCORE_VALOR_S equ $-score_valor_s
                  
    ; Nave referente as vidas
    nave_vidas    db 9,9,9,9,9,0,0,C,C,C,C,0,E,E,E,E,0,0,0
                  db 0,9,9,9,C,C,C,C,C,C,C,0,E,0,0,E,E,0,0
                  db 0,C,C,C,C,C,C,C,C,C,C,0,E,0,E,E,0,E,E
                  db E,E,E,E,E,C,C,C,C,C,C,C,0,0,0,0,0,0,0
                  db 0,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C
                  db 0,9,9,9,C,C,C,C,C,C,C,C,C,C,C,C,C,0,0
                  db 9,9,9,9,9,0,0,C,C,C,C,C,C,C,C,0,0,0,0
    
    ; Numero de linhas da nave do cabecalho
    nave_vidas_linhas equ 7
    ; Numero de colunas da nave do cabecalho
    nave_vidas_colunas equ 19
    
    ; Numero de vidas do jogador
    vidas         db 3
    
    ; String tempo
    tempo         db "TEMPO: "
                  TAM_TEMPO equ $-tempo
    
    ; Tempo restante em segundos em formato inteiro
    tempo_valor   dw 60
                  TAM_TEMPO_VALOR equ $-tempo_valor
    
    ; String de tempo restante em segundos em formato ASCII
    tempo_valor_s db "60"
                  TAM_TEMPO_VALOR_S equ $-tempo_valor_s
    
    ; Proximo tick
    proximo_tempo  dw 0
    
    ;------------------------------------------------------------------;
    ;------------------------Dados das Fases---------------------------;
    ;------------------------------------------------------------------;
    
    nave_jet      db 9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                  db 0,9,9,9,9,9,9,9,0,0,0,0,0,0,0,C,C,C,C,0,E,E,E,0,0,0,0,0,0
                  db 0,0,9,9,9,9,9,9,9,0,0,0,C,C,C,C,C,C,C,0,E,E,E,E,E,E,0,0,0
                  db 0,0,0,9,9,9,9,9,C,C,C,C,C,C,C,C,C,C,C,0,E,E,0,0,E,E,E,0,0
                  db 0,0,0,0,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,0,E,E,0,0,E,E,E,E,0
                  db 0,0,0,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,0,E,0,E,E,E,0,E,E
                  db E,E,E,E,E,E,E,E,E,C,C,C,C,C,C,C,C,C,C,C,C,0,0,0,0,0,0,0,0
                  db 0,0,0,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C
                  db 0,0,0,0,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,0
                  db 0,0,0,9,9,9,9,9,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,C,0,0
                  db 0,0,9,9,9,9,9,9,9,0,0,0,C,C,C,C,C,C,C,C,C,C,C,C,C,0,0,0,0
                  db 0,9,9,9,9,9,9,9,0,0,0,0,0,0,0,C,C,C,C,0,0,0,0,0,0,0,0,0,0
                  db 9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    
    ; Numero de linhas da nave Jet
    nave_jet_linhas equ 13
    
    ; Numero de colunas da nave Jet
    nave_jet_colunas equ 29
    
    ; Posicao no eixo X da nave Jet
    nave_jet_x    dw 0
    
    ; Posicao no eixo Y da nave Jet
    nave_jet_y    dw 100
    
    ; Limpa nave Jet vertical
    limpa_jet_v   db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
                  db 0
    
    ; Linhas da sprite que limpa a nave Jet 
    limpa_jet_v_l equ 13
    
    ; Colunas da sprite que limpa a nave Jet
    limpa_jet_v_c equ 1
               
    ; Limpa nave Jet horizontal
    limpa_jet_h   db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    ; Linhas da sprite que limpa a nave Jet
    limpa_jet_h_l equ 1
    
    ; Colunas da sprite que limpa a nave Jet
    limpa_jet_h_c equ 29
    
    ;------------------------------------------------------------------;
    ;------------------------Dados da Fase 1---------------------------;
    ;------------------------------------------------------------------;
    
    ; Logo da Fase 1
    fase1_logo    db "         _____                _ " , CR, LF
                  db "        |  ___|_ _ ___  ___  / |" , CR, LF
                  db "        | |_ / _` / __|/ _ \ | |" , CR, LF
                  db "        |  _| (_| \__ \  __/ | |" , CR, LF
                  db "        |_|  \__,_|___/\___| |_|"
                  TAM_FASE1_LOGO equ $-fase1_logo
                  
    nave_alien    db 0,0,0,0,0,0,0,2,2,2,2,2,2,2,A,E,E,E,E,E,E,E,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,2,2,2,2,2,2,2,A,E,E,E,E,E,E,E,0,0,0,0,0,0,0
                  db 0,0,0,0,2,2,2,2,2,A,E,E,E,E,E,E,E,E,E,E,E,E,E,E,E,0,0,0,0
                  db 0,0,0,0,2,2,2,2,2,A,E,E,E,E,E,E,E,E,E,E,E,E,E,E,E,0,0,0,0
                  db 0,0,0,0,2,2,5,5,5,D,E,E,5,5,5,D,E,E,5,5,5,D,E,E,E,0,0,0,0
                  db 0,0,2,2,2,2,5,5,5,D,E,E,5,5,5,D,E,E,5,5,5,D,E,E,E,E,E,0,0
                  db 0,0,2,2,2,2,5,5,5,D,E,E,5,5,5,D,E,E,5,5,5,D,E,E,E,E,E,0,0
                  db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,A,E,E,E,E,E,E,E,E,E,E,E,E,E,E
                  db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,A,E,E,E,E,E,E,E,E,E,E,E,E,E,E
                  db 0,0,0,0,0,0,5,5,D,2,2,A,E,E,5,5,D,E,E,E,E,0,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,5,5,D,2,2,A,E,E,5,5,D,E,E,E,E,0,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,2,2,2,A,E,E,E,0,0,0,0,0,0,0,0,0,0,0
                  db 0,0,0,0,0,0,0,0,0,0,0,2,2,2,A,E,E,E,0,0,0,0,0,0,0,0,0,0,0
                  
; Fim dados.asm
    