`timescale 1ns / 1ps


module execute_memory(
    //inputs
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pc_plus4_e,
    input  logic        reg_write_e,
    input  logic        mem_write_e,
    input  logic [1:0]  result_src_e,
    input  logic [31:0] alu_result_e,
    input  logic [4:0]  rd_e,
    input  logic [31:0] rd2_e,
    input  logic [2:0]  funct3_e,
    input  logic [31:0] srcb_forward_e,
    
    //outputs
    output logic [31:0] pc_plus4_m,
    output logic        reg_write_m,
    output logic        mem_write_m,
    output logic [1:0]  result_src_m,
    output logic [31:0] alu_result_m,
    output logic [4:0]  rd_m,
    output logic [31:0] rd2_m,
    output logic [2:0]  funct3_m,
    output logic [31:0] srcb_forward_m
    );
    
    
    always_ff @(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    pc_plus4_m <= 32'd0;
                    reg_write_m <= 1'b0;
                    mem_write_m <= 1'b0;
                    result_src_m <= 2'd0;
                    alu_result_m <= 32'd0;
                    rd_m <= 5'd0;
                    rd2_m <= 32'd0;
                    funct3_m <= 3'd0;
                    srcb_forward_m <= 32'd0;
                end
            else
                begin
                    pc_plus4_m <= pc_plus4_e;
                    reg_write_m <= reg_write_e;
                    mem_write_m <= mem_write_e;
                    result_src_m <= result_src_e;
                    alu_result_m <= alu_result_e;
                    rd_m <= rd_e;
                    rd2_m <= rd2_e;
                    funct3_m <= funct3_e;
                    srcb_forward_m <= srcb_forward_e;
                end
        end
    
    
endmodule
