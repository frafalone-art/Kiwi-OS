[BITS 16]
[ORG 0x1000]

begin_2:
    mov si, msg2

print_loop2:
    lodsb
    cmp al, 0
    je after_print
    mov ah, 0x0E
    int 0x10
    jmp print_loop2

after_print:
    cli                     ; disattiva le interrupt prima di A20/GDT/CR0

    ; --- accendi la A20 line ---
    in al, 0x92
    or al, 2
    out 0x92, al

    ; --- carica la GDT ---
    lgdt [gdt_descriptor]

    ; --- accendi il bit Protected Mode in CR0 ---
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; --- salto lungo: forza il refresh, usa il segmento codice della GDT ---
    jmp 0x08:protected_mode_start

gdt_start:
gdt_null:
    dq 0x0000000000000000
gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

msg2 db 'Stage2 loaded!', 0

[BITS 32]
protected_mode_start:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov esp, 0x90000        ; stack valido, area RAM bassa libera

clear_screen:
    mov edi, 0xB8000
    mov ecx, 2000            ; 80 * 25 caselle

clear_loop:
    mov byte [edi], ' '       ; spazio vuoto
    mov byte [edi+1], 0x0F
    add edi, 2
    loop clear_loop

    mov esi, pm_msg           ; ESI punta all'inizio del messaggio
    mov edi, 0xB8000           ; EDI riportato all'inizio schermo

pm_print_loop:
    lodsb
    cmp al, 0
    je pm_stop
    mov [edi], al
    mov byte [edi+1], 0x0F
    add edi, 2
    jmp pm_print_loop

pm_stop:
    cli
    hlt

pm_msg db 'Protected Mode activated', 0
