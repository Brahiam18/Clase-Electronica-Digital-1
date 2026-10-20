-- =============================================================================
-- CLASE 1 - PLANTILLA: detector_flanco.vhd
-- Genera un pulso de UN ciclo cuando 'nivel' pasa de '0' a '1'.
--
--   clk     _|-|_|-|_|-|_|-|_|-|_|-|_
--   nivel   ______|-----------------
--   anterior_________|--------------   (nivel retrasado un ciclo)
--   pulso   ______|--|______________   (nivel AND NOT anterior)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity detector_flanco is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;   -- sincrono, activo en alto
        nivel  : in  std_logic;
        pulso  : out std_logic
    );
end entity detector_flanco;

architecture rtl of detector_flanco is
    signal anterior : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- TODO 1: si rst = '1', anterior <= '0'; si no, guardar 'nivel'
            null;
        end if;
    end process;

    -- TODO 2: ecuacion del pulso
    pulso <= '0';
end architecture rtl;
