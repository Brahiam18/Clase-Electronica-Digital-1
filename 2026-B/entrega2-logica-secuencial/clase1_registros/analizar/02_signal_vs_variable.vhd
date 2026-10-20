-- =============================================================================
-- CLASE 1 - ANALIZAR: por que en este proyecto se prohiben las variables (R8)
-- Ambas arquitecturas "parecen" un registro de desplazamiento de 3 etapas.
-- Simulen las dos con el mismo estimulo y comparen q.
-- Preguntas:
--   1. Cuantos flip-flops sintetiza cada una? (RTL Viewer)
--   2. Por que en la version con variables el dato llega a q en 1 ciclo?
--   3. Que regla general se deduce sobre el ORDEN de las asignaciones?
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity cadena3 is
    port (
        clk, d : in  std_logic;
        q      : out std_logic
    );
end entity cadena3;

-- Con SENALES: las asignaciones se aplican TODAS al final del process.
-- a, b y q leen los valores ANTERIORES -> 3 flip-flops en cadena.
-- El orden de las lineas NO importa.
architecture con_senales of cadena3 is
    signal a, b : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            a <= d;
            b <= a;
            q <= b;
        end if;
    end process;
end architecture con_senales;

-- Con VARIABLES: se actualizan INMEDIATAMENTE, linea por linea.
-- va y vb ya tienen el valor nuevo cuando se usan -> 1 solo flip-flop.
-- El orden de las lineas SI importa (invertirlo cambia el hardware).
architecture con_variables of cadena3 is
begin
    process (clk)
        variable va, vb : std_logic := '0';
    begin
        if rising_edge(clk) then
            va := d;
            vb := va;
            q  <= vb;
        end if;
    end process;
end architecture con_variables;
