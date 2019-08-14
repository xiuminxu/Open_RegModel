//   Ordt 190617.01 autogenerated file 
//   Input: /huaihe/proj/ic/wa/jiongz/work/soc_dv/verify_common/regmodel/outdir/pico_def_demo/spec/manual/openreg.rdl
//   Parms: openreg.parms
//   Date: Mon Aug 12 23:01:57 EDT 2019
//

`timescale 1 ns / 100 ps
//
//---------- module addrmap_PICO_test_leaf_bfm
//
module addrmap_PICO_test_leaf_bfm
(
  address,
  wr_data,
  wr_enable,
  rd_compare,
  rd_data,
  trans_type,
  size,
  leaf_go,
  CLK,
  dec_leaf_rd_data,
  dec_leaf_ack,
  dec_leaf_nack,
  dec_leaf_accept,
  dec_leaf_reject,
  dec_leaf_retry_atomic,
  dec_leaf_data_width,

  active,
  done,
  leaf_dec_addr,
  leaf_dec_wr_data,
  leaf_dec_valid,
  leaf_dec_wr_dvld,
  leaf_dec_cycle,
  leaf_dec_wr_width );

  //------- inputs
  input     [31:0] address;
  input     [31:0] wr_data;
  input    wr_enable;
  input    rd_compare;
  input     [31:0] rd_data;
  input     [1:0] trans_type;
  input     [3:0] size;
  input    leaf_go;
  input    CLK;
  input     [31:0] dec_leaf_rd_data;
  input    dec_leaf_ack;
  input    dec_leaf_nack;
  input    dec_leaf_accept;
  input    dec_leaf_reject;
  input    dec_leaf_retry_atomic;
  input     [2:0] dec_leaf_data_width;

  //------- outputs
  output    active;
  output    done;
  output     [31:0] leaf_dec_addr;
  output     [31:0] leaf_dec_wr_data;
  output    leaf_dec_valid;
  output    leaf_dec_wr_dvld;
  output     [1:0] leaf_dec_cycle;
  output     [2:0] leaf_dec_wr_width;


  //------- reg defines
  reg  active;
  reg  done;
  reg   [31:0] leaf_dec_addr;
  reg   [31:0] leaf_dec_wr_data;
  reg  leaf_dec_valid;
  reg  leaf_dec_wr_dvld;
  reg   [1:0] leaf_dec_cycle;
  reg   [2:0] leaf_dec_wr_width;
  reg   [4:0] trans_size;
  
  initial begin
    active = 0;
    done = 0;
    leaf_dec_addr = 0;
    leaf_dec_wr_data = 0;
    leaf_dec_valid = 0;
    leaf_dec_wr_dvld = 0;
    leaf_dec_cycle = 0;
    leaf_dec_wr_width = 0;
  end
  
  always @(posedge leaf_go) begin
    @(posedge CLK);
      #1 active = 1'b1;
      leaf_dec_addr = address;
      leaf_dec_wr_data = wr_data;
      leaf_dec_valid = 1'b1;
      leaf_dec_wr_dvld = 1'b0;
      leaf_dec_cycle = trans_type;
      trans_size = {1'b0, size} + 5'b1;
      if (trans_type[1] == 1'b0) begin
        leaf_dec_wr_width = size [2:0] ;
        $display("%0d: initiating %d word write to address %x (data=%x)...", $time, trans_size, address, wr_data);
      end
      else begin
        leaf_dec_wr_width = 0;
        $display("%0d: initiating %d word read to address %x...", $time, trans_size, address);
      end
  
    @(posedge CLK);
      leaf_dec_valid = 1'b0;
      leaf_dec_wr_dvld <= ~trans_type[1];
      while (~dec_leaf_reject & ~dec_leaf_ack & ~dec_leaf_nack) begin
         @(posedge CLK);
         leaf_dec_wr_dvld = 1'b0;
      end
  
    leaf_dec_valid = 1'b0;
    leaf_dec_wr_dvld = 1'b0;
    done = 1'b1;
    $display("  accept = %d", dec_leaf_accept);
    $display("  reject = %d", dec_leaf_reject);
    $display("  ack = %d", dec_leaf_ack);
    $display("  nack = %d", dec_leaf_nack);
    $display("  return size = %x", dec_leaf_data_width);
    $display("  retry = %d", dec_leaf_retry_atomic);
    if (trans_type[1] == 1'b1) begin
      $display("  read data = %x", dec_leaf_rd_data);
      if (rd_compare) begin
        if (dec_leaf_rd_data !== rd_data) $display("  read compare FAILED - expected %x", rd_data);
        else $display("  read compare OK - expected %x", rd_data);
      end
    end
    #1 active = 1'b0;
    #1 done = 1'b0;
  end
  
endmodule

//
//---------- module addrmap_PICO_test
//
module addrmap_PICO_test ( );
  //------- wire defines
  wire   [31:0] leaf_dec_wr_data;
  wire   [31:0] leaf_dec_addr;
  wire  leaf_dec_block_sel;
  wire  leaf_dec_valid;
  wire  leaf_dec_wr_dvld;
  wire   [1:0] leaf_dec_cycle;
  wire   [2:0] leaf_dec_wr_width;
  wire   [31:0] dec_leaf_rd_data;
  wire  dec_leaf_ack;
  wire  dec_leaf_nack;
  wire  dec_leaf_accept;
  wire  dec_leaf_reject;
  wire  dec_leaf_retry_atomic;
  wire   [2:0] dec_leaf_data_width;
  wire  l2h_ral_regs_demo_CTRL_MASTER_r;
  wire  l2h_ral_regs_demo_CTRL_DORD_r;
  wire  l2h_ral_regs_demo_CTRL_ENABLE_r;
  wire  l2h_ral_regs_demo_CTRL_CLK2X_r;
  wire   [1:0] l2h_ral_regs_demo_INTCTRL_INTLVL_r;
  wire  l2h_ral_regs_demo_STATUS_WRCOL_r;
  wire  l2h_ral_regs_demo_STATUS_IF_r;
  wire  active;
  wire  done;
  
  //------- reg defines
  reg  CLK;
  reg  CLK_div2;
  reg  CLK_div4;
  reg  clk;
  reg  reset;
  reg   [1:0] h2l_ral_regs_demo_CTRL_PRESCALER_w;
  reg   [1:0] h2l_ral_regs_demo_CTRL_MODE_w;
  reg  h2l_ral_regs_demo_CTRL_MASTER_w;
  reg  h2l_ral_regs_demo_CTRL_MASTER_we;
  reg  h2l_ral_regs_demo_STATUS_WRCOL_w;
  reg  h2l_ral_regs_demo_STATUS_WRCOL_we;
  reg  h2l_ral_regs_demo_STATUS_IF_w;
  reg  h2l_ral_regs_demo_STATUS_IF_we;
  reg   [31:0] address;
  reg   [31:0] wr_data;
  reg  wr_enable;
  reg  rd_compare;
  reg   [31:0] rd_data;
  reg   [1:0] trans_type;
  reg   [3:0] size;
  reg  leaf_go;
  
  always @(*)
     clk = CLK;
  
  initial
    begin
    $display(" << Starting the Simulation >>");
    $dumpfile("test.vcd");
    $dumpvars(0,addrmap_PICO_test);
    #5000
    $dumpoff;
    $finish;
  end
  
  initial
    begin
    CLK = 1'b0; // at time 0
    CLK_div2 = 1'b0;
    CLK_div4 = 1'b0;
    reset = 0; // toggle reset
    #15 reset = 1'b1;
    $display(" %0d: Applying reset...", $time);
    #30 reset = 1'b0;
    $display(" %0d: Releasing reset...", $time);
  end
  
  always
     #5 CLK = ~CLK;
  
  always @ (posedge CLK)
     CLK_div2 = ~CLK_div2; 
  
  always @ (posedge CLK_div2)
     CLK_div4 = ~CLK_div4; 
  
  // 32b write task
  task write32;
    input  [31:0] in_address;
    input  [31:0] in_wr_data;
    input in_wr_enable;
    output  [31:0] address;
    output  [31:0] wr_data;
    output wr_enable;
    output rd_compare;
    output  [31:0] rd_data;
    output [1:0] trans_type;
    output [3:0] size;
    output leaf_go;
    begin
      address = #1 in_address;
      wr_data = 0;
      wr_data [31:0] = in_wr_data;
      wr_enable = in_wr_enable;
      rd_compare = 0;
      rd_data = 0;
      trans_type = 0;
      size = 4'd0;
      leaf_go = 1'b1;
    end
  endtask
  
  // 32b read task
  task read32;
    input  [31:0] in_address;
    input in_rd_compare;
    input  [31:0] in_rd_data;
    output  [31:0] address;
    output  [31:0] wr_data;
    output wr_enable;
    output rd_compare;
    output  [31:0] rd_data;
    output [1:0] trans_type;
    output [3:0] size;
    output leaf_go;
    begin
      address = #1 in_address;
      wr_data = 0;
      wr_enable = 0;
      rd_compare = in_rd_compare;
      rd_data = 0;
      rd_data [31:0] = in_rd_data;
      trans_type = 2'b10;
      size = 4'd0;
      leaf_go = 1'b1;
    end
  endtask
  
  initial
    begin
    CLK = 0;
    CLK_div2 = 0;
    CLK_div4 = 0;
    reset = 0;
    h2l_ral_regs_demo_CTRL_PRESCALER_w = 0;
    h2l_ral_regs_demo_CTRL_MODE_w = 0;
    h2l_ral_regs_demo_CTRL_MASTER_w = 0;
    h2l_ral_regs_demo_CTRL_MASTER_we = 0;
    h2l_ral_regs_demo_STATUS_WRCOL_w = 0;
    h2l_ral_regs_demo_STATUS_WRCOL_we = 0;
    h2l_ral_regs_demo_STATUS_IF_w = 0;
    h2l_ral_regs_demo_STATUS_IF_we = 0;
    address = 0;
    wr_data = 0;
    wr_enable = 0;
    rd_compare = 0;
    rd_data = 0;
    trans_type = 0;
    size = 0;
    leaf_go = 0;
  
    address = 0;
    wr_data = 0;
    wr_enable = 0;
    rd_compare = 0;
    rd_data = 0;
    trans_type = 0;
    size = 0;
    leaf_go = 0;
    repeat(5)
      @(posedge CLK);
  
  write32(40'h0, 32'ha5a5a5a5, 0, address, wr_data, wr_enable, rd_compare, rd_data, trans_type, size, leaf_go);
  @ (posedge done)
     leaf_go = #2 1'b0; 
  
  read32(40'h0, 0, 0, address, wr_data, wr_enable, rd_compare, rd_data, trans_type, size, leaf_go);
  @ (posedge done)
     leaf_go = #2 1'b0; 
  
  end
  
  
  addrmap_PICO_pio pio_dut_0 (
    .clk(clk),
    .reset(reset),
    .h2l_ral_regs_demo_CTRL_PRESCALER_w(h2l_ral_regs_demo_CTRL_PRESCALER_w),
    .h2l_ral_regs_demo_CTRL_MODE_w(h2l_ral_regs_demo_CTRL_MODE_w),
    .h2l_ral_regs_demo_CTRL_MASTER_w(h2l_ral_regs_demo_CTRL_MASTER_w),
    .h2l_ral_regs_demo_CTRL_MASTER_we(h2l_ral_regs_demo_CTRL_MASTER_we),
    .h2l_ral_regs_demo_STATUS_WRCOL_w(h2l_ral_regs_demo_STATUS_WRCOL_w),
    .h2l_ral_regs_demo_STATUS_WRCOL_we(h2l_ral_regs_demo_STATUS_WRCOL_we),
    .h2l_ral_regs_demo_STATUS_IF_w(h2l_ral_regs_demo_STATUS_IF_w),
    .h2l_ral_regs_demo_STATUS_IF_we(h2l_ral_regs_demo_STATUS_IF_we),
    .leaf_dec_wr_data(leaf_dec_wr_data),
    .leaf_dec_addr(leaf_dec_addr),
    .leaf_dec_block_sel(leaf_dec_block_sel),
    .leaf_dec_valid(leaf_dec_valid),
    .leaf_dec_wr_dvld(leaf_dec_wr_dvld),
    .leaf_dec_cycle(leaf_dec_cycle),
    .leaf_dec_wr_width(leaf_dec_wr_width),
    .l2h_ral_regs_demo_CTRL_MASTER_r(l2h_ral_regs_demo_CTRL_MASTER_r),
    .l2h_ral_regs_demo_CTRL_DORD_r(l2h_ral_regs_demo_CTRL_DORD_r),
    .l2h_ral_regs_demo_CTRL_ENABLE_r(l2h_ral_regs_demo_CTRL_ENABLE_r),
    .l2h_ral_regs_demo_CTRL_CLK2X_r(l2h_ral_regs_demo_CTRL_CLK2X_r),
    .l2h_ral_regs_demo_INTCTRL_INTLVL_r(l2h_ral_regs_demo_INTCTRL_INTLVL_r),
    .l2h_ral_regs_demo_STATUS_WRCOL_r(l2h_ral_regs_demo_STATUS_WRCOL_r),
    .l2h_ral_regs_demo_STATUS_IF_r(l2h_ral_regs_demo_STATUS_IF_r),
    .dec_leaf_rd_data(dec_leaf_rd_data),
    .dec_leaf_ack(dec_leaf_ack),
    .dec_leaf_nack(dec_leaf_nack),
    .dec_leaf_accept(dec_leaf_accept),
    .dec_leaf_reject(dec_leaf_reject),
    .dec_leaf_retry_atomic(dec_leaf_retry_atomic),
    .dec_leaf_data_width(dec_leaf_data_width) );
    
  addrmap_PICO_test_leaf_bfm leaf_bfm (
    .address(address),
    .wr_data(wr_data),
    .wr_enable(wr_enable),
    .rd_compare(rd_compare),
    .rd_data(rd_data),
    .trans_type(trans_type),
    .size(size),
    .leaf_go(leaf_go),
    .CLK(CLK),
    .dec_leaf_rd_data(dec_leaf_rd_data),
    .dec_leaf_ack(dec_leaf_ack),
    .dec_leaf_nack(dec_leaf_nack),
    .dec_leaf_accept(dec_leaf_accept),
    .dec_leaf_reject(dec_leaf_reject),
    .dec_leaf_retry_atomic(dec_leaf_retry_atomic),
    .dec_leaf_data_width(dec_leaf_data_width),
    .active(active),
    .done(done),
    .leaf_dec_addr(leaf_dec_addr),
    .leaf_dec_wr_data(leaf_dec_wr_data),
    .leaf_dec_valid(leaf_dec_valid),
    .leaf_dec_wr_dvld(leaf_dec_wr_dvld),
    .leaf_dec_cycle(leaf_dec_cycle),
    .leaf_dec_wr_width(leaf_dec_wr_width) );
    
endmodule

