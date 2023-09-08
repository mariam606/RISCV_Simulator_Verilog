CSCE 3301 – Computer Architecture
Fall 2020
Project 1: femtoRV32
RISC-V FPGA Implementation and Testing
Milestone 2

Omar Ahmed A. Ali
900171970
AbdAllah M. Abdelnaby
900171494

This is a single cycle RISC-V datapath implementation supporting all RV32I except for: jal, jalr, fence, ecall, ebreak (making total of 35 instructions).
Basic testcase is provided, it is not thoroughly tested though. The testcase is loaded in the instruction memory, and is provided as an assembly text and binary text as well.
This implementation uses distinct instruction and data memories.



