Atomic Counters
While working on the next generation SoC you were asked to design a 64-bit event counter which would be interfaced with a 32-bit bus controlled via a microcontroller. The 64-bit counter is incremented whenever a trigger input is seen. Given that the counter is read by a 32-bit bus, a full 64-bit read of the counter needs two 32-bit accesses. It is important that these two accesses should be single-copy atomic.

Design the 64-bit counter module and the appropriate interfacing mechanism to ensure single-copy atomic counter read operations. All the flops should be positive edge triggered with asynchronous resets (if any).

Interface Definition
trig_i    : Trigger input to increment the counter
req_i     : A read request to the counter
atomic_i  : Marks whether the current request is the first part of the two 32-bit accesses to read
            the 64-bit counter. Use this input to save the current value of the upper 32-bit of
            the counter in-order to ensure single-copy atomic operation
ack_o     : Acknowledge output from the counter
count_o   : 32-bit counter value given as output to the controller
Interface Requirements
The counter value is read by a 32-bit wide bus but the output should be single-copy atomic. The interface is a simple request and acknowledge interface with the following strict requirements:

Request can be a pulse or can get back to back multiple requests
The acknowledge output must be given one cycle after the request is asserted
The count_o signal must be 0 when the ack_o signal is not asserted
The controller will always send two requests in order to read the full 64-bit counter
The first request will always have the atomic_i input asserted
The second request will not have the atomic_i input asserted
Please note that the testbench preloads the counter for this problem to test interesting scenarios.
Sample Simulation
Atomic Counters

Explanation
Cycle T1 : Reset is asserted
Cycle T2 : Reset is de-asserted
Cycle T3 : trig_i is 1'b1 and should increment the internal counter
Cycle T4 : req_i is 1'b1 and atomic_i is 1'b1. Marks the first part of two accesses
Cycle T5 : req_i is 1'b1 and atomic_i is 1'b0. Second part of the request. ack_o is 1'b1 and count_o is 0x1 as only one trigger request was seen
Cycle T6 : req_i is 1'b0. ack_o is 1'b1 with count_o as 0x0 (since the upper 32-bit of the counter are still 0x0. 64-bit counter value: 0x00000000_00000001
Cycle T7 : req_i is 1'b0. ack_o is 1'b0
Cycle T8 : Assume simulation is carried for few cycles with trig_i asserted
Cycle T9 : req_i is 1'b1 with atomic_i being 1'b1
Cycle T10 : req_i is 1'b1 with atomic_i being 1'b0 ack_o is 1'b1 with count_o as 0xFF.
Cycle T11 : req_i is 1'b0. ack_o is 1'b0 ack_o is 1'b1 with count_o as 0x2. 64-bit counter value: 0x00000002_000000FF