# FPGA variables
PROJECT = fpga/rgb_mixer
SOURCES= src/rgb_mixer.v src/encoder.v src/debounce.v src/pwm.v src/slow_clk.v src/random.v src/oneshot.v
ICEBREAKER_DEVICE = lp8k
ICEBREAKER_PIN_DEF = fpga/pins.pcf
ICEBREAKER_PACKAGE = cm81 
SEED = 1

# COCOTB variables
export COCOTB_REDUCED_LOG_FMT=1
export PYTHONPATH := test:$(PYTHONPATH)
export LIBPYTHON_LOC=$(shell cocotb-config --libpython)

#all: show_synth

# if you run rules with NOASSERT=1 it will set PYTHONOPTIMIZE, which turns off assertions in the tests


# FPGA recipes

show_synth_rgb_mixer: src/rgb_mixer.v
	yosys -p "read_verilog $<; proc; opt; show -colors 2 -width -signed"

rgb_mixer.json: $(SOURCES)
	yosys -l fpga/yosys.log -p 'synth_ice40 -top rgb_mixer -json $(PROJECT).json' $(SOURCES)

rgb_mixer.asc: rgb_mixer.json $(ICEBREAKER_PIN_DEF)
	nextpnr-ice40 -l fpga/nextpnr.log --seed $(SEED) --freq 20 --package $(ICEBREAKER_PACKAGE) --$(ICEBREAKER_DEVICE) --asc fpga/$@ --pcf $(ICEBREAKER_PIN_DEF) --pcf-allow-unconstrained --json fpga/$< 


rgb_mixer.bin: rgb_mixer.asc
	icepack fpga/$< fpga/$@
	
prog: rgb_mixer.bin
	tinyfpgab --program fpga/$<
#	iceprog $<

# general recipes 


lint:
	verible-verilog-lint src/*v --rules_config verible.rules

clean:
	rm -rf *vcd sim_build fpga/*log fpga/*bin test/__pycache__

.PHONY: clean
