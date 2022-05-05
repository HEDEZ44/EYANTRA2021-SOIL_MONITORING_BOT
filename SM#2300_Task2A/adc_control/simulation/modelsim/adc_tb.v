`timescale 1ps/1ps

module adc_tb;

reg  clk_50;
wire adc_cs_n;
wire [1:0]data_frame;
wire adc_sck;
reg adc_sck_exp = 0;
wire din;
reg din_exp = 0;
reg  dout = 0;
wire [11:0]d_out_ch5;
reg [11:0]d_out_ch5_exp = 0;
wire [11:0]d_out_ch6;
reg [11:0]d_out_ch6_exp = 0;
wire [11:0]d_out_ch7;
reg [11:0]d_out_ch7_exp = 0;

reg flag_adc_sck = 1;
reg flag_din = 1;
reg flag_ch5 = 1;
reg flag_ch6 = 1;
reg flag_ch7 = 1;

integer i = 10;
integer j = 0;
integer fw;

reg dout_mem[50:0];
reg din_mem[50:0];


adc_control dut (.clk_50(clk_50), .dout(dout), .adc_cs_n(adc_cs_n),
					  .din(din), .adc_sck(adc_sck), .d_out_ch5(d_out_ch5),
					  .d_out_ch6(d_out_ch6), .d_out_ch7(d_out_ch7), .data_frame(data_frame)
);

	
always @ (negedge clk_50) begin

	if(i != 0)
		i <= i - 1;
	else begin
		i <= 9; //9
		adc_sck_exp <= adc_sck_exp ? 1'b0: 1'b1;
	end

end

initial begin
	
	#12800000; d_out_ch5_exp = 1118;

end

initial begin
	
	#19200000; d_out_ch6_exp = 1998;

end

initial begin
	
	#6400000; d_out_ch7_exp = 3802;

end

initial begin

	dout_mem[0]  <= 0;dout_mem[1]  <= 0;dout_mem[2]  <= 0;dout_mem[3]  <= 0;dout_mem[4]  <= 1;
	dout_mem[5]  <= 1;dout_mem[6]  <= 1;dout_mem[7]  <= 0;dout_mem[8]  <= 1;dout_mem[9]  <= 1;
	dout_mem[10] <= 0;dout_mem[11] <= 1;dout_mem[12] <= 1;dout_mem[13] <= 0;dout_mem[14] <= 1;
	dout_mem[15] <= 0;dout_mem[16] <= 0;dout_mem[17] <= 0;dout_mem[18] <= 0;dout_mem[19] <= 0;
	dout_mem[20] <= 0;dout_mem[21] <= 1;dout_mem[22] <= 0;dout_mem[23] <= 0;dout_mem[24] <= 0;
	dout_mem[25] <= 1;dout_mem[26] <= 0;dout_mem[27] <= 1;dout_mem[28] <= 1;dout_mem[29] <= 1;
	dout_mem[30] <= 1;dout_mem[31] <= 0;dout_mem[32] <= 0;dout_mem[33] <= 0;dout_mem[34] <= 0;
	dout_mem[35] <= 0;dout_mem[36] <= 0;dout_mem[37] <= 1;dout_mem[38] <= 1;dout_mem[39] <= 1;
	dout_mem[40] <= 1;dout_mem[41] <= 1;dout_mem[42] <= 0;dout_mem[43] <= 0;dout_mem[44] <= 1;
	dout_mem[45] <= 1;dout_mem[46] <= 1;dout_mem[47] <= 0;dout_mem[48] <= 0;dout_mem[49] <= 0;
	dout_mem[50] <= 0;

end

initial begin

	din_mem[0]  <= 0;din_mem[1]  <= 0;din_mem[2]  <= 1;din_mem[3]  <= 0;din_mem[4]  <= 1;
	din_mem[5]  <= 0;din_mem[6]  <= 0;din_mem[7]  <= 0;din_mem[8]  <= 0;din_mem[9]  <= 0;
	din_mem[10] <= 0;din_mem[11] <= 0;din_mem[12] <= 0;din_mem[13] <= 0;din_mem[14] <= 0;
	din_mem[15] <= 0;din_mem[16] <= 0;din_mem[17] <= 0;din_mem[18] <= 1;din_mem[19] <= 1;
	din_mem[20] <= 0;din_mem[21] <= 0;din_mem[22] <= 0;din_mem[23] <= 0;din_mem[24] <= 0;
	din_mem[25] <= 0;din_mem[26] <= 0;din_mem[27] <= 0;din_mem[28] <= 0;din_mem[29] <= 0;
	din_mem[30] <= 0;din_mem[31] <= 0;din_mem[32] <= 0;din_mem[33] <= 0;din_mem[34] <= 1;
	din_mem[35] <= 1;din_mem[36] <= 1;din_mem[37] <= 0;din_mem[38] <= 0;din_mem[39] <= 0;
	din_mem[40] <= 0;din_mem[41] <= 0;din_mem[42] <= 0;din_mem[43] <= 0;din_mem[44] <= 0;
	din_mem[45] <= 0;din_mem[46] <= 0;din_mem[47] <= 0;din_mem[48] <= 0;din_mem[49] <= 0;
	din_mem[50] <= 1;

end

always begin
	
	clk_50 = 0; #10000;
	clk_50 = 1; #10000;
	
end

always @ (negedge adc_sck_exp) begin
	
	#1;
	
	dout = dout_mem[j];
	din_exp = din_mem[j];
	
	if (j == 50)
		j = 0;
	else
		j = j + 1;

end

always @ (negedge clk_50) begin

	#5000;
	
	if(adc_sck !== adc_sck_exp) begin
		flag_adc_sck = 0;
	end
	if(din !== din_exp) begin
		flag_din = 0;
	end
	if(d_out_ch5 !== d_out_ch5_exp) begin
		flag_ch5 = 0;
	end
	if(d_out_ch6 !== d_out_ch6_exp) begin
		flag_ch6 = 0;
	end
	if(d_out_ch7 !== d_out_ch7_exp) begin
		flag_ch7 = 0;
	end	

end

always begin

	#20000000;
	
	if(flag_adc_sck == 0 || flag_din == 0 || flag_ch5 == 0 || flag_ch6 == 0 || flag_ch7 == 0) begin
		
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"%02h","Errors");
		$fclose(fw);
		
		if(flag_adc_sck == 0)
			$display("ERROR : Check \"adc_sck\"");
		if(flag_din == 0)
			$display("ERROR : Check \"din\"");
		if(flag_ch5 == 0)
			$display("ERROR : Check \"d_out_ch5\"");
		if(flag_ch6 == 0)
			$display("ERROR : Check \"d_out_ch6\"");
		if(flag_ch7 == 0)
			$display("ERROR : Check \"d_out_ch7\"");
		
	end
	else begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"%02h","No Errors");
		$display("No errors encountered, congratulations!");
		$fclose(fw);
	end
		
end

endmodule