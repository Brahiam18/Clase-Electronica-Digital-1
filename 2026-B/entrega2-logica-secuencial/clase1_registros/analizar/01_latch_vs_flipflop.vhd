-- =============================================================================
-- CLASE 1 - ANALIZAR: latch inferido vs flip-flop vs logica combinacional
-- Compilen este archivo en Quartus y abran:
--   Tools > Netlist Viewers > RTL Viewer
--   Compilation Report > Analysis & Synthesis > Messages (busquen "latch")
-- Preguntas para clase:
--   1. Cual de las tres arquitecturas genera un LATCH? Por que?
--   2. Cual genera un FLIP-FLOP? Que palabra del codigo lo provoca?
--   3. Como se arregla la arquitectura A sin volverla secuencial?
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity ejemplo_memoria is
    port (
        clk, habilitar, dato : in  std_logic;
        q                    : out std_logic
    );
end entity ejemplo_memoria;

-- -----------------------------------------------------------------------------
-- A) MAL: process combinacional con 'if' INCOMPLETO.
--    Cuando habilitar = '0' no se dice cuanto vale q -> debe "recordar"
--    el valor anterior -> Quartus infiere un LATCH (Warning 10631).
-- -----------------------------------------------------------------------------
architecture latch_inferido of ejemplo_memoria is
begin
    process (habilitar, dato)
    begin
        if habilitar = '1' then
            q <= dato;
        end if;            -- falta el 'else'
    end process;
end architecture latch_inferido;

-- -----------------------------------------------------------------------------
-- B) BIEN (si queremos memoria): flip-flop D con habilitacion.
--    Solo cambia en el flanco de subida del reloj. Si habilitar = '0'
--    conserva el valor: eso es exactamente lo que hace un flip-flop.
-- -----------------------------------------------------------------------------
architecture flip_flop of ejemplo_memoria is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if habilitar = '1' then
                q <= dato;
            end if;        -- aqui SI esta permitido no poner 'else'
        end if;
    end process;
end architecture flip_flop;

-- -----------------------------------------------------------------------------
-- C) BIEN (si NO queremos memoria): combinacional con valor por defecto.
-- -----------------------------------------------------------------------------
architecture combinacional of ejemplo_memoria is
begin
    process (habilitar, dato)
    begin
        q <= '0';          -- valor por defecto: toda rama queda cubierta
        if habilitar = '1' then
            q <= dato;
        end if;
    end process;
end architecture combinacional;
