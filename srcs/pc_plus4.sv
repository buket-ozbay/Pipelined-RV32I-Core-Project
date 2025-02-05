`timescale 1ns / 1ps


module pc_plus4(
    input  logic [31:0] pc_pp,
    output logic [31:0] pc_plus4
    );
    
    assign pc_plus4 = pc_pp + 32'd4;
endmodule
