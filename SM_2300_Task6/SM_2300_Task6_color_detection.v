/*
  * Team Id         :   SM#2300  
  
  * Author List     :   Ashwini kumar, Ankit kumar
	 
  * Filename        :   SM_2300_Task6_color_detection
	 
  * Theme           :   Soil Monitoring Robot
	 
  * Functions/Tasks :   None
  
  * Global variables:   counter,counter_new_red ,counter_new_blue , counter_new_green,counter_new_clear,final_red,
								final_blue,final_green,final_clear,frame,red,green ,clear ,S0 ,S1,S2,S3,temp_scale_clock,blue_value_for_red,blue_value_for_blue,
								blue_value_for_green,green_value_for_red,green_value_for_green,blue_value_for_blue,green_value_for_blue, green_value_for_blue,red_value_for_green
                        red_led_reg, blue_led_reg, green-led_reg,count_confidence_red,count_confidence_blue,count_confidence_green,thresh_confidence


*/





module SM_2300_Task6_color_detection(
    input clk_50M, 
	 output scale_clk,  //(clock for 20% frequency scaling)
    input out,   //output square wave signal of color sensor
	 output  temp_S0,temp_S1,temp_S2,temp_S3, //inputs to the color sensor ( s0 s1 -> decide frequency distribution  s2 s3 ->controls activation of color filters
    output [20:0] temp_red, temp_blue , temp_green, temp_clear,//values of filters 
	 output red_led, blue_led, green_led//detected color is given as output using this terminal
);


wire neg_edge;

reg [20:0]counter = 0;


// counter_new to store value of red green blue clear signal obtaining from color sensor 
reg [20:0] counter_new_red =0;
reg [20:0] counter_new_blue =0;
reg [20:0] counter_new_green=0;
reg [20:0] counter_new_clear =0;

// temporary reg for assign red green blue clear value for a particular specific color
reg [20:0] final_red=0;          
reg [20:0] final_blue=0;
reg [20:0] final_green=0;
reg [20:0] final_clear=0;


reg [1:0] frame =0;
reg [20:0] blue=0;  // variable for storing blue value obtained from color sensor
reg [20:0] red=0;    // variable for storing red value obtained from color sensor
reg [20:0] green =0;  // variable for storing green value obtained from color sensor
reg [20:0] clear =0;   // variable for storing clear value obtained from color sensor


reg S0 =0;        // S0 & S1 -> specific frequency selection variable
reg S1=0;         //
reg S2=0;        // S2 & S3 -> color filter selection variables
reg S3=0;

reg temp_scale_clock = 0;  //clock for handling the signal obtained from color sensor
assign temp_S0 = S0;
assign temp_S1 = S1;
assign temp_S2 = S2;
assign temp_S3 = S3;

reg [4:0] count =0;    // counter for scale clock (scale_clk)
always@(posedge clk_50M)
begin

if(count==25)   
  begin
    temp_scale_clock = ~temp_scale_clock;
    count=1;
  
  end
else
  begin
    count=count+1;
  
  end
  
end

assign scale_clk = temp_scale_clock;


// negative edge detector
reg last = 0;
always @(posedge scale_clk) 
begin
    last <= out;
end

assign neg_edge  = last & (~out);

always @(posedge scale_clk) 
begin
counter = counter +1; // counter to keep track of clock until negedge of input signal(out) is detected
if (neg_edge ==1)
  counter =1;
end 



always @(negedge out) begin
if(frame ==3) frame =0;
			else frame = frame +1;
	     end
always @(posedge scale_clk) begin
case (frame)
0: begin S0 =1; S1 = 0 ; S2 = 0; S3 =0;
	if((out==0 )&& (counter>=2))
	 begin counter_new_red=  counter_new_red +1;   // counter_new to store value of red green blue color 
	      end

	if(out ==1&&counter==(counter_new_red+4))
	begin final_red = counter_new_red; end

	if((out==0) && (counter ==1)) 
	begin counter_new_red =1; end
   red = final_red; 
	 
   end
1: begin S0 =1; S1 = 0 ; S2 = 0; S3 =1;

	if((out==0 )&& (counter>=2))
	 begin counter_new_blue=  counter_new_blue +1;   // counter_new to store value of red green blue color 
	      end

	if(out ==1&&counter==(counter_new_blue+4))
	begin final_blue = counter_new_blue; end

	if((out==0) && (counter ==1)) 
	begin counter_new_blue =1; end
   blue = final_blue;
   end
2: begin S0 =1; S1 = 0 ; S2 = 1; S3 =1;

	if((out==0 )&& (counter>=2))
	 begin counter_new_green=  counter_new_green +1;   // counter_new to store value of red green blue color 
	      end

	if(out ==1&&counter==(counter_new_green+4))
	begin final_green = counter_new_green; end

	if((out==0) && (counter ==1)) 
	begin counter_new_green =1; end
   green= final_green;
   end
3 : begin  S0 =1; S1 = 0 ; S2 = 1; S3 =0;

	if((out==0 )&& (counter>=2))
	 begin counter_new_clear=  counter_new_clear +1;   // counter_new to store value of red green blue color 
	      end

	if(out ==1&&counter==(counter_new_clear+4))
	begin final_clear = counter_new_clear; end

	if((out==0) && (counter ==1)) 
	begin counter_new_clear =1; end
      clear = final_clear ;
		end
endcase
end

assign temp_red = red;   
assign temp_clear = clear;
assign temp_blue = blue;
assign temp_green = green;


//values for red for different color filters
reg [20:0]blue_value_for_red= 560;
reg [20:0]clear_value_for_red= 149;
reg [20:0]green_value_for_red= 717;
reg [20:0]red_value_for_red= 235;


//values for blue for different color filters
reg [20:0]blue_value_for_blue= 420 ;

reg [20:0]clear_value_for_blue=  221;
reg [20:0]green_value_for_blue=750;
reg [20:0]red_value_for_blue= 911;


///values for green for different color filters

reg [20:0]blue_value_for_green= 440;
reg [20:0]clear_value_for_green=127;
reg [20:0]green_value_for_green=260;

reg [20:0]red_value_for_green=540;

reg  [10:0] variance_value=100;//variance for values of filters

assign red_led_temp=   ( (temp_red >red_value_for_red - variance_value ) &&( temp_red < red_value_for_red +variance_value)&&(temp_blue > blue_value_for_red-variance_value) &&( temp_blue < blue_value_for_red + variance_value)&&(temp_green > green_value_for_red-variance_value) &&( temp_green < green_value_for_red + variance_value)&&(temp_clear>clear_value_for_red -variance_value) &&( temp_clear< clear_value_for_red+variance_value));

assign blue_led_temp = ( (temp_red >red_value_for_blue - variance_value ) &&( temp_red < red_value_for_blue +variance_value)&&(temp_blue > blue_value_for_blue-variance_value) &&( temp_blue < blue_value_for_blue + variance_value)&&(temp_green > green_value_for_blue-variance_value) &&( temp_green < green_value_for_blue + variance_value)&&(temp_clear>clear_value_for_blue -variance_value) &&( temp_clear< clear_value_for_blue+variance_value));

 
assign green_led_temp = ( (temp_red >red_value_for_green  - variance_value ) &&( temp_red< red_value_for_green +variance_value)&&(temp_blue > blue_value_for_green-variance_value) &&( temp_blue < blue_value_for_green + variance_value)&&(temp_green > green_value_for_green-variance_value) &&( temp_green < green_value_for_green + variance_value)&&(temp_clear >clear_value_for_green -variance_value) &&( temp_clear< clear_value_for_green +variance_value));


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [15:0]count_confidence_red=0;//checks if it is not a garbage value by using thresh_confidence for red
reg [15:0]count_confidence_blue=0;//checks if it is not a garbage value by using thresh_confidence for blue
reg [15:0]count_confidence_green=0;//checks if it is not a garbage value by using thresh_confidence for green

reg [15:0] thresh_confidence=10;//threshold value of confirming a specific color


wire green_led_temp;
wire red_led_temp;
wire blue_led_temp;
reg red_led_reg=0;
reg green_led_reg=0;
reg blue_led_reg=0;


always @(posedge clk_50M)
           //detects the color and checks if it is not a garbage value by using thresh_confidence
begin

if(red_led_temp==1)
				begin
					 if(count_confidence_red>thresh_confidence)  red_led_reg=1;
					 else count_confidence_red=count_confidence_red+1;
				end
	 
if(red_led_temp==0)  begin count_confidence_red=0;
							 red_led_reg=0;
							
							end 

if(blue_led_temp==1)
				begin
					 if(count_confidence_blue>thresh_confidence ) blue_led_reg=1;
					 else count_confidence_blue = count_confidence_blue+1;
				end
	 
if(blue_led_temp==0) begin count_confidence_blue=0;
								blue_led_reg=0;
								end
if(green_led_temp==1)
				begin
					 if(count_confidence_green >thresh_confidence)  green_led_reg=1;
					 else count_confidence_green=count_confidence_green+1;
				end
	 
if(green_led_temp==0) begin count_confidence_green=0;
										green_led_reg=0;
								
								end
					

end




assign red_led=red_led_reg;
assign green_led=green_led_reg;
assign blue_led=blue_led_reg;

endmodule
