`timescale 1ns / 1ps


module alu_decoder(
    input  logic [1:0] alu_op_ad,
    input  logic       op_5,
    input  logic [2:0] funct3_ad,
    input  logic       funct7_5_ad,
    output logic [4:0] alu_control
    );
    
    assign alu_control = (alu_op_ad == 2'b00)                                                                       ? 5'b00000 : //Add
                         (alu_op_ad == 2'b01)                                                                       ? 5'b00001 : //Substract
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b000) && (op_5 == 1'b1) && (funct7_5_ad == 1'b1)) ? 5'b00001 :
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b000))                                            ? 5'b00000 :
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b001))                                            ? 5'b00010 ://SLL
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b010))                                            ? 5'b00011 ://SLT
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b011))                                            ? 5'b00100 ://SLTU
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b100))                                            ? 5'b00101 ://XOR
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b101) && (funct7_5_ad == 1'b1)) ? 5'b00111 ://SRA,SRAI
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b101))                                            ? 5'b00110 ://SRL
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b110))                                            ? 5'b01000 ://OR
                         ((alu_op_ad == 2'b10) && (funct3_ad == 3'b111))                                            ? 5'b01001 ://AND
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b000))                                            ? 5'b01010 ://BEQ
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b001))                                            ? 5'b01011 ://BNE
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b100))                                            ? 5'b01100 ://BLT
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b101))                                            ? 5'b01101 ://BGE
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b110))                                            ? 5'b01110 ://BLTU
                         ((alu_op_ad == 2'b11) && (funct3_ad == 3'b111))                                            ? 5'b01111 ://BGEU
                                                                                                                      5'b00000;
endmodule
