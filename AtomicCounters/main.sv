module atomic_counters (
  input                   clk,
  input                   reset,
  input                   trig_i,
  input                   req_i,
  input                   atomic_i,
  output logic            ack_o,
  output logic[31:0]      count_o
);

  // --------------------------------------------------------
  // DO NOT CHANGE ANYTHING HERE
  // --------------------------------------------------------
  logic [63:0] count_q;
  logic [63:0] count;

  logic atomic_q, req_q;
  
  logic [31:0] counter_msb;
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_q[63:0] <= 64'h0;
    else
      count_q[63:0] <= count;
  // --------------------------------------------------------

  // Write your logic here...
  assign count = count_q + {{63{1'b0}}, trig_i};
  
  always_ff@(posedge clk, posedge reset) begin
    if(reset) begin
      req_q <= '0;
      atomic_q <= '0;
    end
    else begin
      req_q <= req_i;
      atomic_q <= atomic_i;
    end
  end
  
  always_ff@(posedge clk, posedge reset) begin
    if (reset) begin
      counter_msb <= '0;
    end
    else if(atomic_i) begin
      
      counter_msb <= count_q[63:32];
    end
  end
  
  
  assign ack_o = req_q;
  assign count_o = req_q ? 
    											(atomic_q ? count_q[31:0] : counter_msb) : 
    											'0;
  // looks wrong
endmodule

