`timescale 1ps/1ps

module tb;

	reg clk = 0;
	wire tx;	
	reg tx_exp;
	reg check = 0;
	wire time_err;
	reg flag  = 1;

	uart uut (.clk_50M(clk), .tx(tx));

	integer fd;
	integer fw;
	integer j = 0;
	

	reg [(8*45) - 1:0]str; //45 chars can be stored
	
	assign #(1,1) time_err = tx ^ tx_exp;

	initial begin
	
		fd = $fopen("dumpout_py.txt","r");

		while(! $feof(fd)) begin

			$fgets(str, fd);

			if(str != 0) begin
				
				tx_exp = str[15:8] - 48;
				
				#8680000;

			end

		end


		$fclose(fd);

	end
	
	always begin
	
		clk = ~clk; #10000;
	
	end
	
	always begin
		
		if(j == 0) begin
			j = 1;
			#4340000;
		end
		else
			#8680000;
		
		if(tx_exp === tx) begin
			check = 0;
		end
		else begin
			check = 1;
			flag  = 0;
			#1;
			check = 0;
		end
	
	end
	
	always begin
	
		#660000000;
		
		fw = $fopen("result.txt","w");
	
		if(flag == 1) begin
			$fdisplay(fw,"%02h","No Errors");
			$display("No errors encountered, congratulations!");
		end
		else begin
			$fdisplay(fw,"%02h","Errors");
			$display("Error(s) encountered, please check your design!");
		end
		
		$fclose(fw);
	
	end


endmodule