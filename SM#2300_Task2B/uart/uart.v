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
module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

//reg [3:0] count =0;
//reg [8:0] baud_rate_counter =0;
reg start_bit=0;
reg [1:0] stop_bit= 2'b11;
reg [0:7] data_bit = 8'b11001010;
reg [0:7] data_bit1 = 8'b10110010;
reg [7:0] data_bit2 = 8'b00110000;
reg [7:0] data_bit3 = 8'b00110000;


reg [1:0] state =0 ;
reg tx_out =0 ;
reg [2:0] frame =0;

reg [8:0] clock_count =0;
reg clock=1;
reg [3:0] cpb_count =0;

always @(posedge clk_50M)
begin


if(clock_count==434)
    begin
    clock = ~clock;	 
    clock_count=1;
	 end

else 
clock_count = clock_count + 1;

end

// cpb counter for 11 bit iteration
always @(clock)

begin
if(cpb_count ==11)
   begin
    frame = frame +1;
    cpb_count =1;
   end
else
 cpb_count = cpb_count +1; 
end

always @(clock)
begin
case (frame)
0 : case (cpb_count)
     2 : tx_out = start_bit;
     3 : tx_out = data_bit[0];
     4 : tx_out = data_bit[1];
     5 : tx_out = data_bit[2];
     6 : tx_out = data_bit[3];
     7 : tx_out = data_bit[4];
     8 : tx_out = data_bit[5];
     9 : tx_out = data_bit[6];
     10: tx_out = data_bit[7];
     11: tx_out = stop_bit[0];
     1: tx_out = stop_bit[1];
     endcase
1 :  case (cpb_count)
     2 : tx_out = start_bit;
     3 : tx_out = data_bit1[0];
     4 : tx_out = data_bit1[1];
     5 : tx_out = data_bit1[2];
     6 : tx_out = data_bit1[3];
     7 : tx_out = data_bit1[4];
     8 : tx_out = data_bit1[5];
     9 : tx_out = data_bit1[6];
     10: tx_out = data_bit1[7];
     11: tx_out = stop_bit[0];
     1: tx_out = stop_bit[1];
     endcase
2 :  case (cpb_count)
     2 : tx_out = start_bit;
     3 : tx_out = data_bit2[0];
     4 : tx_out = data_bit2[1];
     5 : tx_out = data_bit2[2];
     6 : tx_out = data_bit2[3];
     7 : tx_out = data_bit2[4];
     8 : tx_out = data_bit2[5];
     9 : tx_out = data_bit2[6];
     10: tx_out = data_bit2[7];
     11: tx_out = stop_bit[0];
     1: tx_out = stop_bit[1];
     endcase
3 :  case (cpb_count)
     2 : tx_out = start_bit;
     3 : tx_out = data_bit3[0];
     4 : tx_out = data_bit3[1];
     5 : tx_out = data_bit3[2];
     6 : tx_out = data_bit3[3];
     7 : tx_out = data_bit3[4];
     8 : tx_out = data_bit3[5];
     9 : tx_out = data_bit3[6];
     10: tx_out = data_bit3[7];
     11: tx_out = stop_bit[0];
     1: tx_out = stop_bit[1];
     endcase
default :
         tx_out  =1;	  
endcase	  
end 
assign tx = tx_out;





////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////