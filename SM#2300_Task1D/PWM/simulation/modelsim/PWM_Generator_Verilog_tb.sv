`timescale 1ns/1ns

module PWM_Generator_Verilog_tb;

logic clk;
logic [7:0] DUTY_CYCLE;
logic PWM_OUT;
logic Expected_PWM_OUT;
logic [7:0]error_count;
logic error;

logic [5:0]i;


integer file_id;

PWM_Generator i1 (  
	.DUTY_CYCLE(DUTY_CYCLE),
	.PWM_OUT(PWM_OUT),
	.clk(clk)
);

always
	begin
		clk = 1; #10;
		clk = 0; #10;
	end

initial
	begin
	i = 0;
	error = 0;
	error_count = 0;
end

always@(posedge clk)
begin
	DUTY_CYCLE[7:0] = 8'd50; i = 1; #1000;
	DUTY_CYCLE[7:0] = 8'd10; i = 2; #1000;
	DUTY_CYCLE[7:0] = 8'd90; i = 3; #1000;
	DUTY_CYCLE[7:0] = 8'd80; i = 4; #1000;
	DUTY_CYCLE[7:0] = 8'd20; i = 5; #1000;
	DUTY_CYCLE[7:0] = 8'd30; i = 6; #1000;
	DUTY_CYCLE[7:0] = 8'd40; i = 7; #1000;
	DUTY_CYCLE[7:0] = 8'd60; i = 8; #1000;
	DUTY_CYCLE[7:0] = 8'd70; i = 9; #1000;
end 


always@(posedge clk)
begin
	Expected_PWM_OUT <= 1; #(DUTY_CYCLE*10);
	Expected_PWM_OUT <= 0; #((100-DUTY_CYCLE)*10);
end


always@(clk)
	begin
		if(Expected_PWM_OUT !== PWM_OUT)
			begin
				//$display ("Wrong Output for Input");
				error_count = error_count + 1;
				error <= 1;
			end
		else
			begin
				error <= 0;
			end
			
		if (i==9)
			begin
				if (error_count == 0)
				begin
					file_id = $fopen("results.txt","w");
					$fwrite(file_id, "%02h","No Errors");
					$fclose(file_id);
					$display ("CONGRATULATIONS YOUR DESIGN WORKS FINE");
				end
				else
				begin
					file_id = $fopen("results.txt","w");
					$fwrite(file_id, "%02h","Errors");
					$fclose(file_id);
					$display ("ERROR ENCOUNTERED IN YOUR DESIGN");
				end
				i = 0;
		//$stop;
		end
	end
endmodule
