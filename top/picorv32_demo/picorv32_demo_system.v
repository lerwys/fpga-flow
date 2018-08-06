module picorv32_demo_system #(
    parameter firmware_file = "",
    parameter firmware_ram_depth = 16384*4
)
(
    input           clk_i,
    input           rst_i,
    // picorv signals
    output          trap_o,
    output          trace_valid_o,
    output [35:0]   trace_data_o,
    output          mem_instr_o,
    input [31:0]    irq_i,

    // external modules
    inout [31:0]    gpio_b
);

////////////////////////////////////////////////////////////////////////
// Modules interconnections
////////////////////////////////////////////////////////////////////////
`include "wb_intercon.vh"

////////////////////////////////////////////////////////////////////////
// Picorv32
////////////////////////////////////////////////////////////////////////
picorv32_wb #(
    .ENABLE_REGS_DUALPORT (1),
    .ENABLE_MUL           (1),
    .ENABLE_DIV           (1),
    .ENABLE_IRQ           (1),
    .ENABLE_TRACE         (1)
) cmp_picorv32 (
    .wb_clk_i           (clk_i),
    .wb_rst_i           (rst_i),

    .wbm_adr_o          (wb_m2s_picorv32_adr),
    .wbm_dat_i          (wb_s2m_picorv32_dat),
    .wbm_stb_o          (wb_m2s_picorv32_stb),
    .wbm_ack_i          (wb_s2m_picorv32_ack),
    .wbm_cyc_o          (wb_m2s_picorv32_cyc),
    .wbm_dat_o          (wb_m2s_picorv32_dat),
    .wbm_we_o           (wb_m2s_picorv32_we),
    .wbm_sel_o          (wb_m2s_picorv32_sel),

    .trap               (trap),
    .irq                (irq),
    .trace_valid        (trace_valid),
    .trace_data         (trace_data),
    .mem_instr          (mem_instr)
);

////////////////////////////////////////////////////////////////////////
// RAM
////////////////////////////////////////////////////////////////////////

wb_ram #(
    .memfile            (firmware_file),
    .depth              (firmware_ram_depth)
) cmp_wb_ram (
    //Wishbone Master interface
    .wb_clk_i           (clk_i),
    .wb_rst_i           (rst_i),

    .wb_cyc_i           (wb_m2s_ram_cyc),
    .wb_dat_i           (wb_s2m_ram_dat),
    .wb_sel_i           (wb_s2m_ram_sel),
    .wb_we_i            (wb_s2m_ram_we),
    .wb_adr_i           (wb_m2s_ram_adr),
    .wb_stb_i           (wb_m2s_ram_stb),
    .wb_dat_o           (wb_s2m_ram_dat),
    .wb_ack_o           (wb_s2m_ram_ack)
);

assign wb_s2m_ram_err = 1'b0;
assign wb_s2m_ram_rty = 1'b0;

////////////////////////////////////////////////////////////////////////
// LEDs
////////////////////////////////////////////////////////////////////////

wb_leds cmp_wb_leds
(
    // Clock/Resets
    .clk_i              (clk_i),
    .rst_n_i            (rst_i),

    // Wishbone signals
    .wb_cyc_i           (wb_m2s_leds_cyc),
    .wb_dat_i           (wb_s2m_leds_dat),
    .wb_sel_i           (wb_s2m_leds_sel),
    .wb_we_i            (wb_s2m_leds_we),
    .wb_adr_i           (wb_m2s_leds_adr),
    .wb_stb_i           (wb_m2s_leds_stb),
    .wb_dat_o           (wb_s2m_leds_dat),
    .wb_ack_o           (wb_s2m_leds_ack),

    // LEDs
    .leds_o             (gpio_b)
);

assign wb_s2m_leds_err = 1'b0;
assign wb_s2m_leds_rty = 1'b0;

endmodule
