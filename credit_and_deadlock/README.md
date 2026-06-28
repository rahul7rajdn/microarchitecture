Credit Deadlock
Adam is part of a networking SoC which implements an internal ring based structure to connect with devices. The ring structure only supports unidirectional data transfers, with data travelling anti-clockwise direction around the ring using a valid-ready protocol. The ring based topology for the networking chip is shown below:

Ring Topology

While interfacing certain devices on the ring using the valid-ready protocol, performance team noticed a significant drop in the performance. It was noticed that a lot of transaction don’t make progress for hundreds of cycle due to the ring being blocked by one slow transaction. The slow transaction end-up taking all of the resources until the target device got free and ready to accept the incoming transaction. This becomes a bottleneck for the system performance as one particular transaction could end up taking all of the resources blocking other transaction from any other device to win arbitration. After running various performance tests, the team decides to go with a strict performance criteria where any transaction on the ring shouldn’t be stalled by more than 3 cycles.

In order to meet this performance criteria, you decide to upgrade the valid ready based protocol on the ring to include credit and retry signals. This would mean that the transaction on the ring could get a retry whenever it is not accepted in the 3 cycle window. This allows the target device to assert a retry instead of a ready whenever it doesn’t have resources to accept a new transaction. Once the retry is given the target device can again request the transaction on the ring by granting credits for the transaction which earlier got a retry. This would mean that no transaction could be stalled on the ring for more than 3 cycles and would allow the ring to make progress even when even the target device is busy or doesn’t have resources to accept the new request at the moment.

You also plan to introduce a throttling mechanism on the ring which throttles the requests on the incoming channel for a particular device whenever the device sends 4 retries without releasing any credits.

Ring Topology with Credits

Since the target device don’t support the credit based valid-ready protocol, you decide to implement an interfacing module to manage the credit based infrastructure. You also plan to introduce a buffer which must be at least 4 entries deep and can go as deep as 6 entries. This allows you to add additional buffering thus improving the ring bandwidth.

Design the module which would interface a valid-credit with retry based interface to a standard valid-ready interface.

Credit and Deadlock Block Diagram

All the flops (if any) should be positive edge triggered with asynchronous resets.

Interface Definition
The interface consists of three channels:

RX Channel - The credit and retry based valid-ready protocol on the ring
// RX Channel
rx_valid_i   => Request is valid on this cycle
rx_id_i => The unique request ID for the transaction
rx_payload_i => The associated request payload
rx_credit_i => Request has associated credits
rx_ready_o => Request got a ready and got accepted
rx_retry_o => Request got a retry and was not accepted
TX Channel - The standard valid-ready based protocol connecting the target device
// TX Channel
tx_valid_o => Request is valid on this cycle
tx_id_o => The unique request ID for the transaction
tx_payload_o => The associated request payload
tx_ready_i => Request got a ready and got accepted
Credit Channel - Interface to grant credits for requests which got a retry instead of ready
// Credit channel
credit_gnt_o => A credit is granted on this cycle
credit_id_o => The unique request ID which got a credit

There is no ready associated with the credit channel hence it can be assumed
that the credit is always accepted as soon as it is granted.
Interface Requirements
The valid-ready protocol must be honoured - i.e. ID or payload can’t change until request got a ready or a retry
The requests must be sent in the same order on the TX channel as on the RX channel unless the request gets a retry
The request on the RX channel must get either a ready or a retry in the 3 cycle window
The buffer must be at least 4 entries deep and can go as deep as 6 entries
The interface guarantees that the request which got a retry will only be sent again on the RX channel once the credit is granted
The interface guarantees that the request on the RX channel will have the credit attribute asserted only if the credit was granted earlier
The specification mandate that a request with credit should never get a retry again - This implies that a request can only get a single retry
There are no timing relationship between when the credits are granted and when the request is retried on the RX channel. The request on RX channel can either be retried on the very next cycle or could take any number of cycles. There can be additional requests in that period which may or may-not have credits
Back-to-back transfers are allowed
The interface guarantees that there won’t be more than 4 retries ever. The RX channel would throttle if 4 retries are seen and wouldn’t send more requests to that target device unless it gets some credits
Credits must be released as soon as buffer space is available
Shared Modules
You are allowed to use the following shared modules in your RTL:

Fifo
module qs_fifo #(
  parameter DATA_W = 4,
  parameter DEPTH  = 4
)(
  input   logic               clk,
  input   logic               reset,

  input   logic               push_i,
  input   logic [DATA_W-1:0]  push_data_i,

  input   logic               pop_i,
  output  logic [DATA_W-1:0]  pop_data_o,

  output  logic               empty_o,
  output  logic               full_o
);
endmodule
Skid Buffer
module qs_skid_buffer #(
  parameter DATA_W = 8
)(
  input   logic               clk,
  input   logic               reset,

  input   logic               i_valid_i,
  input   logic [DATA_W-1:0]  i_data_i,
  output  logic               i_ready_o,

  input   logic               e_ready_i,
  output  logic               e_valid_o,
  output  logic [DATA_W-1:0]  e_data_o
);
endmodule
Sample Simulation
Credit_and_Deadlock