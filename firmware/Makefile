RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32

SHELL = bash
FIRMWARE_OBJS = start.o main.o print.o leds.o
GCC_WARNS  = -Werror -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings
GCC_WARNS += -Wredundant-decls -Wstrict-prototypes -Wmissing-prototypes -pedantic # -Wconversion
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)i/bin/riscv32-unknown-elf-
COMPRESSED_ISA = C

firmware.hex: firmware.bin makehex.py
	python3 makehex.py $< 16384 > $@

firmware.bin: firmware.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@
	chmod -x $@

firmware.elf: $(FIRMWARE_OBJS) sections.lds
	$(TOOLCHAIN_PREFIX)gcc -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,-T,sections.lds,-Map,firmware.map,--strip-debug \
		$(FIRMWARE_OBJS) -lgcc
	chmod -x $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c -march=rv32im$(subst C,c,$(COMPRESSED_ISA)) -Os --std=c99 $(GCC_WARNS) -ffreestanding -nostdlib -o $@ $<

clean:
	rm -vrf $(FIRMWARE_OBJS) $(TEST_OBJS) \
		firmware.elf firmware.bin firmware.hex firmware.map

.PHONY: clean
