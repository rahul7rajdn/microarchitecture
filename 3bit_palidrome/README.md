Palindrome 3b
You are tasked to design a circuit which would detect a 3-bit palindrome sequence from incoming stream of bits.

Palindrome code is a sequence of characters which reads the same backward as forward. For example, the following are palindromes: 101, 010, 111, 000, etc.

All the flops should be positive edge triggered with asynchronous resets (if any).

Interface Definition
x_i : Input stream of bits to the circuit

palindrome_o : Output to signal that the current bit and the last two bits together form a
               palindrome
Interface Requirements
Output must be given every cycle
Input will be a stream of bits presented to the circuit on every cycle
Sample Simulation
Palindrome

Explanation
Cycle T0: Circuit is reset
Cycle T1: Reset is deasserted with input as 1'b0
Cycle T2: Input remains at 1'b0 and the stream of input becomes 2'b00
Cycle T3: Input is 1'b0 and output goes HIGH since stream becomes 3'b000 which is a palindrome
Cycle T4: Input is 1'b1 and output goes LOW as stream is now 3'b001
Cycle T5: Input is 1'b0 and output goes HIGH as stream becomes 3'b010 which is a palindrome
Cycle T6: Input is 1'b1 and output remains HIGH since stream is 3'b101
Cycle T7: Input is 1'b1 and output goes LOW as stream is 3'b011
Cycle T8: Input is 1'b1 and output goes HIGH as stream is 3'b111