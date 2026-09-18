interface axi4_if (input bit clk, input bit rst);

  logic wr_en;
  logic rd_en;
  logic [127:0] wr_data;
  logic full;
  logic [127:0] rd_data;
  logic empty;

  //write address channel
  logic [3:0] AWID_a;
  logic [31:0] AWADDR_a;
  logic [3:0] AWLEN_a;
  logic [2:0] AWSIZE_a;
  logic [1:0] AWBURST_a;
  logic [1:0] AWLOCK_a;
  logic [1:0] AWCACHE_a;
  logic [2:0] AWPROT_a;
  logic AWVALID_a;
  logic AWREADY_a;

  // Write Data channel
  logic [3:0] WID_a;
  logic [63:0] WDATA_a;
  logic [3:0] WSTRB_a;
  logic WLAST_a;
  logic WVALID_a;
  logic WREADY_a;

  // Write Response channel
  logic [3:0] BID_a;
  logic [1:0] BRESP_a;
  logic BVALID_a;
  logic BREADY_a;

  // Read Address channel
  logic [3:0] ARID_a;
  logic [31:0] ARADDR_a;
  logic [3:0] ARLEN_a;
  logic [2:0] ARSIZE_a;
  logic [1:0] ARBURST_a;
  logic [1:0] ARLOCK_a;
  logic [1:0] ARCACHE_a;
  logic [2:0] ARPROT_a;
  logic ARVALID_a;
  logic ARREADY_a;

  // Read Data channel
  logic [3:0] RID_a;
  logic [63:0] RDATA_a;
  logic [1:0] RRESP_a;
  logic RLAST_a;
  logic RVALID_a;
  logic RREADY_a;

  clocking cb @(posedge clk);
    default input #1step output #1;
    output wr_en, rd_en, wr_data;
    input  full, rd_data, empty;
    input  AWREADY_a, WREADY_a, BID_a, BRESP_a, BVALID_a;
    output BREADY_a;
    input  ARREADY_a;
    input  RID_a, RDATA_a, RRESP_a, RLAST_a, RVALID_a;
    output RREADY_a;
  endclocking

endinterface
