start:
    mov si, greeting
    call print_string

    ; --- prima ES:BX (usa AX temporaneamente) ---
    mov ax, 0
    mov es, ax
    mov bx, 0x1000

    ; --- poi i parametri di lettura (AH/AL per ultimi) ---
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0

    int 0x13
    jc disk_error

    jmp 0x1000
