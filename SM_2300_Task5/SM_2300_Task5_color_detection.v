module SM_2300_Task5_color_detection(
    input clk_50M, 
	 output scale_clk,
    input out,
	 output  temp_S0,temp_S1,temp_S2,temp_S3,
    output [20:0] temp_red, temp_blue , temp_green, temp_clear,
	 output red_led, blue_led, green_led
);


wire neg_edge;
reg [20:0]counter = 0;

reg [20:0] counter_new_red =0;
reg [20:0] counter_new_blue =0;
reg [20:0] counter_new_green=0;
reg [20:0] counter_new_clear =0;


reg [20:0] final_red=0;
reg [20:0] final_blue=0;
reg [20:0] final_green=0;
reg [20:0] final_clear=0;


reg [1:0] frame =0;
reg [20:0] blue=0;
reg [20:0] red=0;
reg [20:0] green =0;
reg [20:0] clear =0;
reg S0 =0; 
reg S1=0; 
reg S2=0;
reg S3=0;

reg temp_scale_clock = 0;
assign temp_S0 = S0;
assign temp_S1 = S1;
assign temp_S2 = S2;
assign temp_S3 = S3;

reg [4:0] count =0;
always@(posedge clk_50M)
begin

if(count==25)   // (50 / 2.5) = 20 // frequency divider
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


// simple flip/flip to store last value of signal
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
assign red_led = ( (temp_red >1010-200 ) &&( temp_red < 1010+200)&&(temp_blue > 1370-200) &&( temp_blue < 1370+200)&&(temp_green > 1543-200) &&( temp_green < 1543+200)&&(temp_clear>480-200) &&( temp_clear < 480+200));
assign blue_led = ( (temp_red > 1800-200) &&( temp_red < 1800+200)&&(temp_blue >970-200) &&( temp_blue < 970+200)&&(temp_green > 1630-200) &&( temp_green < 1630+200)&&(temp_clear> 485-200) &&( temp_clear < 485+200));
assign green_led = ( (temp_red > 700) &&( temp_red < 900)&&(temp_blue > 750) &&( temp_blue < 850)&&(temp_green > 700) &&( temp_green < 850)&&(temp_clear> 200) &&( temp_clear < 350));

endmodule


