# PIPELINE-PROCESSOR

*COMPANY*: CODTECH IT SOLUTIONS

*NAME*: KARNAKANTI SINDHU

*INTER ID*: CTIS7239

*DOMAIN*: VLSI

*DURATION*: 4 WEEKS

*MENTOR*: NEELA SANTHOSH KUMAR  

# 4-Stage Pipelined Processor Design (Verilog)
Design and simulate a 4-stage pipelined processor using Verilog that supports basic instructions:
- ADD
- SUB
- LOAD

# Pipeline Processor
A pipeline processor divides instruction execution into multiple stages. Each stage performs part of the instruction, allowing multiple instructions to be processed simultaneously.

Without Pipeline:
- One instruction completes fully before the next starts
- Slow execution

 With Pipeline:

- Multiple instructions run in parallel (different stages)
- Faster throughput
# Pipeline Stages Used
This design uses 4 stage
Stage| Name| Description
1| IF (Instruction Fetch)| Fetch instruction from memory
2| ID (Instruction Decode)| Decode instruction and read registers
3| EX (Execute)| Perform ALU operations
4| WB (Write Back)| Write result to register
Each instruction is 32-bit wide:
[31:28] → Opcode  
[27:25] → Source Register 1 (rs)  
[24:22] → Source Register 2 (rt)  
[21:19] → Destination Register (rd)
 Supported Instructions
Instruction| Opcode| Description
ADD| 0001| R[rd] = R[rs] + R[rt]
SUB| 0010| R[rd] = R[rs] - R[rt]
LOAD| 0011| R[rd] = MEM[R[rs]]

# Design Overview
The processor consists of:
- Instruction Memory
- Register File
- Data Memory
- ALU
- Pipeline Registers:
  - IF/ID
  - ID/EX
  - EX/WB


# Verilog Code (Design)

module pipeline_processor(input clk);

// Program Counter
reg [3:0] pc;

// Memories
reg [31:0] instr_mem [0:15];
reg [31:0] reg_file [0:7];
reg [31:0] data_mem [0:15];

// Pipeline registers
reg [31:0] IF_ID_instr;

reg [31:0] ID_EX_A, ID_EX_B;
reg [3:0] ID_EX_opcode;
reg [2:0] ID_EX_rd;

reg [31:0] EX_WB_result;
reg [2:0] EX_WB_rd;

// Initialization
initial begin
    pc = 0;
    IF_ID_instr = 0;
    ID_EX_A = 0;
    ID_EX_B = 0;
    ID_EX_opcode = 0;
    ID_EX_rd = 0;
    EX_WB_result = 0;
    EX_WB_rd = 0;
end

// IF Stage
always @(posedge clk) begin
    IF_ID_instr <= instr_mem[pc];
    pc <= pc + 1;
end

// ID Stage
always @(posedge clk) begin
    ID_EX_opcode <= IF_ID_instr[31:28];
    ID_EX_A <= reg_file[IF_ID_instr[27:25]];
    ID_EX_B <= reg_file[IF_ID_instr[24:22]];
    ID_EX_rd <= IF_ID_instr[21:19];
end

// EX Stage
always @(posedge clk) begin
    case(ID_EX_opcode)
        4'b0001: EX_WB_result <= ID_EX_A + ID_EX_B;
        4'b0010: EX_WB_result <= ID_EX_A - ID_EX_B;
        4'b0011: EX_WB_result <= data_mem[ID_EX_A];
        default: EX_WB_result <= 0;
    endcase
    EX_WB_rd <= ID_EX_rd;
end

// WB Stage
always @(posedge clk) begin
    reg_file[EX_WB_rd] <= EX_WB_result;
end

endmodule



# Testbench Code

module tb;

reg clk;
pipeline_processor uut(.clk(clk));

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    // Register initialization
    uut.reg_file[1] = 10;
    uut.reg_file[2] = 20;
    uut.reg_file[3] = 5;

    // Data memory
    uut.data_mem[10] = 100;

    // Instructions
    uut.instr_mem[0] = {4'b0001,3'b001,3'b010,3'b100,19'b0}; // ADD
    uut.instr_mem[1] = {4'b0010,3'b100,3'b011,3'b101,19'b0}; // SUB
    uut.instr_mem[2] = {4'b0011,3'b001,3'b000,3'b110,19'b0}; // LOAD

    #300;
    $finish;
end

endmodule

---

# Working Explanation

Instruction Flow Example

1. ADD R4 = R1 + R2
   
   - 10 + 20 = 30

2. SUB R5 = R4 - R3
   
   - 30 - 5 = 25

3. LOAD R6 = MEM[R1]
   
   - MEM[10] = 100


# Simulation Output (Expected)

After running simulation:

Register| Value
R4| 30
R5| 25
R6| 100

---

#  Waveform Observation

During simulation:

- "pc" increases each clock cycle
- Instructions move through pipeline stages
- "EX_WB_result" shows computed values
- Registers update in WB stage


# Tools Used

- Vivado 
  



- Internship Task Submission (CODTECH)

---
