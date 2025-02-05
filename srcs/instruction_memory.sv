`timescale 1ns / 1ps


module instruction_memory #(
    parameter L_imem = 256)
    (
    input  logic [31:0] pc_im,
    output logic [31:0] instruction_im 
    );
    reg [31:0] instruction_memory [L_imem-1:0];
    
    initial begin
        $readmemh("imem.mem", instruction_memory);
    end
    
    assign instruction_im = instruction_memory[pc_im/4];
    
endmodule
