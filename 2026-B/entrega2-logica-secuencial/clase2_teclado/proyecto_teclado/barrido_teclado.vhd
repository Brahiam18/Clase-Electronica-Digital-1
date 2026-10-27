library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity barrido_teclado is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tick      : in  std_logic;
        columnas  : in  std_logic_vector(3 downto 0);
        filas     : out std_logic_vector(3 downto 0);
        hay_tecla : out std_logic;
        codigo    : out std_logic_vector(3 downto 0)
    );
end entity barrido_teclado;
architecture rtl of barrido_teclado is
    signal fila      : unsigned(1 downto 0) := "00";
    signal col_idx   : std_logic_vector(1 downto 0);
    signal una_col   : std_logic;
    signal fila_col  : std_logic_vector(3 downto 0);
    signal cod_tabla : std_logic_vector(3 downto 0);
    signal hay_r     : std_logic := '0';
    signal cod_r     : std_logic_vector(3 downto 0) := (others => '0');
begin
    with columnas select
        col_idx <= "00" when "1110",
                   "01" when "1101",
                   "10" when "1011",
                   "11" when "0111",
                   "00" when others;
    with columnas select
        una_col <= '1' when "1110" | "1101" | "1011" | "0111",
                   '0' when others;
    fila_col <= std_logic_vector(fila) & col_idx;
    with fila_col select
        cod_tabla <= "0001" when "0000",
                     "0010" when "0001",
                     "0011" when "0010",
                     "1010" when "0011",
                     -- COMPLETAR 2
                     "1101" when others;
    -- COMPLETAR 1
    filas <= "ZZZZ";
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                fila  <= "00";
                hay_r <= '0';
                cod_r <= (others => '0');
            elsif tick = '1' then
                if columnas = "1111" then
                    hay_r <= '0';
                    fila  <= fila + 1;
                elsif una_col = '1' then
                    hay_r <= '1';
                    cod_r <= cod_tabla;
                else
                    hay_r <= '0';
                end if;
            end if;
        end if;
    end process;
    hay_tecla <= hay_r;
    codigo    <= cod_r;
end architecture rtl;
