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
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg [6:0] count =0;
reg [11:0] data_temp = 0;
reg [6:0] count_cycle=0;
reg [1:0]data_frame_temp=0;
reg [11:0] data_temp_temp1 = 0;
reg [11:0] data_temp_temp2 = 0;
reg [11:0] data_temp_temp3 = 0;

reg temp_din=0;

always@(negedge clk_50)
begin

if(count==20)
  begin
    count=1;
  
  end
else
  begin
    count=count+1;
  
  end
  
end

assign adc_sck=(count>10);

always@(negedge adc_sck)
begin

if(count_cycle==16)
	begin
	   data_frame_temp = data_frame_temp +1;
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

   3: temp_din=1;
   4: temp_din=0;
   5: temp_din=1;
	default : temp_din =0;
	endcase
	end
1 : begin case(count_cycle)

   3: temp_din=1;
   4: temp_din=1;
   5: temp_din=0;
	default : temp_din =0;
	endcase
	end
2 : begin case(count_cycle)

   3: temp_din=1;
   4: temp_din=1;
   5: temp_din=1;
	default : temp_din =0;
	endcase
	end	

endcase

end


assign din=temp_din;



always @(negedge adc_sck)
begin
case (data_frame)
0 : begin case(count_cycle)
   6  : data_temp[11] = dout;
   7  : data_temp[10] = dout;
   8  : data_temp[9] = dout;
   9  : data_temp[8] = dout;
   10  : data_temp[7] = dout;
   11 : data_temp[6] = dout;
   12 : data_temp[5] = dout;
   13 : data_temp[4] = dout;
   14 : data_temp[3] = dout;
   15 : data_temp[2] = dout;
   16 : data_temp[1] = dout;
   1 : data_temp[0] = dout;
	
	endcase
	end
1 : begin case(count_cycle)
    6  : data_temp[11] = dout;
   7  : data_temp[10] = dout;
   8  : data_temp[9] = dout;
   9  : data_temp[8] = dout;
   10  : data_temp[7] = dout;
   11 : data_temp[6] = dout;
   12 : data_temp[5] = dout;
   13 : data_temp[4] = dout;
   14 : data_temp[3] = dout;
   15 : data_temp[2] = dout;
   16 : data_temp[1] = dout;
   1 : data_temp[0] = dout;
	
	endcase
	end
2 : begin case(count_cycle)
   6  : data_temp[11] = dout;
   7  : data_temp[10] = dout;
   8  : data_temp[9] = dout;
   9  : data_temp[8] = dout;
   10  : data_temp[7] = dout;
   11 : data_temp[6] = dout;
   12 : data_temp[5] = dout;
   13 : data_temp[4] = dout;
   14 : data_temp[3] = dout;
   15 : data_temp[2] = dout;
   16 : data_temp[1] = dout;
   1 : data_temp[0] = dout;
	endcase
	end	
	
endcase

if(data_frame_temp==2 && count_cycle==1) data_temp_temp1=data_temp;

if(data_frame_temp==3 && count_cycle==1) data_temp_temp2=data_temp;

if(data_frame_temp==1 && count_cycle==1) data_temp_temp3=data_temp;	


end

assign d_out_ch5 = data_temp_temp1 ;
assign d_out_ch6 = data_temp_temp2;
assign d_out_ch7 = data_temp_temp3;


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////