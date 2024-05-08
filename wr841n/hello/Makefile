
.PHONY: clean all nothing

toolchain_dir:=/usr/src/ap123_gpl/build/gcc-4.3.3/build_mips/staging_dir/usr/bin


all: hello


hello: hello.c
	PATH=$(toolchain_dir):$PATH mips-linux-gcc -o $@ $<


