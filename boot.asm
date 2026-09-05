[BITS 16]
[ORG 0x7C00]

start:
    mov si, greeting

printing:
    lodsb
    cmp al, 0
    je rest
    mov ah, 0x0E
    int 0x10
    jmp printing

rest:
    cli
    hlt
    jmp rest

greeting db 'Hello from Kiwi OS', 0

times 510-($-$$) db 0
dw 0xAA55