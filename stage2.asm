[BITS 16]
[ORG 0x1000]

begin_2:
    mov si, msg2

print_loop2:
    lodsb
    cmp al, 0
    je stop
    mov ah, 0x0E
    int 0x10
    jmp print_loop2

stop:
    cli
    hlt
    jmp $

msg2 db 'Stage2 loaded!', 0
