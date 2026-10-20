-- =============================================================================
-- contador_bcd.vhd
-- Contador ascendente de 2 digitos BCD (00..99). Se usa para contar cuantas
-- veces se ha vaciado el tanque (menu de administrador, opcion 5).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_bcd is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        inc : in  std_logic;
        bcd : out std_logic_vector(7 downto 0)
    );
end entity contador_bcd;

architecture rtl of contador_bcd is
    signal u, d : unsigned(3 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                u <= (others => '0');
                d <= (others => '0');
            elsif inc = '1' then
                if u = 9 then
                    u <= (others => '0');
                    if d = 9 then
                        d <= (others => '0');
                    else
                        d <= d + 1;
                    end if;
                else
                    u <= u + 1;
                end if;
            end if;
        end if;
    end process;

    bcd <= std_logic_vector(d) & std_logic_vector(u);
end architecture rtl;
