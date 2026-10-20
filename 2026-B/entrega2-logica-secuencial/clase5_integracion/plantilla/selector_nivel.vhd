-- =============================================================================
-- selector_nivel.vhd   (Etapa B de la entrega 1, reutilizada)
-- Entrega los 3 digitos BCD del porcentaje (centenas, decenas, unidades).
-- Restriccion de la entrega 1 que se mantiene: SIN process, solo concurrente.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.tanque_pkg.all;

entity selector_nivel is
    port (
        nivel : in  std_logic_vector(2 downto 0);
        cen   : out std_logic_vector(3 downto 0);
        dec   : out std_logic_vector(3 downto 0);
        uni   : out std_logic_vector(3 downto 0)
    );
end entity selector_nivel;

architecture flujo of selector_nivel is
begin
    with nivel select
        cen <= "0001" when N_100,
               "0000" when others;

    with nivel select
        dec <= "0010" when N_25,
               "0101" when N_50,
               "0111" when N_75,
               "0000" when others;

    with nivel select
        uni <= "0101" when N_25 | N_75,
               "0000" when others;
end architecture flujo;
