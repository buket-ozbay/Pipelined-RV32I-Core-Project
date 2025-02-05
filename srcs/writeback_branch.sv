`timescale 1ns / 1ps


module writeback_branch(
    //inputs
    input  logic        clk,
    input  logic        rst,
    input  logic [4:0]  rd_w,
    input  logic        reg_write_w,
    input  logic [31:0] result_w,
    
    //outputs
    output logic [4:0]  rd_b,
    output logic        reg_write_b,
    output logic [31:0] result_b
    );
    
    
    always_ff @(posedge clk or negedge rst)
        begin
            if(!rst)
                begin
                    rd_b            <= 5'd0;
                    reg_write_b     <= 1'b0;
                    result_b        <= 32'd0;
                end
            else
                begin
                    rd_b            <= rd_w;
                    reg_write_b     <= reg_write_w;
                    result_b        <= result_w;
                end
        end
endmodule
