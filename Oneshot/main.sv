module one_shot (
  input   logic        clk,
  input   logic        reset,

  input   logic        data_i,

  output  logic        shot_o

);
  
  logic data_q;

  always_ff@(posedge clk, posedge reset) begin
    if (reset) begin
      data_q <= '0;
    end
    else begin
      data_q <= data_i;
    end
  end
  
  assign shot_o = ~data_q & data_i;
  // Write your logic here

endmodule
