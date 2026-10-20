-- =============================================================================
-- CLASE 1 - PLANTILLA: reset_sync.vhd   (R2)
-- El pulsador KEY0 de la DE0-Nano vale '0' al presionarlo (activo en BAJO)
-- y es asincrono. Este bloque entrega un reset SINCRONO activo en ALTO.
-- Pregunta: los flip-flops arrancan en '0' al configurar la FPGA.
--           Que valor tiene 'rst' en los primeros ciclos? Es bueno o malo?
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity reset_sync is
    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        rst   : out std_logic
    );
end entity reset_sync;

architecture rtl of reset_sync is
    signal ff1, ff2 : std_logic := '0';
begin
    -- TODO 1: sincronizador de 2 flip-flops para rst_n

    -- TODO 2: invertir la polaridad (activo en bajo -> activo en alto)
    rst <= '0';
end architecture rtl;
