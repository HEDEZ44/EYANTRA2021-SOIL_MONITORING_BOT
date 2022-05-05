transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/SM#2300_Task4 {E:/SM#2300_Task4/White_Line_Following.v}

