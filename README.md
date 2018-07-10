# FPGA Flow Demo Project

This project aims to be a demo project for some
FPGA tools being developed for code-generation,
register-map automation and software integration.

Some of the tools being tested here are:

1. [FuseSoC](https://github.com/olofk/fusesoc), for IP-packaging and project generation
    * For now, a FuseSoC fork is needed to support the new features being implemented.
        You can get it here: [FuseSoC Fork](https://github.com/lerwys/fusesoc)
2. [Cheby](https://gitlab.cern.ch/cohtdrivers/cheby), for register-map generation
    * There is a Cheby fork with some new details changed, but they are pretty much
        merged in upstream Cheby. You should't need the fork, but in any case you can
        get it here: [Cheby Fork](https://github.com/lerwys/cheby)
3. [vhd2vl](https://github.com/ldoolitt/vhd2vl), for converting from VHDL to Verilog code

## Build Instructions

1. Make sure to have the latest master versions of the tools installed
2. Initialize Fusesoc

```bash
fusesoc init
```

3. Add currect repository to global fusesoc library

```bash
fusesoc library add --global fpga-flow .
```

4. Run LED testbench

```bash
fusesoc run --target=sim --tool=icarus wb_leds
```

5. Optionally, run the simulation opening the vcd file with gtkwave

```bash
fusesoc build --target=sim --tool=icarus wb_leds --vcd
```
