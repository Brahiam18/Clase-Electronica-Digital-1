# run.do - Clase 5: sistema completo. Antes, copien TODOS sus archivos terminados a la carpeta rtl/
# Uso en la consola de ModelSim/Questa:  do run.do
catch {quit -sim}
vlib work
vcom -93 rtl/tanque_pkg.vhd
vcom -93 rtl/sincronizador.vhd
vcom -93 rtl/reset_sync.vhd
vcom -93 rtl/base_tiempo.vhd
vcom -93 rtl/antirrebote.vhd
vcom -93 rtl/detector_flanco.vhd
vcom -93 rtl/barrido_teclado.vhd
vcom -93 rtl/teclado_4x4.vhd
vcom -93 rtl/reg_desplazamiento.vhd
vcom -93 rtl/temporizador.vhd
vcom -93 rtl/digito_bcd.vhd
vcom -93 rtl/temporizador_bcd.vhd
vcom -93 rtl/contador_bcd.vhd
vcom -93 rtl/watchdog_bomba.vhd
vcom -93 rtl/detector_nivel.vhd
vcom -93 rtl/selector_nivel.vhd
vcom -93 rtl/decodificador_7seg.vhd
vcom -93 rtl/formateador_display.vhd
vcom -93 rtl/fsm_proceso.vhd
vcom -93 rtl/fsm_sesion.vhd
vcom -93 rtl/top_tanque.vhd
vcom -93 tb/tb_top_tanque.vhd
vsim -voptargs=+acc work.tb_top_tanque
add wave /tb_top_tanque/*
run -all
