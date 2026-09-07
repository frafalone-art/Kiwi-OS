[BITS 16]
[ORG 0x7C00]

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
    
print_string:
    lodsb
    cmp al, 0
    je print_done
    mov ah, 0x0E
    int 0x10
    jmp print_string
print_done:
    ret

disk_error:
    mov si, err_msg
    call print_string
    cli
    hlt
    jmp $

greeting db 'Kiwi OS booting...', 0
err_msg db 'Disk error!', 0

times 510-($-$$) db 0
dw 0xAA55
