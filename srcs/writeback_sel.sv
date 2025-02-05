`timescale 1ns / 1ps


module writeback_sel #(parameter N = 32)
    (
    input  logic [N-1:0] in0,//alu_result
    input  logic [N-1:0] in1,//rd_dm
    input  logic [N-1:0] in2,//pc_plus4
    input  logic [1:0]  sel, //result_src
    output logic [N-1:0] out //result to WB
    );
    
    assign out = (sel == 3'b00) ? in0:
                 (sel == 3'b01) ? in1:
                 (sel == 3'b10) ? in2:
                 in1;
    
endmodule
