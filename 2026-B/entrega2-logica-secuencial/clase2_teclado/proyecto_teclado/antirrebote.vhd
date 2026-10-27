library ieee;
use ieee.std_logic_1164.all;
entity antirrebote is
    generic (
        ANCHO   : positive := 1;
        N_TICKS : positive := 20
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick    : in  std_logic;
        entrada : in  std_logic_vector(ANCHO-1 downto 0);
        salida  : out std_logic_vector(ANCHO-1 downto 0)
    );
end entity antirrebote;
architecture rtl of antirrebote is
    signal previa  : std_logic_vector(ANCHO-1 downto 0) := (others => '0');
    signal estable : std_logic_vector(ANCHO-1 downto 0) := (others => '0');
    signal cuenta  : integer range 0 to N_TICKS - 1 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                previa  <= (others => '0');
                estable <= (others => '0');
                cuenta  <= 0;
            elsif entrada /= previa then
                previa <= entrada;
                cuenta <= 0;
            elsif tick = '1' then
                if cuenta = N_TICKS - 1 then
                    estable <= previa;
                else
                    cuenta <= cuenta + 1;
                end if;
            end if;
        end if;
    end process;
    salida <= estable;
end architecture rtl;
