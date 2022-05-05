/*
  * Team Id         :   SM#2300  
  
  * Author List     :   Ashwini kumar, Ankit kumar
	 
  * Filename        :   SM_2300_Task6_adc_control
	 
  * Theme           :   Soil Monitoring Robot
	 
  * Functions/Tasks :   black Line Following() , e_on() , e_off() ,rotate_right(), rotate_left(),stop_bot(), node_rotation_right(), node_rotation_left(), node_rotation_backward(),
	                     orientation(), find_path(), min_vertex(), relax_edge(), dijkstra(),dijkstra_1(), dijk_n_travel(), path_state(), finding_min_dist(), set_block(),
	
  * Global variables: 	min_found, data_frame, done, done_path, node_i, d_out_ch5, d_out_ch6, d_out_ch7,	temp_din, pwm_out, count,temp_din, data_temp, count_cycle, 			    
	                     data_frame_temp, data_temp_temp1,data_temp_temp2,data_temp_temp3,adc_clock, clock_duty, DUTY_CYCLE,DUTY_CYCLE_1,PWM_OUT_reg,
							   start,i,j,cnt,minimum, end_node,vertex, done_dij,start_1,i_1,j_1,cnt_1,minimum_1, end_node_1,vertex_1, done_dij_1, left_ch,centre_ch,
								right_ch,counter, clock_1khz,end_node_min,end_node_temp1, i_1,j_1,cnt_1, done_ng, done_mt=0,done_vg,done_pp,flag_mt,flag_vg,flag_ng, flag_pp, 
								delay_value_temp,delta_x,delta_y, orientation_temp, node_detection, node_detection_edge_0,node_detection_edge,
								start_delay,clock_delay_count,node_detection,node_detection_flag, node_state,count_node_green, count_node_blue, count_node_red,node_red_1
								node_green_1, node_blue,node_green, node_blue_1, node_red,clock_ms, count_ms  
*/



module SM_2300_Task6_adc_control(input  clk_50M,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)q
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	
	
	output PWM_OUT,       //pwm signal which is being provided to motors
	input green_signal, 
	input blue_signal,
	input red_signal,
	output reg [10:0]o0 ,  //  (o1 and  o1) storing mininum distance from a particular node
   output reg [10:0]o1 ,

	
   output reg [7:0] sim1, sim2, sim3,siv1,siv2,sin1,sin2,sip1,sip2, // variables for storing color value
	
   output reg inA1, inB1, inA2, inB2,                          // motor driver output terminals
   output reg [6:0]curr_node , next_node,end_node_temp1,
	output reg EA1, EA2,                                       // two terminals for electromagnet
	output reg depo_signal,
	output reg	pick_signal,
	output reg [4:0] flag_ng,flag_mt ,flag_vg ,flag_pp,      // flags to indicate specfic terrain work is done
	output reg done_all                                      // signal for indicating complete task Done
 

);

reg min_found=0;  // signal for indicating that minimum distance from a particular start node has been found 

wire [1:0]data_frame;

reg done=0;       
reg done_path=0;



reg  [6:0]node_i=0;   // variable for node counter
wire[11:0]d_out_ch5;	    //12-bit output of ch. 5 (parallel)
wire[11:0]d_out_ch6;	//12-bit output of ch. 6 (parallel)
wire [11:0]d_out_ch7; //12-bit output of ch. 7(parallel)





initial begin
	pick_signal=0;
	depo_signal=0;
	 done_all=0;
end


reg [7:0] s[0:6][0:1];    //memory for storing input placement order of blocks 

initial
          //node
 begin 
		 s[0][0]=2;    
		 s[1][0]=3;
		 s[2][0]=5;
		 s[3][0]=6;
		 s[4][0]=9;
		 s[5][0]=8;
		 s[6][0]=10;
		 
			  //color
		 s[0][1]="R";    
		 s[1][1]="G";
		 s[2][1]="B";
		 s[3][1]="N";
		 s[4][1]="R";
		 s[5][1]="G";
		 s[6][1]="N";
 
 end

///////////////////////////    ADC conversion start/////////////////////////////////////////////////////
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
begin                         //code for selecting  differnt channels (i.e. 5,6,7)


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
   9  : data_temp[7] <= dout;
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
   9  : data_temp[7] <= dout;
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
   9  : data_temp[7] <= dout;
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

////////////////////////////////////////  ADC conversion end                 ///////////////////////////////////////////////////////////////////


//////////////////   Generation of PWM signal for motor start /////////////////////////////////////////////////
reg [15:0] count_duty =0;
reg [10:0] DUTY_CYCLE=33;
reg [10:0] DUTY_CYCLE_1=90;
reg clock_1khz=0;

reg PWM_OUT_reg=0;

always@(posedge clk_50M)
begin
if(curr_node==32&&node_detection==1)

	begin
	if(count_duty==27777)
		begin
			count_duty=1;
		end
	else
		begin
			count_duty=count_duty+1;
		
		end
	PWM_OUT_reg=(count_duty*100/27777 <= DUTY_CYCLE_1);
	
	end
	
else
	begin
	if(count_duty==27777)
		begin
			count_duty=1;
		end
	else
		begin
			count_duty=count_duty+1;
		
		end
	PWM_OUT_reg=(count_duty*100/27777 <= DUTY_CYCLE);
	end

end

assign PWM_OUT= PWM_OUT_reg;



///////////////////////////////////   Generation of PWM signal for motor end  ////////////////////////////////////////////////////////////////////////

/////////////////////////// thresholding the  line sensor channel values according to black line and white surface ///////////////////////////

parameter [10:0]pwm_p= 510;             // threshold value   
wire left_ch, right_ch, centre_ch;

assign left_ch=(d_out_ch5>pwm_p)?1:0;
assign right_ch=(d_out_ch7>pwm_p)?1:0;
assign centre_ch=(d_out_ch6>pwm_p)?1:0;



reg [23:0]count_1khz =0;

always @(posedge clk_50M)     // code for generating 1KHz clock
begin 
if(count_1khz == 25000) begin 
  clock_1khz = ~clock_1khz;
  count_1khz = 1; end
else 
  count_1khz = count_1khz +1;  // 50 000000/1000
end


reg high = 1;
reg low =0;

/*
  * Task Name  : black_line_following
  * Input      : None
  * Output     : None
  * Logic      : depending upon the value of sensor channels the bot follows the black line (turning left or right or forward).
  * Example    : black_line_following();
*/

task black_line_following;

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

	if(( left_ch==0 &&centre_ch==1 && right_ch==0 ))
		begin

		//straight bot 
		inA1 = high;
		inA2 =low;

		inB1 = high; 
		inB2 = low; 
		
		end
		
		
	if((left_ch==1 && centre_ch==1 && right_ch==0)) 
		begin
		
		//straight bot 
		inA1 = high;
		inA2 =low;

		inB1 = high; 
		inB2 = low;
		end

			
	if((left_ch==0 && centre_ch==1 && right_ch==1)) 
		begin
		//straight bot 
		inA1 = high;
		inA2 =low;

		inB1 = high; 
		inB2 = low; 
		 
		end
		
	if((left_ch==1 && centre_ch==1 && right_ch==1)) 
		begin
		if(curr_node==32)begin
		inA1 = PWM_OUT;
		inA2 =low;

		inB1 = PWM_OUT; 
		inB2 = low;
		end
		//straight bot
		else begin
		inA1 = high;
		inA2 =low;

		inB1 = high; 
		inB2 = low;
			end
		end

endtask

/*
  * Task Name  : rotate_left
  * Input      : None
  * Output     : None
  * Logic      : turning left ,left wheel move backward and right wheel move forward   
  * Example    : rotate_left();
*/

task rotate_left();
//left
inA1 = low;
inA2 =high;

inB1 = high; 
inB2 = low; 

endtask

/*
  * Task Name  : rotate_right
  * Input      : None
  * Output     : None
  * Logic      : stop   
  * Example    : stop_bot();
*/

task stop_bot();
inA1 = high;
inA2 =high;

inB1 = high; 
inB2 = high;

endtask

/*
  * Task Name  : rotate_right
  * Input      : None
  * Output     : None
  * Logic      : turning right, right wheel move backward and left wheel move forward   
  * Example    : rotate_right();
*/

task rotate_right();

//right
inA1 = high;
inA2 =low;
inB1 = low; 
inB2 = high; 

endtask

/*
  * Task Name  : e_on
  * Input      : None
  * Output     : None
  * Logic      : electromagnetic on
  * Example    :  e_on();
*/

task e_on();    // electromagnetic on
EA1=high;
 EA2=low;
 
 endtask
 
 
/*
  * Task Name  : e_off
  * Input      : None
  * Output     : None
  * Logic      : electromagnetic off
  * Example    :  e_off();
*/

 
task e_off();   
EA1=low;
 EA2=low;
 
 endtask

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////// dijkstra algo start  ////////////////////////////////////////////////////


reg [6:0] start;  // start node

reg [1:0] processed[36:0]; 

reg [6:0] i,j,cnt;

reg [10:0] val [36:0];   // memory for storing distance for a particular node from every other nodes
     
reg [10:0] cost [36:0][V-1:0];  // weight between  nodes 
reg [5:0] parent [36:0];      // memory for storing the previous node of a particular node
integer minimum = INT_MAX;    //  variable for storing minimum distance value from a particular node
reg [6:0] end_node;



reg [5:0] vertex;    /// variable for storing closest node
 
reg done_dij=0;



/*
  * Task Name  : min_vertex
  * Input      : None
  * Output     : None
  * Logic      : traversing distance mem (i.e val[]) and storing the closest neighbouring node into (vertex) if that node is not taken(i.e. processed) before
  * Example    : min_vertex();
*/
 
  
task min_vertex;    
begin 
	minimum=INT_MAX;
	
	for(i=0;i< (V);i= i+1)
	begin
		
		if(processed[i]==0 && val[i]<minimum )
		begin
			vertex = i;
			minimum = val[i];
			
		end
	end
	
end
endtask

/*
  * Task Name  : relax_edge
  * Input      : None
  * Output     : None
  * Logic      :  3 conditions to relax:-
                       1.Edge is present from vertex to j.
			              2.Vertex j is not included in shortest path graph
			              3.Edge weight is smaller than current edge weight
			
  * Example    : relax_edge();
*/
 

task relax_edge ;  
begin

for( j=0;j< V;j =j+1)
		begin
		if(cost[vertex][j]!=0 && processed[j]==0 && cost[vertex][j]!=inf && (val[vertex]+cost[vertex][j] < val[j]))
			begin
				val[j] = val[vertex]+cost[vertex][j];
				parent[j] = vertex;
				
			end
		end
end		
endtask		

    
parameter state_0=4'd0,
			 state_1=4'd1,
			 state_2=4'd2,
			 state_3=4'd3,
			 state_4=4'd4,
			 state_5=4'd5,
			 state_6=4'd6,
			 state_7=4'd7;
			

reg [3:0] curr_state= state_0;
/*
  * Task Name  : dijkstra
  * Input      : None
  * Output     : None
  * Logic      :   conditions to follow:-
                       1. initializing cost array, parent array, val array, processed array
			              2. finding minimum vertex which is closest among all the neighbouring nodes fromstart node
			              3. update the node (say processed) so that next time that will not get taken 
							  4. relax edge (i.e. updating neighbouring node distance)
			              5. this 4 steps(1,2,3,4) will be continously happenning untill all the edges(i.e.V-1) are not taken
  * Example    : dijkstra();
*/
 


task dijkstra();
begin
 
case(curr_state)
	state_0:	begin
						cnt = 0;              // initialization of varaibles 
						node_i=0;
						
					   for (i =0; i< 37; i=i+1) begin 
						  val[i] = INT_MAX;
						  parent[i] = 0;                     
						  processed[i] = 0;
						  end
						
				for (i=0; i< 37; i= i+1)        //generating graph 
				  for (j=0 ; j< 37; j= j+1)
						if (i== j)
							cost[i][j] =0;
							else if ((i ==0 && j == 1)|| (i ==1 && j == 0))
							cost[i][j] =5;
								
							else if ((i ==1 && j == 2)|| (i ==2 && j == 1))
							cost[i][j] =5;
									  
							else if ((i ==1 && j == 3)|| (i ==3 && j == 1))
							cost[i][j] =5;
									  
							else if ((i ==1 && j == 4)|| (i ==4 && j == 1))
							cost[i][j] =5;
									  
							else if ((i ==4 && j == 5)|| (i ==5 && j == 4))
							cost[i][j] =5;
									  
							else if ((i ==4 && j == 6)|| (i == 6&& j == 4))
							cost[i][j] =5;
									  
							else if ((i == 4&& j ==7 )|| (i == 7&& j ==4 ))
							cost[i][j] =5;
							
							else if ((i == 7&& j ==8 )|| (i == 8&& j ==7 ))
							cost[i][j] =5;
							
							else if ((i ==7 && j == 9)|| (i ==9 && j == 7))
							cost[i][j] =5;
							
							else if ((i == 7&& j == 11)|| (i ==11 && j ==7 ))
							cost[i][j] =5;
							
							else if ((i == 11&& j == 12)|| (i ==12 && j == 11))
							cost[i][j] =5;
							
							else if ((i == 11&& j == 10)|| (i ==10 && j == 11))
							cost[i][j] =5 ;
							
							else if ((i == 12 && j == 13)|| (i == 13&& j == 12 ))
							cost[i][j] = 10;//
							
							
							else if ((i ==13 && j ==14 )|| (i ==14 && j ==13 ))
							cost[i][j] =5;
							
							else if ((i ==13 && j ==28 )|| (i ==28 && j ==13))
							cost[i][j] =5;
							
							else if ((i ==13 && j ==26 )|| (i ==26 && j == 13))
							cost[i][j] =9;
							
							else if ((i ==26 && j == 27)|| (i ==27 && j ==26 ))
							cost[i][j] =5;
						
							else if ((i ==26 && j ==25 )|| (i ==25 && j ==26 ))
							cost[i][j] =12;
				
							else if ((i ==25 && j ==23 )|| (i ==23 && j ==25 ))
							cost[i][j] =6;
							
							else if ((i ==25 && j ==0 )|| (i ==0&& j ==25 ))
							cost[i][j] =10;
							
							else if ((i ==23 && j ==24 )|| (i ==24&& j ==23 ))
							cost[i][j] =5;
							
							else if ((i == 23&& j ==21 )|| (i ==21 && j ==23 ))
							cost[i][j] =20;
						  
							else if ((i ==21 && j ==22 )|| (i ==22 && j ==21 ))
							cost[i][j] =5;
						  
						
						  else if ((i ==21 && j ==16 )|| (i ==16 && j ==21 ))
						  cost[i][j] =8;
						  
						  else if ((i ==14&& j ==18 )|| (i ==18&& j ==14 ))
						  cost[i][j] =10;
						  
						  else if ((i ==14 && j ==15 )|| (i ==15 && j ==14 ))
						  cost[i][j] =7;
						  else if ((i ==15 && j ==20 )|| (i ==20 && j ==15 ))
						  cost[i][j] =5;
						  
						  else if ((i ==15 && j ==16 )|| (i ==16 && j ==15 ))
						  cost[i][j] =5;
						  
						  else if ((i ==16 && j ==17 )|| (i ==17 && j ==16 ))
						  cost[i][j] =25;
						  
						  else if ((i ==18 && j ==19 )|| (i ==19 && j ==18 ))
						  cost[i][j] =5;
						  
						  else if ((i ==18 && j ==17 )|| (i ==17 && j ==18 ))
						  cost[i][j] =7;
						  
						  else if ((i ==17 && j ==29 )|| (i ==29 && j ==17 ))
						  cost[i][j] =12;
						  
						  else if ((i ==29 && j ==30 )|| (i ==30 && j ==29 ))
						  cost[i][j] =7;
						  
						  else if ((i ==29 && j ==32 )|| (i ==32 && j ==29 ))
						  cost[i][j] =10;
						  
						  else if ((i ==32 && j ==33 )|| (i ==33 && j ==32 ))
						  cost[i][j] =5;
						  
						  else if ((i ==32 && j ==36 )|| (i ==36 && j ==32 ))
						  cost[i][j] =12;
						  
						  else if ((i ==36 && j ==0 )|| (i ==0 && j ==36 ))
						  cost[i][j] =29;
						  
						  else if ((i ==36 && j ==35 )|| (i ==35 && j ==36 ))
						  cost[i][j] =7;
						  
						  else if ((i ==35 && j ==12 )|| (i ==12 && j ==35 ))
						  cost[i][j] =5;
						  
						  else if ((i ==35 && j ==34 )|| (i ==34 && j ==35 ))
						  cost[i][j] =5;
						  
						  else if ((i ==30 && j ==12 )|| (i ==12 && j ==30 ))
						  cost[i][j] =7;
						  
						  else if ((i ==30 && j ==31 )|| (i ==31 && j ==30 ))
						  cost[i][j] =5;
						  
						  
						  else cost[i][j] = inf;
						
						val[start] =0;
						parent[start] = start;		  
											
						if(val[start]==0 && parent[start] ==start)
						begin 
						curr_state<= state_1;
						end
				end
	
	
	state_1:	begin     
				
				min_vertex();
				
				if(i==V) curr_state<= state_2;
				
				end
				

	state_2: begin
	
				processed[vertex]=1;
				relax_edge ();
				
				if(j==V) curr_state<= state_3;
				
				
				end
				
	state_3: begin
				i=0;
				j=0;
				if(i==0&&j==0)curr_state <= state_4;
				end
				
				
	state_4:begin
			  cnt = cnt +1;
			  if(cnt >0) curr_state <= state_1;
			  if (cnt ==V-1 )
				  curr_state <=state_5;
				 
        end
	

	state_5:begin
				
				done_dij=1;
			end
endcase

end
endtask

/////////////////////////////////     Dijkstra algo ends /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// separate dijkstra_1 for calculating only minimum distance from curr node to the required block ///////////////

reg [1:0] processed_1[36:0];
reg [10:0] val_1 [36:0];  
reg [5:0] parent_1 [36:0]; 

integer minimum_1 = INT_MAX;
reg [6:0] end_node_1;

reg [5:0] vertex_1;


parameter INT_MAX = 10'b1111111111;

reg [6:0] i_1,j_1,cnt_1;
parameter V = 8'd37;


reg [6:0] start_1=0;
reg  [9:0]inf =INT_MAX;
 
reg done_dij_1=0;
  
task min_vertex_1;
begin 
	minimum_1=INT_MAX;
	
	for(i_1=0;i_1< (V);i_1= i_1+1)
	begin
		
		if(processed_1[i_1]==0 && val_1[i_1]<minimum_1 )
		begin
			vertex_1 = i_1;
			minimum_1 = val_1[i_1];
			
		end
	end
	
end
endtask


task relax_edge_1 ;
begin

for( j_1=0;j_1< V;j_1 =j_1+1)
		begin
			
			if(cost[vertex_1][j_1]!=0 && processed_1[j_1]==0 && cost[vertex_1][j_1]!=inf && (val_1[vertex_1]+cost[vertex_1][j_1] < val_1[j_1]))
			begin
				val_1[j_1] = val_1[vertex_1]+cost[vertex_1][j_1];
				parent_1[j_1] = vertex_1;
				
			end
		end
end		
endtask	

parameter state_0_1=4'd0,
			 state_1_1=4'd1,
			 state_2_1=4'd2,
			 state_3_1=4'd3,
			 state_4_1=4'd4,
			 state_5_1=4'd5,
			 state_6_1=4'd6,
			 state_7_1=4'd7;
			
reg [3:0] curr_state_1= state_0_1;

/*
  * Task Name  : dijkstra_1
  * Input      : None
  * Output     : None
  * Logic      :   conditions to follow:-
                       1. initializing cost array, parent array, val array, processed array
			              2. finding minimum vertex which is closest among all the neighbouring nodes fromstart node
			              3. update the node (say processed) so that next time that will not get taken 
							  4. relax edge (i.e. updating neighbouring node distance)
			              5. this 4 steps(1,2,3,4) will be continously happenning untill all the edges(i.e.V-1) are not taken
  * Example    : dijkstra_1();
*/


task dijkstra_1();
begin
 
case(curr_state_1)
	state_0_1:	begin
						cnt_1 = 0;
						
					   for (i_1 =0; i_1< 37; i_1=i_1+1) begin 
						  val_1[i_1] = INT_MAX;
						  parent_1[i_1] = 0;                     
						  processed_1[i_1] = 0;
						  end
						
						val_1[start_1] =0;
						parent_1[start_1] = start_1;		  
											
						if(val_1[start_1]==0 && parent_1[start_1] ==start_1)
						begin 
						curr_state_1 <= state_1_1;
						end
				end
	
	
	state_1_1:	begin
				
				min_vertex_1();
				
				if(i_1==V) curr_state_1<= state_2_1;
				
				end
				

	state_2_1: begin
	
				processed_1[vertex_1]=1;
				relax_edge_1 ();
				
				if(j_1==V) curr_state_1<= state_3_1;
				
				
				end
				
	state_3_1: begin
				i_1=0;
				j_1=0;
				if(i_1==0&&j_1==0)curr_state_1 <= state_4_1;
				
				
				end
				
				
	state_4_1:begin
			  cnt_1 = cnt_1 +1;
			  if(cnt_1 >0) curr_state_1 <= state_1_1;
			  if (cnt_1 ==V-1 )
				  curr_state_1 <=state_5_1;
				 
        end
	
	state_5_1:begin
				
				done_dij_1=1;
			end

endcase

end

endtask

//////////////////////////////////////////////// end of separte dijk   ////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////// creating a Path in temporary path array start//////////////////////////////////////////////////////////////////


reg [20:0]a =0;
reg [5:0] path [36:0];
reg [5:0] path_temp[36:0]; 

/*
  * Task Name  : find_path
  * Input      : z
  * Output     : None
  * Logic      : finding temporary path
  * Example    : find_path();
*/

task find_path;
	input [5:0] z;
 begin
      path_temp[a]=z;
		a=a+1;
		z=parent[z];
		end_node= z;
		if(end_node==start)  begin
									path_state<=ps4;
									end
		else path_state<=ps1;
end 
endtask

////////////////////////////////////////// creating a Path in temporary path array end //////////////////////////////////////////////////////////////////

reg [32:0]counter=0;

 parameter [15:0]delay_value=400;       
 reg [32:0] delay_value_temp=40000000;  //delay for rotation at nodes
 initial begin 
 counter=0;
end



/*
  * Task Name  : node_rotation_left
  * Input      : none
  * Output     : None
  * Logic      : using counter to measure time and rotate the bot during that time to get the desired rotation 
  * Example    : node_rotation_left();
*/


//90 deg anticlock wise rotaton

task node_rotation_left;
		if(counter<delay_value_temp) counter=counter+1;
		if(counter==delay_value_temp) counter=counter;
		
		if((counter <delay_value_temp/2)) black_line_following();
		if((counter>delay_value_temp/2)&&(counter<delay_value_temp)) rotate_left();
		if(counter==delay_value_temp) black_line_following();
endtask


/*
  * Task Name  : node_rotation_right
  * Input      : none
  * Output     : None
  * Logic      : using counter to measure time and rotate the bot during that time to get the desired rotation 
  * Example    : node_rotation_right();
*/

//90 deg clock wise rotation

task node_rotation_right;
		if(counter<delay_value_temp) counter=counter+1;
		if(counter==delay_value_temp) counter=counter;
		
		if((counter <delay_value_temp/2)) black_line_following();
		if((counter>delay_value_temp/2)&&(counter<delay_value_temp)) rotate_right();
		if(counter==delay_value_temp)  black_line_following();
endtask


/*
  * Task Name  : node_rotation_backward
  * Input      : none
  * Output     : None
  * Logic      : using counter to measure time and rotate the bot during that time to get the desired rotation 
  * Example    : node_rotation_backward();
*/

//task for 180 deg rotation

task node_rotate_backward;

if(curr_node==22||curr_node==24||curr_node==27||curr_node==19||curr_node==20||curr_node==28||curr_node==31||curr_node==33||curr_node==34)begin
		if(counter<2*delay_value_temp) counter=counter+1;
		if(counter==2*delay_value_temp) counter=counter;
		if(counter<delay_value_temp/4)  black_line_following();
		if((counter>delay_value_temp/4)&&(counter<2*delay_value_temp)) rotate_right();
		if(counter==2*delay_value_temp) black_line_following();
		
		end
		
else begin
      if(counter<2*delay_value_temp) counter=counter+1;
		if(counter==2*delay_value_temp) counter=counter;
		if((counter<2*delay_value_temp)) rotate_left();
		if(counter==2*delay_value_temp) black_line_following();
		end
endtask
 
reg [6-1:0] dir [0:36][0:1] ;  //memory for x & y co-ord of nodes

initial begin 
 ///node x      node y
 dir[0][0] =0 ; dir[0][1] =5 ;
 dir[1][0] =5 ; dir[1][1] =5 ;
 dir[2][0] =5 ; dir[2][1] =2 ;
 dir[3][0] =5 ; dir[3][1] =7 ;
 dir[4][0] =10 ; dir[4][1] =5 ;
 dir[5][0] =10 ; dir[5][1] =2 ;
 dir[6][0] =10 ; dir[6][1] =7 ;
 dir[7][0] =15 ; dir[7][1] =5 ;
 dir[8][0] =15 ; dir[8][1] =7 ;
 dir[9][0] =15 ; dir[9][1] =2 ;
 dir[10][0] =20 ; dir[10][1] =7 ;
 dir[11][0] =20 ; dir[11][1] =5 ;
 dir[12][0] =25 ; dir[12][1] =5 ;
 dir[13][0] =25 ; dir[13][1] =10 ;
 dir[14][0] =25 ; dir[14][1] =15 ;
 dir[15][0] =25 ; dir[15][1] =20 ;
 dir[16][0] =25 ; dir[16][1] =25 ;
 dir[17][0] =35 ; dir[17][1] =15 ;
 dir[18][0] =30 ; dir[18][1] =15 ;
 dir[19][0] =30 ; dir[19][1] =17 ;
 dir[20][0] =30 ; dir[20][1] =20 ;
 dir[21][0] =15 ; dir[21][1] =25 ;
 dir[22][0] =15 ; dir[22][1] =20 ;
 dir[23][0] =0 ; dir[23][1] =15 ;
 dir[24][0] =5 ; dir[24][1] =15 ;
 dir[25][0] =0 ; dir[25][1] =10 ;
 dir[26][0] =15 ; dir[26][1] =10 ;
 dir[27][0] =15 ; dir[27][1] =15 ;
 dir[28][0] =30 ; dir[28][1] =10 ;
 dir[29][0] =35 ; dir[29][1] =5 ;
 dir[30][0] =30 ; dir[30][1] =5 ;
 dir[31][0] =30 ; dir[31][1] =7 ;
 dir[32][0] =35 ; dir[32][1] =2 ;
 dir[33][0] =32 ; dir[33][1] =2 ;
 dir[34][0] =30 ; dir[34][1] =2 ;
 dir[35][0] =25 ; dir[35][1] =2 ;
 dir[36][0] =25 ; dir[36][1] =0 ;
 end
 
 parameter N=2'b11,    //north
			  S=2'b10,    //south
			  W=2'b00,    // west
			  E=2'b01;    // east
			  
reg [1:0] orientation_temp=W;
integer delta_x;             // (next_node x co-ord  - curr_node x co-ord)
integer delta_y;             // (next_node x co-ord  - curr_node x co-ord)


always@(posedge clk_50M)
begin
delta_x=dir[next_node][0] - dir[curr_node][0];
delta_y=dir[next_node][1] - dir[curr_node][1];
end



/*
  * Task Name  : orientation
  * Input      : none
  * Output     : None
  * Logic      : we give an initial direction to the bot and it calculates the next direction according to the current node and next node and
						delta_x and delta_y(processing the values of dir memory).it gives the direction and also what movement(black line following ,node rotation left etc..)it has to
						perform in that direction and current node & next node.
  * Example    : orientation();
*/
// task for deciding the orientation of robot
task orientation;

begin
	if(orientation_temp==N)
	
		begin
			if(curr_node==0&&next_node==36)
			begin
				counter = delay_value_temp;
				if(counter==delay_value_temp)orientation_temp=W;
				black_line_following();
			end
			
			else if(curr_node==36&&next_node==0)
			begin
				if(counter==delay_value_temp) orientation_temp=S;
				node_rotation_right();
			end
		  
		  else if(curr_node==32&&next_node==36)
			begin
			   
				if(node_detection_edge_0==1) orientation_temp=E;
				black_line_following();
			end
			
			else if(curr_node==36&&next_node==32)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotation_left();
			end
		  
		   else if(curr_node==23&&next_node==21)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotate_backward();
	
			end
			
			else if(curr_node==21&&next_node==23)
			begin
				if(counter==delay_value_temp) orientation_temp=N;
					node_rotation_right();
			end
			
		  	else if(curr_node==16&&next_node==17)
			begin
				if(counter==delay_value_temp) orientation_temp=N;
				node_rotation_left();
			end
			
			else if(curr_node==17&&next_node==16)
			begin
				if(counter==delay_value_temp) orientation_temp=E;
				node_rotate_backward();
				
			end
			
			else  begin
							if((delta_x )<0  )
								begin
									if(counter==delay_value_temp) orientation_temp=E;
									node_rotation_right();  
									
								end
							if((delta_x )>0 )
								begin
								 // left
										if(counter==delay_value_temp) orientation_temp=W;
										node_rotation_left();
								end
										
							if((delta_y )<0 )
								begin
								// forward
										if(counter==delay_value_temp) orientation_temp=N;
										black_line_following();
								end
							if((delta_y )>0 )
								begin
								//backward
										if(counter==delay_value_temp) orientation_temp=S;
										node_rotate_backward();
										
								end				
					end	
			end	
	else if(orientation_temp==S)
		begin	
			if(curr_node==0&&next_node==36)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotate_backward();
			
			end
			
			else if(curr_node==36&&next_node==0)
			begin
				if(counter==delay_value_temp) orientation_temp=S;
				node_rotation_left();
	
			end
		  
		  else if(curr_node==32&&next_node==36)
			begin
				if(counter==delay_value_temp) orientation_temp=E;
				node_rotation_left();
	
			end
			
			else if(curr_node==36&&next_node==32)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotation_right();
	
			end
		  
		   else if(curr_node==23&&next_node==21)
			begin
						black_line_following();
						if(node_detection_edge_0==1) orientation_temp=W;
			end
			
			else if(curr_node==21&&next_node==23)
			begin
				if(counter==delay_value_temp) orientation_temp=N;
					node_rotation_left();
			end
			
		  	else if(curr_node==16&&next_node==17)
			begin
				if(counter==delay_value_temp) orientation_temp=N;
				node_rotation_right();
			end
			
			else if(curr_node==17&&next_node==16)
			begin
				if(node_detection_edge_0==1) orientation_temp=E;
				black_line_following();
			end
			
			else  begin
							if((delta_x )<0  )
								begin
								  // leftturn;
										if(counter==delay_value_temp) orientation_temp=E;
										node_rotation_left();
								end
							if((delta_x )>0 )
								begin
								 // right
										if(counter==delay_value_temp) orientation_temp=W;
										node_rotation_right();
								end
							if((delta_y )<0 )
								begin
								// backward
										if(counter==delay_value_temp) orientation_temp=N;
										node_rotate_backward();
								end
							if((delta_y )>0 ) 
								begin
								//forward
										if(counter==delay_value_temp) orientation_temp=S;
										black_line_following();
								end
				end
				
		end
		
	else if(orientation_temp==W)
	 begin	
			 if(curr_node==0&&next_node==36)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotation_right();
			
			end
			
			else if(curr_node==36&&next_node==0)
			begin
				if(counter==delay_value_temp) orientation_temp=S;
				node_rotate_backward();
	
			end
		  
		  else if(curr_node==32&&next_node==36)
			begin
				if(counter==delay_value_temp) orientation_temp=E;
				node_rotate_backward();
	
			end
			
			else if(curr_node==36&&next_node==32)
			begin
			   
				if(node_detection_edge_0==1) orientation_temp=W;
				black_line_following();
	
			end
		  
		   else if(curr_node==23&&next_node==21)
			begin
				if(counter==delay_value_temp)orientation_temp=W;
				node_rotation_left();
	
			end
			
			if(curr_node==21&&next_node==23)
			begin
				if(counter==delay_value_temp)orientation_temp=N;
				node_rotate_backward();
	
			end
			
		  	else if(curr_node==16&&next_node==17)
			begin
			   
				if(node_detection_edge_0==1) orientation_temp=N;
				black_line_following();
	
			end
			
			else if(curr_node==17&&next_node==16)
			begin
				if(counter==delay_value_temp)orientation_temp=E;
				node_rotation_left();
			end	
				
			else  begin
							if((delta_x )<0  )
								begin
								  // backward
										if(counter==delay_value_temp)orientation_temp=E;
										node_rotate_backward();
								end
							  
							if((delta_x )>0 )
								begin
								 // forward
										if(counter==delay_value_temp)orientation_temp=W;
										black_line_following();
								end
							if((delta_y )<0 )
								begin
								// right
										if(counter==delay_value_temp)orientation_temp=N;
										node_rotation_right();
								end
							if((delta_y )>0 ) 
								begin
								//left
										node_rotation_left();
										if(counter==delay_value_temp)orientation_temp=S;
										
								end
					end
					
 end
	
	else if(orientation_temp==E)
	 begin
				
			if(curr_node==0&&next_node==36)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotation_left();
			
			end
			
			else if(curr_node==36&&next_node==0)
			begin
			   counter = delay_value_temp;
				if(counter==delay_value_temp) orientation_temp=S;
				black_line_following();
	
			end
		  
		  else if(curr_node==32&&next_node==36)
			begin
			   counter = delay_value_temp;
				if(counter==delay_value_temp) orientation_temp=E;
				black_line_following();
	
			end
			
			else if(curr_node==36&&next_node==32)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotate_backward();
	
			end
		  
		   else if(curr_node==23&&next_node==21)
			begin
				if(counter==delay_value_temp) orientation_temp=W;
				node_rotation_right();
	
			end
			
			else if(curr_node==21&&next_node==23)
			begin
			   
				if(node_detection_edge_0==1)  orientation_temp=N;
				black_line_following();
	
			end
			
		  	else if(curr_node==16&&next_node==17)
			begin
				if(counter==delay_value_temp) orientation_temp=N;
				node_rotate_backward();
	
			end
			
			else if(curr_node==17&&next_node==16)
			begin
				if(counter==delay_value_temp) orientation_temp=E;
				node_rotation_right();
			end	
			
			else 
				begin
						if((delta_x )<0  )
							begin
							  // forward
									if(counter==delay_value_temp) orientation_temp=E;
									black_line_following();
							  end
						else if((delta_x )>0 )
							begin
							 // backward
									if(counter==delay_value_temp) orientation_temp=W;
									node_rotate_backward();
							end
						else if((delta_y )<0 )
							begin
							// left
									if(counter==delay_value_temp) orientation_temp=N;
									node_rotation_left();
							end
						else if((delta_y )>0 ) 
							begin
							//right
									if(counter==delay_value_temp) orientation_temp=S;
									node_rotation_right();
							end
							
				end
	end
end

endtask



parameter ps1 = 3'd0;
parameter ps2 = 3'd1;
parameter ps3 = 3'd2;
parameter ps4 = 3'd3;
parameter ps5 = 3'd4;
parameter ps6 = 3'd5;
parameter ps7 = 3'd6;

reg [2:0] path_state=ps1;

 
/*
  * Task Name  : path_travel
  * Input      : none
  * Output     : None
  * Logic      : here we use the path generated from the dijkstra algorithm and then use this generated path for orientation(direction and travelling both)
						which helps move the bot in that desired path and desired direction.
  * Example    : path_travel();
*/
task path_travel;                       // for travelling the path given by dijk algo
case (path_state)

				   ps1:find_path(end_node);  
					
					ps2:begin 
							orientation();			
									if(node_detection_edge==1)
										begin
										counter=0;
										node_i = node_i +1;
										path_state<=ps5; 
										end
						end
						
					ps3:begin
						curr_node=path[node_i-1];     
						next_node=path[node_i];
						
						if(next_node==60) begin 
														done=1;		
												end 						
												
						else if ((curr_node==path[node_i-1])&&(next_node==path[node_i]))  path_state<=ps2;
						
						end
														 
																								
					ps4: begin done_path =1;
								
								for(i=0;i<37;i=i+1)   //reversing the value from temporary path (path_temp) to get getriginal path
										begin
											if(i>=a)path[i]=path_temp[i];
											else path[i]=path_temp[a-(i+1)];
										end
										curr_node = start;
										next_node = path[0];
										path_state <=ps6;
								end	
							
					ps5:begin		
									if(node_i>0)
										begin
											orientation();
											path_state<=ps3;	
										end
							end
							
					ps6:	begin 									
								counter=0;
								path_state <=ps2;
							end
				endcase

endtask


/*
  * Task Name  : dij_n_travel
  * Input      : none
  * Output     : None
  * Logic      : to make path calculation and path travelling in the same task we just used both task(dijkstra and path_travel) in one task .
  * Example    : dij_n_travel();
*/
task dij_n_travel;

dijkstra();
if(done_dij==1)path_travel();
endtask

reg [4:0] s_end_state= se_0;
 
 parameter se_0 =  5'd0,
			  se_1 =  5'd1,
			  se_2 =  5'd2,
			  se_3 =  5'd3,
			  se_4 =  5'd4,
			  se_5 =  5'd5,
			  se_6 =  5'd6,
			  se_7 =  5'd7,
			  se_8 =  5'd8;
			  

reg done_ng=0;  // for indicating nutty ground travel is done
reg done_mt=0;  // for indicating maize terrian travel is done
reg done_vg=0;  // for indicating vegatable garden travel is done
reg done_pp=0;  // for indicating paddy plain travel is done

reg [6:0]end_node_min=0;  // storing value of node(where blocks are placed) which is in closest in distance
 
always @(posedge clk_50M) 
begin

case(s_end_state)


	se_0:begin                       // state for resetting the variables for next travel
			        done =0;       
					  done_dij=0;
					  done_dij_1=0;
					  curr_state_1=state_0_1;
					  a=0;
					  curr_state= state_0;
					  path_state=ps1;
					  min_found=0;
					  check_min=check_min1;
					  s_end_state=se_1;
			
			end

	se_1:	begin                       // state for following maize terrain and its pick and deposition works
					if (flag_mt == 0)    
						begin
						orientation_temp=W;
						start=0;
						end_node=25;
						s_end_state=se_2;
						end
							
							
					if (flag_mt ==1)	begin
						start=25;
						end_node= 21;
						
						s_end_state=se_2;
						end
						  
					if (flag_mt ==2)	begin
						start=21;
						end_node= 14;
						
						s_end_state=se_2;
						end
					if(flag_mt == 3)	begin
						start= 14;
						end_node= 26;
						
						s_end_state=se_2;
						
						end
						
						
						
					if (flag_mt ==4 )	begin
							n=1;
						if(SIM[1]!="N")begin                  //checking if any color is detected on SIM1
								 if(min_found==0)  s_end_state=se_4;
								 if(min_found==1) begin
															start= curr_node;
															end_node=end_node_min ;
															s_end_state=se_2;
															
														end
														
														
									end
							
						else flag_mt=6;
					end
				
				
					if (flag_mt == 5)	begin 
						start=  curr_node;
						
						end_node = 27;
						end_node_temp1=end_node;
						
						s_end_state=se_2;
						
					 end
					 
					 if(flag_mt ==6) begin
							n=2;                                //checking if any color is detected on SIM2
						if(SIM[2]!="N")begin
					
								 if(min_found==0)  s_end_state=se_4;
								 if(min_found==1) begin 
								 
															start= curr_node;
															end_node=end_node_min ;
															s_end_state=se_2;
															
														end			
									end
							
						else flag_mt=8;
						
					 
					 end
					 
					 if (flag_mt == 7)	begin 
						start=  curr_node;
						
						end_node = 24;
						end_node_temp1=end_node;
						s_end_state=se_2;
						
					 end
					 
					 if(flag_mt ==8) begin                   //checking if any color is detected on SIM3
							n=3;
								if(SIM[3]!="N")begin
										 if(min_found==0)  s_end_state=se_4;
										 if(min_found==1) begin 
																	start= curr_node;
																	end_node=end_node_min;
																	s_end_state=se_2;																	
																end					
											end
									
								else flag_mt=10;
					 end
					 
					 if (flag_mt == 9)	begin 
						start=  curr_node;						
						end_node = 22;
						end_node_temp1=end_node;
						s_end_state=se_2;						
					 end
					 
					 if(flag_mt ==10)begin
					    done_mt=1;
						s_end_state=se_5;					 
						 end			 
		end					
   se_2:begin
			 for (i =0; i<37; i= i+1) begin path[i] = 60; end   // resetting path memory
			 
			 for (j =0; j<37; j= j+1) begin path_temp[j] = 60; end
			
			if (i==37&&j==37)  s_end_state=se_3;
			
			end
	se_3:begin		
			dij_n_travel();
			
			if(done==1)begin
			     if(done_mt==0)flag_mt = flag_mt +1;
				  if(done_mt==1&&done_ng==0) flag_ng=flag_ng+1;
				  if(done_ng==1&&done_vg==0) flag_vg=flag_vg+1;
				  if(done_vg==1&&done_pp==0) flag_pp=flag_pp+1;
				  s_end_state=se_0;
				  end
			end
			
			
	se_4:begin
			if( min_found==1) s_end_state=se_1;
			else finding_min_dist();			
			end
			
	se_5: begin                            // state for following nutty ground and its pick and deposition works
					if (flag_ng == 0)
						begin
						start=curr_node;
						end_node=14;
						s_end_state=se_2;
						end
						
					if (flag_ng ==1)	begin
						start=14;
						end_node= 16;
						s_end_state=se_2;
						end
						  
					if (flag_ng ==2)	begin
						start=16;
						end_node= 17;
						s_end_state=se_2;
						end
					if(flag_ng == 3)	begin
						start= 17;
						end_node= 18;
						s_end_state=se_2;
						
						end	
					if (flag_ng ==4 )	begin
							n=1;
						if(SIN[1]!="N")begin   //checking if any color is detected on SIN1
					
								 if(min_found==0)  s_end_state=se_4;
								 if(min_found==1) begin 
															start= curr_node;
															end_node=end_node_min ;
															s_end_state=se_2;
														end					
									end
							
						else flag_ng=6;
					end
								
					if (flag_ng == 5)	begin 
						start=  curr_node;						
						end_node = 19;
						end_node_temp1=end_node;						
						s_end_state=se_2;
						
					 end
					 
					 if(flag_ng ==6) begin
							n=2;
						if(SIN[2]!="N")begin   //checking if any color is detected on SIN2
					
								 if(min_found==0)  s_end_state=se_4;
								 if(min_found==1) begin 
															start= curr_node;
															end_node=end_node_min ;
															s_end_state=se_2;
														end					
									end
							
						else flag_ng=8;
					 end
					 
					 if (flag_ng == 7)	begin 
						start=  curr_node;
					   end_node = 20;						
						end_node_temp1=end_node;
						s_end_state=se_2;	
					 end
					 
					 
					 if(flag_ng ==8)begin
					    done_ng=1;
						 s_end_state=se_6;
						 end
			end
			
	se_6: begin                                  // state for following vegetable garden and its pick and deposition works
						if (flag_vg == 0)
							begin
							start=curr_node;
							end_node=29;
							s_end_state=se_2;
							end
										
						if (flag_vg ==1)	begin
							start=29;
							end_node= 30;							
							s_end_state=se_2;
							end

						if (flag_vg ==2)	begin
							start=30;
							end_node= 12;							
							s_end_state=se_2;
							end
							
						if(flag_vg == 3)	begin
							start= 12;
							end_node= 13;							
							s_end_state=se_2;							
							end
								
						if (flag_vg ==4 )	begin
								n=1;
							if(SIV[1]!="N")begin
						
									 if(min_found==0)  s_end_state=se_4;
									 if(min_found==1) begin 
									 
																start= curr_node;
																end_node=end_node_min ;
																s_end_state=se_2;
															end					
										end
								
							else flag_vg=6;
						end
					
						if (flag_vg == 5)	begin 
							start=  curr_node;
							end_node = 31;
							end_node_temp1=end_node;
							s_end_state=se_2;
						 end
						 
						 if(flag_vg ==6) begin
								n=2;
							if(SIV[2]!="N")begin
									 if(min_found==0)  s_end_state=se_4;
									 if(min_found==1) begin 
																start= curr_node;
																end_node=end_node_min ;
																s_end_state=se_2;
															end				
										end
								
							else flag_vg=8;
						 end
						 
						 if (flag_vg == 7)	begin 
							start=  curr_node;
							end_node = 28;
							end_node_temp1=end_node;
							s_end_state=se_2;
						 end
						 
						 
						 if(flag_vg ==8)begin
							 done_vg=1;
							 s_end_state=se_7;
							 end
				end
				
				
	se_7: begin                            // state for following paddy plain and its pick and deposition works
							if (flag_pp == 0)
								begin
								start=curr_node;
								end_node=29;
								s_end_state=se_2;
								end
						
							if (flag_pp ==1)	begin
								start=29;
								end_node= 32;
								s_end_state=se_2;
								end
								  
							if (flag_pp ==2)	begin
								start=32;
								end_node= 36;
								s_end_state=se_2;
								end
								
							if(flag_pp == 3)	begin
								start= 36;
								end_node= 35;
								s_end_state=se_2;
								end
								
							if (flag_pp ==4 )	begin
									n=1;
								if(SIP[1]!="N")begin
										 if(min_found==0)  s_end_state=se_4;
										 if(min_found==1) begin 
																	start= curr_node;
																	end_node=end_node_min ;
																	s_end_state=se_2;
																end		
											end
									
								else flag_pp=6;
							end
						
							if (flag_pp == 5)	begin 
								start=  curr_node;
								end_node = 33;
								end_node_temp1=end_node;
								s_end_state=se_2;
							 end
							 
							 if(flag_pp ==6) begin
									n=2;
								if(SIP[2]!="N")begin
										 if(min_found==0)  s_end_state=se_4;
										 if(min_found==1) begin 
																	start= curr_node;
																	end_node=end_node_min ;
																	s_end_state=se_2;
																end		
											end
									
								else flag_pp=8;
							 
							 end
							 
							 if (flag_pp == 7)	begin 
								start=  curr_node;
								end_node = 34;
								end_node_temp1=end_node;
								s_end_state=se_2;
							 end
							 
							 
							 if(flag_pp ==8)begin
								 done_pp=1;
								 s_end_state=se_8;
								 end
					end
	se_8:begin
			done_all=1;
			stop_bot();
			end
			
	endcase
	
end
 
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 reg [7:0] SIM[3:1];  // memory for storing color value for maize terrain when detected by the color sensor
 reg [7:0] SIV[3:1];  // memory for storing color value for vegetable garden when detected by the color sensor
 reg [7:0] SIP[3:1];  // memory for storing color value for paddy plain when detected by the color sensor
 reg [7:0] SIN[3:1];  // memory for storing color value for nutty ground when detected by the color sensor
 reg [2:0]n=0;
 
 initial begin
 for(n=1;n<4;n=n+1)
 begin
	SIM[n]="N";   //initiallizing SIM memory 
   SIV[n]="N" ;  //initiallizing SIV memory 
	SIN[n]="N";   //initiallizing SIN memory 
   SIP[n]="N" ;  //initiallizing SIP memory 
 end
 
 end
 

 
 always@(posedge clk_50M)
 begin
	 if(curr_node==2)   s[0][1]="N";  // updating the block arrangement (i..e once one block is picked it wont go tonthe same location for picking)
	 if(curr_node==3)   s[1][1]="N";
	 if(curr_node==5)   s[2][1]="N";
	 if(curr_node==6)   s[3][1]="N";
	 if(curr_node==9)   s[4][1]="N";
	 if(curr_node==8)   s[5][1]="N";
	 if(curr_node==10)  s[6][1]="N";
 
 end
 
 reg count_node_green=0;
 reg [6:0]node_green =0;
 reg [6:0]node_green_1=0;
 reg count_node_red=0;
 reg [6:0]node_red =0;
 reg [6:0]node_red_1=0;
 reg count_node_blue=0;
 reg [6:0]node_blue =0;
 reg [6:0]node_blue_1=0;
 reg [4:0]x=0;
 
always@(posedge clk_50M)
begin                               //condition  when one type color block is already picked and piaced then other same color type block is being updated for picking 
if(curr_node==0||curr_node==3||curr_node==2||curr_node==5||curr_node==6||curr_node==8||curr_node==9||curr_node==10||curr_node==27||curr_node==24||curr_node==22||curr_node==19||curr_node==20||curr_node==31||curr_node==28||curr_node==33||curr_node==34) begin 
						x=0;
								count_node_green=0;
								count_node_blue=0;
								count_node_red=0;
						set_block();
						
						end
						

end


/*
  * Task Name  : set_block
  * Input      : none
  * Output     : None
  * Logic      : assigning corresponding node location for a particular colored block 
  * Example    : set_block();
*/

 
task set_block;      // task for picking the block which is in minimum distance from warehouse

for(x=0;x<7;x=x+1)
		begin
		if( s[x][1]=="G"&& count_node_green==0 )begin
	                                     	node_green=s[x][0];
														count_node_green=1;
														end
	 if( s[x][1]=="G"&& count_node_green==1 )begin node_green_1=s[x][0];
														count_node_green=1;
														end
////////////////////////////////////////////////////////////////////////			
		if( s[x][1]=="R"&& count_node_red==0 )begin
	                                     	node_red=s[x][0];
														count_node_red=1;
														end
		if( s[x][1]=="R"&& count_node_red==1 )begin node_red_1=s[x][0];
														count_node_red=1;
														end	
		/////////////////////////////////////////////////////////////////////
														
		if( s[x][1]=="B"&& count_node_blue==0 )begin
	                                     	node_blue=s[x][0];
														count_node_blue=1;
														end
		if( s[x][1]=="B"&& count_node_blue==1 )begin node_blue_1=s[x][0];
														count_node_blue=1;
														end
     end
		
endtask

parameter check_min1 = 3'd1,
          check_min2 =3'd2,
			 check_min3= 3'd3,
			 check_min4 =3'd4;
			  
reg [2:0] check_min = check_min1;



/*
  * Task Name  : finding_min_dist
  * Input      : none
  * Output     : None
  * Logic      : finding min dist of dersired blocks and compare among themselves to follow closest block by applying separate (dijkstra_1)
  * Example    : finding_min_dist();
*/
 
task finding_min_dist;     // task for finding min distance of desired blocks and which compare among them to follow closest one

 case (check_min)
						check_min1:	begin
						                min_found=0;
											 start_1 = curr_node;
											 check_min = check_min2;
										 end
										 
						check_min2:begin
											if(done_dij_1==1)check_min= check_min3;
											else	 dijkstra_1(); 
										end	 
											 
						check_min3: begin
										 if((flag_mt==4||flag_mt==5||flag_mt==6||flag_mt==7||flag_mt==8))
										   begin
												if(SIM[n]=="G" ) 
														begin
														 o0 = val_1[node_green];
														 o1 = val_1[node_green_1];
														 
														 end_node_min = (o0 > o1 ? node_green_1: node_green);  //cond. for obtaining minimum block distance among two same colored blocks
															
														 check_min= check_min4;
														end
														
												if(SIM[n]=="R" ) 
														begin
														 o0 = val_1[node_red];
														 o1 = val_1[node_red_1];
														 
														 end_node_min = (o0 > o1 ? node_red_1: node_red);
														 check_min= check_min4;
														end
														
												if(SIM[n]=="B" ) 
														begin
														 o0 = val_1[node_blue];
														 o1 = val_1[node_blue_1];
														 
														end_node_min = (o0 > o1 ? node_blue_1: node_blue);
														check_min= check_min4;
														end	
												end
												
											 if((flag_ng==4||flag_ng==5||flag_ng==6))
												begin
												if(SIN[n]=="G" ) 
														begin
														 o0 = val_1[node_green];
														 o1 = val_1[node_green_1];
														 
														 end_node_min = (o0 > o1 ? node_green_1: node_green);
															
														 check_min= check_min4;
														 
														end
														
												if(SIN[n]=="R" ) 
														begin
														 o0 = val_1[node_red];
														 o1 = val_1[node_red_1];
														 
														 end_node_min = (o0 > o1 ? node_red_1: node_red);
														 check_min= check_min4;
														end
														
												if(SIN[n]=="B" ) 
														begin
														 o0 = val_1[node_blue];
														 o1 = val_1[node_blue_1];
														 
														end_node_min = (o0 > o1 ? node_blue_1: node_blue);
														check_min= check_min4;
														end
												end
												
											if((flag_vg==4||flag_vg==5||flag_vg==6))
												begin
												if(SIV[n]=="G" ) 
														begin
														 o0 = val_1[node_green];
														 o1 = val_1[node_green_1];
														 
														 end_node_min = (o0 > o1 ? node_green_1: node_green);
															
														 check_min= check_min4;
														end
														
												if(SIV[n]=="R" ) 
														begin
														 o0 = val_1[node_red];
														 o1 = val_1[node_red_1];
														 
														 end_node_min = (o0 > o1 ? node_red_1: node_red);
														 check_min= check_min4;
														end
												if(SIV[n]=="B" ) 
														begin
														 o0 = val_1[node_blue];
														 o1 = val_1[node_blue_1];
														 
														end_node_min = (o0 > o1 ? node_blue_1: node_blue);
														check_min= check_min4;
														end	
												end
												
											if((flag_pp==4||flag_pp==5||flag_pp==6))
												begin
												if(SIP[n]=="G" ) 
														begin
														
														 o0 = val_1[node_green];
														 o1 = val_1[node_green_1];
														 
														 end_node_min = (o0 > o1 ? node_green_1: node_green);
															
														 check_min= check_min4;
														end
														
												if(SIP[n]=="R" ) 
														begin
														 o0 = val_1[node_red];
														 o1 = val_1[node_red_1];
														 
														 end_node_min = (o0 > o1 ? node_red_1: node_red);
														 check_min= check_min4;
														end
														
												if(SIP[n]=="B" ) 
														begin
														 o0 = val_1[node_blue];
														 o1 = val_1[node_blue_1];
														 
														end_node_min = (o0 > o1 ? node_blue_1: node_blue);
														check_min= check_min4;
														end	
												end 
										 end					
									 
						check_min4:  begin
											     min_found=1;
											end
					 
					endcase
						
endtask

 //////////////////////////////////////////////////////////////////

always@ ( posedge clk_50M)     // condition for updating SIs when any color is detected
begin
	if( curr_node== 13 && next_node==26  )
			begin
				if(green_signal==1) begin SIM[1]= "G";  
				                    end
				          
				if(red_signal==1) begin SIM[1]= "R"; 
				                        end
				
				if(blue_signal==1)begin SIM[1]= "B"; 
				                         end
			end
	if( curr_node== 29 && next_node==  30 )
			begin
				if(green_signal==1)begin SIV[1]= "G"; 
				                          end
				          
				if(red_signal==1)begin SIV[1]= "R"; 
				                        end
				
				if(blue_signal==1)begin SIV[1]= "B"; 
				                        end
		end
		
	if( curr_node== 17 && next_node== 18  )
			begin
				if(green_signal==1)begin SIN[1]= "G"; 
				                         end
				          
				if(red_signal==1)begin SIN[1]= "R";
			                        	 end
				
				if(blue_signal==1)begin SIN[1]= "B"; 
				                        end
		end	
		
	if( curr_node== 29 && next_node== 32  )
			begin
				if(green_signal==1)begin SIP[1]= "G"; 
				                          end
				          
				if(red_signal==1)begin SIP[1]= "R"; 
				                       end
				
				if(blue_signal==1)begin SIP[1]= "B"; 
				                      end
		end		
			
	if( curr_node==  23 && next_node == 21  )
			begin
				if(green_signal==1)begin SIM[3]= "G"; 
			                          	 end
				          
				if(red_signal==1)begin SIM[3]= "R"; 
				                        end
				
				if(blue_signal==1)begin SIM[3]= "B";
			                        	end	
			end
			
	if( curr_node== 12 && next_node==13  )
			begin
				if(green_signal==1)begin SIV[2]= "G";
			                          	  end
				          
				if(red_signal==1)begin SIV[2]= "R"; 
				                      end
				
				if(blue_signal==1)begin SIV[2]= "B"; 
				                         end
			end
	
	if( curr_node==  25 && next_node == 23  )
			begin
				if(green_signal==1)begin SIM[2]= "G"; 
				                          end
				          
				if(red_signal==1)begin SIM[2]= "R"; 
				                       end
				
				if(blue_signal==1)begin SIM[2]= "B"; 
				                        end
				
			end
	
	if( curr_node== 14 && next_node== 15  )
			begin
				if(green_signal==1)begin SIN[2]= "G"; 
				                          end
				          
				if(red_signal==1)begin SIN[2]= "R"; 
				                        end
				
				if(blue_signal==1)begin SIN[2]= "B"; 
				                        end
		end	
		
	if( curr_node== 36 && next_node== 35  )
			begin
				if(green_signal==1)begin SIP[2]= "G"; 
				                         end
				          
				if(red_signal==1)begin SIP[2]= "R"; 
				                       end
				
				if(blue_signal==1)begin SIP[2]= "B"; 
				                       end
		end
end	

always@(posedge clk_50M)
begin         // storing SIs value for providing to UART module

sim1=SIM[1];         
sim2=SIM[2];
sim3=SIM[3];
siv1=SIV[1];
siv2=SIV[2];
sin1=SIN[1];
sin2=SIN[2];
sip1=SIP[1];
sip2=SIP[2];

end  

reg clock_ms=0;     // 1 mili sec clock
reg [20:0]count_ms=0; // counter for generating clock of 1 millisecond

always @(posedge clk_50M)
begin                         // code for generating clock of 1 millisecond
	
	if(count_ms==25000)
			begin
				clock_ms=~clock_ms;
				count_ms=1;
			end
		
	else	count_ms = count_ms +1;
		

end



reg start_delay=1;
reg [20:0]clock_delay_count=0;          // counter for providing delay

reg node_detection =0;
reg node_detection_flag=0;              // it  controls that node detection should not happen multiple times for 1 node .
reg node_detection_edge_0 =0;           // node edge detection signal
reg node_detection_edge=0;              // delayed node edge detection signal

reg [1:0]node_state=ns0;

parameter ns0=2'b00,
			ns1=2'b11,
			ns2=2'b10;
				
always@(posedge clk_50M)
                                       // condition for node detection
begin
 node_detection = (( left_ch==1 &&centre_ch==1&& right_ch==1 )||( centre_ch==1&& right_ch==1 )||( left_ch==1 &&centre_ch==1 ));
 
end
			
always @(posedge clk_50M)
begin
node_detection_edge_0 = ((node_detection==1) && (node_detection_flag==0 ) ) ; 
end


always @(posedge clk_50M)
begin
node_detection_edge = ( node_detection_edge_0) ;                                        
end


always @(posedge  clock_ms)
begin 
	if(start_delay==0) clock_delay_count=0;	
		
	if(start_delay==1)
		begin
			clock_delay_count = clock_delay_count +1;
		end
end


always @(posedge clk_50M)
begin
case(node_state)   //condition for detecting node for only 1 time 
		ns0:begin
					start_delay=0;
					if((node_detection==1) && (node_detection_flag==0))
					begin
					node_detection_flag=~node_detection_flag;
					if((node_detection_flag==1))node_state<=ns1;
					end
				end		
		ns1: begin
				if((node_detection_flag==1))begin		
						start_delay=1;
						node_state<=ns2;
				end
			  end
			  
		ns2: begin
				if(clock_delay_count >410  )begin node_detection_flag=~node_detection_flag;
										node_state<=ns0;
										end
			  end
endcase
end


always @(posedge clk_50M)  // condition for electro magnet, depositon signal and pick signal (high or low)
begin

if(curr_node==2 ||curr_node==3 || curr_node==5 ||curr_node==6||curr_node==8 ||curr_node==9|| curr_node==10)
	begin
		e_on();
		depo_signal=0;
		pick_signal=1;
	end
if(curr_node==19 ||curr_node==20|| curr_node==28 ||curr_node==31||curr_node==22 ||curr_node==24 ||curr_node==27||curr_node==34||curr_node==33 )
	begin
			e_off();
			depo_signal=1;
			pick_signal=0;
	end
	
end

endmodule
