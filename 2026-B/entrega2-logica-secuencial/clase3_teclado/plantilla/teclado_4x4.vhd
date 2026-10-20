-- =============================================================================
-- CLASE 3 - PLANTILLA: teclado_4x4.vhd   (bloque ESTRUCTURAL: solo instancias)
--
--  columnas -> [sincronizador] -> [barrido_teclado] -> [antirrebote] -> [detector_flanco]
--                col_s           hay_raw, cod_raw     estable(4..0)     tecla_valida
--                                                     estable(3..0) ---> tecla_cod
--
-- Truco: el antirrebote recibe un bus de 5 bits = hay_raw & cod_raw, asi la
-- tecla y su codigo se estabilizan JUNTOS.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity teclado_4x4 is
    generic (
        N_REBOTE : positive := 20
    );
    port (
        clk, rst     : in  std_logic;
        tick_1ms     : in  std_logic;
        columnas     : in  std_logic_vector(3 downto 0);
        filas        : out std_logic_vector(3 downto 0);
        tecla_valida : out std_logic;
        tecla_cod    : out std_logic_vector(3 downto 0)
    );
end entity teclado_4x4;

architecture estructural of teclado_4x4 is
    signal col_s   : std_logic_vector(3 downto 0);
    signal hay_raw : std_logic;
    signal cod_raw : std_logic_vector(3 downto 0);
    signal estable : std_logic_vector(4 downto 0) := (others => '0');
begin
    u_sync : entity work.sincronizador
        generic map (ANCHO => 4)
        port map (clk => clk, entrada => columnas, salida => col_s);

    u_barrido : entity work.barrido_teclado
        port map (clk => clk, rst => rst, tick => tick_1ms, columnas => col_s,
                  filas => filas, hay_tecla => hay_raw, codigo => cod_raw);

    -- TODO 1: instanciar antirrebote (ANCHO => 5, N_TICKS => N_REBOTE)
    --         entrada(4) => hay_raw, entrada(3 downto 0) => cod_raw, salida => estable

    -- TODO 2: instanciar detector_flanco sobre estable(4)
    tecla_valida <= '0';

    tecla_cod <= estable(3 downto 0);
end architecture estructural;
