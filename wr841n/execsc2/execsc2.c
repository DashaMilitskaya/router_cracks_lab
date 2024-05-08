#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>

int main (int argc, char *argv[]) {

unsigned char buf[0x1000];
void (*sc)(void);
int fd = 0;
int prot;

    if (argc > 1) {
        fd = open (argv[1], O_RDONLY);
        if (fd == -1) {
            perror ("error open file: ");
            return 1;
            }
        }

    printf ("read %d bytes\n", read (fd, buf, 0x1000));

    mprotect ((void*)((unsigned int)buf & 0xFFFFF000),
              0x1000 + ((unsigned int)buf & 0xFFF),
              PROT_READ | PROT_WRITE | PROT_EXEC);

    sc = (void(*)(void)) buf;

    sleep (2);
    (*sc)();

    printf ("execute shellcode\n");

    return 0;
}

