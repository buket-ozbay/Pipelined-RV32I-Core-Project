`timescale 1ns / 1ps


module pre_decoder(
    input  logic [31:0] instruction_pd,
    output logic [6:0]  opcode_pd,
    output logic [2:0]  funct3_pd,
    output logic [6:0]  funct7_pd,
    output logic [4:0]  rs1_pd,
    output logic [4:0]  rs2_pd,
    output logic [4:0]  rd_pd
    );
    
    
    assign opcode_pd = instruction_pd[6:0];
    assign funct7_pd = instruction_pd[31:25];
    assign funct3_pd = instruction_pd[14:12];
    assign rs1_pd = instruction_pd[19:15];
    assign rs2_pd = instruction_pd[24:20];
    assign rd_pd = instruction_pd[11:7];
    
endmodule
