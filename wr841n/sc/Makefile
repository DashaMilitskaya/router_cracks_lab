
.PHONY: clean all nothing

toolchain_dir:=/usr/src/ap123_gpl/build/gcc-4.3.3/build_mips/staging_dir/usr/bin


all: syscall_hello.bin


syscall_hello.bin: syscall_hello.S
	PATH=$(toolchain_dir):$PATH mips-linux-gcc -G0 -mno-abicalls -fno-pic -c -mips32 -o syscall_hello.o syscall_hello.S
	PATH=$(toolchain_dir):$PATH mips-linux-objcopy -O binary -j .text syscall_hello.o syscall_hello.bin
	rm -rf syscall_hello.o

