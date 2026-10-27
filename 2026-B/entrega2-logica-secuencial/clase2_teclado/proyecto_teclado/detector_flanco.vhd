library ieee;
use ieee.std_logic_1164.all;
entity detector_flanco is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
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
            if rst = '1' then
                anterior <= '0';
            else
                anterior <= nivel;
            end if;
        end if;
    end process;
    pulso <= nivel and not anterior;
end architecture rtl;
