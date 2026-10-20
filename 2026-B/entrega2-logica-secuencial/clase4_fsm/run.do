# run.do - Clase 4: compila fsm_proceso y corre su testbench
# Uso en la consola de ModelSim/Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 plantilla/tanque_pkg.vhd
vcom -93 plantilla/fsm_proceso.vhd
vcom -93 tb/tb_fsm_proceso.vhd
vsim -voptargs=+acc work.tb_fsm_proceso
add wave -r /*
run -all
