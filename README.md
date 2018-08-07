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

## Clone Instructions

1. When cloning this project remember to specify the flag --recursive, so it
it will clone the submodules, as well:

```bash
git clone --recursive https://github.com/lerwys/fpga-flow
```

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

### LEDs Example

1. Run LED testbench

```bash
fusesoc run --target=sim --tool=icarus wb_leds
```

2. Optionally, run the simulation opening the vcd file with gtkwave

```bash
fusesoc build --target=sim --tool=icarus wb_leds --vcd
```

#### What's happening when bulding/running the LEDs example project

When running the step #4 or #5, fusesoc will perform the following:

1. Fetch the modules' dependencies

    - Fusesoc will gather the list of dependencies by looking at the "depend"
    section of the respective module's .core file.

    - With the list of dependencies, fusesoc will then search for the modules'
    .core files by searching in its known libraries:
        - The names and locations of those libraries are found in .conf files,
        located in:
            - `$XDG_CONFIG_HOME/fusesoc` (`$XDG_CONFIG_HOME` is normally set to
            `~/.config` on Linux systems), initialized by running `fusesoc init`.
            - `$PWD` .conf files, created by issuing `fusesoc library add <library-name> <library-location>`
            - Command line option `cores-root` when building/running a module or
            project.
        - For local libraries, the ones with `sync-type = local` in its .conf
        files, the location is specified in the `location =` parameter.
        - For remote libraries, the ones with `sync-type = git` for instance,
        the library location is found by looking at:
            - `$XDG_DATA_HOME/fusesoc` (`$XDG_DATA_HOME` is normally set to
            ~/.local/share on Linux systems), populated by issuing `fusesoc init`.
            - `$PWD`, populated by issuing fusesoc library add `<library-name> <library-location>`

    - In each core file, fusesoc will look for a `provider` section:
        - If there is a provider section, it will use the information located there
        to download the source files.
            - Specifically, the "provider" section can contain various mechanisms
            for fetching the core. The most common ones are "git", "github" and "url",
            but there are others.
            - In this case, fusesoc will download the specified files and put them
            into into the cache, `$XDG_CACHE_HOME/fusesoc` (`$XDG_CACHE_HOME` is normally
            set to `~/.cache` on Linux systems).
        - If not, fusesoc will assume the core is a "local core" and will just
        use the files specified by the "filesets" section in .core file.


    - Fusesoc will output the name of the module being fetched when running
    a testbench or when building a project like this:

    ```bash
    lerwys@lerwysPC:~/Repos/fpga-flow$ fusesoc run --target=sim --tool=icarus wb_leds
    INFO: Preparing ::dpram:0
    INFO: Preparing ::vlog_tb_utils:1.1
    INFO: Preparing ::wb_common:1.0.2
    INFO: Preparing ::wb_bfm:1.2.1
    INFO: Preparing ::wbgen2_dpssram:0
    INFO: Preparing ::wb_leds:0
    ```

2. The fusesoc fork we are using has initial support for Cheby generated files.
This was done by adding a new `Cheby` "provider" to fusesoc.

    - Basically, this "provider" runs `cheby` command-line tool to generate
    the wishbone register-map in either VHDL (native Cheby) or Verilog (converted
    from VHDL using vhd2vl). It does so by using the specified cheby .yml file
    (`core_file: `, in the "provider section"). The `Cheby` "provider" code can
    be seen here: https://github.com/lerwys/fusesoc/blob/master/fusesoc/provider/cheby.py

    - The generated files will then be create when running the testbench as needed
    and an output message like this should be seen on stdout:

    ```bash
    INFO: Using Cheby to generate core data/wb_leds_csr.yml
    ```

3. After resolving the dependencies, fusesoc will create a `build` directory in
the same folder that it was run with at least the `src` folder in it.

    - The `src` folder will contain a copy of all of the dependant modules,
    each in its own folder, and the module being tested itself. For example,
    after running `fusesoc run --target=sim --tool=icarus wb_leds` the following
    is present in my `build` directory:

    ```bash
    lerwys@lerwysPC:~/Repos/fpga-flow$ ls build/wb_leds_0/src/
    dpram_0  vlog_tb_utils_1.1  wb_bfm_1.2.1  wb_common_1.0.2  wbgen2_dpssram_0  wb_leds_0
    ```

4. As we are running an Icarus testbench for our "wb_leds" module, fusesoc will create
a `sim-icarus` folder inside `build`, containing a generated `Makefile`, the dependency
list, `wb_leds.scr`, and some other support files. This is, of course, dependant on the
tool being selected (e.g., Icarus Verilog, or "icarus" in fusesoc) and the target
(e.g., Simulation, or "sim" in fusesoc)

    - For the case of Icarus Verilog, fusesoc will issue the following commands
    when running  `fusesoc run --target=sim --tool=icarus wb_leds`:

    ```bash
    iverilog -swb_leds_tb -c wb_leds_0.scr -o wb_leds_0
    vvp -n -M. -l icarus.log -lxt2  wb_leds_0
    ```

5. Finally, fusesoc will execute icarus simulator and run the specified testbench
(see target "sim" inside wb_leds .core file). The following should appear on stdout:

    ```bash
    Completed transaction 1/10
    Completed transaction 2/10
    Completed transaction 3/10
    Completed transaction 4/10
    Completed transaction 5/10
    Completed transaction 6/10
    Completed transaction 7/10
    Completed transaction 8/10
    Completed transaction 9/10
    Completed transaction 10/10
    ```

### PicoRV32 Example

This is a more complete example than the above LEDs example and shows the usage
of the PicoRV32 along with a RAM and a LEDs module.

The top-level design can be found at "top/picorv32_demo/picorv32_demo_top.v"
and the PicoRV32 system with a RAM and LEDs can be found at "top/picorv32_demo/picorv32_demo_top.v".

In the same way as the above LEDs example, the same FuseSoC flow is happening here.
Particularly, more dependencies will be fetched when FuseSoC runs:

```bash
fusesoc run --target=sim --tool=icarus picorv32_demo --firmware=firmware/firmware.hex --vcd
INFO: Preparing ::cdc_utils:0.1
INFO: Preparing ::dpram:0
INFO: Preparing ::picorv32:0-r1
INFO: Preparing ::verilog-arbiter:0-r2
INFO: Preparing ::vlog_tb_utils:1.1
INFO: Preparing ::wb_common:1.0.2
INFO: Preparing ::wb_bfm:1.2.1
INFO: Preparing ::wbgen2_dpssram:0
INFO: Preparing ::wb_intercon:1.2.1
INFO: Preparing ::wb_leds:0
INFO: Preparing ::wb_ram:1.1
INFO: Preparing ::picorv32_demo:0
```

And there is also a synthesis target that will build a bitstream file for a
Xilinx Artix7 A35T FPGA (untested on real hardware), when FuseSoC runs with
`--target=synth` option.

In order to generate this example either for simulation or synthesis, an example
firmware must be generated first:

1. Generate example firmware

    ```bash
    make -C firmware firmware.hex
    ```

Then, FuseSoC can runs normally, as usual.

2. Run synthesis for picorv32

```bash
fusesoc run --target=synth --tool=vivado picorv32_demo --firmware=firmware/firmware.hex
```

3. Optionally run fusesoc with the option --vcd to genearte a dump of the signals

```bash
fusesoc run --target=synth --tool=vivado picorv32_demo --firmware=firmware/firmware.hex --vcd
```

4. And open gtkwave to analyze the signals

```bash
gtkwave build/picorv32_demo_0/sim-icarus/testbench.vcd testbench/picorv32_demo/picorv32_demo_tb.gtkw
```

### PicoRV32 Makefile automation

Instead of typing the commands one by one, a Makefile is provided for convenience.
The Makefile just calls FuseSoC on the background, but it avoids having to memorize
the full command.

* Run simulation

```bash
make picorv32_demo_sim
````

* Run simulation with VCD output

```bash
make picorv32_demo_view
````

* Run synthesis

```bash
make picorv32_demo_synth
````

* Clean generated files

```bash
make clean
````
