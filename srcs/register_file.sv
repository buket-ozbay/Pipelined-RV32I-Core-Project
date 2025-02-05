`timescale 1ns / 1ps


module register_file(
    input  logic         clk_rf,
    input  logic         rst_rf,
    input  logic [4:0]   a1_rf,
    input  logic [4:0]   a2_rf,
    input  logic [4:0]   a3_rf,
    input  logic [31:0]  wd3_rf,
    input  logic         we3_rf,
    output logic [31:0]  rd1_rf,
    output logic [31:0]  rd2_rf
    );
    
    reg [31:0] registers [31:0];
    wire [31:0] reg_w;
    integer i;
    
    assign rd1_rf = registers[a1_rf];
    assign rd2_rf = registers[a2_rf];
    
    //comb part 
    assign reg_w = (we3_rf == 1'b1) ? (a3_rf != 5'd0) ? wd3_rf : 32'd0 : registers[a3_rf];
    
    always_ff @(posedge clk_rf or negedge rst_rf)
        begin
            if(!rst_rf)
                begin
                    for(i=0;i<32;i=i+1)
                        begin
                            registers[i] <= 32'd0;
                        end
                end
            else
                begin//sequential part
                    registers[a3_rf] <= reg_w;
                end
        end
       
endmodule
