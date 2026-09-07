[BITS 16]
[ORG 0x7C00]

start:
    mov si, greeting
    call print_string

    ; --- carica stage2 da disco (settore 2) in RAM a 0x1000 ---
    mov ah, 0x02        ; funzione BIOS: leggi settori
    mov al, 1            ; leggi 1 settore
    mov ch, 0             ; cilindro 0
    mov cl, 2             ; settore 2 (il primo dopo il boot sector, che è il settore 1)
    mov dh, 0             ; testa 0
    ; dl è già impostato dalla BIOS al drive di avvio corretto, non lo tocchiamo

    mov bx, 0x1000       ; offset: dove in RAM scrivere (dentro ES)
    mov ax, 0              ; azzero AX...
    mov es, ax             ; ...e lo copio in ES, così ES:BX = 0x0000:0x1000 = 0x1000

    int 0x13
    jc disk_error

    jmp 0x1000            ; salta a stage2 appena caricato

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
