transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Reg_module_WI.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Reg_module_W.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Reg_module_RW.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Reg_module_RI.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/proc_param.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/PC.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/mux_3to1_8bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/imem_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/dmem_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/cu_param.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Comp.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Bus_mux.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/AR.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/Alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/ins_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/data_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/core.v}
vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/controlunit.v}

vlog -vlog01compat -work work +incdir+C:/Users/ChamikaIshanSudusing/Documents/pointcloud {C:/Users/ChamikaIshanSudusing/Documents/pointcloud/processor_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  processor_tb

add wave *
view structure
view signals
run -all
