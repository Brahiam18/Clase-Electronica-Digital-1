# run.do - Clase 1: compila las plantillas y corre el testbench
# Uso en la consola de Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 plantilla/sincronizador.vhd
vcom -93 plantilla/reset_sync.vhd
vcom -93 plantilla/detector_flanco.vhd
vcom -93 plantilla/reg_desplazamiento.vhd
vcom -93 tb/tb_clase1.vhd
vsim -voptargs=+acc work.tb_clase1
add wave -r /*
run -all
