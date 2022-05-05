/*
  * Team Id :    SM#2300  
  
    Author List :  Ashwini kumar, Ankit kumar
	 
	 Filename  :   SM_2300_Task6_final_final1
	 
	 Theme    : Soil Monitoring Robot
	 
	 Function : None
	 
*/

module SM_2300_Task6_final_final1(
	out,
	clk_50M,
	dout,
	temp_S0,
	temp_S1,
	temp_S2,
	temp_S3,
	tx,
	red_on1,
	red_on2,
	red_on3,
	green_on1,
	blue_on1,
	blue_on2,
	blue_on3,
	green_on2,
	green_on3,
	din,
	adc_sck,
	adc_cs_n,
	inA1,
	inA2,
	inB2,
	EA1,
	EA2,
	inB1
);


input wire	out;
input wire	clk_50M;
input wire	dout;
output wire	temp_S0;
output wire	temp_S1;
output wire	temp_S2;
output wire	temp_S3;
output wire	tx;
output wire	red_on1;
output wire	red_on2;
output wire	red_on3;
output wire	green_on1;
output wire	blue_on1;
output wire	blue_on2;
output wire	blue_on3;
output wire	green_on2;
output wire	green_on3;
output wire	din;
output wire	adc_sck;
output wire	adc_cs_n;
output wire	inA1;
output wire	inA2;
output wire	inB2;
output wire	EA1;
output wire	EA2;
output wire	inB1;

wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;

wire	[6:0] SYNTHESIZED_WIRE_12;
wire	[6:0] SYNTHESIZED_WIRE_13;
wire	[4:0] SYNTHESIZED_WIRE_14;
wire	[4:0] SYNTHESIZED_WIRE_15;
wire	[4:0] SYNTHESIZED_WIRE_16;
wire	[4:0] SYNTHESIZED_WIRE_17;
wire	[6:0] SYNTHESIZED_WIRE_18;
wire	[7:0] SYNTHESIZED_WIRE_19;
wire	[7:0] SYNTHESIZED_WIRE_20;
wire	[7:0] SYNTHESIZED_WIRE_21;
wire	[7:0] SYNTHESIZED_WIRE_22;
wire	[7:0] SYNTHESIZED_WIRE_23;
wire	[7:0] SYNTHESIZED_WIRE_24;
wire	[7:0] SYNTHESIZED_WIRE_25;
wire	[7:0] SYNTHESIZED_WIRE_26;
wire	[7:0] SYNTHESIZED_WIRE_27;

wire SYNTHESIZED_WIRE_47;





SM_2300_Task6_color_detection	b2v_inst2(
	.clk_50M(clk_50M),
	.out(out),
	
	.temp_S0(temp_S0),
	.temp_S1(temp_S1),
	.temp_S2(temp_S2),
	.temp_S3(temp_S3),
	.red_led(SYNTHESIZED_WIRE_30),
	.blue_led(SYNTHESIZED_WIRE_29),
	.green_led(SYNTHESIZED_WIRE_28)
	
	
	
	);


SM_2300_Task6_adc_control	b2v_inst3(
	.clk_50M(clk_50M),
	.dout(dout),
	.green_signal(SYNTHESIZED_WIRE_28),
	.blue_signal(SYNTHESIZED_WIRE_29),
	.red_signal(SYNTHESIZED_WIRE_30),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.adc_sck(adc_sck),
	.inA1(inA1),
	.inB1(inB1),
	.inA2(inA2),
	.inB2(inB2),
	.EA1(EA1),
	.EA2(EA2),
	.depo_signal(SYNTHESIZED_WIRE_7),
	.pick_signal(SYNTHESIZED_WIRE_6),
	.curr_node(SYNTHESIZED_WIRE_12),
	.end_node_temp1(SYNTHESIZED_WIRE_13),
	.flag_mt(SYNTHESIZED_WIRE_14),
	.flag_ng(SYNTHESIZED_WIRE_15),
	.flag_pp(SYNTHESIZED_WIRE_16),
	.flag_vg(SYNTHESIZED_WIRE_17),
	.done_all(SYNTHESIZED_WIRE_47),
	.next_node(SYNTHESIZED_WIRE_18),
	
	
	.sim1(SYNTHESIZED_WIRE_19),
	.sim2(SYNTHESIZED_WIRE_20),
	.sim3(SYNTHESIZED_WIRE_21),
	.sin1(SYNTHESIZED_WIRE_22),
	.sin2(SYNTHESIZED_WIRE_23),
	.sip1(SYNTHESIZED_WIRE_24),
	.sip2(SYNTHESIZED_WIRE_25),
	.siv1(SYNTHESIZED_WIRE_26),
	.siv2(SYNTHESIZED_WIRE_27));
	defparam	b2v_inst3.check_min1 = 3'b001;
	defparam	b2v_inst3.check_min2 = 3'b010;
	defparam	b2v_inst3.check_min3 = 3'b011;
	defparam	b2v_inst3.check_min4 = 3'b100;
	defparam	b2v_inst3.delay_value = 16'b0000000110010000;
	defparam	b2v_inst3.E = 2'b01;
	defparam	b2v_inst3.INT_MAX = 10'b1111111111;
	defparam	b2v_inst3.N = 2'b11;
	defparam	b2v_inst3.ns0 = 2'b00;
	defparam	b2v_inst3.ns1 = 2'b11;
	defparam	b2v_inst3.ns2 = 2'b10;
	defparam	b2v_inst3.ps1 = 3'b000;
	defparam	b2v_inst3.ps2 = 3'b001;
	defparam	b2v_inst3.ps3 = 3'b010;
	defparam	b2v_inst3.ps4 = 3'b011;
	defparam	b2v_inst3.ps5 = 3'b100;
	defparam	b2v_inst3.ps6 = 3'b101;
	defparam	b2v_inst3.ps7 = 3'b110;
	defparam	b2v_inst3.pwm_p = 11'd550;
	defparam	b2v_inst3.S = 2'b10;
	defparam	b2v_inst3.se_0 = 5'b00000;
	defparam	b2v_inst3.se_1 = 5'b00001;
	defparam	b2v_inst3.se_2 = 5'b00010;
	defparam	b2v_inst3.se_3 = 5'b00011;
	defparam	b2v_inst3.se_4 = 5'b00100;
	defparam	b2v_inst3.se_5 = 5'b00101;
	defparam	b2v_inst3.se_6 = 5'b00110;
	defparam	b2v_inst3.se_7 = 5'b00111;
	defparam	b2v_inst3.se_8 = 5'b01000;
	defparam	b2v_inst3.state_0 = 4'b0000;
	defparam	b2v_inst3.state_0_1 = 4'b0000;
	defparam	b2v_inst3.state_1 = 4'b0001;
	defparam	b2v_inst3.state_1_1 = 4'b0001;
	defparam	b2v_inst3.state_2 = 4'b0010;
	defparam	b2v_inst3.state_2_1 = 4'b0010;
	defparam	b2v_inst3.state_3 = 4'b0011;
	defparam	b2v_inst3.state_3_1 = 4'b0011;
	defparam	b2v_inst3.state_4 = 4'b0100;
	defparam	b2v_inst3.state_4_1 = 4'b0100;
	defparam	b2v_inst3.state_5 = 4'b0101;
	defparam	b2v_inst3.state_5_1 = 4'b0101;
	defparam	b2v_inst3.state_6 = 4'b0110;
	defparam	b2v_inst3.state_6_1 = 4'b0110;
	defparam	b2v_inst3.state_7 = 4'b0111;
	defparam	b2v_inst3.state_7_1 = 4'b0111;
	defparam	b2v_inst3.V = 8'b00100101;
	defparam	b2v_inst3.W = 2'b00;


SM_2300_Task6_uart	b2v_inst4(
	.red_signal(SYNTHESIZED_WIRE_30),
	.blue_signal(SYNTHESIZED_WIRE_29),
	.green_signal(SYNTHESIZED_WIRE_28),
	.clk_50M(clk_50M),
	.pick_signal(SYNTHESIZED_WIRE_6),
	.depo_signal(SYNTHESIZED_WIRE_7),
	.curr_node(SYNTHESIZED_WIRE_12),
	.end_node_temp1(SYNTHESIZED_WIRE_13),
	.flag_mt(SYNTHESIZED_WIRE_14),
	.flag_ng(SYNTHESIZED_WIRE_15),
	.flag_pp(SYNTHESIZED_WIRE_16),
	.flag_vg(SYNTHESIZED_WIRE_17),
	.done_all(SYNTHESIZED_WIRE_47),
	.next_node(SYNTHESIZED_WIRE_18),
	.sim1(SYNTHESIZED_WIRE_19),
	.sim2(SYNTHESIZED_WIRE_20),
	.sim3(SYNTHESIZED_WIRE_21),
	.sin1(SYNTHESIZED_WIRE_22),
	.sin2(SYNTHESIZED_WIRE_23),
	.sip1(SYNTHESIZED_WIRE_24),
	.sip2(SYNTHESIZED_WIRE_25),
	.siv1(SYNTHESIZED_WIRE_26),
	.siv2(SYNTHESIZED_WIRE_27),
	.tx(tx),
	.red_on1(red_on1),
	.green_on1(green_on1),
	.blue_on1(blue_on1),
	.red_on2(red_on2),
	.green_on2(green_on2),
	.blue_on2(blue_on2),
	.red_on3(red_on3),
	.green_on3(green_on3),
	.blue_on3(blue_on3));
	defparam	b2v_inst4.s0 = 3'b000;
	defparam	b2v_inst4.s1 = 3'b001;
	defparam	b2v_inst4.s2 = 3'b010;
	defparam	b2v_inst4.s3 = 3'b011;
	defparam	b2v_inst4.s4 = 3'b100;
	defparam	b2v_inst4.s5 = 3'b101;
	defparam	b2v_inst4.s6 = 3'b110;


endmodule
