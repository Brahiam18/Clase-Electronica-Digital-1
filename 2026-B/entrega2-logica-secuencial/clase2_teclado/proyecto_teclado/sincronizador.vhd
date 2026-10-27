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
            ff1 <= entrada;
            ff2 <= ff1;
        end if;
    end process;
    salida <= ff2;
end architecture rtl;
