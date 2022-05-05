`timescale 1 ps/1 ps

module fsm_tb;

reg clk;
reg [3:0]in;

wire y;
reg  exp_out = 0;

fsm dut(clk, in, y);

reg [3:0] str[19:0];

localparam [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

integer i = 0; 
integer fw;
reg   flag = 1;
reg [2:0] j = 3'b000;


initial begin

	str[0]  = 7;
	str[1]  = 5;
	str[2]  = 1;
	str[3]  = 0;
	str[4]  = 9;
	str[5]  = 4;
	str[6]  = 1;
	str[7]  = 0;
	str[8]  = 9;
	str[9]  = 4;
	str[10] = 3;
	str[11] = 1;
	str[12] = 0;
	str[13] = 9;
	str[14] = 2;
	str[15] = 1;
	str[16] = 0;
	str[17] = 9;
	str[18] = 4;
	str[19] = 8;

end

always begin

	clk = 0; #100;
	clk = 1; #100;

end

always @ (negedge clk) begin

	in = str[i];
	
	if (i == 19)
		i = 0;
	else
		i = i + 1;
		
end

always @ (posedge clk) begin

	case (j)
	
		S0 : begin
		
			if(in == 1)
				j = S1;
			else
				j = S0;
				
			exp_out = 0;
		
		end
		
		S1 : begin
		
			if(in == 0)
				j = S2;
			else if(in == 1)
				j = S1;
			else
				j = S0;
				
			exp_out = 0;
		
		end
		
		S2 : begin
		
			if(in == 9)
				j = S3;
			else if(in == 1)
				j = S1;
			else
				j = S0;
				
			exp_out = 0;
		
		end
		
		S3 : begin
		
			if(in == 4) begin
				j = S4;
				exp_out = 1;
			end
			else if(in == 1)
				j = S1;
			else
				j = S0;
				
		
		end
		
		S4 : begin
		
			if(in == 1)
				j = S1;
			else
				j = S0;
				
			exp_out = 0;
		
		end
	
	endcase

end

always begin

	#50;

	if(y !== exp_out) begin
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
