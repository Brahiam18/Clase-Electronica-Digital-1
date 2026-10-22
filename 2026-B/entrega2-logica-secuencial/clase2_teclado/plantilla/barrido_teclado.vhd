-- =============================================================================
-- CLASE 2 - PLANTILLA: barrido_teclado.vhd
--
--   Distribucion:      col0 col1 col2 col3
--             fila0     1    2    3    A
--             fila1     4    5    6    B
--             fila2     7    8    9    C
--             fila3     *    0    #    D
--   Codigos: 0-9 = digito, A=1010, B=1011, C=1100, D=1101, *=1110, #=1111
--
-- Funcionamiento (en cada tick de 1 ms):
--   * columnas = "1111"        -> nadie presiona en esta fila: avanzar fila
--   * exactamente una en '0'   -> hay tecla: congelar fila y guardar codigo
--   * dos o mas en '0'         -> lectura descartada (hay_tecla = 0)
-- La salida todavia REBOTA: despues va al antirrebote.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrido_teclado is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tick      : in  std_logic;
        columnas  : in  std_logic_vector(3 downto 0);  -- YA sincronizadas
        filas     : out std_logic_vector(3 downto 0);  -- activas en 0
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
    -- Codificador de columna (HECHO): que columna esta en '0'
    with columnas select
        col_idx <= "00" when "1110",
                   "01" when "1101",
                   "10" when "1011",
                   "11" when "0111",
                   "00" when others;

    -- TODO 1: una_col = '1' solo si EXACTAMENTE una columna esta en '0'
    una_col <= '0';

    -- Tabla fila & columna -> codigo (ROM).  TODO 2: completar las filas 1, 2 y 3
    fila_col <= std_logic_vector(fila) & col_idx;
    with fila_col select
        cod_tabla <= "0001" when "0000",  -- 1
                     "0010" when "0001",  -- 2
                     "0011" when "0010",  -- 3
                     "1010" when "0011",  -- A
                     -- TODO: fila 1 (4 5 6 B), fila 2 (7 8 9 C), fila 3 (* 0 #)
                     "1101" when others;  -- D

    -- TODO 3: decodificador de fila activa en BAJO (fila 0 -> "1110", ...)
    filas <= "1111";

    -- TODO 4: proceso secuencial (reset, y en cada tick las 3 situaciones)
    process (clk)
    begin
        if rising_edge(clk) then
            null;
        end if;
    end process;

    hay_tecla <= hay_r;
    codigo    <= cod_r;
end architecture rtl;
