`timescale 1 ps/1 ps

module seq_ckt_tb;

reg clk;
wire [2:0]Y;
reg  [2:0]exp_out = 0;

seq_block_verilog dut (clk, Y);

reg [2:0] str[5:0]; //6,3,5,7,2,1



integer i = 0;
integer fw;
reg   flag = 1;

initial begin

	str[0] = 6;
	str[1] = 3;
	str[2] = 5;
	str[3] = 7;
	str[4] = 2;
	str[5] = 1;

end

always begin

	clk = 0; #100;
	clk = 1; #100;

end

always @ (posedge clk) begin
	
	exp_out = str[i];
	
	if (i == 5)
		i = 0;
	else
		i = i + 1;

end

always begin

	#50;

	if(Y !== exp_out) begin
		flag = 0;
	end
		
end

always begin

	#4000;
	
	if(flag == 0) begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw, "%02h","Errors");
		$display("Error(s) encountered, please check your design!");
		$fclose(fw);
	end
	else begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw, "%02h","No Errors");
		$display("No errors encountered, congratulations!");
		$fclose(fw);
	end
		
end

endmodule