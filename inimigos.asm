; Inicio inimigos.asm
    ;------------------------------------------------------------------;
    ;-----------Rotinas referente aos inimigos das fases---------------;
    ;------------------------------------------------------------------;

; Rotina para verificar e criar novos inimigos
cria_inimigo proc
push AX
push BX
push CX
push SI

    mov CX, 5
    xor SI, SI

    ; Verifica se existe algum slot livre
procura_slot:
    cmp inimigo_ativo[SI], 0
    je achou_slot
    inc SI
    loop procura_slot
    jmp fim_cria

achou_slot:
    mov inimigo_ativo[SI], 1 ; Altera para inimigo ativo

    ; X inicial = 290 (borda direita)
    mov BX, SI
    shl BX, 1                       ; Multiplica por 2 por ser dw
    mov word ptr inimigo_x[BX], 289

    ; Gera Y aleatorio (8-94)
    mov AH, 00h
    int 1Ah
    mov AX, DX
    xor DX, DX
    mov CX, 85
    div CX
    add DX, 8
    mov word ptr inimigo_y[BX], DX

    ; Tipo e sprite
    cmp fase, 2
    jz inimigo_fase2
    mov inimigo_tipo[SI], 0
    jmp fim_cria
    
inimigo_fase2:
    mov inimigo_tipo[SI], 1
    
fim_cria:
pop SI
pop CX
pop BX
pop AX
ret
cria_inimigo endp

; Rotina para atualizar a posicao dos inimigos
atualiza_inimigos proc
push AX
push BX
push CX
push SI

    mov CX, 5
    xor SI, SI
    
    ; Verifica se existe inimigo ativo
loop_atualizai:
    cmp inimigo_ativo[SI], 1
    jne proximoi

    mov BX, SI
    shl BX, 1  ; bx = si * 2

    ; Move inimigo para a esquerda
    mov AX, inimigo_x[BX]
    dec AX
    mov inimigo_x[BX], AX

    ; Saiu da tela
    cmp AX, 0
    jg proximoi
    mov inimigo_ativo[SI], 0
    
    mov DX, inimigo_y[BX]
    mov AX, inimigo_x[BX]
    
    ; Trecho que limpa o inimigo no inicio da tela
push BX
push SI
    mov BX, AX
    inc BX
    mov aux_linhas, 13
    mov aux_colunas, 29
    mov SI, OFFSET bug_fix
    call desenha_sprite
pop SI
pop BX
    
proximoi:
    inc SI
    loop loop_atualizai

pop SI
pop CX
pop BX
pop AX
ret
atualiza_inimigos endp

; Rotina que desenha os inimigos
desenha_inimigos proc
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

    mov CX, 5
    xor SI, SI
    
loop_desenha:
    ; Verifica se existe algum inimigo ativo
    cmp inimigo_ativo[SI], 1
    jne proximo_desenha

    ; Calcula posicao na VRAM
    mov BX, SI
    shl BX, 1
    
    mov DX, inimigo_y[BX] ; Y
    mov AX, inimigo_x[BX] ; X

    ; Ponteiro da sprite, verifica qual tipo do inimigo
    cmp inimigo_tipo[SI], 1
    jz desenha_meteoroi
    mov SI, OFFSET nave_alien
    jmp ialien
    
desenha_meteoroi:
    mov SI, OFFSET meteoro
    
ialien:
    
push BX
    mov BX, AX
    mov aux_linhas, sprites_menu_l
    mov aux_colunas, sprites_menu_c
    call desenha_sprite
    
    add BX, 29
    mov aux_colunas, 1
    mov SI, OFFSET limpa_sm_v
    call desenha_sprite
pop BX


proximo_desenha:
    inc SI
    loop loop_desenha

pop ES
pop DS
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
ret
desenha_inimigos endp
    ; Fim inimigos.asm