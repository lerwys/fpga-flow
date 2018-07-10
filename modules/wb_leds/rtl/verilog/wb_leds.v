module wb_leds
(
    // Clock/Resets
    input               clk_i,
    input               rst_n_i,

    // Wishbone signals
    input  [31:0]       wb_adr_i,
    input  [31:0]       wb_dat_i,
    input  [3:0]        wb_sel_i,
    input               wb_we_i,
    input               wb_cyc_i,
    input               wb_stb_i,
    output [31:0]       wb_dat_o,
    output              wb_ack_o,
    output              wb_err_o,
    output              wb_rty_o,

    // LEDs
    output [31:0]       leds_o
);

wb_leds_csr wb_leds_csr (
    .rst_n_i            (rst_n_i),
    .clk_i              (clk_i),
    .wb_dat_i           (wb_dat_i),
    .wb_dat_o           (wb_dat_o),
    .wb_cyc_i           (wb_cyc_i),
    .wb_sel_i           (wb_sel_i),
    .wb_stb_i           (wb_stb_i),
    .wb_we_i            (wb_we_i),
    .wb_ack_o           (wb_ack_o),
    .wb_err_o           (wb_err_o),
    .wb_rty_o           (wb_rty_o),
    .wb_stall_o         (wb_stall_o),
    .leds_o             (leds_o)
);

endmodule
