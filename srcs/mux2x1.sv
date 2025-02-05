`timescale 1ns / 1ps


module mux2x1 #(parameter N = 32)
    (
    input  logic [N-1:0] in0,//Immediate32
    input  logic [N-1:0] in1,//RD2 or srcb_forward_c
    input  logic sel,        //ALU_Src
    output logic [N-1:0] out //Src_B
    );
    
    assign out = sel ? in0 : in1;
    
endmodule
