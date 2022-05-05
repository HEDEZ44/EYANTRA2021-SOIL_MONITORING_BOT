// Copyright (C) 2019  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"
// CREATED		"Mon Feb 14 21:59:14 2022"

module SM_2300_Task5_final(
	out,
	clk_50M,
	dout,
	adc_cs_n,
	din,
	inB1,
	adc_sck,
	inA2,
	inB2,
	EA1,
	EA2,
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
	inA1
);


input wire	out;
input wire	clk_50M;
input wire	dout;
output wire	adc_cs_n;
output wire	din;
output wire	inB1;
output wire	adc_sck;
output wire	inA2;
output wire	inB2;
output wire	EA1;
output wire	EA2;
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
output wire	inA1;

wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	[6:0] SYNTHESIZED_WIRE_6;
wire	[6:0] SYNTHESIZED_WIRE_7;





SM_2300_Task5_adc_control	b2v_inst(
	.clk_50M(clk_50M),
	.dout(dout),
	.green_edge(SYNTHESIZED_WIRE_8),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.adc_sck(adc_sck),
	
	
	
	.inA1(inA1),
	.inB1(inB1),
	.inA2(inA2),
	.inB2(inB2),
	.EA1(EA1),
	.EA2(EA2),
	.depo_signal(SYNTHESIZED_WIRE_5),
	.pick_signal(SYNTHESIZED_WIRE_4),
	.curr_node(SYNTHESIZED_WIRE_6),
	
	
	
	
	.next_node(SYNTHESIZED_WIRE_7));
	defparam	b2v_inst.check_min1 = 3'b001;
	defparam	b2v_inst.check_min2 = 3'b010;
	defparam	b2v_inst.check_min3 = 3'b011;
	defparam	b2v_inst.check_min4 = 3'b100;
	defparam	b2v_inst.delay_value = 16'b0000000110010000;
	defparam	b2v_inst.E = 2'b01;
	defparam	b2v_inst.INT_MAX = 10'b1111111111;
	defparam	b2v_inst.N = 2'b11;
	defparam	b2v_inst.ns0 = 2'b00;
	defparam	b2v_inst.ns1 = 2'b11;
	defparam	b2v_inst.ns2 = 2'b10;
	defparam	b2v_inst.ps1 = 3'b000;
	defparam	b2v_inst.ps2 = 3'b001;
	defparam	b2v_inst.ps3 = 3'b010;
	defparam	b2v_inst.ps4 = 3'b011;
	defparam	b2v_inst.ps5 = 3'b100;
	defparam	b2v_inst.ps6 = 3'b101;
	defparam	b2v_inst.ps7 = 3'b110;
	defparam	b2v_inst.pwm_p = 11'b00011111010;
	defparam	b2v_inst.S = 2'b10;
	defparam	b2v_inst.se_1 = 5'b00001;
	defparam	b2v_inst.se_2 = 5'b00010;
	defparam	b2v_inst.se_3 = 5'b00011;
	defparam	b2v_inst.state_0 = 4'b0000;
	defparam	b2v_inst.state_0_1 = 4'b0000;
	defparam	b2v_inst.state_1 = 4'b0001;
	defparam	b2v_inst.state_1_1 = 4'b0001;
	defparam	b2v_inst.state_2 = 4'b0010;
	defparam	b2v_inst.state_2_1 = 4'b0010;
	defparam	b2v_inst.state_3 = 4'b0011;
	defparam	b2v_inst.state_3_1 = 4'b0011;
	defparam	b2v_inst.state_4 = 4'b0100;
	defparam	b2v_inst.state_4_1 = 4'b0100;
	defparam	b2v_inst.state_5 = 4'b0101;
	defparam	b2v_inst.state_5_1 = 4'b0101;
	defparam	b2v_inst.state_6 = 4'b0110;
	defparam	b2v_inst.state_6_1 = 4'b0110;
	defparam	b2v_inst.state_7 = 4'b0111;
	defparam	b2v_inst.state_7_1 = 4'b0111;
	defparam	b2v_inst.V = 8'b00100101;
	defparam	b2v_inst.W = 2'b00;


SM_2300_Task5_color_detection	b2v_inst2(
	.clk_50M(clk_50M),
	.out(out),
	
	.temp_S0(temp_S0),
	.temp_S1(temp_S1),
	.temp_S2(temp_S2),
	.temp_S3(temp_S3),
	.red_led(SYNTHESIZED_WIRE_1),
	.blue_led(SYNTHESIZED_WIRE_2),
	.green_led(SYNTHESIZED_WIRE_8)
	
	
	
	);


SM_2300_Task5_uart	b2v_inst3(
	.red_signal(SYNTHESIZED_WIRE_1),
	.blue_signal(SYNTHESIZED_WIRE_2),
	.green_signal(SYNTHESIZED_WIRE_8),
	.clk_50M(clk_50M),
	.pick_signal(SYNTHESIZED_WIRE_4),
	.depo_signal(SYNTHESIZED_WIRE_5),
	.curr_node(SYNTHESIZED_WIRE_6),
	.next_node(SYNTHESIZED_WIRE_7),
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
	defparam	b2v_inst3.s0 = 3'b000;
	defparam	b2v_inst3.s1 = 3'b001;
	defparam	b2v_inst3.s2 = 3'b010;
	defparam	b2v_inst3.s3 = 3'b011;
	defparam	b2v_inst3.s4 = 3'b100;
	defparam	b2v_inst3.s5 = 3'b101;
	defparam	b2v_inst3.s6 = 3'b110;


endmodule
