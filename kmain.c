void kmain(void) {
    char *video = (char*) 0xB8000;
    char *msg = "Kernel in C is running!";
    int i = 0;

    while (msg[i] != 0) {
        video[i * 2] = msg[i];
        video[i * 2 + 1] = 0x0A;   // verde su nero, come già fatto in asm
        i++;
    }

    while (1) {
        asm volatile("hlt");
    }
}
