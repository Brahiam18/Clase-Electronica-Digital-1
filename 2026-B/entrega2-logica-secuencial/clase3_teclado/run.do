# run.do - Clase 3: usa sus archivos terminados de las clases 1 y 2
# Uso en la consola de ModelSim/Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 ../clase1_registros/plantilla/sincronizador.vhd
vcom -93 ../clase1_registros/plantilla/detector_flanco.vhd
vcom -93 ../clase2_contadores/plantilla/base_tiempo.vhd
vcom -93 ../clase2_contadores/plantilla/antirrebote.vhd
vcom -93 plantilla/barrido_teclado.vhd
vcom -93 plantilla/teclado_4x4.vhd
vcom -93 tb/tb_teclado.vhd
vsim -voptargs=+acc work.tb_teclado
add wave -r /*
run -all
