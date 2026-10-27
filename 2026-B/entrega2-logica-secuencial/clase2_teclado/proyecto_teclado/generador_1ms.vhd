library ieee;
use ieee.std_logic_1164.all;
entity generador_1ms is
    generic (
        CLK_HZ : positive := 50_000_000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        tick_1ms : out std_logic
    );
end entity generador_1ms;
architecture rtl of generador_1ms is
    constant CICLOS : positive := CLK_HZ / 1000;
    signal cuenta : integer range 0 to CICLOS - 1 := 0;
    signal tick   : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            tick <= '0';
            if rst = '1' then
                cuenta <= 0;
            elsif cuenta = CICLOS - 1 then
                cuenta <= 0;
                tick   <= '1';
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;
    tick_1ms <= tick;
end architecture rtl;
