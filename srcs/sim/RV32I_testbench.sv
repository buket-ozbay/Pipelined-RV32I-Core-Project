`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Istanbul Technical University 
// Author: Buket Ozbay 
// Module Name: RV32I_testbench
// Project Name: RV32I Processor
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module RV32I_testbench;

    reg clk_c;
    reg rst_c;
    wire [31:0] out_c;


    RV32I_pipelined uut (
        .clk_c(clk_c),
        .rst_c(rst_c),
        .out_c(out_c)
    );

    always #50 clk_c = ~clk_c;

    integer file, golden_file, scan_file;
    
    reg [31:0] golden_address, golden_data;
    reg [31:0] reg_address, reg_data;
    reg [31:0] mem_address, mem_data;
    reg [31:0] cycle_count;

    initial begin

        $dumpfile("RV32I_testbench.vcd");
        $dumpvars(0, RV32I_testbench);

        clk_c = 0;
        rst_c = 0;
        cycle_count = 0;
        #100;
        rst_c = 1;

        file = $fopen("rv_track.txt", "w");
        if (file == 0) begin
            $display("Dosya acilamadi: rv_track.txt");
        end else begin
            $display("Dosya basariyla acildi: rv_track.txt");
        end
    end

    always @(posedge clk_c) begin
        
        cycle_count = cycle_count + 1;
        //$fwrite(file, "PC_Sel Out: %d // pc_plus4: %d, pc_target: %d, branch: %d, branch_op: %d \n", uut.pc_sel.out, uut.pc_sel.in0, uut.pc_sel.in2, uut.pc_sel.branch, uut.pc_sel.branch_op);
        //$fwrite(file, "ALU srcA: %d - srcB: %d // alu result: %d,result:%d, rs1:%d, rs2:%d, rd_m:%d, reg_write_w:%d, a3_rf:%d, reg_w_rf:%d, registers[a3_rf]:%d, registers[1]:%d\n", uut.srca_forward_c, uut.src_b_c, uut.alu_result_m, uut.result_c, uut.rs1_e, uut.rs2_e, uut.rd_m, uut.reg_write_w, uut.register_file.a3_rf, uut.register_file.reg_w, uut.register_file.registers[uut.register_file.a3_rf], uut.register_file.registers[32'd1]);
        if(uut.branch_op_e) begin //branch_op_e = predicted_branch_e olarak sürüldü (test ettikten sonra sil)
            //$fwrite(file, "BRANCH OP ---> predicted branch: %d | actual branch: %d \n",uut.predicted_branch_e, uut.branch_c);
        end
        
        if (uut.reg_write_w && (uut.rd_w != '0)) begin
            $fwrite(file, "Register Write - Address: %d, Data: %h\n", uut.rd_w, uut.result_c);
            reg_address = uut.rd_w;
            reg_data = uut.result_c;
            $fflush(file);
        end
        if (uut.mem_write_m == 1'b1) begin
            if(uut.funct3_m == 3'b000) begin
            $fwrite(file, "Memory Write - Address: %d, Data: %h\n", uut.alu_result_m, uut.data_memory.wd_dm[7:0]);
            mem_address = uut.alu_result_m;
            mem_data = uut.rd2_m;
            end
            if(uut.funct3_m == 3'b001) begin
            $fwrite(file, "Memory Write - Address: %d, Data: %h\n", uut.alu_result_m, uut.data_memory.wd_dm[15:0]);
            mem_address = uut.alu_result_m;
            mem_data = uut.rd2_m;
            end
            if(uut.funct3_m == 3'b010) begin
            $fwrite(file, "Memory Write - Address: %d, Data: %h\n", uut.alu_result_m, uut.data_memory.wd_dm);
            mem_address = uut.alu_result_m;
            mem_data = uut.rd2_m;
            end
            $fflush(file);
        end
        
        if ((!uut.reg_write_w && !uut.mem_write_m) || (uut.mem_write_m && (uut.alu_result_m == '0)) || (uut.reg_write_w && (uut.rd_w == '0))) begin
            $fwrite(file, "\n");
            $fflush(file);
        end
    end
   
    initial begin
        #100000;
        $fclose(file);
        $display("Test bitti.");
        $finish;
    end

endmodule