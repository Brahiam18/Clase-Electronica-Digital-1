# Restriccion de tiempo: reloj de 50 MHz (periodo 20 ns).
# Sin este archivo el Timing Analyzer no puede reportar Fmax con sentido (R12).
create_clock -name clk -period 20.000 [get_ports {clk}]
derive_clock_uncertainty
# Entradas asincronas: ya pasan por sincronizadores, no se analizan.
set_false_path -from [get_ports {rst_n s1 s2 s3 s4 s5 columnas[*]}]
set_false_path -to   [get_ports {filas[*] dis*[*] led_* bomba_en compuerta_en}]
