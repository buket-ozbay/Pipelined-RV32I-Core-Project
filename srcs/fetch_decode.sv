`timescale 1ns / 1ps


module fetch_decode(
    //inputs
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pc_f,
    input  logic [31:0] pc_plus4_f,
    //input  logic [31:0] pc_next_f,
    input  logic [31:0] instruction_f,
    input  logic        flush_f,
    input  logic        predicted_branch_f,
    
    //outputs
    output logic [31:0] pc_d,
    output logic [31:0] pc_plus4_d,
    //output logic [31:0] pc_next_d,
    output logic [31:0] instruction_d,
    output logic        predicted_branch_d
    );
    
    always_ff @(posedge clk or negedge rst)
        begin
            if (!rst || flush_f)
                begin
                    pc_d            <= 32'd0;
                    pc_plus4_d      <= 32'd0;
                    //pc_next_d       <= 32'd0;
                    instruction_d   <= 32'd0;
                    predicted_branch_d <= 1'b0;
                end
            else
                begin
                    pc_d            <= pc_f;
                    pc_plus4_d      <= pc_plus4_f;
                    //pc_next_d       <= pc_next_f;
                    instruction_d   <= instruction_f;
                    predicted_branch_d <= predicted_branch_f;
                end
        end
endmodule
