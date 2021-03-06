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
// CREATED		"Fri Jan 21 02:37:32 2022"

module SM2300_Task4_final2(
	clk_50M,
	out,
	dout,
	temp_S0,
	temp_S1,
	temp_S2,
	temp_S3,
	tx,
	din,
	inA1,
	inA2,
	inB2,
	inB1,
	adc_cs_n,
	adc_sck,
	red_on,
	green_on,
	blue_on
);


input wire	clk_50M;
input wire	out;
input wire	dout;
output wire	temp_S0;
output wire	temp_S1;
output wire	temp_S2;
output wire	temp_S3;
output wire	tx;
output wire	din;
output wire	inA1;
output wire	inA2;
output wire	inB2;
output wire	inB1;
output wire	adc_cs_n;
output wire	adc_sck;
output wire	red_on;
output wire	green_on;
output wire	blue_on;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[1:0] SYNTHESIZED_WIRE_3;





SM2300_Task4_uart	b2v_inst(
	.red_signal(SYNTHESIZED_WIRE_0),
	.blue_signal(SYNTHESIZED_WIRE_1),
	.green_signal(SYNTHESIZED_WIRE_2),
	.clk_50M(clk_50M),
	.laps(SYNTHESIZED_WIRE_3),
	.tx(tx),
	.red_on(red_on),
	.green_on(green_on),
	.blue_on(blue_on));
	defparam	b2v_inst.s0 = 3'b000;
	defparam	b2v_inst.s1 = 3'b001;
	defparam	b2v_inst.s2 = 3'b010;
	defparam	b2v_inst.s3 = 3'b011;
	defparam	b2v_inst.s4 = 3'b100;


SM2300_Task4_color_detection	b2v_inst1(
	.clk_50M(clk_50M),
	.out(out),
	
	.temp_S0(temp_S0),
	.temp_S1(temp_S1),
	.temp_S2(temp_S2),
	.temp_S3(temp_S3),
	.red_led(SYNTHESIZED_WIRE_0),
	.blue_led(SYNTHESIZED_WIRE_1),
	.green_led(SYNTHESIZED_WIRE_2)
	
	
	
	);


SM2300_Task4_adc_control	b2v_inst2(
	.clk_50M(clk_50M),
	.dout(dout),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.adc_sck(adc_sck),
	
	
	
	
	.inA1(inA1),
	.inB1(inB1),
	.inA2(inA2),
	.inB2(inB2),
	
	
	
	
	
	.laps(SYNTHESIZED_WIRE_3));
	defparam	b2v_inst2.delay_value = 16'b0000000110010000;
	defparam	b2v_inst2.pwm_p = 11'b00011111010;


endmodule
