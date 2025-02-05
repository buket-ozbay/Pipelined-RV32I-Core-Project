`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Istanbul Technical University 
// Author: Buket Ozbay 
// Module Name: RV32I_pipelined
// Project Name: RV32I Processor
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module RV32I_pipelined#(parameter N=32, L_imem=256, L_dmem=64)
    (
    input  logic clk_c,
    input  logic rst_c,
    output logic [31:0] out_c
    );
    
    //////hazard handling
    wire [1:0] forward_ae, forward_be;
    wire [31:0] srca_forward_c, srcb_forward_c;
    wire flush_c;
    
    /////fetch
    wire [31:0] pc, pc_next_c,pc_target_c,pc_plus4_c,pc_jalr_c,pc_auipc_lui_c;
    wire [31:0] instruction_c;
    wire predicted_branch;
    
    /////fetch-decode stage
    wire [31:0] pc_plus4_d, pc_d;
    wire [31:0] instruction_d;
    wire [31:0] instruction_e;
    
    /////decode
    wire branch_op_c,branch_c;
    wire [1:0]pc_src_c;
    wire [1:0]result_src_c;
    wire [4:0]alu_control_c;
    wire [1:0]alu_op_c;
    wire [2:0]imm_src_c;
    wire alu_src_c;
    wire reg_write_c;
    wire mem_write_c;
    wire auipc_sel_c;
    wire lui_sel_c;
    wire [4:0]rs1_c;
    wire [4:0]rs2_c;
    wire [31:0] rd1_c, rd2_c;
    wire [6:0]funct7_c;
    wire [2:0]funct3_c;
    wire [6:0]opcode_c;
    wire [31:0]immediate32_c;
    wire jump_op_c;
    wire predicted_branch_d;
    
    //decode-execute stage
    wire [31:0] pc_e;
    wire [31:0] pc_plus4_e;
    wire branch_op_e;
    wire [31:0] immediate32_e;
    wire auipc_sel_e;
    wire lui_sel_e;
    wire [31:0] rd1_e, rd2_e;
    wire [4:0] rs1_e, rs2_e, rd_e;
    wire [2:0] funct3_e;
    wire [6:0] funct7_e;
    wire [1:0] result_src_e;
    wire mem_write_e, reg_write_e;
    wire [4:0] alu_control_e;
    wire [1:0] alu_op_e;
    wire alu_src_e;
    wire [1:0] pc_src_e;
    wire predicted_branch_e;
    wire jump_op_e;
    
    /////execute
    wire [31:0] src_b_c;
    wire [31:0] result_c, alu_result_c;
    
    /////execute-memory stage
    wire [31:0] pc_plus4_m;
    wire [31:0] alu_result_m;
    wire reg_write_m, mem_write_m;
    wire [1:0] result_src_m;
    wire [4:0] rd_m;
    wire [31:0] rd2_m;
    wire [2:0] funct3_m;
    wire [31:0] srcb_forward_m;
    
    /////memory
    wire [4:0]rd_c;
    wire [31:0]read_data_c;
    
    ////memory-writeback stage
    wire [31:0] read_data_w;
    wire [31:0] alu_result_w;
    wire [31:0] pc_plus4_w;
    wire [4:0] rd_w;
    wire [1:0] result_src_w;
    wire reg_write_w;
    
    ////writeback-branch stage
    wire [4:0] rd_b;
    wire reg_write_b;
    wire [31:0] result_b;
    
    
    hazard_unit hazard_unit(
    //inputs
    .rs1_e(rs1_e),
    .rs2_e(rs2_e),
    .reg_write_m(reg_write_m),
    .reg_write_w(reg_write_w),
    .reg_write_b(reg_write_b),
    .rd_m(rd_m),
    .rd_w(rd_w),
    .rd_b(rd_b),
    .branch_hu(branch_c),
    .branch_op_hu(branch_op_e),
    .jump_op_hu(jump_op_e),
    //outputs
    .forward_ae(forward_ae),
    .forward_be(forward_be),
    .flush(flush_c)
    );
    
    
//    branch_predictor global_bp(
//    .clk_bp(clk_c),
//    .rst_bp(rst_c),
//    .branch(branch_c),                    //actual decision
//    .branch_op(branch_op_e),              //emphasizing it is a branch instruction
//    .branch_direction_pred(predicted_branch) 
//    );


    //pc cycling
    program_counter program_counter(
    .clk_pc(clk_c),
    .rst_pc(rst_c),
    .pc_next(pc_next_c),
    .program_counter(pc)
    );
    
    
    //pc -> pc+4
    pc_plus4 pc_p4(
    .pc_pp(pc),
    .pc_plus4(pc_plus4_c)
    );
    
    
    //for branch jump operations
    pc_target pc_target(
    .pc_pt(pc_e),
    .auipc_sel_pt(auipc_sel_e),
    .rd1_pt(rd1_e),
    .immediate32_pt(immediate32_e), 
    .pc_target(pc_target_c),
    .pc_auipc_lui(pc_auipc_lui_c),
    .pc_jalr(pc_jalr_c)
    );
    
    
    //selects the program counter value according to the instruction type
    mux3x1 #(32) pc_sel(
    .sel(pc_src_e),
    .in0(pc_plus4_c),
    .in2(pc_target_c),
    .in1(pc_jalr_c),
    .branch(branch_c),
    .branch_op(branch_op_e),
    .out(pc_next_c)
    );
    
    
    instruction_memory #(256) instruction_memory(
    .pc_im(pc), 
    .instruction_im(instruction_c)
    );
    
    
    fetch_decode fd_stage(
    //inputs
    .clk(clk_c),
    .rst(rst_c),
    .pc_f(pc),
    .pc_plus4_f(pc_plus4_c),
    .instruction_f(instruction_c),
    .predicted_branch_f(predicted_branch),
    //outputs
    .flush_f(flush_c),
    .pc_d(pc_d),
    .pc_plus4_d(pc_plus4_d),
    .instruction_d(instruction_d),
    .predicted_branch_d(predicted_branch_d)
    );

    
    pre_decoder pre_decoder(
    .instruction_pd(instruction_d),
    .opcode_pd(opcode_c),
    .funct3_pd(funct3_c),
    .funct7_pd(funct7_c),
    .rs1_pd(rs1_c),
    .rs2_pd(rs2_c),
    .rd_pd(rd_c)
    );
    
    
    main_decoder main_decoder(
    .clk_md(clk_c),
    .rst_md(rst_c),
    .opcode_md(opcode_c),
    .funct3_md(funct3_c),
    .branch_md(branch_c),
    .pc_src(pc_src_c),
    .branch_op_md(branch_op_c),
    .jump_op_md(jump_op_c),
    .result_src(result_src_c),
    .alu_op(alu_op_c),
    .alu_src(alu_src_c),
    .imm_src(imm_src_c),
    .reg_write(reg_write_c),
    .mem_write(mem_write_c),
    .auipc_sel(auipc_sel_c),
    .lui_sel(lui_sel_c)
    );
    
    
    immediate_extender immediate_extender(
    .imm_src_ie(imm_src_c),
    .instruction_ie(instruction_d),
    .immediate32_ie(immediate32_c)
    );
    

    register_file register_file(
    .clk_rf(clk_c),
    .rst_rf(rst_c),
    .a1_rf(rs1_c),
    .a2_rf(rs2_c),
    .a3_rf(rd_w),
    .wd3_rf(result_c),
    .we3_rf(reg_write_w),
    .rd1_rf(rd1_c),
    .rd2_rf(rd2_c)
    );  
    
    
    //to seperate ALU operations
    alu_decoder alu_decoder(
    .op_5(opcode_c[5]),
    .funct3_ad(funct3_c),
    .funct7_5_ad(funct7_c[5]),
    .alu_op_ad(alu_op_c),
    .alu_control(alu_control_c)
    );
    
    
    //decode-execute stage
    decode_execute de_stage(
    //inputs
    .clk(clk_c),
    .rst(rst_c),
    .pc_d(pc_d),
    .pc_plus4_d(pc_plus4_d),
    .branch_op_d(branch_op_c),
    .jump_op_d(jump_op_c),
    .immediate32_d(immediate32_c),
    .instruction_d(instruction_d),
    .auipc_sel_d(auipc_sel_c),
    .lui_sel_d(lui_sel_c),
    .rs1_d(rs1_c),
    .rs2_d(rs2_c),
    .rd_d(rd_c),
    .rd1_d(rd1_c),
    .rd2_d(rd2_c),
    .result_src_d(result_src_c),
    .mem_write_d(mem_write_c),
    .reg_write_d(reg_write_c),
    .alu_src_d(alu_src_c),
    .alu_control_d(alu_control_c),
    .funct3_d(funct3_c),
    .funct7_d(funct7_c),
    .alu_op_d(alu_op_c),
    .flush_d(flush_c),
    .pc_src_d(pc_src_c),
    .predicted_branch_d(predicted_branch_d),
    //outputs 
    .pc_e(pc_e),
    .pc_plus4_e(pc_plus4_e),
    .branch_op_e(branch_op_e),
    .jump_op_e(jump_op_e),
    .immediate32_e(immediate32_e),
    .instruction_e(instruction_e),
    .auipc_sel_e(auipc_sel_e),
    .lui_sel_e(lui_sel_e),
    .rd1_e(rd1_e),
    .rd2_e(rd2_e),
    .rs1_e(rs1_e),
    .rs2_e(rs2_e),
    .rd_e(rd_e),
    .alu_src_e(alu_src_e),
    .result_src_e(result_src_e),
    .mem_write_e(mem_write_e),
    .reg_write_e(reg_write_e),
    .alu_control_e(alu_control_e),
    .funct3_e(funct3_e),
    .funct7_e(funct7_e),
    .alu_op_e(alu_op_e),
    .pc_src_e(pc_src_e),
    .predicted_branch_e(predicted_branch_e)
    );
    
    
    //selects forwarded data for rd1
    branch_src_mux #(32) forward_rd1_sel(
    .sel(forward_ae),
    .in0(rd1_e),
    .in1(result_c),
    .in2(alu_result_m),
    .in3(result_b),
    .out(srca_forward_c)//determined in the execute stage
    );
    
    
    //selects forwarded data for rd2
    branch_src_mux #(32) forward_rd2_sel(
    .sel(forward_be),
    .in0(rd2_e),
    .in1(result_c),
    .in2(alu_result_m),
    .in3(result_b),
    .out(srcb_forward_c)//determined in the execute stage
    );
     
    
    //selects the whether immediate or rd2 as the input src_b of ALU
    mux2x1 #(32) srcb_sel(
    .sel(alu_src_e),
    .in1(srcb_forward_c),
    .in0(immediate32_e),
    .out(src_b_c)
    );
 
    
    //arithmetic logic unit
    alu alu(
    .branch_op(branch_op_e),
    .alu_control(alu_control_e),
    .pc_auipc_lui(pc_auipc_lui_c),
    .auipc_sel(auipc_sel_e),
    .lui_sel(lui_sel_e),
    .src_a(srca_forward_c),
    .src_b(src_b_c),
    .alu_result(alu_result_c),
    .branch(branch_c)
    );
    
    
    //execute-memory stage
    execute_memory em_stage(
    //inputs
    .clk(clk_c),
    .rst(rst_c),
    .pc_plus4_e(pc_plus4_e),
    .reg_write_e(reg_write_e),
    .mem_write_e(mem_write_e),
    .result_src_e(result_src_e),
    .alu_result_e(alu_result_c),
    .rd_e(rd_e),
    .rd2_e(rd2_e),
    .funct3_e(funct3_e),
    .srcb_forward_e(srcb_forward_c),
    //outputs
    .pc_plus4_m(pc_plus4_m),
    .reg_write_m(reg_write_m),
    .mem_write_m(mem_write_m),
    .result_src_m(result_src_m),
    .alu_result_m(alu_result_m),
    .rd_m(rd_m),
    .rd2_m(rd2_m),
    .funct3_m(funct3_m),
    .srcb_forward_m(srcb_forward_m)
    );
    
    
    data_memory #(64)
    data_memory(
    .rst_dm(rst_c),
    .clk_dm(clk_c),
    .mem_bit_sel(funct3_m),
    .we_dm(mem_write_m),
    .a_dm(alu_result_m),
    .wd_dm(srcb_forward_m),
    .rd_dm(read_data_c)
    );
   
   
   //memory-writeback stage
    memory_writeback mw_stage(
    .clk(clk_c),
    .rst(rst_c),
    .read_data_m(read_data_c),
    .rd_m(rd_m),
    .pc_plus4_m(pc_plus4_m),
    .result_src_m(result_src_m),
    .reg_write_m(reg_write_m),
    .alu_result_m(alu_result_m),
    //outputs
    .read_data_w(read_data_w),
    .rd_w(rd_w),
    .pc_plus4_w(pc_plus4_w),
    .result_src_w(result_src_w),
    .reg_write_w(reg_write_w),
    .alu_result_w(alu_result_w)
    );
   
   
    //selects which data will be written to RF
    writeback_sel #(32) wb_sel(
    .sel(result_src_w),
    .in0(alu_result_w),
    .in1(read_data_w),
    .in2(pc_plus4_w),
    .out(result_c)
    );
    
    
    //writeback-branch stage
    writeback_branch wb_stage(
    //inputs
    .clk(clk_c),
    .rst(rst_c),
    .rd_w(rd_w),
    .reg_write_w(reg_write_w),
    .result_w(result_c),
    //outputs
    .rd_b(rd_b),
    .reg_write_b(reg_write_b),
    .result_b(result_b)
    );
    
    assign out_c = result_c;
endmodule
