transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/seq_ckt/seq_ckt {E:/seq_ckt/seq_ckt/seq_block_verilog.v}
vlog -vlog01compat -work work +incdir+E:/seq_ckt/seq_ckt {E:/seq_ckt/seq_ckt/T_ff.v}

vlog -vlog01compat -work work +incdir+E:/seq_ckt/seq_ckt/simulation/modelsim {E:/seq_ckt/seq_ckt/simulation/modelsim/seq_ckt_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  seq_ckt_tb

add wave *
view structure
view signals
run 4000 ps
