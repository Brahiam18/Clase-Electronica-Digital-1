# run.do - Clase 3: compila las plantillas y corre el testbench
# Uso en la consola de ModelSim/Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 plantilla/base_tiempo.vhd
vcom -93 plantilla/temporizador.vhd
vcom -93 plantilla/digito_bcd.vhd
vcom -93 plantilla/temporizador_bcd.vhd
vcom -93 plantilla/watchdog_bomba.vhd
vcom -93 tb/tb_clase3.vhd
vsim -voptargs=+acc work.tb_clase3
add wave -r /*
run -all
