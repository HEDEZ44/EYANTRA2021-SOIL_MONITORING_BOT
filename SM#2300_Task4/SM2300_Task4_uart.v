// SM : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module SM2300_Task4_uart(
	input red_signal,blue_signal, green_signal,
	input clk_50M,
	input [1:0]laps,//50 MHz clock
	output tx,
	output reg red_on,green_on,blue_on  //UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
reg start_bit=0;

reg [1:0] stop_bit= 2'b11;
reg [7:0] red_bit = 8'b01010011;  // "S"
reg [7:0] red_bit1 = 8'b01001001; // "I"
reg [7:0] red_bit2 = 8'b00101101; // "-"
reg [7:0] red_bit3 = 8'b01010011; // "S"
reg [7:0] red_bit4 = 8'b01001001;  // "I"
reg [7:0] red_bit5 = 8'b01001101; // "M"
reg [7:0] red_bit6 = 8'b00110001; // "1"
reg [7:0] red_bit7 = 8'b00101101;//  '-'
reg [7:0] red_bit8= 8'b01010000;  // "P"
reg [7:0] red_bit9 = 8'b00101101; // "-"
reg [7:0] red_bit10 = 8'b00100011; // "#"


reg [7:0] GREEN_bit = 8'b01010011;  // "S"
reg [7:0] GREEN_bit1 = 8'b01001001; // "I"
reg [7:0] GREEN_bit2 = 8'b00101101; // "-"
reg [7:0] GREEN_bit3 = 8'b01010011; // "S"
reg [7:0] GREEN_bit4 = 8'b01001001;  // "I"
reg [7:0] GREEN_bit5 = 8'b01001101; // "M"
reg [7:0] GREEN_bit6 = 8'b00110010; // "2"
reg [7:0] GREEN_bit7 = 8'b00101101;//  '-'
reg [7:0] GREEN_bit8= 8'b01001110;  // "N"
reg [7:0] GREEN_bit9 = 8'b00101101; // "-"
reg [7:0] GREEN_bit10 = 8'b00100011; // "#"

reg [7:0] BLUE_bit = 8'b01010011;  // "S"
reg [7:0] BLUE_bit1 = 8'b01001001; // "I"
reg [7:0] BLUE_bit2 = 8'b00101101; // "-"
reg [7:0] BLUE_bit3 = 8'b01010011; // "S"
reg [7:0] BLUE_bit4 = 8'b01001001;  // "I"
reg [7:0] BLUE_bit5 = 8'b01001101; // "M"
reg [7:0] BLUE_bit6 = 8'b00110011; // "3"
reg [7:0] BLUE_bit7 = 8'b00101101;//  '-'
reg [7:0] BLUE_bit8= 8'b01010111;  // "W"
reg [7:0] BLUE_bit9 = 8'b00101101; // "-"
reg [7:0] BLUE_bit10 = 8'b00100011; // "#"
reg idle =1;

// at transmitter side in uart , parallel to serial data conversion

reg [1:0] state =0 ;  

reg tx_out =1 ;
reg [4:0] frame =0;  // frame to diffentiate in sending signal i.e "SM00"...frame 0 to S,1 to M , so on

reg [8:0] clk_50M_count =0; // 434 (50M/ baud rate) clock counter 
reg clock=1;    // clock to keep track of one bit of data packet that how how it gonna stay 
reg [3:0] clock_count=0;





always @(posedge clk_50M)
begin


if(clk_50M_count==217)
    begin
    clock = ~clock;	 
    clk_50M_count=1;
	 end

else 
clk_50M_count = clk_50M_count + 1;

end


always @(posedge clock)
begin 
	if(start_frame==0)
		begin
		clock_count=0;
		frame=1;
		
		end
	if(start_frame==1)
		begin
			if(clock_count==11)
				begin
					if(frame==12) frame=1;
					else frame=frame+1;
				clock_count=1;
				end
			else
			clock_count = clock_count +1;
		end


end



reg delay_red =0;
wire red_edge;
always @(posedge clock)
	begin 
	delay_red <= red_signal; 
	end
	
assign red_edge = red_signal & (~delay_red);


reg delay_green =0;
wire green_edge;
always @(posedge clock)
	begin 
	delay_green <= green_signal; 
	end
	
assign green_edge = green_signal & (~delay_green);





reg delay_blue =0;
wire blue_edge;
always @(posedge clock)
	begin 
	delay_blue <= blue_signal; 
	end
	
assign blue_edge = blue_signal & (~delay_blue);


//always@(posedge clock)
//begin
//
//if(red_edge==1) red_on=1;
//if(laps==1) red_on=0
//
//
//
//
//end





parameter s0=3'b000,
			 s1=3'b001,
			 s2=3'b010,
			 s3=3'b011,
			 s4=3'b100;
			 


reg[3:0] curr=s0;
reg start_frame=0;

reg red_flag =0;
reg green_flag =0;
reg blue_flag =0;

always@(posedge clock)
begin
if(laps ==1 && red_edge ==1) red_flag=1;
if(laps ==1 && green_edge ==1) green_flag  =1;
if(laps ==1 && blue_edge ==1) blue_flag =1;

if(laps ==1 && red_flag==1) red_on =1;
if(laps ==1 && green_flag==1) green_on =1;
if(laps ==1 && blue_flag==1) blue_on =1;

if(laps ==1 && red_flag==0) red_on =0;
if(laps ==1 && green_flag==0) green_on =0;
if(laps ==1 && blue_flag==0) blue_on =0;
 
if(laps ==0)
		begin 
		  if(red_edge ==1) red_on =1;
		  if (green_edge ==1) green_on =1;
		  if (blue_edge ==1) blue_on =1;
		end
 
 if (laps ==2) begin 
    red_on =0;
	 blue_on =0;
	 green_on =0;
end


end



reg start_delay=0;
reg [20:0]clock_delay_count=0;

always @(posedge clock)
begin 
	
	if(start_delay==0) clock_delay_count=0;	
		
	if(start_delay==1)
		begin
			if(clock_delay_count==115207)
				begin
					
				clock_delay_count=1;
				end
			else
			clock_delay_count = clock_delay_count +1;
		end


end






reg red_message_flag=0;
reg green_message_flag=0;
reg blue_message_flag=0;

always @(posedge clock)
begin
case(curr)
	s0:begin
			start_delay=0;
			start_frame=0;
			tx_out=1;
			if(red_edge ==1 &&red_message_flag==0) curr<=s1;
			if(green_edge ==1&&green_message_flag==0) curr<=s2;
			if(blue_edge ==1&&blue_message_flag==0) curr<=s3;
			 
		end

	s1:begin
			start_frame=1;
			case(frame)

				1:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = red_bit[0];
						4: tx_out = red_bit[1];
						5: tx_out = red_bit[2];
						6: tx_out = red_bit[3];
						7: tx_out = red_bit[4];
						8: tx_out = red_bit[5];
						9: tx_out = red_bit[6];
						10: tx_out = red_bit[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				2:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit1[0];
						4: tx_out = red_bit1[1];
						5: tx_out = red_bit1[2];
						6: tx_out = red_bit1[3];
						7: tx_out = red_bit1[4];
						8: tx_out = red_bit1[5];
						9: tx_out = red_bit1[6];
						10: tx_out = red_bit1[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				3:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = red_bit2[0];
						4: tx_out = red_bit2[1];
						5: tx_out = red_bit2[2];
						6: tx_out = red_bit2[3];
						7: tx_out = red_bit2[4];
						8: tx_out = red_bit2[5];
						9: tx_out = red_bit2[6];
						10: tx_out = red_bit2[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
				4:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = red_bit3[0];
						4: tx_out = red_bit3[1];
						5: tx_out = red_bit3[2];
						6: tx_out = red_bit3[3];
						7: tx_out = red_bit3[4];
						8: tx_out = red_bit3[5];
						9: tx_out = red_bit3[6];
						10: tx_out = red_bit3[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
					
				5:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit4[0];
						4: tx_out = red_bit4[1];
						5: tx_out = red_bit4[2];
						6: tx_out = red_bit4[3];
						7: tx_out = red_bit4[4];
						8: tx_out = red_bit4[5];
						9: tx_out = red_bit4[6];
						10: tx_out = red_bit4[7];
						11: tx_out = stop_bit[0];
						
						
					endcase


				6:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit5[0];
						4: tx_out = red_bit5[1];
						5: tx_out = red_bit5[2];
						6: tx_out = red_bit5[3];
						7: tx_out = red_bit5[4];
						8: tx_out = red_bit5[5];
						9: tx_out = red_bit5[6];
						10: tx_out = red_bit5[7];
						11: tx_out = stop_bit[0];
						
					endcase

				7:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = red_bit6[0];
						4: tx_out = red_bit6[1];
						5: tx_out = red_bit6[2];
						6: tx_out = red_bit6[3];
						7: tx_out = red_bit6[4];
						8: tx_out = red_bit6[5];
						9: tx_out = red_bit6[6];
						10: tx_out = red_bit6[7];
						11: tx_out = stop_bit[0];
						
						
						
					endcase

				8:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = red_bit7[0];
						4: tx_out = red_bit7[1];
						5: tx_out = red_bit7[2];
						6: tx_out = red_bit7[3];
						7: tx_out = red_bit7[4];
						8: tx_out = red_bit7[5];
						9: tx_out = red_bit7[6];
						10: tx_out = red_bit7[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				9:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit8[0];
						4: tx_out = red_bit8[1];
						5: tx_out = red_bit8[2];
						6: tx_out = red_bit8[3];
						7: tx_out = red_bit8[4];
						8: tx_out = red_bit8[5];
						9: tx_out = red_bit8[6];
						10: tx_out = red_bit8[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
					
				10:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit9[0];
						4: tx_out = red_bit9[1];
						5: tx_out = red_bit9[2];
						6: tx_out = red_bit9[3];
						7: tx_out = red_bit9[4];
						8: tx_out = red_bit9[5];
						9: tx_out = red_bit9[6];
						10: tx_out = red_bit9[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				11:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = red_bit10[0];
						4: tx_out = red_bit10[1];
						5: tx_out = red_bit10[2];
						6: tx_out = red_bit10[3];
						7: tx_out = red_bit10[4];
						8: tx_out = red_bit10[5];
						9: tx_out = red_bit10[6];
						10: tx_out = red_bit10[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				12: begin
						
						red_message_flag=1;
						curr<=s4;
					 end
					
					
				endcase
				
		end
		
	s4:begin
			start_delay=1;
			if(clock_delay_count<115204) tx_out=1;
			if(clock_delay_count==115205) 
				begin 
					red_message_flag=0;
					green_message_flag=0;
					blue_message_flag=0;
					curr<=s0;
				end
	   end
						
	s2:begin
			start_frame=1;
			case(frame)

				1:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit[0];
						4: tx_out = GREEN_bit[1];
						5: tx_out = GREEN_bit[2];
						6: tx_out = GREEN_bit[3];
						7: tx_out = GREEN_bit[4];
						8: tx_out = GREEN_bit[5];
						9: tx_out = GREEN_bit[6];
						10: tx_out = GREEN_bit[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				2:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit1[0];
						4: tx_out = GREEN_bit1[1];
						5: tx_out = GREEN_bit1[2];
						6: tx_out = GREEN_bit1[3];
						7: tx_out = GREEN_bit1[4];
						8: tx_out = GREEN_bit1[5];
						9: tx_out = GREEN_bit1[6];
						10: tx_out = GREEN_bit1[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				3:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit2[0];
						4: tx_out = GREEN_bit2[1];
						5: tx_out = GREEN_bit2[2];
						6: tx_out = GREEN_bit2[3];
						7: tx_out = GREEN_bit2[4];
						8: tx_out = GREEN_bit2[5];
						9: tx_out = GREEN_bit2[6];
						10: tx_out = GREEN_bit2[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
				4:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit3[0];
						4: tx_out = GREEN_bit3[1];
						5: tx_out = GREEN_bit3[2];
						6: tx_out = GREEN_bit3[3];
						7: tx_out = GREEN_bit3[4];
						8: tx_out = GREEN_bit3[5];
						9: tx_out = GREEN_bit3[6];
						10: tx_out = GREEN_bit3[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
					
				5:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit4[0];
						4: tx_out = GREEN_bit4[1];
						5: tx_out = GREEN_bit4[2];
						6: tx_out = GREEN_bit4[3];
						7: tx_out = GREEN_bit4[4];
						8: tx_out = GREEN_bit4[5];
						9: tx_out = GREEN_bit4[6];
						10: tx_out = GREEN_bit4[7];
						11: tx_out = stop_bit[0];
						
						
					endcase


				6:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit5[0];
						4: tx_out = GREEN_bit5[1];
						5: tx_out = GREEN_bit5[2];
						6: tx_out = GREEN_bit5[3];
						7: tx_out = GREEN_bit5[4];
						8: tx_out = GREEN_bit5[5];
						9: tx_out = GREEN_bit5[6];
						10: tx_out = GREEN_bit5[7];
						11: tx_out = stop_bit[0];
						
					endcase

				7:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit6[0];
						4: tx_out = GREEN_bit6[1];
						5: tx_out = GREEN_bit6[2];
						6: tx_out = GREEN_bit6[3];
						7: tx_out = GREEN_bit6[4];
						8: tx_out = GREEN_bit6[5];
						9: tx_out = GREEN_bit6[6];
						10: tx_out = GREEN_bit6[7];
						11: tx_out = stop_bit[0];
						
						
						
					endcase

				8:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit7[0];
						4: tx_out = GREEN_bit7[1];
						5: tx_out = GREEN_bit7[2];
						6: tx_out = GREEN_bit7[3];
						7: tx_out = GREEN_bit7[4];
						8: tx_out = GREEN_bit7[5];
						9: tx_out = GREEN_bit7[6];
						10: tx_out = GREEN_bit7[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				9:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit8[0];
						4: tx_out = GREEN_bit8[1];
						5: tx_out = GREEN_bit8[2];
						6: tx_out = GREEN_bit8[3];
						7: tx_out = GREEN_bit8[4];
						8: tx_out = GREEN_bit8[5];
						9: tx_out = GREEN_bit8[6];
						10: tx_out = GREEN_bit8[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
					
				10:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit9[0];
						4: tx_out = GREEN_bit9[1];
						5: tx_out = GREEN_bit9[2];
						6: tx_out = GREEN_bit9[3];
						7: tx_out = GREEN_bit9[4];
						8: tx_out = GREEN_bit9[5];
						9: tx_out = GREEN_bit9[6];
						10: tx_out = GREEN_bit9[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				11:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = GREEN_bit10[0];
						4: tx_out = GREEN_bit10[1];
						5: tx_out = GREEN_bit10[2];
						6: tx_out = GREEN_bit10[3];
						7: tx_out = GREEN_bit10[4];
						8: tx_out = GREEN_bit10[5];
						9: tx_out = GREEN_bit10[6];
						10: tx_out = GREEN_bit10[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				12:begin
						green_message_flag=1;
						curr<=s4;
					end
					
					
				endcase
				
		end					
			
				
s3:begin
			start_frame=1;
			case(frame)

				1:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit[0];
						4: tx_out = BLUE_bit[1];
						5: tx_out = BLUE_bit[2];
						6: tx_out = BLUE_bit[3];
						7: tx_out = BLUE_bit[4];
						8: tx_out = BLUE_bit[5];
						9: tx_out = BLUE_bit[6];
						10: tx_out = BLUE_bit[7];
						11: tx_out = stop_bit[0];
						
					endcase

				2:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit1[0];
						4: tx_out = BLUE_bit1[1];
						5: tx_out = BLUE_bit1[2];
						6: tx_out = BLUE_bit1[3];
						7: tx_out = BLUE_bit1[4];
						8: tx_out = BLUE_bit1[5];
						9: tx_out = BLUE_bit1[6];
						10: tx_out = BLUE_bit1[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				3:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit2[0];
						4: tx_out = BLUE_bit2[1];
						5: tx_out = BLUE_bit2[2];
						6: tx_out = BLUE_bit2[3];
						7: tx_out = BLUE_bit2[4];
						8: tx_out = BLUE_bit2[5];
						9: tx_out = BLUE_bit2[6];
						10: tx_out = BLUE_bit2[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
				4:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit3[0];
						4: tx_out = BLUE_bit3[1];
						5: tx_out = BLUE_bit3[2];
						6: tx_out = BLUE_bit3[3];
						7: tx_out = BLUE_bit3[4];
						8: tx_out = BLUE_bit3[5];
						9: tx_out = BLUE_bit3[6];
						10: tx_out = BLUE_bit3[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
					
				5:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit4[0];
						4: tx_out = BLUE_bit4[1];
						5: tx_out = BLUE_bit4[2];
						6: tx_out = BLUE_bit4[3];
						7: tx_out = BLUE_bit4[4];
						8: tx_out = BLUE_bit4[5];
						9: tx_out = BLUE_bit4[6];
						10: tx_out = BLUE_bit4[7];
						11: tx_out = stop_bit[0];
						
						
					endcase


				6:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit5[0];
						4: tx_out = BLUE_bit5[1];
						5: tx_out = BLUE_bit5[2];
						6: tx_out = BLUE_bit5[3];
						7: tx_out = BLUE_bit5[4];
						8: tx_out = BLUE_bit5[5];
						9: tx_out = BLUE_bit5[6];
						10: tx_out = BLUE_bit5[7];
						11: tx_out = stop_bit[0];
						
					endcase

				7:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit6[0];
						4: tx_out = BLUE_bit6[1];
						5: tx_out = BLUE_bit6[2];
						6: tx_out = BLUE_bit6[3];
						7: tx_out = BLUE_bit6[4];
						8: tx_out = BLUE_bit6[5];
						9: tx_out = BLUE_bit6[6];
						10: tx_out = BLUE_bit6[7];
						11: tx_out = stop_bit[0];
						
						
						
					endcase

				8:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit7[0];
						4: tx_out = BLUE_bit7[1];
						5: tx_out = BLUE_bit7[2];
						6: tx_out = BLUE_bit7[3];
						7: tx_out = BLUE_bit7[4];
						8: tx_out = BLUE_bit7[5];
						9: tx_out = BLUE_bit7[6];
						10: tx_out = BLUE_bit7[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				9:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit8[0];
						4: tx_out = BLUE_bit8[1];
						5: tx_out = BLUE_bit8[2];
						6: tx_out = BLUE_bit8[3];
						7: tx_out = BLUE_bit8[4];
						8: tx_out = BLUE_bit8[5];
						9: tx_out = BLUE_bit8[6];
						10: tx_out = BLUE_bit8[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
					
				10:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit9[0];
						4: tx_out = BLUE_bit9[1];
						5: tx_out = BLUE_bit9[2];
						6: tx_out = BLUE_bit9[3];
						7: tx_out = BLUE_bit9[4];
						8: tx_out = BLUE_bit9[5];
						9: tx_out = BLUE_bit9[6];
						10: tx_out = BLUE_bit9[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				11:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = BLUE_bit10[0];
						4: tx_out = BLUE_bit10[1];
						5: tx_out = BLUE_bit10[2];
						6: tx_out = BLUE_bit10[3];
						7: tx_out = BLUE_bit10[4];
						8: tx_out = BLUE_bit10[5];
						9: tx_out = BLUE_bit10[6];
						10: tx_out = BLUE_bit10[7];
						11: tx_out = stop_bit[0];
						
					endcase
							
				12:begin
						blue_message_flag=1;
						curr<=s4;
					end
					
					
				endcase
				
		end					
							
endcase
					
end
assign tx = tx_out;

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////