module edge_capture (
  input   logic        clk,
  input   logic        reset,

  input   logic [31:0] data_i,

  output  logic [31:0] edge_o

);

  // Write your logic here...
  logic [31:0] edge_q, data_q;
  
  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      edge_q <= '0;
      data_q <= '0;
    end
    else begin
      data_q <= data_i;
      edge_q <= edge_o;
    end 
  end
  
  
  always_comb begin
    edge_o = reset ? '0 : (~data_i & data_q) | edge_q;
  end
endmodule
