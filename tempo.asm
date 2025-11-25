; Inicio tempo.asm
    ;------------------------------------------------------------------;
    ;------------Rotinas referente ao tempo do cabecalho---------------;
    ;------------------------------------------------------------------;

.code

; Rotina para calcular o tempo da fase
calcula_timer proc
push AX
push BX
push CX
push DX
push ES

    mov AX, 0040h ; AX recebe o inicio do segmento
    mov ES, AX    ; ES recebe o inicio do segmento
    
    mov AX, ES:[006Ch]    ; AX recebe o tick atual
    mov BX, AX            ; BX recebe o tick atual
    mov AX, proximo_tempo ; AX recebe o proximo tick
    mov DX, AX            ; DX recebe o proximo tick 
    mov CX, tempo_valor   ; CX recebe o tempo restante em segundos
    
    cmp BX, DX   ; Compara o tick atual e o tick anterior
    jl fim_timer ; Se atual menor que proximo pula para fim_timer
    
    add DX, 18            ; Adiciona 18 ticks ao valor armazenado em DX
    mov AX, DX            ; AX recebe o valor de DX (Proximo tick)
    mov proximo_tempo, AX ; Proximo_tempo recebe o valor de AX

    dec CX               ; Diminui um segundo do timer
    mov tempo_valor, CX  ; Armazena em tempo_valor o tempo restante
    
    cmp fase, 1
    jnz cmpfase2
    add score_valor, 10
    jmp fim_timer
    
cmpfase2:
    cmp fase, 2
    jnz cmpfase3
    add score_valor, 15
    jmp fim_timer
    
cmpfase3:
    cmp fase, 3
    jnz fim_timer
    add score_valor, 20
    
fim_timer:
pop ES
pop DX
pop CX
pop BX
pop AX
ret
calcula_timer endp

; Rotina para converter o Timer para ASCII
timer_to_ascii proc
push AX
push BX
push CX
push DX
push DI
push SI
    
    mov AX, tempo_valor          ; Carrega o timer em AX
    mov CX, 2                    ; Carrega em CX o n?mero de caracteres
    mov DI, OFFSET tempo_valor_s ; Carrega o offset da string do timer 
    mov BX, 10                   ; Carrega 10 em BX para divis?o por 10
    inc DI                       ; Incrementa DI para armazenar o primeiro caracter
    
loop_divisao_timer:
    xor DX, DX ; Zera DX
    div BX     ; Divide AX por BX
        
    add DL, '0'             ; Adiciona o valor do caracter 0 em 
    mov [DI], DL            ; Salva na string
    dec DI                  ; Move o ponteiro para o digito da esquerda
    loop loop_divisao_timer ; Ate CX ficar em 0
    
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
ret    
timer_to_ascii endp

; Rotina para exibir o tempo (ASCII)
exibe_timer proc
push AX
push CX
push BP
    
    call timer_to_ascii ; Chama a rotina que transforma o inteiro em caracter
    
    ; Mostra o tempo
    mov BP, OFFSET tempo_valor_s
    mov AH, 13h                 
    mov AL, 0h                  
    xor BH, BH                  
    mov BL, 0Ah                 
    mov CX, TAM_TEMPO_VALOR_S  
    mov DH, 00                   
    mov DL, 38                   
    int 10h
    
pop BP
pop CX
pop AX
ret
exibe_timer endp

; Fim tempo.asm