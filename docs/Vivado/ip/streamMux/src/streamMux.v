	module streamMux (
		input wire [31:0] s0_tdata, s1_tdata, s2_tdata, s3_tdata,
		input wire s0_tlast, s1_tlast, s2_tlast, s3_tlast, s0_tvalid, s1_tvalid, s2_tvalid, s3_tvalid,
		input wire m_tready,
		input wire [1:0] Sel,
		output wire [31:0] m_tdata,
		output wire m_tlast, m_tvalid,
		output wire s0_tready, s1_tready, s2_tready, s3_tready,
		input wire m_aclk, s0_aclk, s1_aclk, s2_aclk, s3_aclk
	);

	assign m_tdata = (Sel==2'b00) ? s0_tdata : (Sel==2'b01) ? s1_tdata : (Sel==2'b10) ? s2_tdata : s3_tdata;
	assign m_tlast = (Sel==2'b00) ? s0_tlast : (Sel==2'b01) ? s1_tlast : (Sel==2'b10) ? s2_tlast : s3_tlast;
	assign m_tvalid = (Sel==2'b00) ? s0_tvalid : (Sel==2'b01) ? s1_tvalid : (Sel==2'b10) ? s2_tvalid : s3_tvalid;

	assign s0_tready = (Sel==2'b00) ? m_tready : 0;
	assign s1_tready = (Sel==2'b01) ? m_tready : 0;
	assign s2_tready = (Sel==2'b10) ? m_tready : 0;
	assign s3_tready = (Sel==2'b11) ? m_tready : 0;

endmodule
