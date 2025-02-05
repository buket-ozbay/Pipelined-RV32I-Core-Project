module hazard_unit(
    input  logic [4:0] rs1_e,
    input  logic [4:0] rs2_e,
    input  logic reg_write_m,
    input  logic reg_write_w,
    input  logic reg_write_b,
    input  logic [4:0] rd_m,
    input  logic [4:0] rd_w,
    input  logic [4:0] rd_b,
    input  logic [2:0] result_src_hu,
    input  logic branch_hu,
    input  logic branch_op_hu,
    input  logic jump_op_hu,
    
    output logic [1:0] forward_ae,
    output logic [1:0] forward_be,
    output logic flush
    );
    
    // Flushing
    assign flush = (branch_op_hu && branch_hu) || jump_op_hu;  //branch and jump operations are got in the execute stage, no need to flush seperation.
    
    // RS1 Forwarding
    always_comb begin
        if (((rs1_e == rd_m) && reg_write_m) && (rs1_e != 5'd0))
            forward_ae = 2'b10;
        else if (((rs1_e == rd_w) && reg_write_w) && (rs1_e != 5'd0))
            forward_ae = 2'b01;
        else if (((rs1_e == rd_b) && reg_write_b) && (rs1_e != 5'd0))
            forward_ae = 2'b11;
        else
            forward_ae = 2'b00;
    end

    // RS2 Forwarding
    always_comb begin
        if (((rs2_e == rd_m) && reg_write_m) && (rs2_e != 5'd0))
            forward_be = 2'b10;
        else if (((rs2_e == rd_w) && reg_write_w) && (rs2_e != 5'd0))
            forward_be = 2'b01;
        else if (((rs2_e == rd_b) && reg_write_b) && (rs2_e != 5'd0))
            forward_be = 2'b11;
        else
            forward_be = 2'b00;
    end

endmodule
