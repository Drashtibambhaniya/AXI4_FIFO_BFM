interface cpu_if(input logic clk);

  logic rst;
  logic wr_en;
  logic [127:0] wr_data;
  logic full;

  logic rd_en;
  logic [127:0] rd_data;
  logic empty;

endinterface
