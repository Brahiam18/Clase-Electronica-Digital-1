-- =============================================================================
-- CLASE 1 - PLANTILLA: sincronizador.vhd   (R11)
-- Objetivo: llevar una entrada asincrona al dominio del reloj con DOS
-- flip-flops en cascada. Generico en ANCHO para sincronizar un bus.
--
--   entrada --[FF1]--ff1--[FF2]--ff2--> salida
--              clk         clk
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity sincronizador is
    generic (
        ANCHO : positive := 1
    );
    port (
        clk     : in  std_logic;
        entrada : in  std_logic_vector(ANCHO-1 downto 0);
        salida  : out std_logic_vector(ANCHO-1 downto 0)
    );
end entity sincronizador;

architecture rtl of sincronizador is
    signal ff1, ff2 : std_logic_vector(ANCHO-1 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- TODO 1: primer flip-flop (toma la entrada)
            -- TODO 2: segundo flip-flop (toma la salida del primero)
            null;
        end if;
    end process;

    -- TODO 3: conectar la salida
    salida <= (others => '0');
end architecture rtl;
