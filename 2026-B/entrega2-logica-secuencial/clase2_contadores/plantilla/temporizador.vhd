-- =============================================================================
-- CLASE 2 - PLANTILLA: temporizador.vhd
-- Mientras ena = '1', cuenta pulsos de 'tick'. Al contar N_TICKS levanta
-- 'fin' y lo MANTIENE. Si ena = '0' o llega 'reiniciar', vuelve a cero.
--   Inactividad 20 s : tick = tick_1hz, N_TICKS = 20, reiniciar = tecla_valida
--   Error sensor 1 s : tick = tick_1ms, N_TICKS = 1000, ena = error
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity temporizador is
    generic (
        N_TICKS : positive := 10
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tick      : in  std_logic;
        ena       : in  std_logic;
        reiniciar : in  std_logic;
        fin       : out std_logic
    );
end entity temporizador;

architecture rtl of temporizador is
    signal cuenta : integer range 0 to N_TICKS - 1 := 0;
    signal fin_r  : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- TODO: escribir el comportamiento completo.
            --   1) rst, ena = '0' o reiniciar = '1'  -> cuenta 0, fin_r '0'
            --   2) si llega tick y fin_r = '0':
            --        si cuenta = N_TICKS - 1 -> fin_r '1'
            --        si no                   -> cuenta + 1
            null;
        end if;
    end process;

    fin <= fin_r;
end architecture rtl;
