module tb_top;

  logic clk;
  logic ACLK;

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;     
  end

  assign ACLK = clk;

  logic rst;
  logic ARESETn;

  initial begin
    rst = 1'b1;
    ARESETn = 1'b0;

    repeat (5) @(posedge clk);

    rst = 1'b0;
    ARESETn = 1'b1;
  end

  cpu_if cpu_vif(clk);

  axi_if axi_vif(ACLK);


  assign cpu_vif.rst = rst;
  assign axi_vif.ARESETn = ARESETn;


  Project_AXI4_Top dut (

    .clk (clk),
    .rst (rst),
    .wr_en (cpu_vif.wr_en),
    .rd_en (cpu_vif.rd_en),
    .wr_data(cpu_vif.wr_data),

    .rd_data (cpu_vif.rd_data),
    .full (cpu_vif.full),
    .empty cpu_vif.empty),

    .ACLK      (ACLK),
    .ARESETn   (ARESETn),

    .AWREADY_a (axi_vif.AWREADY),

    .WREADY_a  (axi_vif.WREADY),

    .ARREADY_a (axi_vif.ARREADY),

    .RID_a     (axi_vif.RID),
    .RDATA_a   (axi_vif.RDATA),
    .RRESP_a   (axi_vif.RRESP),
    .RLAST_a   (axi_vif.RLAST),
    .RVALID_a  (axi_vif.RVALID),

    .BID_a     (axi_vif.BID),
    .BRESP_a   (axi_vif.BRESP),
    .BVALID_a  (axi_vif.BVALID),

    .AWID_a    (axi_vif.AWID),
    .AWADDR_a  (axi_vif.AWADDR),
    .AWLEN_a   (axi_vif.AWLEN),
    .AWSIZE_a  (axi_vif.AWSIZE),
    .AWBURST_a (axi_vif.AWBURST),
    .AWLOCK_a  (axi_vif.AWLOCK),
    .AWCACHE_a (axi_vif.AWCACHE),
    .AWPROT_a  (axi_vif.AWPROT),
    .AWVALID_a (axi_vif.AWVALID),

    .WID_a     (axi_vif.WID),
    .WDATA_a   (axi_vif.WDATA),
    .WSTRB_a   (axi_vif.WSTRB),
    .WLAST_a   (axi_vif.WLAST),
    .WVALID_a  (axi_vif.WVALID),

    .BREADY_a  (axi_vif.BREADY),

    .ARID_a    (axi_vif.ARID),
    .ARADDR_a  (axi_vif.ARADDR),
    .ARLEN_a   (axi_vif.ARLEN),
    .ARSIZE_a  (axi_vif.ARSIZE),
    .ARBURST_a (axi_vif.ARBURST),
    .ARLOCK_a  (axi_vif.ARLOCK),
    .ARCACHE_a (axi_vif.ARCACHE),
    .ARPROT_a  (axi_vif.ARPROT),
    .ARVALID_a (axi_vif.ARVALID),
    .RREADY_a  (axi_vif.RREADY)
  );



  initial begin

    uvm_config_db#(virtual cpu_if)::set(null, "*", "cpu_vif", cpu_vif);

    uvm_config_db#(virtual axi_if)::set(null,"*", "axi_vif", axi_vif
    );

    run_test();

  end

endmodule
