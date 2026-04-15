module pipeline_processor(input clk);
reg [3:0] pc;
reg [31:0] instr_mem [0:15];
reg [31:0] reg_file [0:7];
reg [31:0] data_mem [0:15];
reg [31:0] IF_ID_instr;
reg [31:0] ID_EX_A, ID_EX_B;
reg [3:0] ID_EX_opcode;
reg [2:0] ID_EX_rd;
reg [31:0] EX_WB_result;
reg [2:0] EX_WB_rd;
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
always @(posedge clk) begin
    IF_ID_instr <= instr_mem[pc];
    pc <= pc + 1;
end
always @(posedge clk) begin
    ID_EX_opcode <= IF_ID_instr[31:28];
    ID_EX_A <= reg_file[IF_ID_instr[27:25]];
    ID_EX_B <= reg_file[IF_ID_instr[24:22]];
    ID_EX_rd <= IF_ID_instr[21:19];
end
always @(posedge clk) begin
    case(ID_EX_opcode)
        4'b0001: EX_WB_result <= ID_EX_A + ID_EX_B;
        4'b0010: EX_WB_result <= ID_EX_A - ID_EX_B;
        4'b0011: EX_WB_result <= data_mem[ID_EX_A];
        default: EX_WB_result <= 0;
    endcase

    EX_WB_rd <= ID_EX_rd;
end
always @(posedge clk) begin
    reg_file[EX_WB_rd] <= EX_WB_result;
end
endmodule