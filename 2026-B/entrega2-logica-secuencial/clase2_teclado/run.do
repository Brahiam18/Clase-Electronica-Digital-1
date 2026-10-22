# run.do - Clase 2: teclado matricial. Usa sus archivos terminados de la clase 1
# Uso en la consola de ModelSim/Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 ../clase1_registros/plantilla/sincronizador.vhd
vcom -93 ../clase1_registros/plantilla/detector_flanco.vhd
vcom -93 apoyo/base_tiempo.vhd
vcom -93 plantilla/antirrebote.vhd
vcom -93 plantilla/barrido_teclado.vhd
vcom -93 plantilla/teclado_4x4.vhd
vcom -93 tb/tb_teclado.vhd
vsim -voptargs=+acc work.tb_teclado
add wave -r /*
run -all
