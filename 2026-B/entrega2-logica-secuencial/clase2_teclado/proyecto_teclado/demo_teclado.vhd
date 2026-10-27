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
    u_rst : entity work.reset_sync
        port map (clk => clk, rst_n => rst_n, rst => rst);
    u_1ms : entity work.generador_1ms
        generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms);
    u_tec : entity work.teclado_4x4
        generic map (N_REBOTE => N_REBOTE)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms, columnas => columnas,
                  filas => filas, tecla_valida => valida, tecla_cod => cod);
    process (clk)
    begin
        if rising_edge(clk) then
            -- COMPLETAR 3
        end if;
    end process;
    led <= std_logic_vector(contador) & ultima;
end architecture rtl;
