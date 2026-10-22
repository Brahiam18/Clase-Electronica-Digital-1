-- =============================================================================
-- CLASE 2 - PLANTILLA: antirrebote.vhd
-- Acepta el valor de 'entrada' solo si se mantiene IGUAL durante N_TICKS
-- pulsos de 'tick'. Cualquier cambio reinicia la cuenta.
--   Teclado     : N_TICKS = 20  con tick de 1 ms  -> 20 ms
--   Sensores S1-S4 (filtro de oleaje, RF10): N_TICKS = 200 -> 200 ms
--
--   entrada  ___|-|_|-|__|-------------------------
--   cuenta    0  0 0 0 0  1 2 3 ...          N-1
--   salida   _______________________________|-----   (solo tras N ticks quieta)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity antirrebote is
    generic (
        ANCHO   : positive := 1;
        N_TICKS : positive := 20
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick    : in  std_logic;
        entrada : in  std_logic_vector(ANCHO-1 downto 0);
        salida  : out std_logic_vector(ANCHO-1 downto 0)
    );
end entity antirrebote;

architecture rtl of antirrebote is
    signal previa  : std_logic_vector(ANCHO-1 downto 0) := (others => '0');
    signal estable : std_logic_vector(ANCHO-1 downto 0) := (others => '0');
    signal cuenta  : integer range 0 to N_TICKS - 1 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                previa  <= (others => '0');
                estable <= (others => '0');
                cuenta  <= 0;
            -- TODO 1: si entrada /= previa -> guardar entrada en previa y
            --         reiniciar la cuenta
            -- TODO 2: si no, y llega tick:
            --         si cuenta = N_TICKS - 1 -> estable <= previa
            --         si no                   -> cuenta + 1
            end if;
        end if;
    end process;

    salida <= estable;
end architecture rtl;
