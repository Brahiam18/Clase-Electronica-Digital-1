-- =============================================================================
-- CLASE 2 - DEMO EN LA TARJETA: demo_teclado.vhd
-- Prueba el teclado SOLO, antes de integrarlo al proyecto.
--   * LED[3:0] muestran el codigo de la ultima tecla.
--   * LED[7:4] cuentan cuantas teclas se han aceptado (prueba de rebote:
--     si al presionar una vez el contador sube 2 o mas, el antirrebote falla).
-- Preguntas:
--   1. Cambien N_REBOTE a 1 y vuelvan a programar. Que pasa con el contador?
--   2. Mantengan una tecla presionada 3 s. Cuantas veces sube el contador? Por que?
--   3. Presionen 1 y 4 a la vez (misma columna). Que se lee? Por que importa
--      la resistencia en serie de las filas en ese caso?
-- Pines (DE0-Nano): ver demo_teclado.qsf
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demo_teclado is
    generic (
        CLK_HZ   : positive := 50_000_000;
        N_REBOTE : positive := 20
    );
    port (
        clk      : in  std_logic;
        rst_n    : in  std_logic;
        columnas : in  std_logic_vector(3 downto 0);
        filas    : out std_logic_vector(3 downto 0);
        led      : out std_logic_vector(7 downto 0)
    );
end entity demo_teclado;

architecture rtl of demo_teclado is
    signal rst, tick_1ms, valida : std_logic;
    signal cod      : std_logic_vector(3 downto 0);
    signal ultima   : std_logic_vector(3 downto 0) := (others => '0');
    signal contador : unsigned(3 downto 0) := (others => '0');
begin
    u_rst : entity work.reset_sync port map (clk => clk, rst_n => rst_n, rst => rst);

    u_bt : entity work.base_tiempo
        generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms,
                  tick_4hz => open, tick_1hz => open, onda_2hz => open);

    u_tec : entity work.teclado_4x4
        generic map (N_REBOTE => N_REBOTE)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms, columnas => columnas,
                  filas => filas, tecla_valida => valida, tecla_cod => cod);

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ultima <= (others => '0'); contador <= (others => '0');
            elsif valida = '1' then
                ultima   <= cod;
                contador <= contador + 1;
            end if;
        end if;
    end process;

    led <= std_logic_vector(contador) & ultima;
end architecture rtl;
