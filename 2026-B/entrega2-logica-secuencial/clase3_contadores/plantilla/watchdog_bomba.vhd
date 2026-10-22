-- =============================================================================
-- CLASE 3 - TAREA: watchdog_bomba.vhd   (RF8, proteccion de marcha en seco)
-- Mientras bomba_en = '1' cuenta segundos. Si el nivel SUBE, la cuenta se
-- reinicia. Si pasan T_S segundos sin subir -> falla = '1' (se mantiene
-- hasta que la bomba se apague).
-- Pistas:
--   * Necesitan recordar el nivel anterior -> registro 'previo'.
--   * "Subio" = unsigned(nivel) > previo.
--   * Con bomba_en = '0' todo vuelve a cero.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watchdog_bomba is
    generic (
        T_S : positive := 15
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        tick_1hz : in  std_logic;
        bomba_en : in  std_logic;
        nivel    : in  std_logic_vector(2 downto 0);
        falla    : out std_logic
    );
end entity watchdog_bomba;

architecture rtl of watchdog_bomba is
    signal previo : unsigned(2 downto 0) := (others => '0');
    signal cuenta : integer range 0 to T_S - 1 := 0;
    signal f      : std_logic := '0';
begin
    -- TODO: proceso sincrono completo

    falla <= f;
end architecture rtl;
