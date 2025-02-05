`timescale 1ns / 1ps


module alu(
    input  logic [31:0]  src_a,
    input  logic [31:0]  src_b,
    input  logic [4:0]   alu_control,//may be 4 bit
    input  logic         branch_op,
    input  logic         auipc_sel,
    input  logic         lui_sel,
    input  logic [31:0]  pc_auipc_lui,
    output logic [31:0]  alu_result,
    output               branch
    );

    
    
    //Determines whether a branch should be taken
    assign branch = (branch_op == 0) ? 1'b0:
                    ((alu_control == 5'b01010) && (src_a == src_b)) ?                   1'b1: //BEQ
                    ((alu_control == 5'b01011) && (src_a != src_b)) ?                   1'b1: //BNE
                    ((alu_control == 5'b01100) && ($signed(src_a) < $signed(src_b))) ?  1'b1: //BLT
                    ((alu_control == 5'b01101) && ($signed(src_a) >= $signed(src_b)))?  1'b1: //BGE
                    ((alu_control == 5'b01110) && (src_a < src_b)) ?                    1'b1: //BLTU
                    ((alu_control == 5'b01111) && (src_a >= src_b))?                    1'b1: // BGEU
                    1'b0; //Default Case
    
    
    assign alu_result = (auipc_sel || lui_sel)     ?                            pc_auipc_lui  :                      
                        (alu_control ==  5'b00000) ?                            src_a + src_b :
                        (alu_control ==  5'b00001) ?                            src_a - src_b :
                        (alu_control ==  5'b00011) ?                            $signed(src_a) < $signed(src_b) :// Signed Less Than (SLTI,SLT,BLT)
                        (alu_control ==  5'b00100 || alu_control == 5'b01110) ? src_a < src_b ://Unsigned Less Than (BLTU,SLTIU,SLTU)
                        (alu_control ==  5'b01101) ?                            $signed(src_a) >= $signed(src_b) :// Signed Less Than (SLTI,SLT,BLT)
                        (alu_control ==  5'b01111) ?                            src_a >= src_b :
                        (alu_control ==  5'b01000) ?                            src_a | src_b :
                        (alu_control ==  5'b00101) ?                            src_a ^ src_b :
                        (alu_control ==  5'b01001) ?                            src_a & src_b :
                        (alu_control ==  5'b00010) ?                            src_a << src_b ://Logical Shift Left (SLLI,SLL)
                        (alu_control ==  5'b00110) ?                            src_a >> src_b ://Logical Shift Right (SRLI,SRL)
                        (alu_control ==  5'b00111) ?                            (src_a >> src_b) | ({32{src_a[31]}} << (32 - src_b)) ://Arithmetic Shift Right (SRAI,SRA)
                        (alu_control ==  5'b01010) ?                            src_a == src_b :
                        (alu_control ==  5'b01011) ?                            src_a != src_b :
                                                                                32'd0;
                        
    
endmodule
