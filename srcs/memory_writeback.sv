`timescale 1ns / 1ps


module memory_writeback(
    //inputs
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] read_data_m,
    input  logic [4:0]  rd_m,
    input  logic [31:0] pc_plus4_m,
    input  logic [1:0]  result_src_m,
    input  logic        reg_write_m,
    input  logic [31:0] alu_result_m,
    
    //outputs
    output logic [31:0] read_data_w,
    output logic [4:0]  rd_w,
    output logic [31:0] pc_plus4_w,
    output logic [1:0]  result_src_w,
    output logic        reg_write_w,
    output logic [31:0] alu_result_w
    );
    
    
    always_ff @(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    read_data_w     <= 32'd0;
                    rd_w            <= 5'd0;
                    pc_plus4_w      <= 32'd0;
                    result_src_w    <= 2'd0;
                    reg_write_w     <= 1'b0;
                    alu_result_w    <= 32'd0;
                end
            else
                begin
                    read_data_w     <= read_data_m;
                    rd_w            <= rd_m;
                    pc_plus4_w      <= pc_plus4_m;
                    result_src_w    <= result_src_m;
                    reg_write_w     <= reg_write_m;
                    alu_result_w    <= alu_result_m;
                end
        end
    
    
endmodule
