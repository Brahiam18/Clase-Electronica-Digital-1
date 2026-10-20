-- =============================================================================
-- detector_nivel.vhd   (Etapa A de la entrega 1, reutilizada)
-- Convierte los 4 sensores (ya sincronizados y filtrados) en un codigo de
-- nivel 0..4 y una bandera de error. En la entrega 1 el codificador entregaba
-- "000" tanto para 0 % como para una combinacion invalida; aqui la bandera
-- 'error' elimina esa ambiguedad.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.tanque_pkg.all;

entity detector_nivel is
    port (
        sensores : in  std_logic_vector(3 downto 0);   -- S4 S3 S2 S1
        nivel    : out std_logic_vector(2 downto 0);
        error    : out std_logic
    );
end entity detector_nivel;

architecture flujo of detector_nivel is
begin
    with sensores select
        nivel <= N_0   when "0000",
                 N_25  when "0001",
                 N_50  when "0011",
                 N_75  when "0111",
                 N_100 when "1111",
                 N_0   when others;

    with sensores select
        error <= '0' when "0000" | "0001" | "0011" | "0111" | "1111",
                 '1' when others;
end architecture flujo;
