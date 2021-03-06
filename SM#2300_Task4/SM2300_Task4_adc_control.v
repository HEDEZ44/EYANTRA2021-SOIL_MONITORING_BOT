// SM : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module SM2300_Task4_adc_control(input  clk_50M,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)q
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame,
	output PWM_OUT,
	output PWM_OUT_left,
	output PWM_OUT_center,
	output PWM_OUT_right,
	output reg [15:0]counter,
	output reg  [1:0] laps,
 output reg inA1, inB1, inA2, inB2
	 //To represent 16-cycle frame (optional)
);
	

////////////////////////WRITE YOUR CODE FROM HERE////////////////////////////////////////////////////////////

reg PWM_OUT_1;
reg [6:0] count =0;
reg [11:0] data_temp = 0;
reg [6:0] count_cycle=0;
reg [1:0]data_frame_temp=0;
reg [11:0] data_temp_temp1 = 0;
reg [11:0] data_temp_temp2 = 0;
reg [11:0] data_temp_temp3 = 0;
reg adc_clock=0;



reg temp_din=0;
integer pwm_temp=0;
always@(negedge clk_50M)
begin

if(count==10)   // (50 / 2.5) = 20 // frequency divider
  begin
    adc_clock = ~adc_clock;
    count=1;
  
  end
else
  begin
    count=count+1;
  
  end
  
end

assign adc_sck= adc_clock;
assign adc_cs_n=(count_cycle>=1)?0:1;







always@(negedge adc_sck)
begin

if(count_cycle==16)
	begin
		if(data_frame_temp==2) data_frame_temp=0;
		
	   else data_frame_temp = data_frame_temp +1;
		
		count_cycle=1;
		
	end
else
  begin
	count_cycle=count_cycle+1;
	
  end
  
end

assign data_frame = data_frame_temp;



always@(negedge adc_sck)
begin


	case (data_frame_temp)
	0 : begin case(count_cycle)
		2: temp_din<=1;
		3: temp_din<=0;
		4: temp_din<=1;
		
		default : temp_din <=0;
		endcase
		end
	1 : begin case(count_cycle)
		2: temp_din<=1;
		3: temp_din<=1;
		4: temp_din<=0;

		default : temp_din <=0;
		endcase
		end
	2 : begin case(count_cycle)
		2: temp_din<=1;
		3: temp_din<=1;
		4: temp_din<=1;

		default : temp_din <=0;
		endcase
		end
	
	
	endcase
end




assign din=temp_din;



always @(negedge adc_sck)
begin
case (data_frame_temp)
0 : begin case(count_cycle)
   5  : data_temp[11] <= dout;
   6  : data_temp[10] <= dout;
   7  : data_temp[9] <= dout;
   8  : data_temp[8] <= dout;
   9 : data_temp[7] <= dout;
   10 : data_temp[6] <= dout;
   11 : data_temp[5] <= dout;
   12 : data_temp[4] <= dout;
   13 : data_temp[3] <= dout;
   14 : data_temp[2] <= dout;
   15 : data_temp[1] <= dout;
   16: data_temp[0] <= dout;
	
	endcase
	end
1 : begin case(count_cycle)
    5  : data_temp[11] <= dout;
   6  : data_temp[10] <= dout;
   7  : data_temp[9] <= dout;
   8  : data_temp[8] <= dout;
   9 : data_temp[7] <= dout;
   10 : data_temp[6] <= dout;
   11 : data_temp[5] <= dout;
   12 : data_temp[4] <= dout;
   13 : data_temp[3] <= dout;
   14 : data_temp[2] <= dout;
   15 : data_temp[1] <= dout;
   16: data_temp[0] <= dout;
	endcase
	end
2 : begin case(count_cycle)
   5  : data_temp[11] <= dout;
   6  : data_temp[10] <= dout;
   7  : data_temp[9] <= dout;
   8  : data_temp[8] <= dout;
   9 : data_temp[7] <= dout;
   10 : data_temp[6] <= dout;
   11 : data_temp[5] <= dout;
   12 : data_temp[4] <= dout;
   13 : data_temp[3] <= dout;
   14 : data_temp[2] <= dout;
   15 : data_temp[1] <= dout;
   16: data_temp[0] <= dout;
	endcase
	end	
	

	
endcase

if(data_frame_temp==2&& count_cycle==1) data_temp_temp1<=data_temp;

if(data_frame_temp==0&& count_cycle==1) data_temp_temp2<=data_temp;

if(data_frame_temp==1&& count_cycle==1) data_temp_temp3<=data_temp;	


end

assign d_out_ch5 =  data_temp_temp1;
assign d_out_ch6 =  data_temp_temp2;
assign d_out_ch7 =  data_temp_temp3;




///////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [15:0] count_duty =0;
reg [10:0] DUTY_CYCLE=45;
reg clock_1khz=0;

always@(posedge clk_50M)
begin

if(count_duty==25000)
	begin
		count_duty=1;
		
	
	end
else
	begin
		count_duty=count_duty+1;
	
	end



end

assign PWM_OUT= (count_duty*100/25000 <= DUTY_CYCLE);


///////////////////////////////////////////////////////////////////////////////////////////////////////////

parameter [10:0]pwm_p=250;
wire left_ch, right_ch, centre_ch;

assign left_ch=(d_out_ch5>pwm_p)?1:0;
assign right_ch=(d_out_ch7>pwm_p)?1:0;
assign centre_ch=(d_out_ch6>pwm_p)?1:0;



reg [23:0]count_1khz =0;

always @(posedge clk_50M)
begin 
if(count_1khz == 25000) begin 
  clock_1khz = ~clock_1khz;
  count_1khz = 1; end
else 
  count_1khz = count_1khz +1;  // 50 000000/1000
end





reg node_detection=0;

always@(posedge clock_1khz)
begin
 node_detection = (( left_ch==1 &&centre_ch==1 )||( centre_ch==1 && right_ch==1));
 
end






reg [4:0] node=0;
reg value=0;

always@(posedge clock_1khz)
begin
if(node==1)value=1;
else value=0;

end


reg d_value =0;
wire value_edge;
always @(posedge clock_1khz)
	begin 
	d_value<= value; 
	end
	
assign value_edge = value & (~d_value);






always @(posedge node_detection )
 begin
   node = node +1;
	if(node==9)begin
				node=1;
				laps=laps+1;
				
				
				end
 end


 
 
task black_line_following();


	if((left_ch==1 && centre_ch==0 && right_ch==0)) 
		begin
		//left bot

		inA1 = PWM_OUT;
		inA2 =low;

		inB1 = high; 
		inB2 = low; 
		end

	if((left_ch==0 && centre_ch==0 && right_ch==1) )
		begin
		//right bot
		inA1 = high;
		inA2 =low;

		inB1 = PWM_OUT; 
		inB2 = low; 

		end

	if(( left_ch==0 &&centre_ch==1 && right_ch==0 )||( left_ch==1 &&centre_ch==1 )||( centre_ch==1 && right_ch==1))
		begin

		//straight bot 
		inA1 = high;
		inA2 =low;

		inB1 = high; 
		inB2 = low; 
		


		end
	
endtask




task rotate_left();

//left
inA1 = low;
inA2 =high;

inB1 = high; 
inB2 = low; 

endtask

task stop_bot();
inA1 = high;
inA2 =high;

inB1 = high; 
inB2 = high;

endtask



parameter [15:0]delay_value=400;


task node_rotation();
		
		
		if(counter<delay_value) counter=counter+1;
		if(counter==delay_value) counter=counter;
		
		if((counter <delay_value/2)) black_line_following();
		if((counter>delay_value/2)&&(counter<delay_value)) rotate_left();
		if(counter==delay_value) black_line_following();
		if(node_detection==1)counter=0;
		
		
endtask






//




always @(posedge  clock_1khz)
begin
case(node)
   0: black_line_following();
	1: begin black_line_following();
		if(laps==2)stop_bot();
		end
	
	
	2: begin
		
		node_rotation();
		end
		
		
	3: black_line_following();
		
	4:	begin
		
		node_rotation();
		end
		
	5: black_line_following();
	
	6: black_line_following();
	
	7:	begin
		
		node_rotation();
		end
		
	8: black_line_following();
	
	
	
	
endcase
end


reg high = 1;
reg low =0;


//////////////////////////YOUR CODE ENDS HERE///////////////////////////////////////////////////////////////
endmodule

/////////////////////////////////MODULE ENDS////////////////////////////////////////////////////////////////