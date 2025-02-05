`timescale 1ns / 1ps


module data_memory #(parameter L_dmem = 64)
    (
    input  logic         clk_dm,
    input  logic         rst_dm,
    input  logic [2:0]   mem_bit_sel,//to select # bits for load and store operations(funct3 is used)
    input  logic         we_dm,
    input  logic [31:0]  a_dm,
    input  logic [31:0]  wd_dm,
    output logic [31:0]  rd_dm
    );
    
    reg [31:0] data_memory [L_dmem-1:0];
    integer i;
    wire[31:0] write_data0_w, write_data1_w, write_data2_w, write_data3_w;
    
    initial begin
    $readmemh("dmem.mem", data_memory);
    end
    
    always_ff @(posedge clk_dm or negedge rst_dm)
        begin
            if(!rst_dm)
                begin
                    for(i=0; i<L_dmem; i=i+1)
                        begin
                            data_memory[i] <= 32'd0;
                        end
                end
            else//sequential part
                begin
                    data_memory[a_dm] <= write_data0_w;
                    data_memory[a_dm+1] <= write_data1_w;
                    data_memory[a_dm+2] <= write_data2_w;
                    data_memory[a_dm+3] <= write_data3_w;
                end
        end

    assign rd_dm = (mem_bit_sel == 3'b000) ? {{(24){data_memory[a_dm][7]}}, data_memory[a_dm][7:0]}:
                   (mem_bit_sel == 3'b001) ? {{(16){data_memory[a_dm+1][7]}},data_memory[a_dm+1][7:0], data_memory[a_dm][7:0]}:
                   (mem_bit_sel == 3'b010) ? {data_memory[a_dm+3][7:0], data_memory[a_dm+2][7:0], data_memory[a_dm+1][7:0], data_memory[a_dm][7:0]}:
                   (mem_bit_sel == 3'b100) ? {24'd0, data_memory[a_dm][7:0]}:
                   (mem_bit_sel == 3'b101) ? {16'd0, data_memory[a_dm+1][7:0], data_memory[a_dm][7:0]}:
                   32'd0;
           
    //comb part    
    assign write_data0_w = (we_dm == 1'b1) ?  wd_dm[7:0] : data_memory[a_dm];                             //SB,SH,SW
    assign write_data1_w = (we_dm == 1'b1 && mem_bit_sel != 3'b000) ?  wd_dm[15:8] : data_memory[a_dm+1]; //SH,SW
    assign write_data2_w = (we_dm == 1'b1 && mem_bit_sel == 3'b010) ?  wd_dm[23:16] : data_memory[a_dm+2];//SW
    assign write_data3_w = (we_dm == 1'b1 && mem_bit_sel == 3'b010) ?  wd_dm[31:24] : data_memory[a_dm+3];//SW
    

endmodule
