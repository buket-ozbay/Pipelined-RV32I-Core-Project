`timescale 1ns / 1ps


module pc_target(
    input  logic [31:0] pc_pt,
    input  logic auipc_sel_pt,
    input  logic [31:0] rd1_pt,
    input  logic [31:0] immediate32_pt,
    output logic [31:0] pc_target,
    output logic [31:0] pc_auipc_lui,
    output logic [31:0] pc_jalr
    );
    
    wire [31:0] auipc;
    wire [31:0] pc_temp;
    
    assign pc_temp = rd1_pt + immediate32_pt;
    assign pc_jalr = {pc_temp[30:1], 1'b0};
    
    assign auipc = pc_pt + {immediate32_pt[31:12],12'd0};
    assign pc_target = immediate32_pt + pc_pt;
    assign pc_auipc_lui = auipc_sel_pt ? auipc : {immediate32_pt[31:12],12'd0};


endmodule
