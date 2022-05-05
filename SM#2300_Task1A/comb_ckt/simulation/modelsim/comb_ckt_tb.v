`timescale 1 ps/1 ps

module comb_ckt_tb;


reg	[3:0] A;
reg	[3:0] B;
reg	C;
reg	D;
reg	E;
reg	F;
reg	S1;
reg	S0;
wire	Y;

reg   exp_out;

comb_ckt_verilog dut(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .S1(S1), .S0(S0), .Y(Y));

reg [13:0] ip[15:0]; //16 inputs, each 14 bits
reg 		  op[15:0]; //16 outputs, each 1 bit

reg   flag = 1;
integer fw;
integer i = 0;

initial begin

	ip[0]  = 14'b01101110011100; op[0]  = 1;
	ip[1]  = 14'b00000001000001; op[1]  = 1;
	ip[2]  = 14'b01001100000010; op[2]  = 0;
	ip[3]  = 14'b11110011000011; op[3]  = 1;
	ip[4]  = 14'b10100101100100; op[4]  = 0;
	ip[5]  = 14'b01100011000101; op[5]  = 0;
	ip[6]  = 14'b01100111000110; op[6]  = 0;
	ip[7]  = 14'b00110010000111; op[7]  = 1;
	ip[8]  = 14'b11000011101000; op[8]  = 0;
	ip[9]  = 14'b11101111001001; op[9]  = 1;
	ip[10] = 14'b11001100001010; op[10] = 1;
	ip[11] = 14'b10111011001011; op[11] = 0;
	ip[12] = 14'b00111011110000; op[12] = 1;
	ip[13] = 14'b10111010001101; op[13] = 0;
	ip[14] = 14'b11011101001110; op[14] = 1;
	ip[15] = 14'b01001000001111; op[15] = 0;

end

always begin

	A <= ip[i][13:10];
	B <= ip[i][9:6];
	C <= ip[i][5];
	D <= ip[i][4];
	E <= ip[i][3];
	F <= ip[i][2];
	S1<= ip[i][1];
	S0<= ip[i][0];
	
	exp_out <= op[i];
	
	if (i == 15)
		i = 0;
	else
		i = i + 1;
		
	#100;

end

always begin

	#50;

	if(Y !== exp_out) begin
		flag = 0;
	end
		
end

always begin

	#1800;
	
	if(flag == 0) begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"%02h","Errors");
		$display("Error(s) encountered, please check your design!");
		$fclose(fw);
	end
	else begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"%02h","No Errors");
		$display("No errors encountered, congratulations!");
		$fclose(fw);
	end
		
end

endmodule

