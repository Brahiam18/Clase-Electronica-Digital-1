-- =============================================================================
-- CLASE 4 - PLANTILLA: fsm_proceso.vhd
-- Maquina de estados de la PLANTA (Figura 1 de la guia: flujo de la planta). Decide bomba_en y
-- compuerta_en. Estilo de 3 procesos (R5):
--   P1 registro   : estado y salidas registradas (R6)
--   P2 siguiente  : logica de siguiente estado, con PRIORIDADES:
--                   1) falla de sensor  2) nivel = 100 %  3) S5 = 0  4) comandos
--   P3 salidas    : valor que tendran bomba/compuerta en el SIGUIENTE estado
-- Interbloqueo RF5: por construccion bomba_n y comp_n nunca valen 1 a la vez.
-- HECHO: registros (P1), REPOSO, LLENAR_NIVEL y la prioridad 1.
-- PENDIENTE: busquen los TODO (estados PAUSA, VACIAR, MANUAL, FALLA y salidas).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tanque_pkg.all;

entity fsm_proceso is
    port (
        clk, rst      : in  std_logic;
        -- comandos de fsm_sesion
        cmd_nivel     : in  std_logic;                      -- pulso
        cmd_cancelar  : in  std_logic;                      -- pulso
        objetivo      : in  std_logic_vector(2 downto 0);   -- N_25..N_100
        man_bomba     : in  std_logic;
        man_comp      : in  std_logic;
        -- planta y vigilancia
        s5            : in  std_logic;
        nivel         : in  std_logic_vector(2 downto 0);
        err_sensor    : in  std_logic;                      -- confirmado (1 s)
        -- salidas
        inicio_vaciado: out std_logic;                      -- pulso
        estado_proc   : out std_logic_vector(2 downto 0);
        bomba_en      : out std_logic;                      -- registrada
        compuerta_en  : out std_logic                       -- registrada
    );
end entity fsm_proceso;

architecture rtl of fsm_proceso is
    type t_estado is (REPOSO, LLENAR_NIVEL, PAUSA, VACIAR, MANUAL, FALLA);
    signal estado, estado_n : t_estado := REPOSO;

    signal obj_r                : unsigned(2 downto 0) := "000"; -- objetivo guardado
    signal bomba_r, comp_r      : std_logic := '0';
    signal bomba_n, comp_n      : std_logic;
    signal hay_falla, lleno     : std_logic;
begin
    hay_falla <= err_sensor;          -- error de sensor confirmado (RF6)
    lleno     <= '1' when nivel = N_100 else '0';

    -- ============ P1: registros ============
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                estado <= REPOSO; obj_r <= "000";
                bomba_r <= '0'; comp_r <= '0';
            else
                estado    <= estado_n;
                bomba_r   <= bomba_n;
                comp_r    <= comp_n;
                if cmd_nivel = '1' and estado = REPOSO then
                    obj_r <= unsigned(objetivo);    -- guardar el objetivo
                end if;
            end if;
        end if;
    end process;

    -- ============ P2: siguiente estado ============
    process (estado, hay_falla, lleno, s5, cmd_nivel,
             cmd_cancelar, objetivo, obj_r, nivel, man_bomba, man_comp)
    begin
        estado_n  <= estado;            -- por defecto: quedarse

        -- prioridad 1: falla (desde cualquier estado excepto FALLA)
        if estado /= FALLA and hay_falla = '1' then
            estado_n  <= FALLA;
        else
            case estado is
                when REPOSO =>
                    if cmd_nivel = '1' and s5 = '1'
                       and unsigned(nivel) < unsigned(objetivo) then
                        estado_n <= LLENAR_NIVEL;
                    elsif man_bomba = '1' or man_comp = '1' then
                        estado_n <= MANUAL;
                    end if;

                when LLENAR_NIVEL =>
                    if lleno = '1' then                 -- prioridad 2
                        estado_n <= VACIAR;
                    elsif s5 = '0' then                 -- prioridad 3
                        estado_n <= PAUSA;
                    elsif cmd_cancelar = '1' then       -- prioridad 4
                        estado_n <= REPOSO;
                    elsif unsigned(nivel) >= obj_r then
                        estado_n <= REPOSO;             -- objetivo alcanzado
                    end if;

                when PAUSA =>
                    -- TODO 1: prioridades: lleno -> VACIAR ; cmd_cancelar -> REPOSO ;
                    --         s5 = '1' -> volver a LLENAR_NIVEL
                    null;

                when VACIAR =>
                    -- TODO 2: enclavado: solo sale a REPOSO cuando nivel = N_0
                    null;

                when MANUAL =>
                    -- TODO 3: lleno -> VACIAR ; sin pedidos manuales -> REPOSO
                    null;

                when FALLA =>
                    -- TODO 4: FALLA queda ENCLAVADA (RF6): no tiene transicion de
                    --         salida, solo el reset (KEY0) la libera. Que hay que
                    --         escribir aqui? Por que no se genera un latch?
                    null;
            end case;
        end if;
    end process;

    -- ============ P3: salidas del siguiente estado (se registran en P1) ============
    process (estado_n, man_bomba, man_comp, s5)
    begin
        bomba_n <= '0';
        comp_n  <= '0';
        case estado_n is
            when LLENAR_NIVEL =>
                bomba_n <= '1';
            -- TODO 5: VACIAR -> compuerta
            -- TODO 6: MANUAL -> compuerta = man_comp ;
            --         bomba = man_bomba AND s5 AND NOT man_comp   (por que? RF5)
            when others =>
                null;
        end case;
    end process;

    -- ============ salidas ============
    bomba_en       <= bomba_r;
    compuerta_en   <= comp_r;
    inicio_vaciado <= '1' when estado_n = VACIAR and estado /= VACIAR else '0';

    estado_proc <= P_NIVEL   when estado = LLENAR_NIVEL  else
                   P_PAUSA   when estado = PAUSA         else
                   P_VACIAR  when estado = VACIAR        else
                   P_MANUAL  when estado = MANUAL        else
                   P_FALLA_S when estado = FALLA         else
                   P_REPOSO;
end architecture rtl;
