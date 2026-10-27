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
    process (clk)
    begin
        if rising_edge(clk) then
            ff1 <= rst_n;
            ff2 <= ff1;
        end if;
    end process;
    rst <= not ff2;
end architecture rtl;
