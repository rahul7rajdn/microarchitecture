module big_endian_converter #(
  parameter DATA_W = 32
)(
  input   logic              clk,
  input   logic              reset,

  input   logic [DATA_W-1:0] le_data_i,

  output  logic [DATA_W-1:0] be_data_o

);

  // Write your logic here

  
  always_comb begin
    for (int i =0; i < DATA_W; i=i+8) begin
      be_data_o[i +: 8] = le_data_i[DATA_W-1-i -: 8];
    end
    
  end
  
endmodule
