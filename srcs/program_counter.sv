`timescale 1ns / 1ps


module program_counter(
    input  logic clk_pc,
    input  logic rst_pc,
    input  logic [31:0] pc_next,
    output logic [31:0] program_counter
    );
    
    always_ff @(posedge clk_pc or negedge rst_pc)
        begin
            if (!rst_pc)
                begin
                    program_counter <= 32'd0;
                end
            else
                begin
                    program_counter <= pc_next;
                end
        end
endmodule
