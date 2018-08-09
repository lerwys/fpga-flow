FUSESOC ?= fusesoc
MAKE ?= make
GTKWAVE ?= gtkwave

FIRMWARE_DIR = firmware
FIRMWARE_FILE = firmware.hex
FIRMWARE = $(FIRMWARE_DIR)/$(FIRMWARE_FILE)

VCD_DIR = build/picorv32_demo_0/sim-icarus
VCD_FILE = testbench.vcd
VCD = $(VCD_DIR)/$(VCD_FILE)
SAV_DIR = testbench/picorv32_demo
SAV_FILE = picorv32_demo_tb.gtkw
SAV = $(SAV_DIR)/$(SAV_FILE)
BIT_DIR = build/picorv32_demo_0/synth-vivado
BIT_FILE = picorv32_demo_0.bit
BIT = $(BIT_DIR)/$(BIT_FILE)
SIM_DIR = build/picorv32_demo_0/sim-icarus
SIM_FILE = picorv32_demo_0
SIM = $(SIM_DIR)/$(SIM_FILE)

picorv32_demo_sim: $(FIRMWARE) $(SIM)
	$(FUSESOC) sim picorv32_demo --firmware=$(FIRMWARE) --vcd

picorv32_demo_view: picorv32_demo_sim $(VCD) $(SAV)
	$(GTKWAVE) $(VCD) $(SAV)

picorv32_demo_synth: $(BIT)

picorv32_demo_program: picorv32_demo_synth
	$(FUSESOC) pgm picorv32_demo

$(FIRMWARE):
	$(MAKE) -C $(FIRMWARE_DIR) $(FIRMWARE_NAME)

$(BIT): $(FIRMWARE)
	$(FUSESOC) build --target=synth --tool=vivado picorv32_demo

$(SIM): $(FIRMWARE)
	$(FUSESOC) build --target=sim --tool=icarus picorv32_demo --firmware=$(FIRMWARE)

clean:
	rm -rf build
	$(MAKE) -C $(FIRMWARE_DIR) clean

.PHONY: clean picorv32_demo_sim picorv32_demo_synth picorv32_demo_program \
	$(FIRMWARE)
