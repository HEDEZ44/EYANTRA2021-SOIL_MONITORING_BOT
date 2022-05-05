/*
  * Team Id         :   SM#2300  
  
  * Author List     :   Ashwini kumar, Ankit kumar
	 
  * Filename        :   SM_2300_Task6_uart
	 
  * Theme           :   Soil Monitoring Robot
	 
  * Functions/Tasks :   None
  
  * Global variables:   stop_bit, start_bit, idle, state, tx_out, frame, clk_50M_count, clock, clock_count,delay_red, red_edge, delay_blue, blue_edge, green_edge, delay_green, delay_pick,pick_edge,depo_edge,delay_depo,
                        start_delay, clock_delay_count, start_frame, message_flag, depo_message_falg, pick_message_flag,S, iS,dS, mS,nS, vS,pS,hS,DS,zS,oS,WS,tS,rS,bS,gS  
                        n_l, counter_blink, blink_count,


*/



module SM_2300_Task6_uart(
	
	input red_signal,blue_signal, green_signal,
	input clk_50M,
	input pick_signal,depo_signal, 
	input [6:0] curr_node, next_node,end_node_temp1,  //input from adc control module
	input [7:0] sim1, sim2, sim3,siv1,siv2,sin1,sin2,sip1,sip2, // variables for inputing color value for diffrent terrains from Adc
	
	output tx,  //transmit
	output reg red_on1,green_on1,blue_on1,        // RGB for led1 
	output reg red_on2,green_on2,blue_on2,        // RGB for led2 
	output reg red_on3,green_on3,blue_on3,         // RGB for led3 
	input [4:0] flag_ng,flag_mt ,flag_vg ,flag_pp,  
	input done_all                               // signal for indicating task Done
);

initial begin  // to make sure initially all leds are off
green_on1=0;
red_on2=0;
green_on2=0;
blue_on2=0;
red_on3=0;
green_on3=0;
blue_on3=0;

end

reg  start_bit=0;
reg [1:0] stop_bit= 2'b11;
reg idle =1;

reg tx_out =1 ;  //temporary reg for saving transmit sigmal

reg [4:0] frame =0;  // frame to diffentiate in sending signal i.e "SM00"...frame 0 for S,1 for M , so on

reg [8:0] clk_50M_count =0; // 434 (50M/ baud rate) clock counter 
reg clock=1;    // clock to keep track of one bit of data packet that how long it gonna stay 
reg [3:0] clock_count=0; //for  sending 11 bit i.e. start, data and stop bits  

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

always @(posedge clock)    //condition for changing clock count and frame
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
					if(frame==(12+2)) frame=1;
					else frame=frame+1;
				clock_count=1;
				end
			else
			clock_count = clock_count +1;
		end


end

// posedge detector for red signal
reg delay_red =0;
wire red_edge;    
always @(posedge clock)
	begin 
	delay_red <= red_signal; 
	end
	
assign red_edge = red_signal & (~delay_red);

// posedge detector for green signal
reg delay_green =0;
wire green_edge;
always @(posedge clock)
	begin 
	delay_green <= green_signal; 
	end
	
assign green_edge = green_signal & (~delay_green);

//posedge detector for blue signal
reg delay_blue =0;
wire blue_edge;
always @(posedge clock)
	begin 
	delay_blue <= blue_signal; 
	end
	
assign blue_edge = blue_signal & (~delay_blue);

// posedge detector for pick signal

reg delay_pick =0;
wire pick_edge;
always @(posedge clock)
	begin 
	delay_pick <= pick_signal; 
	end
	
assign pick_edge = pick_signal & (~delay_pick);

// posedge detector for deposition signal
reg delay_depo =0;
wire depo_edge;
always @(posedge clock)
	begin 
	delay_depo <= depo_signal; 
	end
	
assign depo_edge = depo_signal & (~delay_depo);

parameter s0=3'b000, 
			 s1=3'b001,
			 s2=3'b010,
			 s3=3'b011,
			 s4=3'b100,
          s5=3'b101,
			 s6=3'b110;

reg[3:0] curr=s0;
reg start_frame=0;

reg start_delay=0;
reg [32:0]clock_delay_count=0;  // counter for delay of approx 4 sec

always @(posedge clock)
begin 
	
	if(start_delay==0) clock_delay_count=0;	
		
	if(start_delay==1)
		begin
			if(clock_delay_count==460828)  // delay of approx 4 sec
				begin
					
				clock_delay_count=1;
				end
			else
			clock_delay_count = clock_delay_count +1;
		end


end


//Universal messgae signal for Status indication , pick and deposition

reg [0:7] S = "S";
reg [0:7] iS = "I";
reg [0:7] mS = "M";    // maize terrain
reg [0:7] nS = "N";   //nuty grnd
reg [0:7] vS = "V";   // veg garden
reg [0:7] pS = "P";  //paddy plain
reg [0:7] rS = "P";   //red
reg [0:7] gS = "N";  //green
reg [0:7] bS = "W";  //blue
reg [0:7] dS = "-";
reg [0:7] hS = "#";
reg [0:7] oS = "1";
reg [0:7] wS = "2";
reg [0:7] tS = "3";
reg [0:7] DS = "D";
reg [0:7] zS = "Z";
reg [0:7] n_l="\n";


// message flag , pick message flag and deposition message flag controls that the message should be sent only once until bot cross the patch
reg message_flag=0;
reg pick_message_flag =0;
reg depo_message_flag =0;

always @(posedge clock)
begin
case(curr)
   s0:   begin             // initial state whicch decide which message to be sent (i.e. SI, pick or depo)
			start_delay=0;
			start_frame=0;
			tx_out=1;
			
			if((red_edge ==1 || blue_edge ==1 || green_edge ==1) && (message_flag==0) && (flag_mt == 1 || flag_mt == 2 || flag_mt == 3|| flag_vg == 1 || flag_vg == 2 || flag_vg == 3 || 
		   flag_ng == 1 || flag_ng == 2 || flag_ng == 3 || flag_pp == 1 || flag_pp == 2 || flag_pp == 3	) ) curr<=s1;                                                                          
			if((curr_node== 2|| curr_node== 3|| curr_node== 5|| curr_node== 6||curr_node== 8|| curr_node== 9||curr_node==10 ) && pick_message_flag ==0) curr <= s5;
			if((curr_node== 27|| curr_node== 24|| curr_node== 22|| curr_node== 19||curr_node== 20|| curr_node== 31||curr_node==28 || curr_node== 33||curr_node==34) && depo_message_flag ==0) curr <= s6;
		end

	s1:   begin                    //state for SI message
						start_frame=1;
						case(frame)

							1: //S                             
																		  
								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = S[7];	
						         4 : tx_out = S[6];	
									5 : tx_out = S[5];
									6 : tx_out = S[4];	
									7 : tx_out = S[3];	
									8 : tx_out = S[2];
					            9 : tx_out = S[1];
									10 : tx_out = S[0];					
														
									11: tx_out = stop_bit[0];
								endcase	
									
							2://I

								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = iS[7];	
						         4 : tx_out = iS[6];	
									5 : tx_out = iS[5];
									6 : tx_out = iS[4];	
									7 : tx_out = iS[3];	
									8 : tx_out = iS[2];
					            9 : tx_out = iS[1];
									10 : tx_out = iS[0];	
									11: tx_out = stop_bit[0];
									
									endcase
								
							3://-

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
									
									endcase
								
							4://S

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = S[7];	
						         4 : tx_out = S[6];	
									5 : tx_out = S[5];
									6 : tx_out = S[4];	
									7 : tx_out = S[3];	
									8 : tx_out = S[2];
					            9 : tx_out = S[1];
									10 : tx_out = S[0];	
									11: tx_out = stop_bit[0];
									
									endcase
									
								
							5://I

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = iS[7];	
						         4 : tx_out = iS[6];	
									5 : tx_out = iS[5];
									6 : tx_out = iS[4];	
									7 : tx_out = iS[3];	
									8 : tx_out = iS[2];
					            9 : tx_out = iS[1];
									10 : tx_out = iS[0];	
									11: tx_out = stop_bit[0];
									endcase
									
							6: begin
								if(flag_mt==1||flag_mt==2||flag_mt==3)  //M
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = mS[7];	
						         4 : tx_out = mS[6];	
									5 : tx_out = mS[5];
									6 : tx_out = mS[4];	
									7 : tx_out = mS[3];	
									8 : tx_out = mS[2];
					            9 : tx_out = mS[1];
									10 : tx_out = mS[0];	
									11: tx_out = stop_bit[0];
									endcase
								if(flag_vg==1||flag_vg==2||flag_vg==3)   // V
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = vS[7];	
						         4 : tx_out = vS[6];	
									5 : tx_out = vS[5];
									6 : tx_out = vS[4];	
									7 : tx_out = vS[3];	
									8 : tx_out = vS[2];
					            9 : tx_out = vS[1];
									10 : tx_out = vS[0];		
									11: tx_out = stop_bit[0];
									endcase	
								if(flag_ng==1||flag_ng==2||flag_ng==3)  // N
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = nS[7];	
						         4 : tx_out = nS[6];	
									5 : tx_out = nS[5];
									6 : tx_out = nS[4];	
									7 : tx_out = nS[3];	
									8 : tx_out = nS[2];
					            9 : tx_out = nS[1];
									10 : tx_out = nS[0];	
									11: tx_out = stop_bit[0];
									endcase
								if(flag_pp==1||flag_pp==2||flag_pp==3)  // P
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = pS[7];	
						         4 : tx_out = pS[6];	
									5 : tx_out = pS[5];
									6 : tx_out = pS[4];	
									7 : tx_out = pS[3];	
									8 : tx_out = pS[2];
					            9 : tx_out = pS[1];
									10 : tx_out = pS[0];	
									11: tx_out = stop_bit[0];
									endcase	
								end
							7: begin    // 1

								if ((curr_node== 13 && next_node == 26)|| (curr_node== 17 && next_node == 18)|| (curr_node== 29 && next_node == 30)|| (curr_node== 29 && next_node == 32))begin 
								
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = oS[7];	
														4 : tx_out = oS[6];	
														5 : tx_out = oS[5];
														6 : tx_out = oS[4];	
														7 : tx_out = oS[3];	
														8 : tx_out = oS[2];
														9 : tx_out = oS[1];
														10 : tx_out = oS[0];	
														11: tx_out = stop_bit[0];	
											endcase
														
										 end 
										 //2
								 else if ((curr_node== 25 && next_node == 23)||(curr_node== 14 && next_node == 15)||(curr_node== 12 && next_node == 13)||(curr_node== 36 && next_node == 35))begin 
								
													 case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = wS[7];	
														4 : tx_out = wS[6];	
														5 : tx_out = wS[5];
														6 : tx_out = wS[4];	
														7 : tx_out = wS[3];	
														8 : tx_out = wS[2];
														9 : tx_out = wS[1];
														10 : tx_out = wS[0];	
														11: tx_out = stop_bit[0];	
													endcase
																			
										 end
										 //3
								else if (curr_node== 23 && next_node == 21)begin 
								
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = tS[7];	
						         4 : tx_out = tS[6];	
									5 : tx_out = tS[5];
									6 : tx_out = tS[4];	
									7 : tx_out = tS[3];	
									8 : tx_out = tS[2];
					            9 : tx_out = tS[1];
									10 : tx_out = tS[0];	
														11: tx_out = stop_bit[0];	
												endcase		
																			
										 end		 
									
								end	
							8://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
								   3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
									endcase
									
							9:begin 

								if(red_signal==1)  //P
										 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = rS[7];	
												4 : tx_out = rS[6];	
												5 : tx_out = rS[5];
												6 : tx_out = rS[4];	
												7 : tx_out = rS[3];	
												8 : tx_out = rS[2];
												9 : tx_out = rS[1];
												10 : tx_out = rS[0];	
												11: tx_out = stop_bit[0];
											endcase	
									
								else if(green_signal==1)  // N
									 case(clock_count)

										1:	tx_out= idle;
										2:	tx_out=start_bit;
										3 : tx_out = gS[7];	
										4 : tx_out = gS[6];	
										5 : tx_out = gS[5];
										6 : tx_out = gS[4];	
										7 : tx_out = gS[3];	
										8 : tx_out = gS[2];
										9 : tx_out = gS[1];
										10 : tx_out = gS[0];	
										11: tx_out = stop_bit[0];
								  endcase
								
								else if(blue_signal==1)    //W
											 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = bS[7];	
												4 : tx_out = bS[6];	
												5 : tx_out = bS[5];
												6 : tx_out = bS[4];	
												7 : tx_out = bS[3];	
												8 : tx_out = bS[2];
												9 : tx_out = bS[1];
												10 : tx_out = bS[0];	
												11: tx_out = stop_bit[0];
										 endcase
									
									end
								
							10://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
								endcase	
									
								
							11://#

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = hS[7];	
						         4 : tx_out = hS[6];	
									5 : tx_out = hS[5];
									6 : tx_out = hS[4];	
									7 : tx_out = hS[3];	
									8 : tx_out = hS[2];
					            9 : tx_out = hS[1];
									10 : tx_out = hS[0];		
									11: tx_out = stop_bit[0];
								endcase	
									
							
				         12: //new line character
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = n_l[7];	
						         4 : tx_out = n_l[6];	
									5 : tx_out =n_l[5];
									6 : tx_out = n_l[4];	
									7 : tx_out = n_l[3];	
									8 : tx_out = n_l[2];
					            9 : tx_out =n_l[1];
									10 : tx_out = n_l[0];		
									11: tx_out = stop_bit[0];
									endcase
									
							13: begin
									tx_out=  1;
									end
							 
							14: begin
								  message_flag=1;
										curr<=s4; 
								end
								
					 endcase
								
				 end
	
	s4:begin                                //delay for patch detection message so that no multiple messages could get send for a particular signal 
			start_delay=1;
			if(clock_delay_count<115204) tx_out=1;
			if(clock_delay_count==115205) 
				begin 
					message_flag=0;
					depo_message_flag=0;
					pick_message_flag=0;
					curr<=s0;
				end
	   end
		
	s3:begin                                    //delay for pick and deposit message so that no multiple messages could get send for a particular signal 
			start_delay=1;
			if(clock_delay_count<460824) tx_out=1;
			if(clock_delay_count==460825) 
				begin 
					message_flag=0;
					depo_message_flag=0;
					pick_message_flag=0;
					if(done_all ==1) tx_out=1;
					else curr<=s0;
				end
	   end
		
	s5:   begin                                // state  for pick message
						start_frame=1;
						case(frame)

							1: //S                             
																		  
								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
                           3 : tx_out = S[7];	
						         4 : tx_out = S[6];	
									5 : tx_out = S[5];
									6 : tx_out = S[4];	
									7 : tx_out = S[3];	
									8 : tx_out = S[2];
					            9 : tx_out = S[1];
									10 : tx_out = S[0];								
														
									11: tx_out = stop_bit[0];
								endcase	
									
									
							2://-

								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];		
									11: tx_out = stop_bit[0];
									
									endcase
									
							3://P

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = pS[7];	
						         4 : tx_out = pS[6];	
									5 : tx_out = pS[5];
									6 : tx_out = pS[4];	
									7 : tx_out = pS[3];	
									8 : tx_out = pS[2];
					            9 : tx_out = pS[1];
									10 : tx_out = pS[0];		
									11: tx_out = stop_bit[0];
									
									endcase
									
							4://-

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
									
									endcase
									
							5:  //D

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = DS[7];	
						         4 : tx_out = DS[6];	
									5 : tx_out = DS[5];
									6 : tx_out = DS[4];	
									7 : tx_out = DS[3];	
									8 : tx_out = DS[2];
					            9 : tx_out = DS[1];
								   10: tx_out = DS[0];	
									11: tx_out = stop_bit[0];
									endcase
									
							6:    //Z
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = zS[7];	
						         4 : tx_out = zS[6];	
									5 : tx_out = zS[5];
									6 : tx_out = zS[4];	
									7 : tx_out = zS[3];	
									8 : tx_out = zS[2];
					            9 : tx_out = zS[1];
								   10 : tx_out = zS[0];	
									11: tx_out = stop_bit[0];
									endcase		


							7:  begin
								if(flag_mt==4||flag_mt==5||flag_mt==6||flag_mt==7||flag_mt==8||flag_mt==9) //M
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = mS[7];	
						         4 : tx_out = mS[6];	
									5 : tx_out = mS[5];
									6 : tx_out = mS[4];	
									7 : tx_out = mS[3];	
									8 : tx_out = mS[2];
					            9 : tx_out = mS[1];
									10 : tx_out = mS[0];	
									11: tx_out = stop_bit[0];
									endcase
								if(flag_vg==4||flag_vg==5||flag_vg==6||flag_vg==7) // V
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = vS[7];	
						         4 : tx_out = vS[6];	
									5 : tx_out = vS[5];
									6 : tx_out = vS[4];	
									7 : tx_out = vS[3];	
									8 : tx_out = vS[2];
					            9 : tx_out = vS[1];
									10 : tx_out = vS[0];		
									11: tx_out = stop_bit[0];
									endcase	
								if(flag_ng==4||flag_ng==5||flag_ng==6 ||flag_ng==7) // N
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = nS[7];	
						         4 : tx_out = nS[6];	
									5 : tx_out = nS[5];
									6 : tx_out = nS[4];	
									7 : tx_out = nS[3];	
									8 : tx_out = nS[2];
					            9 : tx_out = nS[1];
									10 : tx_out = nS[0];	
									11: tx_out = stop_bit[0];
									endcase
								if(flag_pp==4||flag_pp==5||flag_pp==6 ||flag_pp==7) //P
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = pS[7];	
						         4 : tx_out = pS[6];	
									5 : tx_out = pS[5];
									6 : tx_out = pS[4];	
									7 : tx_out = pS[3];	
									8 : tx_out = pS[2];
					            9 : tx_out = pS[1];
									10 : tx_out = pS[0];	
									11: tx_out = stop_bit[0];
									endcase	
								end
								
							8: begin//1

								if (end_node_temp1 == 27 || end_node_temp1 == 19 || end_node_temp1 == 31 || end_node_temp1 == 27 || end_node_temp1 == 33)
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = oS[7];	
														4 : tx_out = oS[6];	
														5 : tx_out = oS[5];
														6 : tx_out = oS[4];	
														7 : tx_out = oS[3];	
														8 : tx_out = oS[2];
														9 : tx_out = oS[1];
														10 : tx_out = oS[0];	
														11: tx_out = stop_bit[0];	
											endcase
														
										//2
								 else if (end_node_temp1 == 24 || end_node_temp1 == 20 || end_node_temp1 == 28 || end_node_temp1 == 34 )
													 case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = wS[7];	
														4 : tx_out = wS[6];	
														5 : tx_out = wS[5];
														6 : tx_out = wS[4];	
														7 : tx_out = wS[3];	
														8 : tx_out = wS[2];
														9 : tx_out = wS[1];
														10 : tx_out = wS[0];	
														11: tx_out = stop_bit[0];	
													endcase
																			
						       //3
								else if (end_node_temp1 == 22)
								
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = tS[7];	
														4 : tx_out = tS[6];	
														5 : tx_out = tS[5];
														6 : tx_out = tS[4];	
														7 : tx_out = tS[3];	
														8 : tx_out = tS[2];
														9 : tx_out = tS[1];
														10 : tx_out = tS[0];	
														11: tx_out = stop_bit[0];	
												endcase				 
									
								end	
								

							9://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];		
									11: tx_out = stop_bit[0];
									endcase
							10:begin  //P

								if(((sim1== "R" && flag_mt== 5)||( sim2== "R"&& flag_mt== 7)||(sim3== "R" && flag_mt== 9 )) ||
								   ((sin1== "R" && flag_ng== 5)||( sin2== "R"&& flag_ng== 7)) || ((siv1== "R" && flag_vg== 5)||( siv2== "R"&& flag_vg== 7))
									|| ((sip1== "R" && flag_pp== 5)||( sip2== "R"&& flag_pp== 7)))
										 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = rS[7];	
												4 : tx_out = rS[6];	
												5 : tx_out = rS[5];
												6 : tx_out = rS[4];	
												7 : tx_out = rS[3];	
												8 : tx_out = rS[2];
												9 : tx_out = rS[1];
												10 : tx_out = rS[0];	
												11: tx_out = stop_bit[0];
											endcase	
									//N
								else if(((sim1== "G" && flag_mt== 5)||( sim2== "G"&& flag_mt== 7)||(sim3== "G" && flag_mt== 9 )) ||
								   ((sin1== "G" && flag_ng== 5)||( sin2== "G"&& flag_ng== 7)) || ((siv1== "G" && flag_vg== 5)||( siv2== "G"&& flag_vg== 7))
									|| ((sip1== "G" && flag_pp== 5)||( sip2== "G"&& flag_pp== 7)))
									 case(clock_count)

										1:	tx_out= idle;
										2:	tx_out=start_bit;
										3 : tx_out = gS[7];	
										4 : tx_out = gS[6];	
										5 : tx_out = gS[5];
										6 : tx_out = gS[4];	
										7 : tx_out = gS[3];	
										8 : tx_out = gS[2];
										9 : tx_out = gS[1];
										10 : tx_out = gS[0];
										11: tx_out = stop_bit[0];
								  endcase
								  //W
								else if(((sim1== "B" && flag_mt== 5)||( sim2== "B"&& flag_mt== 7)||(sim3== "B" && flag_mt== 9 )) ||
								   ((sin1== "B" && flag_ng== 5)||( sin2== "B"&& flag_ng== 7)) || ((siv1== "B" && flag_vg== 5)||( siv2== "B"&& flag_vg== 7))
									|| ((sip1== "B" && flag_pp== 5)||( sip2== "B"&& flag_pp== 7)))
											 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = bS[7];	
												4 : tx_out = bS[6];	
												5 : tx_out = bS[5];
												6 : tx_out = bS[4];	
												7 : tx_out = bS[3];	
												8 : tx_out = bS[2];
												9 : tx_out = bS[1];
												10 : tx_out = bS[0];
												11: tx_out = stop_bit[0];
										 endcase
									
									end
																	
							11://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
								endcase	
									
								
							12://#

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = hS[7];	
						         4 : tx_out = hS[6];	
									5 : tx_out = hS[5];
									6 : tx_out = hS[4];	
									7 : tx_out = hS[3];	
									8 : tx_out = hS[2];
					            9 : tx_out = hS[1];
									10: tx_out = hS[0];		
									11: tx_out = stop_bit[0];
								endcase	
								
								
							13://new line charater

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = n_l[7];	
						         4 : tx_out = n_l[6];	
									5 : tx_out =n_l[5];
									6 : tx_out = n_l[4];	
									7 : tx_out = n_l[3];	
									8 : tx_out = n_l[2];
					            9 : tx_out =n_l[1];
									10 : tx_out = n_l[0];		
									11: tx_out = stop_bit[0];
								endcase	
								
							14: begin
								  pick_message_flag=1;
										curr<=s3; 
								end
									
			 
					 endcase
								
				 end	
	s6:   begin                    // state for deposit message
						start_frame=1;
						case(frame)

							1: //S                            
																		  
								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
                           3 : tx_out = S[7];	
						         4 : tx_out = S[6];	
									5 : tx_out = S[5];
									6 : tx_out = S[4];	
									7 : tx_out = S[3];	
									8 : tx_out = S[2];
					            9 : tx_out = S[1];
									10: tx_out = S[0];								
														
									11: tx_out = stop_bit[0];
								endcase	
									
							2://-

								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];		
									11: tx_out = stop_bit[0];
									
									endcase
									
							3://D

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = DS[7];	
						         4 : tx_out = DS[6];	
									5 : tx_out = DS[5];
									6 : tx_out = DS[4];	
									7 : tx_out = DS[3];	
									8 : tx_out = DS[2];
					            9 : tx_out = DS[1];
								   10: tx_out = DS[0];	
									11: tx_out = stop_bit[0];
									
									endcase
									
							4://-

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];		
									11: tx_out = stop_bit[0];
									
									endcase
									
							5://D

								case(clock_count)
								  1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = DS[7];	
						         4 : tx_out = DS[6];	
									5 : tx_out = DS[5];
									6 : tx_out = DS[4];	
									7 : tx_out = DS[3];	
									8 : tx_out = DS[2];
					            9 : tx_out = DS[1];
								   10: tx_out = DS[0];	
									11: tx_out = stop_bit[0];
									endcase
									
							6: //Z
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = zS[7];	
						         4 : tx_out = zS[6];	
									5 : tx_out = zS[5];
									6 : tx_out = zS[4];	
									7 : tx_out = zS[3];	
									8 : tx_out = zS[2];
					            9 : tx_out = zS[1];
								   10 : tx_out = zS[0];	
									11: tx_out = stop_bit[0];
									endcase		


							7:  begin 
							   //M
								if(flag_mt==4||flag_mt==5||flag_mt==6||flag_mt==7||flag_mt==8||flag_mt==9||(flag_mt==10&&(curr_node==22 || curr_node==24 || curr_node==27)))
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = mS[7];	
						         4 : tx_out = mS[6];	
									5 : tx_out = mS[5];
									6 : tx_out = mS[4];	
									7 : tx_out = mS[3];	
									8 : tx_out = mS[2];
					            9 : tx_out = mS[1];
									10 : tx_out = mS[0];	
									11: tx_out = stop_bit[0];
									endcase
								//V	
								if(flag_vg==4||flag_vg==5||flag_vg==6||flag_vg==7||(flag_vg==8&&(curr_node==28 || curr_node ==31)))
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = vS[7];	
						         4 : tx_out = vS[6];	
									5 : tx_out = vS[5];
									6 : tx_out = vS[4];	
									7 : tx_out = vS[3];	
									8 : tx_out = vS[2];
					            9 : tx_out = vS[1];
									10 : tx_out = vS[0];		
									11: tx_out = stop_bit[0];
									endcase	
								//N	
								if(flag_ng==4||flag_ng==5||flag_ng==6 ||flag_ng==7||(flag_ng==8&&(curr_node==20 || curr_node==19 )))
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = nS[7];	
						         4 : tx_out = nS[6];	
									5 : tx_out = nS[5];
									6 : tx_out = nS[4];	
									7 : tx_out = nS[3];	
									8 : tx_out = nS[2];
					            9 : tx_out = nS[1];
									10 : tx_out = nS[0];	
									11: tx_out = stop_bit[0];
									endcase
									//P
								if(flag_pp==4||flag_pp==5||flag_pp==6||flag_pp==7||(flag_pp==8&&(curr_node==34 || curr_node == 33)))
									case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = pS[7];	
						         4 : tx_out = pS[6];	
									5 : tx_out = pS[5];
									6 : tx_out = pS[4];	
									7 : tx_out = pS[3];	
									8 : tx_out = pS[2];
					            9 : tx_out = pS[1];
									10 : tx_out = pS[0];	
									11: tx_out = stop_bit[0];
									endcase	
								end
							8: begin//1

								if ((curr_node== 27)|| (curr_node== 19 )|| (curr_node== 31 )|| (curr_node== 33 ))begin 
								
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = oS[7];	
														4 : tx_out = oS[6];	
														5 : tx_out = oS[5];
														6 : tx_out = oS[4];	
														7 : tx_out = oS[3];	
														8 : tx_out = oS[2];
														9 : tx_out = oS[1];
														10 : tx_out = oS[0];
														11: tx_out = stop_bit[0];	
											endcase
														
										 end
										 //2
								 else if ((curr_node== 24 )||(curr_node== 20 )||(curr_node== 28 )||(curr_node== 34 ))begin 
								
													 case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = wS[7];	
														4 : tx_out = wS[6];	
														5 : tx_out = wS[5];
														6 : tx_out = wS[4];	
														7 : tx_out = wS[3];	
														8 : tx_out = wS[2];
														9 : tx_out = wS[1];
														10 : tx_out = wS[0];
														11: tx_out = stop_bit[0];	
													endcase
																			
										 end
										 //3
								else if (curr_node== 22)begin 
								
											  case(clock_count)
														1:	tx_out= idle;
														2:	tx_out=start_bit;
														3 : tx_out = tS[7];	
														4 : tx_out = tS[6];	
														5 : tx_out = tS[5];
														6 : tx_out = tS[4];	
														7 : tx_out = tS[3];	
														8 : tx_out = tS[2];
														9 : tx_out = tS[1];
														10 : tx_out = S[0];
														11: tx_out = stop_bit[0];	
												endcase		
																			
										 end		 
									
								end	
								
							9://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];		
									11: tx_out = stop_bit[0];
									endcase
									
							10:begin
                          //P
								if((sim1== "R" && curr_node==27)||( sim2== "R"&& curr_node==24)||(sim3== "R" && curr_node==22 ) || 
								  (sin1== "R" && curr_node==19)||( sin2== "R"&& curr_node==20) || (siv1== "R" && curr_node==31)||( siv2== "R"&& curr_node==28)
								  || (sip1== "R" && curr_node==33)||( sip2== "R"&& curr_node==34))
										 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = rS[7];	
												4 : tx_out = rS[6];	
												5 : tx_out = rS[5];
												6 : tx_out = rS[4];	
												7 : tx_out = rS[3];	
												8 : tx_out = rS[2];
												9 : tx_out = rS[1];
												10 : tx_out = rS[0];	
												11: tx_out = stop_bit[0];
											endcase	
									//N
								else if((sim1== "G" && curr_node==27)||( sim2== "G"&& curr_node==24)||(sim3== "G" && curr_node==22 ) || 
								  (sin1== "G" && curr_node==19)||( sin2== "G"&& curr_node==20) || (siv1== "G" && curr_node==31)||( siv2== "G"&& curr_node==28)
								  || (sip1== "G" && curr_node==33)||( sip2== "G"&& curr_node==34))
									 case(clock_count)

										1:	tx_out= idle;
										2:	tx_out=start_bit;
										3 : tx_out = gS[7];	
										4 : tx_out = gS[6];	
										5 : tx_out = gS[5];
										6 : tx_out = gS[4];	
										7 : tx_out = gS[3];	
										8 : tx_out = gS[2];
										9 : tx_out = gS[1];
										10 : tx_out = gS[0];
										11: tx_out = stop_bit[0];
								  endcase
								  //W
								else if((sim1== "B" && curr_node==27)||( sim2== "B"&& curr_node==24)||(sim3== "B" && curr_node==22 ) || 
								  (sin1== "B" && curr_node==19)||( sin2== "B"&& curr_node==20) || (siv1== "B" && curr_node==31)||( siv2== "B"&& curr_node==28)
								  || (sip1== "B" && curr_node==33)||( sip2== "B"&& curr_node==34))
											 case(clock_count)

												1:	tx_out= idle;
												2:	tx_out=start_bit;
												3 : tx_out = bS[7];	
												4 : tx_out = bS[6];	
												5 : tx_out = bS[5];
												6 : tx_out = bS[4];	
												7 : tx_out = bS[3];	
												8 : tx_out = bS[2];
												9 : tx_out = bS[1];
												10 : tx_out = bS[0];
												11: tx_out = stop_bit[0];
										 endcase
									
									end
								
							11://-

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = dS[7];	
						         4 : tx_out = dS[6];	
									5 : tx_out = dS[5];
									6 : tx_out = dS[4];	
									7 : tx_out = dS[3];	
									8 : tx_out = dS[2];
					            9 : tx_out = dS[1];
									10: tx_out = dS[0];	
									11: tx_out = stop_bit[0];
								endcase	
									
								
							12://#

								case(clock_count)

									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = hS[7];	
						         4 : tx_out = hS[6];	
									5 : tx_out = hS[5];
									6 : tx_out = hS[4];	
									7 : tx_out = hS[3];	
									8 : tx_out = hS[2];
					            9 : tx_out = hS[1];
									10 : tx_out = hS[0];			
									11: tx_out = stop_bit[0];
								endcase
							
						   13://new line character

								case(clock_count)
									1:	tx_out= idle;
									2:	tx_out=start_bit;
									3 : tx_out = n_l[7];	
						         4 : tx_out = n_l[6];	
									5 : tx_out =n_l[5];
									6 : tx_out = n_l[4];	
									7 : tx_out = n_l[3];	
									8 : tx_out = n_l[2];
					            9 : tx_out =n_l[1];
									10 : tx_out = n_l[0];		
									11: tx_out = stop_bit[0];
								endcase	
								
							14: begin
								  depo_message_flag=1;
										curr<=s3; 
								end
								
					 endcase
								
				 end
		
 endcase
end

assign tx = tx_out;


reg blink_clock=0;

reg [23:0]counter_blink=0;


always @(posedge clk_50M) begin // 50M/2 -1


if(done_all==1)begin   // code for blinking blue light with delay of 0.5 sec after completing task 
			
	if(counter_blink==12500000) begin
	
							blue_on1=~blue_on1;
							blue_on2=~blue_on2;
							blue_on3=~blue_on3;
				
				counter_blink = 1; 
				end
			
	else  counter_blink=counter_blink+1;
	 
end

else begin                                               //condition for turning on different leds for different patches
		
			if(flag_mt == 1 || flag_mt == 2 || flag_mt == 3 ) begin   // (e.g. flag_mt->(1 to 3) for detecting patch for paticular maize terrain)

			if(green_signal==1 && sim1== "G"  && curr_node== 13  && next_node ==26 )green_on1=1;
			if(blue_signal==1 &&  sim1== "B" && curr_node== 13  && next_node ==26  )blue_on1=1;
			if(red_signal==1 && sim1== "R" && curr_node== 13  && next_node ==26 )red_on1=1;

			if(green_signal==1 && sim2== "G" &&   curr_node== 25 && next_node == 23 )green_on2=1;
			if(blue_signal==1 &&  sim2== "B"&&   curr_node== 25 && next_node == 23 )blue_on2=1;
			if(red_signal==1 && sim2== "R"&&   curr_node== 25 && next_node == 23 )red_on2=1;

			if(green_signal==1 && sim3== "G"&& curr_node==  23 && next_node == 21)green_on3=1;
			if(blue_signal==1 &&  sim3== "B"&& curr_node==  23 && next_node == 21)blue_on3=1;
			if(red_signal==1 && sim3 == "R"&& curr_node==  23 && next_node == 21 )red_on3=1;
end

if(flag_vg == 1 || flag_vg == 2 || flag_vg == 3  ) begin 

			if(green_signal==1 && siv1== "G"  && curr_node== 29 && next_node == 30)green_on1=1;
			if(blue_signal==1 &&  siv1== "B" && curr_node== 29 && next_node == 30)blue_on1=1;
			if(red_signal==1 && siv1== "R" && curr_node== 29 && next_node == 30)red_on1=1;

			if(green_signal==1 && siv2== "G" && curr_node== 12 && next_node == 13)green_on2=1;
			if(blue_signal==1 &&  siv2== "B"&& curr_node== 12 && next_node == 13)blue_on2=1;
			if(red_signal==1 && siv2== "R"&& curr_node== 12 && next_node == 13)red_on2=1;

end

if(flag_pp == 1 || flag_pp == 2 || flag_pp == 3  ) begin 

			if(green_signal==1 && sip1== "G"  && curr_node== 29 && next_node == 32)green_on1=1;
			if(blue_signal==1 &&  sip1== "B" && curr_node== 29 && next_node == 32)blue_on1=1;
			if(red_signal==1 && sip1== "R" && curr_node== 29 && next_node == 32)red_on1=1;

			if(green_signal==1 && sip2== "G" && curr_node==  36&& next_node == 35)green_on2=1;
			if(blue_signal==1 &&  sip2== "B"&& curr_node== 36 && next_node == 35)blue_on2=1;
			if(red_signal==1 && sip2== "R"&& curr_node== 36 && next_node == 35)red_on2=1;
end

if(flag_ng == 1 || flag_ng == 2 || flag_ng == 3  ) begin 

			if(green_signal==1 && sin1== "G"  && curr_node== 17 && next_node == 18)green_on1=1;
			if(blue_signal==1 &&  sin1== "B" && curr_node== 17 && next_node == 18)blue_on1=1;
			if(red_signal==1 && sin1== "R" && curr_node== 17 && next_node ==18 )red_on1=1;

			if(green_signal==1 && sin2== "G" && curr_node== 14 && next_node == 15)green_on2=1;
			if(blue_signal==1 &&  sin2== "B"&& curr_node== 14 && next_node == 15)blue_on2=1;
			if(red_signal==1 && sin2== "R"&& curr_node== 14 && next_node == 15)red_on2=1;

end

if(depo_signal==1&&pick_signal==0  )begin                     // code for turning off light after delivering block on deposstion zone
			
  if( (curr_node== 27 ) || (curr_node== 19 ) || (curr_node== 31 )|| (curr_node== 33 ) )begin
			green_on1=0;
         blue_on1=0;
         red_on1 =0;
	end
  if(( curr_node==  24)|| (curr_node== 20  ) || (curr_node== 28  )|| (curr_node== 34 ) )begin
			green_on2=0;
         blue_on2=0;
         red_on2 =0;
	end
	if( (curr_node== 22 ))begin
			green_on3=0;
         blue_on3=0;
         red_on3 =0;
	end
end

end
	
end

endmodule
///////////////////////////////MODULE ENDS///////////////////////////