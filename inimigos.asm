; Inicio inimigos.asm
    ;------------------------------------------------------------------;
    ;-----------Rotinas referente aos inimigos das fases---------------;
    ;------------------------------------------------------------------;

cria_inimigo proc
push AX
push BX
push CX
push SI

mov CX, 5
    xor SI, SI

procura_slot:
    cmp inimigo_ativo[SI], 0
    je achou_slot
    inc SI
    loop procura_slot
    jmp fim_cria

achou_slot:
    mov inimigo_ativo[SI], 1

    ; X inicial = 319 (borda direita)
    mov BX, SI
    shl BX, 1
    mov word ptr inimigo_x[BX], 319

    ; Gera Y aleatorio (8?100)
    mov AH, 00h
    int 1Ah
    mov AX, DX
    xor DX, DX
    mov CX, 93          ; faixa = 100 - 8 + 1
    div CX              ; AX / 93 ? DX = resto (0?92)
    add DX, 8           ; desloca para 8?100
    mov word ptr inimigo_y[BX], DX

    ; Tipo e sprite
    cmp fase, 2
    jz inimigo_fase2
    mov inimigo_tipo[SI], 0
    mov inimigo_sprite[SI], 0
    jmp fim_cria
    
inimigo_fase2:
    mov inimigo_tipo[SI], 1
    mov inimigo_sprite[SI], 1
    
fim_cria:
pop SI
pop CX
pop BX
pop AX
ret
cria_inimigo endp

atualiza_inimigos proc
push ax
push bx
push cx
push si

    mov cx, 5
    xor si, si

loop_atualizai:
    cmp inimigo_ativo[si], 1
    jne proximoi

    mov bx, si
    shl bx, 1            ; bx = si * 2

    ; Move inimigo para a esquerda
    mov ax, inimigo_x[bx]
    dec ax
    mov inimigo_x[bx], ax

    ; Saiu da tela?
    cmp ax, 0
    jg proximoi
    mov inimigo_ativo[si], 0

proximoi:
    inc si
    loop loop_atualizai

pop si
pop cx
pop bx
pop ax
ret
atualiza_inimigos endp

desenha_inimigos proc
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

    mov cx, 5
    xor si, si

loop_desenha:
    cmp inimigo_ativo[si], 1
    jne proximo_desenha

    ; Calcula posi??o na VRAM
    mov bx, si
    shl bx, 1
    
    mov DX, inimigo_y[bx] ; Y
    mov AX, inimigo_x[bx] ; X

    ; Ponteiro da sprite
    cmp inimigo_tipo[BX], 0
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
pop BX


proximo_desenha:
    inc si
    loop loop_desenha

pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
desenha_inimigos endp
    ; Fim inimigos.asm