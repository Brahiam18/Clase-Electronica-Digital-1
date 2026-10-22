-- =============================================================================
-- CLASE 3 - PLANTILLA: digito_bcd.vhd
-- Un digito BCD DESCENDENTE (9 -> 0) con carga paralela.
-- Cuando baja estando en 0 pasa a 9 y avisa con 'presta' al digito siguiente.
--   d:      3 2 1 0 9 8 ...
--   presta: 0 0 0 1 0 0          (presta = 1 solo si d = 0 y dec = 1)
-- Restriccion R7: nada de '/', 'mod', 'rem' ni '*'.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digito_bcd is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        cargar : in  std_logic;
        valor  : in  std_logic_vector(3 downto 0);
        dec    : in  std_logic;
        q      : out std_logic_vector(3 downto 0);
        cero   : out std_logic;
        presta : out std_logic
    );
end entity digito_bcd;

architecture rtl of digito_bcd is
    signal d : unsigned(3 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                d <= (others => '0');
            elsif cargar = '1' then
                d <= unsigned(valor);
            elsif dec = '1' then
                -- TODO 1: si d = 0 pasar a 9; si no, restar 1
                null;
            end if;
        end if;
    end process;

    q      <= std_logic_vector(d);
    -- TODO 2: ecuaciones de 'cero' y 'presta'
    cero   <= '0';
    presta <= '0';
end architecture rtl;
