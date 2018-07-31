// TODO: this only tests address conversion, not classic to pipeline not
// pipeline to classic transactions
module wb_slave_adapter_tb;
    localparam clk_freq_hz = 100_000_000;
    localparam clk_half_period = clk_freq_hz/2;

    localparam MAX_ADDR = 31;
    localparam WB_AW = 32;
    localparam WB_DW = 32;
    //Word size in bytes
    localparam WSB = WB_DW/8;

    reg clk = 1'b1;
    reg rst_n = 1'b0;
    reg test_addr = 0;
    wire rst;

    always #clk_half_period clk <= !clk;
    initial #100 rst_n <= 1;
    assign rst = ~rst_n;

    vlog_tb_utils vlog_tb_utils0();
    vlog_functions utils();
    vlog_tap_generator #("wb_slave_adapter_tb.tap", 1) tap();

    // Wishbone configuration interface
    // X2X
    wire [WB_AW-1:0]    wb_m2s_x2x_adr;
    wire [WB_DW-1:0]    wb_m2s_x2x_dat;
    wire [WB_DW/8-1:0]  wb_m2s_x2x_sel;
    wire                wb_m2s_x2x_we;
    wire                wb_m2s_x2x_cyc;
    wire                wb_m2s_x2x_stb;
    wire [WB_DW-1:0]    wb_s2m_x2x_dat;
    wire                wb_s2m_x2x_ack;
    wire                wb_s2m_x2x_err;

    wire                wb_adp_m2s_x2x_cyc;
    wire                wb_adp_m2s_x2x_stb;
    reg                 wb_adp_s2m_x2x_ack;

    // C2P
    wire [WB_AW-1:0]    wb_m2s_c2p_adr;
    wire [WB_DW-1:0]    wb_m2s_c2p_dat;
    wire [WB_DW/8-1:0]  wb_m2s_c2p_sel;
    wire                wb_m2s_c2p_we;
    wire                wb_m2s_c2p_cyc;
    wire                wb_m2s_c2p_stb;
    wire [WB_DW-1:0]    wb_s2m_c2p_dat;
    wire                wb_s2m_c2p_ack;
    wire                wb_s2m_c2p_err;

    wire                wb_adp_m2s_c2p_cyc;
    wire                wb_adp_m2s_c2p_stb;
    reg                 wb_adp_s2m_c2p_ack;

    // C2P, Byte to Word
    wire [WB_AW-1:0]    wb_m2s_c2p_b2w_adr;
    wire [WB_DW-1:0]    wb_m2s_c2p_b2w_dat;
    wire [WB_DW/8-1:0]  wb_m2s_c2p_b2w_sel;
    wire                wb_m2s_c2p_b2w_we;
    wire                wb_m2s_c2p_b2w_cyc;
    wire                wb_m2s_c2p_b2w_stb;
    wire [WB_DW-1:0]    wb_s2m_c2p_b2w_dat;
    wire                wb_s2m_c2p_b2w_ack;
    wire                wb_s2m_c2p_b2w_err;

    wire                wb_adp_m2s_c2p_b2w_cyc;
    wire                wb_adp_m2s_c2p_b2w_stb;
    reg                 wb_adp_s2m_c2p_b2w_ack;

    // C2P, Word to Byte
    wire [WB_AW-1:0]    wb_m2s_c2p_w2b_adr;
    wire [WB_DW-1:0]    wb_m2s_c2p_w2b_dat;
    wire [WB_DW/8-1:0]  wb_m2s_c2p_w2b_sel;
    wire                wb_m2s_c2p_w2b_we;
    wire                wb_m2s_c2p_w2b_cyc;
    wire                wb_m2s_c2p_w2b_stb;
    wire [WB_DW-1:0]    wb_s2m_c2p_w2b_dat;
    wire                wb_s2m_c2p_w2b_ack;
    wire                wb_s2m_c2p_w2b_err;

    wire                wb_adp_m2s_c2p_w2b_cyc;
    wire                wb_adp_m2s_c2p_w2b_stb;
    reg                 wb_adp_s2m_c2p_w2b_ack;

    // X2X
    wb_bfm_master wb_cfg_x2x (
        .wb_clk_i       (clk),
        .wb_rst_i       (rst),
        .wb_adr_o       (wb_m2s_x2x_adr),
        .wb_dat_o       (wb_m2s_x2x_dat),
        .wb_sel_o       (wb_m2s_x2x_sel),
        .wb_we_o        (wb_m2s_x2x_we),
        .wb_cyc_o       (wb_m2s_x2x_cyc),
        .wb_stb_o       (wb_m2s_x2x_stb),
        .wb_dat_i       (wb_s2m_x2x_dat),
        .wb_ack_i       (wb_s2m_x2x_ack),
        .wb_err_i       (wb_s2m_x2x_err),
        .wb_rty_i       (1'b0));

    wb_slave_adapter #(
      .g_master_mode            ("CLASSIC"),
      .g_master_granularity     ("BYTE"),
      .g_slave_mode             ("CLASSIC"),
      .g_slave_granularity      ("BYTE")
    ) dut_x2x
    (
        .clk_i          (clk),
        .rst_n_i        (rst_n),

        .sl_adr_i       (wb_m2s_x2x_adr),
        .sl_dat_i       (wb_m2s_x2x_dat),
        .sl_sel_i       (wb_m2s_x2x_sel),
        .sl_we_i        (wb_m2s_x2x_we),
        .sl_cyc_i       (wb_m2s_x2x_cyc),
        .sl_stb_i       (wb_m2s_x2x_stb),
        .sl_dat_o       (wb_s2m_x2x_dat),
        .sl_ack_o       (wb_s2m_x2x_ack),
        .sl_err_o       (wb_s2m_x2x_err),
        .sl_stall_o     (),

        .ma_adr_o       (),
        .ma_dat_o       (),
        .ma_sel_o       (),
        .ma_we_o        (),
        .ma_cyc_o       (wb_adp_m2s_x2x_cyc),
        .ma_stb_o       (wb_adp_m2s_x2x_stb),
        .ma_dat_i       (0),
        .ma_ack_i       (wb_adp_s2m_x2x_ack),
        .ma_err_i       (1'b0),
        .ma_rty_i       (1'b0),
        .ma_stall_i     (1'b0)
    );

    // Dummy ack generation
    always @(posedge clk) begin
        if (~rst_n)
            wb_adp_s2m_x2x_ack <= 1'b0;
        else begin
            if (wb_adp_m2s_x2x_cyc && wb_adp_m2s_x2x_stb)
                wb_adp_s2m_x2x_ack <= 1'b1;
            else
                wb_adp_s2m_x2x_ack <= 1'b0;
        end
    end

    // C2P
    wb_bfm_master wb_cfg_c2p (
        .wb_clk_i       (clk),
        .wb_rst_i       (rst),
        .wb_adr_o       (wb_m2s_c2p_adr),
        .wb_dat_o       (wb_m2s_c2p_dat),
        .wb_sel_o       (wb_m2s_c2p_sel),
        .wb_we_o        (wb_m2s_c2p_we),
        .wb_cyc_o       (wb_m2s_c2p_cyc),
        .wb_stb_o       (wb_m2s_c2p_stb),
        .wb_dat_i       (wb_s2m_c2p_dat),
        .wb_ack_i       (wb_s2m_c2p_ack),
        .wb_err_i       (wb_s2m_c2p_err),
        .wb_rty_i       (1'b0));

    wb_slave_adapter #(
      .g_master_mode            ("CLASSIC"),
      .g_master_granularity     ("BYTE"),
      .g_slave_mode             ("PIPELINED"),
      .g_slave_granularity      ("BYTE")
    ) dut_c2p
    (
        .clk_i          (clk),
        .rst_n_i        (rst_n),

        .sl_adr_i       (wb_m2s_c2p_adr),
        .sl_dat_i       (wb_m2s_c2p_dat),
        .sl_sel_i       (wb_m2s_c2p_sel),
        .sl_we_i        (wb_m2s_c2p_we),
        .sl_cyc_i       (wb_m2s_c2p_cyc),
        .sl_stb_i       (wb_m2s_c2p_stb),
        .sl_dat_o       (wb_s2m_c2p_dat),
        .sl_ack_o       (wb_s2m_c2p_ack),
        .sl_err_o       (wb_s2m_c2p_err),
        .sl_stall_o     (),

        .ma_adr_o       (),
        .ma_dat_o       (),
        .ma_sel_o       (),
        .ma_we_o        (),
        .ma_cyc_o       (wb_adp_m2s_c2p_cyc),
        .ma_stb_o       (wb_adp_m2s_c2p_stb),
        .ma_dat_i       (0),
        .ma_ack_i       (wb_adp_s2m_c2p_ack),
        .ma_err_i       (1'b0),
        .ma_rty_i       (1'b0),
        .ma_stall_i     (1'b0)
    );

    // Dummy ack generation
    always @(posedge clk) begin
        if (~rst_n)
            wb_adp_s2m_c2p_ack <= 1'b0;
        else begin
            if (wb_adp_m2s_c2p_cyc && wb_adp_m2s_c2p_stb)
                wb_adp_s2m_c2p_ack <= 1'b1;
            else
                wb_adp_s2m_c2p_ack <= 1'b0;
        end
    end

    // C2P Byte to Word
    wb_bfm_master wb_cfg_c2p_b2w (
        .wb_clk_i       (clk),
        .wb_rst_i       (rst),
        .wb_adr_o       (wb_m2s_c2p_b2w_adr),
        .wb_dat_o       (wb_m2s_c2p_b2w_dat),
        .wb_sel_o       (wb_m2s_c2p_b2w_sel),
        .wb_we_o        (wb_m2s_c2p_b2w_we),
        .wb_cyc_o       (wb_m2s_c2p_b2w_cyc),
        .wb_stb_o       (wb_m2s_c2p_b2w_stb),
        .wb_dat_i       (wb_s2m_c2p_b2w_dat),
        .wb_ack_i       (wb_s2m_c2p_b2w_ack),
        .wb_err_i       (wb_s2m_c2p_b2w_err),
        .wb_rty_i       (1'b0));

    wb_slave_adapter #(
      .g_master_mode            ("CLASSIC"),
      .g_master_granularity     ("BYTE"),
      .g_slave_mode             ("PIPELINED"),
      .g_slave_granularity      ("WORD")
    ) dut_c2p_b2w
    (
        .clk_i          (clk),
        .rst_n_i        (rst_n),

        .sl_adr_i       (wb_m2s_c2p_b2w_adr),
        .sl_dat_i       (wb_m2s_c2p_b2w_dat),
        .sl_sel_i       (wb_m2s_c2p_b2w_sel),
        .sl_we_i        (wb_m2s_c2p_b2w_we),
        .sl_cyc_i       (wb_m2s_c2p_b2w_cyc),
        .sl_stb_i       (wb_m2s_c2p_b2w_stb),
        .sl_dat_o       (wb_s2m_c2p_b2w_dat),
        .sl_ack_o       (wb_s2m_c2p_b2w_ack),
        .sl_err_o       (wb_s2m_c2p_b2w_err),
        .sl_stall_o     (),

        .ma_adr_o       (),
        .ma_dat_o       (),
        .ma_sel_o       (),
        .ma_we_o        (),
        .ma_cyc_o       (wb_adp_m2s_c2p_b2w_cyc),
        .ma_stb_o       (wb_adp_m2s_c2p_b2w_stb),
        .ma_dat_i       (0),
        .ma_ack_i       (wb_adp_s2m_c2p_b2w_ack),
        .ma_err_i       (1'b0),
        .ma_rty_i       (1'b0),
        .ma_stall_i     (1'b0)
    );

    // Dummy ack generation
    always @(posedge clk) begin
        if (~rst_n)
            wb_adp_s2m_c2p_b2w_ack <= 1'b0;
        else begin
            if (wb_adp_m2s_c2p_b2w_cyc && wb_adp_m2s_c2p_b2w_stb)
                wb_adp_s2m_c2p_b2w_ack <= 1'b1;
            else
                wb_adp_s2m_c2p_b2w_ack <= 1'b0;
        end
    end

    // C2P Word to Byte
    wb_bfm_master wb_cfg_c2p_w2b (
        .wb_clk_i       (clk),
        .wb_rst_i       (rst),
        .wb_adr_o       (wb_m2s_c2p_w2b_adr),
        .wb_dat_o       (wb_m2s_c2p_w2b_dat),
        .wb_sel_o       (wb_m2s_c2p_w2b_sel),
        .wb_we_o        (wb_m2s_c2p_w2b_we),
        .wb_cyc_o       (wb_m2s_c2p_w2b_cyc),
        .wb_stb_o       (wb_m2s_c2p_w2b_stb),
        .wb_dat_i       (wb_s2m_c2p_w2b_dat),
        .wb_ack_i       (wb_s2m_c2p_w2b_ack),
        .wb_err_i       (wb_s2m_c2p_w2b_err),
        .wb_rty_i       (1'b0));

    wb_slave_adapter #(
      .g_master_mode            ("CLASSIC"),
      .g_master_granularity     ("WORD"),
      .g_slave_mode             ("PIPELINED"),
      .g_slave_granularity      ("BYTE")
    ) dut_c2p_w2b
    (
        .clk_i          (clk),
        .rst_n_i        (rst_n),

        .sl_adr_i       (wb_m2s_c2p_w2b_adr),
        .sl_dat_i       (wb_m2s_c2p_w2b_dat),
        .sl_sel_i       (wb_m2s_c2p_w2b_sel),
        .sl_we_i        (wb_m2s_c2p_w2b_we),
        .sl_cyc_i       (wb_m2s_c2p_w2b_cyc),
        .sl_stb_i       (wb_m2s_c2p_w2b_stb),
        .sl_dat_o       (wb_s2m_c2p_w2b_dat),
        .sl_ack_o       (wb_s2m_c2p_w2b_ack),
        .sl_err_o       (wb_s2m_c2p_w2b_err),
        .sl_stall_o     (),

        .ma_adr_o       (),
        .ma_dat_o       (),
        .ma_sel_o       (),
        .ma_we_o        (),
        .ma_cyc_o       (wb_adp_m2s_c2p_w2b_cyc),
        .ma_stb_o       (wb_adp_m2s_c2p_w2b_stb),
        .ma_dat_i       (0),
        .ma_ack_i       (wb_adp_s2m_c2p_w2b_ack),
        .ma_err_i       (1'b0),
        .ma_rty_i       (1'b0),
        .ma_stall_i     (1'b0)
    );

    // Dummy ack generation
    always @(posedge clk) begin
        if (~rst_n)
            wb_adp_s2m_c2p_w2b_ack <= 1'b0;
        else begin
            if (wb_adp_m2s_c2p_w2b_cyc && wb_adp_m2s_c2p_w2b_stb)
                wb_adp_s2m_c2p_w2b_ack <= 1'b1;
            else
                wb_adp_s2m_c2p_w2b_ack <= 1'b0;
        end
    end

    integer            transaction;
    reg                VERBOSE = 2;
    initial begin
        if($test$plusargs("verbose"))
            VERBOSE = 2;

        @(negedge rst);
        @(posedge clk);

        test_main();
        tap.ok("All done");
        $finish;
    end

    reg [WB_DW-1:0] stimuli;

    task test_main;
        begin
            test_adp_x2x();
            test_adp_c2p();
            test_adp_c2p_b2w();
            test_adp_c2p_w2b();
        end
    endtask

    task test_adp_x2x;
        reg [WB_AW-1:0] adr;
        reg [WB_DW-1:0] dat;

        begin
            adr = gen_urandom(WB_AW);
            dat = gen_urandom(WB_DW);

            cfg_write_x2x(adr, dat);
            @(posedge clk);

            verify("test_adp_x2x", dat, dut_x2x.ma_dat_o);
            verify("test_adp_x2x", adr, dut_x2x.ma_adr_o);
        end
    endtask

    task test_adp_c2p;
        reg [WB_AW-1:0] adr;
        reg [WB_DW-1:0] dat;

        begin
            adr = gen_urandom(WB_AW);
            dat = gen_urandom(WB_DW);

            cfg_write_c2p(adr, dat);
            @(posedge clk);

            // TODO. Test wishbone transaction, specifically
            // stall and ack signals
            verify("test_adp_c2p", dat, dut_c2p.ma_dat_o);
            verify("test_adp_c2p", adr, dut_c2p.ma_adr_o);
        end
    endtask

    task test_adp_c2p_b2w;
        reg [WB_AW-1:0] adr;
        reg [WB_DW-1:0] dat;

        begin
            adr = gen_urandom(WB_AW);
            dat = gen_urandom(WB_DW);

            cfg_write_c2p_b2w(adr, dat);
            @(posedge clk);

            verify("test_adp_c2p_b2w", dat, dut_c2p_b2w.ma_dat_o);
            verify("test_adp_c2p_b2w", adr >> 2, dut_c2p_b2w.ma_adr_o);
        end
    endtask

    task test_adp_c2p_w2b;
        reg [WB_AW-1:0] adr;
        reg [WB_DW-1:0] dat;

        begin
            adr = gen_urandom(WB_AW);
            dat = gen_urandom(WB_DW);

            cfg_write_c2p_w2b(adr, dat);
            @(posedge clk);

            verify("test_adp_c2p_w2b", dat, dut_c2p_w2b.ma_dat_o);
            verify("test_adp_c2p_w2b", adr << 2, dut_c2p_w2b.ma_adr_o);
        end
    endtask

    function [31:0] gen_urandom;
        input integer max;

        integer tmp;
        begin
            tmp = $urandom % max;
            gen_urandom = tmp[31:0];
        end
    endfunction

    // Stupid boilerplate
    task cfg_write_x2x;
        input [WB_AW-1:0] addr_i;
        input [WB_DW-1:0] dat_i;

        reg  err;
        begin
            wb_cfg_x2x.write(addr_i, dat_i, 4'hf, err);
            if(err) begin
                $display("Error writing to config interface wb_cfg_x2x, address 0x%8x", addr_i);
                $finish;
            end
        end
    endtask

    task cfg_write_c2p;
        input [WB_AW-1:0] addr_i;
        input [WB_DW-1:0] dat_i;

        reg  err;
        begin
            wb_cfg_c2p.write(addr_i, dat_i, 4'hf, err);
            if(err) begin
                $display("Error writing to config interface wb_cfg_c2p, address 0x%8x", addr_i);
                $finish;
            end
        end
    endtask

    task cfg_write_c2p_b2w;
        input [WB_AW-1:0] addr_i;
        input [WB_DW-1:0] dat_i;

        reg  err;
        begin
            wb_cfg_c2p_b2w.write(addr_i, dat_i, 4'hf, err);
            if(err) begin
                $display("Error writing to config interface wb_cfg_c2p_b2w, address 0x%8x", addr_i);
                $finish;
            end
        end
    endtask

    task cfg_write_c2p_w2b;
        input [WB_AW-1:0] addr_i;
        input [WB_DW-1:0] dat_i;

        reg  err;
        begin
            wb_cfg_c2p_w2b.write(addr_i, dat_i, 4'hf, err);
            if(err) begin
                $display("Error writing to config interface wb_cfg_c2p_w2b, address 0x%8x", addr_i);
                $finish;
            end
        end
    endtask

    task verify;
        input [8*16:1] test;
        input [WB_DW-1:0] expected;
        input [WB_DW-1:0] received;
        begin
            if(received !== expected) begin
                $display("Verify failed for test \"%s\". Expected 0x%8x : Got 0x%8x",
                    test,
                    expected,
                    received);
                $finish;
            end
        end
    endtask


endmodule
