`timescale 1ns / 1ps


module immediate_extender(
    input  logic [31:0] instruction_ie,
    input  logic [2:0]  imm_src_ie,
    output logic [31:0] immediate32_ie
    );
    
    
    assign immediate32_ie = (imm_src_ie == 3'b000)? {{20{instruction_ie[31]}}, instruction_ie[31:20]}:  //I-type, JALR is included here.
					        (imm_src_ie == 3'b001)? {{20{instruction_ie[31]}}, instruction_ie[31:25], instruction_ie[11:7]}:  //S-type
					        (imm_src_ie == 3'b010)? {{20{instruction_ie[31]}},instruction_ie[7],instruction_ie[30:25],instruction_ie[11:8],1'b0}: //B-type
					        (imm_src_ie == 3'b011)? {instruction_ie[31:12], 12'b0}: //U-type
					        (imm_src_ie == 3'b100)? {{12{instruction_ie[31]}},instruction_ie[19:12],instruction_ie[20],instruction_ie[30:25],instruction_ie[24:21],1'b0}://{{(11) {j_imm[20]}}, j_imm[20:0]}:  //J-type
					        (imm_src_ie == 3'b101)? {27'b000000000000000000000000000, instruction_ie[24:20]}:
					        32'h00000000;
endmodule
