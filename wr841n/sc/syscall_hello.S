#include <asm/unistd.h>
#include <sys/syscall.h>

#define O_ACCMODE   00000003
#define O_RDONLY    00000000
#define O_WRONLY    00000001
#define O_RDWR      00000002
#define O_CREAT     0x100


.text
.set    noreorder


    addiu $sp, -4
    sw $ra, 0($sp)

    bal 1f
    nop
.ascii  "Hello, world.\n"
.align 4
1:        
#   write(2, "hello, world.\n", 14);
    li $a0, 2
    move $a1, $ra
    li $a2, 14
    li $v0, SYS_write
    syscall

    bal 1f
    nop
.ascii "/tmp/test_file"
.align 4
1:
    move $a0, $ra
    li $a1, O_CREAT | O_RDWR
    li $a2, 0777
    li $v0, SYS_open
    syscall

    ;lw $ra, 0($sp)
    ;jr $ra
    ;addiu $sp, 4

quit:
    li $a0, 0
    li $v0, SYS_exit
    syscall

    b quit
    nop

