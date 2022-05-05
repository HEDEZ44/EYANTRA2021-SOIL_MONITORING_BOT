
module SM_2300_Task5_uart(
	
	input red_signal,blue_signal, green_signal,
	input clk_50M,
	input pick_signal,depo_signal, 
	input [6:0] curr_node, next_node,
	output tx,
	output reg red_on1,green_on1,blue_on1,
	output reg red_on2,green_on2,blue_on2,
	output reg red_on3,green_on3,blue_on3
);

initial begin
green_on1=0;

end



reg  start_bit=0;
reg [1:0] stop_bit= 2'b11;
reg [7:0] red_bit = 8'b01010011;  // "S"
reg [7:0] red_bit1 = 8'b01001001; // "I"
reg [7:0] red_bit2 = 8'b00101101; // "-"
reg [7:0] red_bit3 = 8'b01010011; // "S"
reg [7:0] red_bit4 = 8'b01001001;  // "I"
reg [7:0] red_bit5 = 8'b01001101; // "N"
reg [7:0] red_bit6 = 8'b00110001; // "1"
reg [7:0] red_bit7 = 8'b00101101;//  '-'
reg [7:0] red_bit8= 8'b01010000;  // "P"
reg [7:0] red_bit9 = 8'b00101101; // "-"
reg [7:0] red_bit10 = 8'b00100011; // "#"


reg [7:0] GREEN_bit =   "S";
reg [7:0] GREEN_bit1 =  "I";
reg [7:0] GREEN_bit2 =  "-";
reg [7:0] GREEN_bit3 =  "S";
reg [7:0] GREEN_bit4 =  "I";
reg [7:0] GREEN_bit5 =  "N";
reg [7:0] GREEN_bit6 =  "1";
reg [7:0] GREEN_bit7 =  "-";
reg [7:0] GREEN_bit8 =  "N";         // "N"
reg [7:0] GREEN_bit9 =  "-";
reg [7:0] GREEN_bit10 = "#";

reg [7:0] BLUE_bit = 8'b01010011;  // "S"
reg [7:0] BLUE_bit1 = 8'b01001001; // "I"
reg [7:0] BLUE_bit2 = 8'b00101101; // "-"
reg [7:0] BLUE_bit3 = 8'b01010011; // "S"
reg [7:0] BLUE_bit4 = 8'b01001001;  // "I"
reg [7:0] BLUE_bit5 = 8'b01001101; // "N"
reg [7:0] BLUE_bit6 = 8'b00110011; // "3"
reg [7:0] BLUE_bit7 = 8'b00101101;//  '-'
reg [7:0] BLUE_bit8= 8'b01010111;  // "W"
reg [7:0] BLUE_bit9 = 8'b00101101; // "-"
reg [7:0] BLUE_bit10 = 8'b00100011; // "#"
reg idle =1;


/////////////////////////

 reg [7:0] pick0 = "S";  //S-P-DZN1-N-#  --> pick signal
 reg [7:0] pick1 = "-";
 reg [7:0] pick2 = "P";
 reg [7:0] pick3 = "-";
 reg [7:0] pick4 = "D";
 reg [7:0] pick5 = "Z";
 reg [7:0] pick6 = "N";
 reg [7:0] pick7 = "1";
 reg [7:0] pick8 = "-";
 reg [7:0] pick9 = "N";
 reg [7:0] pick10 = "-";
 reg [7:0] pick11 = "#";
 
 reg [7:0] depo0="S" ;  //S-D-DZN1-N-#   --> depo signal
 reg [7:0] depo1="-" ;
 reg [7:0] depo2= "D";
 reg [7:0] depo3="-" ;
 reg [7:0] depo4= "D";
 reg [7:0] depo5= "Z";
 reg [7:0] depo6= "N";
 reg [7:0] depo7= "1";
 reg [7:0] depo8= "-";
 reg [7:0] depo9= "N";
 reg [7:0] depo10= "-";
 reg [7:0] depo11= "#";



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
					if(frame==(12+1)) frame=1;
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





/////////////////////////


reg delay_pick =0;
wire pick_edge;
always @(posedge clock)
	begin 
	delay_pick <= pick_signal; 
	end
	
assign pick_edge = pick_signal & (~delay_pick);

reg delay_depo =0;
wire depo_edge;
always @(posedge clock)
	begin 
	delay_depo <= depo_signal; 
	end
	
assign depo_edge = depo_signal & (~delay_depo);

//////





parameter s0=3'b000,
			 s1=3'b001,
			 s2=3'b010,
			 s3=3'b011,
			 s4=3'b100,
			 s5=3'b101,
			 s6 =3'b110;
			 


reg[3:0] curr=s0;
reg start_frame=0;

reg red_flag =0;
reg green_flag =0;
reg blue_flag =0;




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

//
reg pick_msg_flag =0;
reg depo_msg_flag =0;

always @(posedge clock)
begin
case(curr)
	s0:begin
			start_delay=0;
			start_frame=0;
			tx_out=1;
			if(red_edge ==1 && red_message_flag==0) curr<=s1;
			if(green_edge ==1&& green_message_flag==0 ) curr<=s2;
			if(blue_edge ==1&& blue_message_flag==0) curr<=s3;
			//
			if(pick_edge ==1 && pick_msg_flag ==0) curr <= s5;
			if(depo_edge ==1 && depo_msg_flag ==0) curr <= s6;
			// 
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
						tx_out=  1;
						end
				
					
					 
				13: begin
					  red_message_flag=1;
							curr<=s4; end
						
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
					//
					pick_msg_flag =0;
					depo_msg_flag =0;
					//
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
						tx_out = 1;
					end
				13: begin  	
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
						 tx_out = 1;
					end
					
				13: begin
						blue_message_flag=1;
						curr<=s4;
						
					end	
					
					
				endcase
				
		end					
s5:begin
			start_frame=1;
			case(frame)

				1:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = pick0[0];
						4: tx_out = pick0[1];
						5: tx_out = pick0[2];
						6: tx_out = pick0[3];
						7: tx_out = pick0[4];
						8: tx_out = pick0[5];
						9: tx_out = pick0[6];
						10: tx_out = pick0[7];
						11: tx_out = stop_bit[0];
						
					endcase

				2:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = pick1[0];
						4: tx_out = pick1[1];
						5: tx_out = pick1[2];
						6: tx_out = pick1[3];
						7: tx_out = pick1[4];
						8: tx_out = pick1[5];
						9: tx_out = pick1[6];
						10: tx_out = pick1[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				3:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = pick2[0];
						4: tx_out = pick2[1];
						5: tx_out = pick2[2];
						6: tx_out = pick2[3];
						7: tx_out = pick2[4];
						8: tx_out = pick2[5];
						9: tx_out = pick2[6];
						10: tx_out = pick2[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
				4:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = pick3[0];
						4: tx_out =pick3[1];
						5: tx_out = pick3[2];
						6: tx_out = pick3[3];
						7: tx_out = pick3[4];
						8: tx_out = pick3[5];
						9: tx_out = pick3[6];
						10: tx_out = pick3[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
					
				5:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out = pick4[0];
						4: tx_out = pick4[1];
						5: tx_out = pick4[2];
						6: tx_out = pick4[3];
						7: tx_out = pick4[4];
						8: tx_out =pick4[5];
						9: tx_out = pick4[6];
						10: tx_out = pick4[7];
						11: tx_out = stop_bit[0];
						
						
					endcase


				6:
					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick5[0];
						4: tx_out = pick5[1];
						5: tx_out = pick5[2];
						6: tx_out = pick5[3];
						7: tx_out = pick5[4];
						8: tx_out = pick5[5];
						9: tx_out = pick5[6];
						10:tx_out = pick5[7];
						11:tx_out = stop_bit[0];
						
					endcase

				7:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick6[0];
						4: tx_out = pick6[1];
						5: tx_out = pick6[2];
						6: tx_out = pick6[3];
						7: tx_out = pick6[4];
						8: tx_out = pick6[5];
						9: tx_out = pick6[6];
						10:tx_out = pick6[7];
						11: tx_out = stop_bit[0];
						
						
						
					endcase

				8:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick7[0];
						4: tx_out = pick7[1];
						5: tx_out = pick7[2];
						6: tx_out = pick7[3];
						7: tx_out = pick7[4];
						8: tx_out = pick7[5];
						9: tx_out = pick7[6];
						10:tx_out = pick7[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				9:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick8[0];
						4: tx_out = pick8[1];
						5: tx_out = pick8[2];
						6: tx_out = pick8[3];
						7: tx_out = pick8[4];
						8: tx_out = pick8[5];
						9: tx_out = pick8[6];
						10:tx_out = pick8[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
					
				10:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick9[0];
						4: tx_out = pick9[1];
						5: tx_out = pick9[2];
						6: tx_out = pick9[3];
						7: tx_out = pick9[4];
						8: tx_out = pick9[5];
						9: tx_out = pick9[6];
						10:tx_out = pick9[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				11:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick10[0];
						4: tx_out = pick10[1];
						5: tx_out = pick10[2];
						6: tx_out = pick10[3];
						7: tx_out = pick10[4];
						8: tx_out = pick10[5];
						9: tx_out = pick10[6];
						10:tx_out = pick10[7];
						11: tx_out = stop_bit[0];
						
					endcase
							
				12:
				    case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3:tx_out =  pick11[0];
						4: tx_out = pick11[1];
						5: tx_out = pick11[2];
						6: tx_out = pick11[3];
						7: tx_out = pick11[4];
						8: tx_out = pick11[5];
						9: tx_out = pick11[6];
						10:tx_out = pick11[7];
						11: tx_out = stop_bit[0];
						
					endcase
				13: begin
						pick_msg_flag=1;
						curr<=s4;
					end	
					
					
				endcase
				
		end
s6:begin
			start_frame=1;
			case(frame)

				1:
					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo0[0];
						4: tx_out = depo0[1];
						5: tx_out = depo0[2];
						6: tx_out = depo0[3];
						7: tx_out = depo0[4];
						8: tx_out = depo0[5];
						9: tx_out = depo0[6];
						10:tx_out = depo0[7];
						11: tx_out = stop_bit[0];
						
					endcase

				2:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo1[0];
						4: tx_out = depo1[1];
						5: tx_out = depo1[2];
						6: tx_out = depo1[3];
						7: tx_out = depo1[4];
						8: tx_out = depo1[5];
						9: tx_out = depo1[6];
						10:tx_out = depo1[7];
						11: tx_out = stop_bit[0];
						
						
					endcase

				3:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo2[0];
						4: tx_out = depo2[1];
						5: tx_out = depo2[2];
						6: tx_out = depo2[3];
						7: tx_out = depo2[4];
						8: tx_out = depo2[5];
						9: tx_out = depo2[6];
						10:tx_out = depo2[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
				4:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo3[0];
						4: tx_out = depo3[1];
						5: tx_out = depo3[2];
						6: tx_out = depo3[3];
						7: tx_out = depo3[4];
						8: tx_out = depo3[5];
						9: tx_out = depo3[6];
						10:tx_out = depo3[7];
						11: tx_out = stop_bit[0];
						
						
					endcase
					
					
				5:

					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo4[0];
						4: tx_out = depo4[1];
						5: tx_out = depo4[2];
						6: tx_out = depo4[3];
						7: tx_out = depo4[4];
						8: tx_out = depo4[5];
						9: tx_out = depo4[6];
						10:tx_out = depo4[7];
						11: tx_out = stop_bit[0];
						
						
					endcase


				6:
					case(clock_count)
					  1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo5[0];
						4: tx_out = depo5[1];
						5: tx_out = depo5[2];
						6: tx_out = depo5[3];
						7: tx_out = depo5[4];
						8: tx_out = depo5[5];
						9: tx_out = depo5[6];
						10:tx_out = depo5[7];
						11:tx_out = stop_bit[0];
						
					endcase

				7:

					case(clock_count)
						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo6[0];
						4: tx_out = depo6[1];
						5: tx_out = depo6[2];
						6: tx_out = depo6[3];
						7: tx_out = depo6[4];
						8: tx_out = depo6[5];
						9: tx_out = depo6[6];
						10:tx_out = depo6[7];
						11: tx_out = stop_bit[0];
						
						
						
					endcase

				8:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo7[0];
						4: tx_out = depo7[1];
						5: tx_out = depo7[2];
						6: tx_out = depo7[3];
						7: tx_out = depo7[4];
						8: tx_out = depo7[5];
						9: tx_out = depo7[6];
						10:tx_out = depo7[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				9:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo8[0];
						4: tx_out = depo8[1];
						5: tx_out = depo8[2];
						6: tx_out = depo8[3];
						7: tx_out = depo8[4];
						8: tx_out = depo8[5];
						9: tx_out = depo8[6];
						10:tx_out = depo8[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
					
				10:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo9[0];
						4: tx_out = depo9[1];
						5: tx_out = depo9[2];
						6: tx_out = depo9[3];
						7: tx_out = depo9[4];
						8: tx_out = depo9[5];
						9: tx_out = depo9[6];
						10:tx_out = depo9[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				11:

					case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo10[0];
						4: tx_out = depo10[1];
						5: tx_out = depo10[2];
						6: tx_out = depo10[3];
						7: tx_out = depo10[4];
						8: tx_out = depo10[5];
						9: tx_out = depo10[6];
						10:tx_out = depo10[7];
						11: tx_out = stop_bit[0];
						
					endcase
							
				12:
				    case(clock_count)

						1:	tx_out= idle;
						2:	tx_out=start_bit;
						3: tx_out = depo11[0];
						4: tx_out = depo11[1];
						5: tx_out = depo11[2];
						6: tx_out = depo11[3];
						7: tx_out = depo11[4];
						8: tx_out = depo11[5];
						9: tx_out = depo11[6];
						10:tx_out = depo11[7];
						11: tx_out = stop_bit[0];
						
					endcase
					
				13: begin
						depo_msg_flag=1;
						curr<=s4;
					end
					
					
				endcase
				
		end		
endcase
					
end

assign tx = tx_out;




reg blink_clock=0;

reg [23:0]counter_blink=0;

always @(posedge clk_50M) begin // 50M/2 -1

if(green_signal==1)green_on1=1;

if(depo_signal==1&&pick_signal==0)begin
			

			green_on1=0;

	if(counter_blink==12500000) begin
				blink_clock=~blink_clock;
				counter_blink = 1; 
				end
			
	else counter_blink=counter_blink+1;
	end  
end



always @(posedge blink_clock)
begin
if(depo_signal==1)begin blue_on1=~blue_on1;
							blue_on2=~blue_on2;
							blue_on3=~blue_on3;
						end

end
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////