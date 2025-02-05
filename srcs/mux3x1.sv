`timescale 1ns / 1ps


module mux3x1 #(parameter N = 32)
    (
    input  logic [N-1:0] in0,//PC_Plus4
    input  logic [N-1:0] in1,//PC_JALR
    input  logic [N-1:0] in2,//PC_Target: Branch and JAL operations
    input  logic [1:0] sel,  //PC_Src
    input  logic branch,
    input  logic branch_op,
    output logic [N-1:0] out //PC_Next
    );
    
    assign out = ((sel == 2'b10) || branch) ? in2 : // (&& branch_op)
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b00) ? in0 :
                                in0 ;

endmodule