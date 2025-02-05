`timescale 1ns / 1ps


module branch_src_mux#(parameter N = 32)
    (
    input  logic [N-1:0] in0,//rd
    input  logic [N-1:0] in1,//result_c
    input  logic [N-1:0] in2,//alu_result
    input  logic [N-1:0] in3,//result_B
    input  logic [1:0]  sel, //forward__e
    output logic [N-1:0] out //result to branch
    );
    
    assign out = (sel == 3'b00) ? in0:
                 (sel == 3'b01) ? in1:
                 (sel == 3'b10) ? in2:
                 (sel == 3'b11) ? in3:
                 in0;
endmodule
