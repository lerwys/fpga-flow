module sys_clk #(
    parameter DIFF_CLKIN = "TRUE",
    parameter CLKIN_PERIOD = 5.0, // default 200MHz
    parameter MULT = 5,         // 200 X 5 = 1000
    parameter DIV0 = 8,         // 1000 / 8 = 125
    parameter DIV1 = 5          // 1000 / 5 = 200
) (
    input rst_i,
    input sysclk_p_i,
    input sysclk_n_i,
    output sysclk_buf_o,
    output clk_out0_o,
    output clk_out1_o,
    output locked_o
);

generate
    if (DIFF_CLKIN == "TRUE") begin : gen_ibufgds
        IBUFGDS ibufgds_int (
            .O(sysclk_buf_o),
            .I(sysclk_p_i),
            .IB(sysclk_n_i)
        );
    end else if (DIFF_CLKIN == "BYPASS") begin : gen_bypass
        assign sysclk_buf_o = sysclk_p_i;
    end else begin : gen_ibifg
        IBUF ibufgds_int (
            .O(sysclk_buf_o),
            .I(sysclk_p_i)
        );
    end
endgenerate

wire mmcm_clkfbin;
wire mmcm_clkfbout;
wire clk_out0_int;
wire clk_out1_int;
MMCME2_BASE #(
    .BANDWIDTH          ("OPTIMIZED"),
    .CLKOUT4_CASCADE    ("FALSE"),
    .STARTUP_WAIT       ("FALSE"),
    .DIVCLK_DIVIDE      (1),
    .CLKFBOUT_MULT_F    (MULT),
    .CLKFBOUT_PHASE     (0.0),
    .CLKIN1_PERIOD      (CLKIN_PERIOD),
    .CLKOUT0_DIVIDE_F   (DIV0),
    .CLKOUT0_DUTY_CYCLE (0.5),
    .CLKOUT0_PHASE      (0.0),
    .CLKOUT1_DIVIDE     (DIV1),
    .CLKOUT1_DUTY_CYCLE (0.5),
    .CLKOUT1_PHASE      (0.0),
    .REF_JITTER1        (0.01)
) MMCME2_BASE_inst (
    .CLKOUT0            (clk_out0_int),
    .CLKOUT1            (clk_out1_int),
    .LOCKED             (locked_o),
    .CLKIN1             (sysclk_buf_o),
    .PWRDWN             (1'b0),
    .RST                (rst_i),
    .CLKFBIN            (mmcm_clkfbin),
    .CLKFBOUT           (mmcm_clkfbout)
);

BUFG clkfbout_bufg (
    .O(mmcm_clkfbin),
    .I(mmcm_clkfbout)
);

BUFG clkout1_buf (
    .O   (clk_out0_o),
    .I   (clk_out0_int)
);

BUFG clkout2_buf (
    .O   (clk_out1_o),
    .I   (clk_out1_int)
);

endmodule
