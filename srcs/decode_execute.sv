`timescale 1ns / 1ps


module decode_execute(
    //inputs
    input  logic          clk,
    input  logic          rst,
    input  logic   [31:0] pc_d,
    input  logic   [31:0] pc_plus4_d,
    input  logic   [31:0] instruction_d,
    //input  logic   [31:0] pc_target_d,
    //input  logic   [31:0] pc_next_d,
    input  logic          branch_op_d,
    input  logic   [31:0] immediate32_d,
    input  logic          auipc_sel_d,
    input  logic          lui_sel_d,
    input  logic          jump_op_d,
    input  logic   [31:0] rd1_d,
    input  logic   [31:0] rd2_d,
    input  logic   [4:0]  rs1_d,
    input  logic   [4:0]  rs2_d,
    input  logic   [4:0]  rd_d,
    input  logic          alu_src_d,
    input  logic   [1:0]  result_src_d,
    input  logic          mem_write_d,
    input  logic          reg_write_d,
    input  logic   [4:0]  alu_control_d,
    input  logic   [2:0]  funct3_d,
    input  logic   [6:0]  funct7_d,
    input  logic   [1:0]  alu_op_d,
    input  logic   [1:0]  pc_src_d,
    input  logic          flush_d,
    input  logic   [31:0] srca_forward_branch_d,
    input  logic   [31:0] srcb_forward_branch_d,
    input  logic          predicted_branch_d,
    
    //outputs 
    output  logic   [31:0] pc_e,
    output  logic   [31:0] pc_plus4_e,
    //output  logic   [31:0] pc_target_e,
    //output  logic   [31:0] pc_next_e,
    output  logic          branch_op_e,
    output  logic   [31:0] immediate32_e,
    output  logic   [31:0] instruction_e,
    output  logic          auipc_sel_e,
    output  logic          lui_sel_e,
    output  logic          jump_op_e,
    output  logic   [31:0] rd1_e,
    output  logic   [31:0] rd2_e,
    output  logic   [4:0]  rs1_e,
    output  logic   [4:0]  rs2_e,
    output  logic   [4:0]  rd_e,
    output  logic          alu_src_e,
    output  logic   [1:0]  result_src_e,
    output  logic          mem_write_e,
    output  logic          reg_write_e,
    output  logic   [4:0]  alu_control_e,
    output  logic   [2:0]  funct3_e,
    output  logic   [6:0]  funct7_e,
    output  logic   [1:0]  alu_op_e,
    output  logic   [1:0]  pc_src_e,
    output  logic   [31:0] srca_forward_branch_e,
    output  logic   [31:0] srcb_forward_branch_e,
    output  logic          predicted_branch_e
    );
    
    always_ff @(posedge clk or negedge rst)
        begin
            if(!rst || flush_d)
                begin
                    pc_e <= 32'd0;
                    pc_plus4_e <= 32'd0;
                    //pc_target_e <= 32'd0;
                    //pc_next_e <= 32'd0;
                    immediate32_e <= 32'd0;
                    rd1_e <= 32'd0;
                    rd2_e <= 32'd0;
                    alu_src_e <= 1'b0;
                    result_src_e <= 2'd0;
                    mem_write_e <= 1'b0;
                    reg_write_e <= 1'b0;
                    alu_control_e <= 5'd0;
                    funct3_e <= 3'd0;
                    funct7_e <= 7'd0;
                    branch_op_e <= 1'b0;
                    alu_op_e <= 2'd0;
                    rs1_e <= 5'd0;
                    rs2_e <= 5'd0;
                    rd_e <= 5'd0;
                    auipc_sel_e <= 1'b0;
                    lui_sel_e   <= 1'b0;
                    jump_op_e   <= 1'b0;
                    pc_src_e <= 2'd0;
                    srca_forward_branch_e <= 32'd0;
                    srcb_forward_branch_e <= 32'd0;
                    predicted_branch_e <= 32'd0;
                    instruction_e <= 32'd0;
                end
            else
                begin
                    pc_e <= pc_d;
                    pc_plus4_e <= pc_plus4_d;
                    //pc_target_e <= pc_target_d;
                    //pc_next_e <= pc_next_d;
                    immediate32_e <= immediate32_d;
                    rd1_e <= rd1_d;
                    rd2_e <= rd2_d;
                    alu_src_e <= alu_src_d;
                    result_src_e <= result_src_d;
                    mem_write_e <= mem_write_d;
                    reg_write_e <= reg_write_d;
                    alu_control_e <= alu_control_d;
                    funct3_e <= funct3_d;
                    funct7_e <= funct7_d;
                    branch_op_e <= branch_op_d;
                    alu_op_e <= alu_op_d;
                    rs1_e <= rs1_d;
                    rs2_e <= rs2_d;
                    rd_e <= rd_d;
                    auipc_sel_e <= auipc_sel_d;
                    lui_sel_e <= lui_sel_d;
                    jump_op_e   <= jump_op_d;
                    pc_src_e <= pc_src_d;
                    srca_forward_branch_e <= srca_forward_branch_d;
                    srcb_forward_branch_e <= srcb_forward_branch_d;
                    predicted_branch_e <= predicted_branch_d;
                    instruction_e <= instruction_d;
                end
        end
endmodule
