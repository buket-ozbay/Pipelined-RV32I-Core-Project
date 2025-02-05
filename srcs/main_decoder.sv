`timescale 1ns / 1ps


module main_decoder(
    input  logic       clk_md,
    input  logic       rst_md,
    input  logic [6:0] opcode_md,
    input  logic [2:0] funct3_md,
    input              branch_md,
    output logic       branch_op_md,
    output logic       jump_op_md,
    output logic [1:0] pc_src,
    output logic [1:0] result_src,
    output logic [1:0] alu_op,
    output logic       alu_src,
    output logic [2:0] imm_src,
    output logic       reg_write,
    output logic       mem_write,
    output logic       auipc_sel,
    output logic       lui_sel
    );
    
    assign imm_src = (opcode_md == 7'b0100011)                                                   ? 3'b001 : //store
                     (opcode_md == 7'b0000011)                                                   ? 3'b000 : //load
                     ((opcode_md == 7'b0010011) && (funct3_md == 3'b001 || funct3_md == 3'b101)) ? 3'b101 : //I-type
                     (opcode_md == 7'b0010011)                                                   ? 3'b000 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 3'b000 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 3'b010 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 3'b011 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 3'b011 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 3'b100 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 3'b000 : //jalr
                                                                                                   3'b000;
    
    //reg_write can be reduced
    assign reg_write =(opcode_md == 7'b0100011)                                                  ? 1'b0 : //store
                     (opcode_md == 7'b0000011)                                                   ? 1'b1 : //load
                     (opcode_md == 7'b0010011)                                                   ? 1'b1 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 1'b1 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 1'b0 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 1'b1 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 1'b1 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 1'b1 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 1'b1 : //jalr
                                                                                                   1'b0;
                                                                                                   
    //mem_write can be reduced
    assign mem_write =(opcode_md == 7'b0100011)                                                  ? 1'b1 : //store
                     (opcode_md == 7'b0000011)                                                   ? 1'b0 : //load
                     (opcode_md == 7'b0010011)                                                   ? 1'b0 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 1'b0 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 1'b0 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 1'b0 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 1'b0 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 1'b0 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 1'b0 : //jalr
                                                                                                   1'b0;
      
                                                                                                   
    //alu_src can be reduced
    assign alu_src = (opcode_md == 7'b0100011)                                                   ? 1'b1 : //store
                     (opcode_md == 7'b0000011)                                                   ? 1'b1 : //load
                     (opcode_md == 7'b0010011)                                                   ? 1'b1 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 1'b0 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 1'b0 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 1'b1 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 1'b1 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 1'b1 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 1'b1 : //jalr
                                                                                                   1'b0;
         
                                                                                                   
    //result_src can be reduced
    assign result_src= (opcode_md == 7'b0100011)                                                 ? 2'b01 : //store
                     (opcode_md == 7'b0000011)                                                   ? 2'b01 : //load
                     (opcode_md == 7'b0010011)                                                   ? 2'b00 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 2'b00 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 2'b10 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 2'b00 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 2'b00 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 2'b10 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 2'b10 : //jalr
                                                                                                   2'b00;  
    //pc_src can be reduced                                                                                            
    assign pc_src =  (opcode_md == 7'b0100011)                                                   ? 2'b00 : //store
                     (opcode_md == 7'b0000011)                                                   ? 2'b00 : //load
                     (opcode_md == 7'b0010011)                                                   ? 2'b00 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 2'b00 : //R-type
                     //((opcode_md == 7'b1100011) && (branch_md))                  ? 2'b10 : //branch
                     (opcode_md == 7'b1100011)                                                   ? 2'b00 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 2'b00 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 2'b00 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 2'b10 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 2'b01 : //jalr
                                                                                                   2'b00;
                                                                                                   
    assign branch_op_md = (opcode_md == 7'b1100011) ? 1'b1 : 1'b0;
    
    //to seperate with ALU operations
    assign auipc_sel    = (opcode_md == 7'b0010111) ? 1'b1 : 1'b0;
    assign lui_sel      = (opcode_md == 7'b0110111) ? 1'b1 : 1'b0;
    
    //alu_op can be reduced
    assign alu_op =  (opcode_md == 7'b0100011)                                                   ? 2'b00 : //store
                     (opcode_md == 7'b0000011)                                                   ? 2'b00 : //load
                     (opcode_md == 7'b0010011)                                                   ? 2'b10 : //I-type
                     (opcode_md == 7'b0110011)                                                   ? 2'b10 : //R-type
                     (opcode_md == 7'b1100011)                                                   ? 2'b11 : //branch
                     (opcode_md == 7'b0110111)                                                   ? 2'b00 : //lui
                     (opcode_md == 7'b0010111)                                                   ? 2'b00 : //auipc
                     (opcode_md == 7'b1101111)                                                   ? 2'b00 : //jal
                     (opcode_md == 7'b1100111)                                                   ? 2'b00 : //jalr
                                                                                                   2'b00;  
                                                                                                   
                                                                                                    
    assign jump_op_md = ((opcode_md == 7'b1100111) || (opcode_md == 7'b1101111))                 ? 1'b1 : //jalr or jal
                                                                                                   1'b0;                                                                                      
                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
endmodule
