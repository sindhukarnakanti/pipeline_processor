module tb;
reg clk;
pipeline_processor uut(.clk(clk));
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    uut.reg_file[1] = 10;
    uut.reg_file[2] = 20;
    uut.reg_file[3] = 5;

    uut.data_mem[10] = 100;

    uut.instr_mem[0] = {4'b0001,3'b001,3'b010,3'b100,19'b0};
    uut.instr_mem[1] = {4'b0010,3'b100,3'b011,3'b101,19'b0};
    uut.instr_mem[2] = {4'b0011,3'b001,3'b000,3'b110,19'b0};
  #300;
    $finish;
end

endmodule