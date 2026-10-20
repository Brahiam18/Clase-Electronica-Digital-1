-- =============================================================================
-- CLASE 4 - ANALIZAR: la MISMA maquina de estados escrita de dos formas
--
--            inicio = 1 y s5 = 1              lleno = 1
--   REPOSO ---------------------> LLENANDO ---------------> VACIANDO
--     ^   <------------------------  |                        |
--     |        s5 = 0                                         |
--     +-------------------------------------------------------+
--                              vacio = 1
--
--   Salidas (Moore): LLENANDO -> bomba = 1 ;  VACIANDO -> compuerta = 1
--
-- Preguntas:
--   1. En la arquitectura A (un proceso), las salidas cambian en el MISMO
--      flanco que el estado o un ciclo despues? Dibujen el diagrama de tiempos.
--   2. En B, que proceso es combinacional y cual secuencial? Cual necesita
--      lista de sensibilidad completa? Que pasa si falta una senal?
--   3. En B, 'bomba' sale de un flip-flop? Comparen con la regla R6.
--   4. Que hace 'when others' si el estado tiene solo 3 valores posibles?
--      (pista: con 2 bits de codificacion hay 4 combinaciones)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity fsm_tanque_simple is
    port (
        clk, rst                 : in  std_logic;
        inicio, s5, lleno, vacio : in  std_logic;
        bomba, compuerta         : out std_logic
    );
end entity fsm_tanque_simple;

-- -----------------------------------------------------------------------------
-- A) UN SOLO PROCESO: compacto, pero el estado, las transiciones y las
--    salidas quedan mezcladas. Dificil de leer cuando la FSM crece.
-- -----------------------------------------------------------------------------
architecture un_proceso of fsm_tanque_simple is
    type t_estado is (REPOSO, LLENANDO, VACIANDO);
    signal estado : t_estado := REPOSO;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                estado <= REPOSO; bomba <= '0'; compuerta <= '0';
            else
                case estado is
                    when REPOSO =>
                        if inicio = '1' and s5 = '1' then
                            estado <= LLENANDO; bomba <= '1';
                        end if;
                    when LLENANDO =>
                        if lleno = '1' then
                            estado <= VACIANDO; bomba <= '0'; compuerta <= '1';
                        elsif s5 = '0' then
                            estado <= REPOSO; bomba <= '0';
                        end if;
                    when VACIANDO =>
                        if vacio = '1' then
                            estado <= REPOSO; compuerta <= '0';
                        end if;
                end case;
            end if;
        end if;
    end process;
end architecture un_proceso;

-- -----------------------------------------------------------------------------
-- B) TRES PROCESOS (estilo exigido en el proyecto, R5):
--    P1 registro, P2 siguiente estado, P3 salidas del siguiente estado.
--    Cada parte se lee directo del diagrama.
-- -----------------------------------------------------------------------------
architecture tres_procesos of fsm_tanque_simple is
    type t_estado is (REPOSO, LLENANDO, VACIANDO);
    signal estado, estado_n : t_estado := REPOSO;
    signal bomba_n, comp_n, bomba_r, comp_r : std_logic := '0';
begin
    -- P1: unico lugar con rising_edge
    p1 : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                estado <= REPOSO; bomba_r <= '0'; comp_r <= '0';
            else
                estado <= estado_n; bomba_r <= bomba_n; comp_r <= comp_n;
            end if;
        end if;
    end process;

    -- P2: flechas del diagrama (combinacional)
    p2 : process (estado, inicio, s5, lleno, vacio)
    begin
        estado_n <= estado;                     -- por defecto: quedarse
        case estado is
            when REPOSO =>
                if inicio = '1' and s5 = '1' then estado_n <= LLENANDO; end if;
            when LLENANDO =>
                if lleno = '1' then    estado_n <= VACIANDO;
                elsif s5 = '0' then    estado_n <= REPOSO;
                end if;
            when VACIANDO =>
                if vacio = '1' then estado_n <= REPOSO; end if;
            when others =>
                estado_n <= REPOSO;             -- estado ilegal: volver a lugar seguro
        end case;
    end process;

    -- P3: salidas segun el SIGUIENTE estado (se registran en P1)
    p3 : process (estado_n)
    begin
        bomba_n <= '0'; comp_n <= '0';
        case estado_n is
            when LLENANDO => bomba_n <= '1';
            when VACIANDO => comp_n  <= '1';
            when others   => null;
        end case;
    end process;

    bomba     <= bomba_r;
    compuerta <= comp_r;
end architecture tres_procesos;
