// SM : Task 1 C : Finite State Machine
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a Finite State Machine.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//Finite State Machine design
//Inputs  : I (4 bit) and CLK (clock)
//Output  : Y (Y = 1 when 1094 sequence(decimal number sequence) is detected)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module fsm(
	input CLK,			  //Clock
	input [3:0]I,       //INPUT I
	output	  Y		  //OUTPUT Y

	);
////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 

parameter s0=3'b000,
			 s1=3'b001,
			 s2=3'b010,
			 s3=3'b011,
			 s4=3'b100;

reg[3:0] curr=s0;

always @(posedge CLK)

		begin
			case(curr)
			
				s0:
					begin
					
						if(I==1) curr <=s1;
						else curr <= s0;
					
					end

				s1:
					begin
						
							if(I==0) curr <=s2;
							else if(I[1]==1) curr <=s1;
							else curr <=s0;
						
						
					
					end
					
					
				s2:
					begin
					
						if(I==9) curr <=s3;
						else if(I[2]==1)curr <=s1;
						else curr<=s0;
						
						
					end
					
					
				s3:
					begin
						if(I==4) curr <=s4;
						else if(I[3]==1) curr  <=s1;
						else curr<=s0;
						
					end
					
				s4:
					begin
						if(I==1) curr<=s1;
						else curr<=s0;
						
					end
					

			endcase	
					
		end
				
							
						
assign Y= curr==s4 ? 1: 0;
			






	

// Tip : Write your code such that Quartus Generates a State Machine 
//			(Tools > Netlist Viewers > State Machine Viewer).
// 		For doing so, you will have to properly declare State Variables of the
//       State Machine and also perform State Assignments correctly.
//			Use Verilog case statement to design.
	
	

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////