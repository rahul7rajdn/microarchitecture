module palindrome3b (
  input   logic        clk,
  input   logic        reset,

  input   logic        x_i,

  output  logic        palindrome_o
);

  // Write your logic here...
	logic ff0, ff1;
  logic [1:0]count, count_q;
  
  always_ff@(posedge clk, posedge reset) begin
    if(reset) begin
    	{ff1, ff0} <= '0;
    	count_q <= '0;
    end
    else begin
    	{ff1, ff0} <= {ff0, x_i};  
    	count_q <= count;
    end
  end
  
  assign count = count_q[1] ? count_q : (count_q + 1'b1);
  assign palindrome_o = count_q[1] ? (ff1==x_i) : '0;
endmodule
