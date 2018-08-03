`timescale 1 ns / 1 ns

module picorv32_demo_top #(
    parameter firmware_file = "../top/picorv32_demo_top/data/system32.hex"
)
(
    input            sysclk_i,

    output [4:0]     gpio_led_o
);

wire clk_125;
wire clk_200;
wire locked;
sys_clk #(
    .DIFF_CLKIN     ("FALSE"),
    .CLKIN_PERIOD   (83.33),
    .MULT           (62.500),
    .DIV0           (7.5),
    .DIV1           (7.5)
) cmp_sys_clk (
    .sysclk_p_i     (sysclk_i),
    .sysclk_n_i     (1'b0),
    .rst_i          (1'b0),
    .clk_out0_o     (clk_125),
    .clk_out1_o     (clk_200),
    .locked_o       (locked)
);

wire [31:0] gpio_b;
wire trap;
wire trace_valid;
wire [35:0] trace_data;
reg [31:0] irq = 0;
picorv32_demo_system #(
    .firmware_file  (firmware_file)
) cmp_picorv32_demo_system (
    .clk_i          (clk_125),
    .rst_i          (1'b0),
    .trap_o         (trap),
    .trace_valid_o  (trace_valid),
    .trace_data_o   (trace_data),
	.mem_instr_o    (mem_instr),

    .irq_i          (irq),

    .gpio_b         (gpio_b)
);

assign gpio_led_o = {trap, gpio_b[31:28]};

endmodule
