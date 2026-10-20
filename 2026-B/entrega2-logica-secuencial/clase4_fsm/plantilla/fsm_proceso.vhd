-- =============================================================================
-- CLASE 4 - PLANTILLA: fsm_proceso.vhd
-- Maquina de estados de la PLANTA (Figura 2 de la guia). Decide bomba_en y
-- compuerta_en. Estilo de 3 procesos (R5):
--   P1 registro   : estado y salidas registradas (R6)
--   P2 siguiente  : logica de siguiente estado, con PRIORIDADES:
--                   1) falla  2) nivel = 100 %  3) S5 = 0  4) comandos
--   P3 salidas    : valor que tendran bomba/compuerta en el SIGUIENTE estado
-- Interbloqueo RF6: por construccion bomba_n y comp_n nunca valen 1 a la vez.
-- HECHO: registros (P1), REPOSO, LLENAR_NIVEL/LLENAR_TIEMPO y la prioridad 1.
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
        cmd_tiempo    : in  std_logic;                      -- pulso
        cmd_cancelar  : in  std_logic;                      -- pulso
        objetivo      : in  std_logic_vector(2 downto 0);   -- N_25..N_100
        man_bomba     : in  std_logic;
        man_comp      : in  std_logic;
        ack_alarma    : in  std_logic;                      -- pulso
        -- planta y vigilancia
        s5            : in  std_logic;
        nivel         : in  std_logic_vector(2 downto 0);
        err_sensor    : in  std_logic;                      -- confirmado (1 s)
        falla_bomba   : in  std_logic;                      -- watchdog
        t_cero        : in  std_logic;                      -- llenado por tiempo
        -- salidas
        t_cargar      : out std_logic;                      -- cargar temporizador
        t_contar      : out std_logic;                      -- habilitar cuenta
        inicio_vaciado: out std_logic;                      -- pulso
        estado_proc   : out std_logic_vector(2 downto 0);
        bomba_en      : out std_logic;                      -- registrada
        compuerta_en  : out std_logic                       -- registrada
    );
end entity fsm_proceso;

architecture rtl of fsm_proceso is
    type t_estado is (REPOSO, LLENAR_NIVEL, LLENAR_TIEMPO, PAUSA,
                      VACIAR, MANUAL, FALLA);
    signal estado, estado_n : t_estado := REPOSO;

    signal origen, origen_n     : t_estado := LLENAR_NIVEL; -- a donde vuelve PAUSA
    signal obj_r                : unsigned(2 downto 0) := "000";
    signal falla_s_r, falla_s_n : std_logic := '0';         -- tipo de falla
    signal bomba_r, comp_r      : std_logic := '0';
    signal bomba_n, comp_n      : std_logic;
    signal hay_falla, lleno     : std_logic;
begin
    hay_falla <= err_sensor or falla_bomba;
    lleno     <= '1' when nivel = N_100 else '0';

    -- ============ P1: registros ============
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                estado <= REPOSO; origen <= LLENAR_NIVEL; obj_r <= "000";
                falla_s_r <= '0'; bomba_r <= '0'; comp_r <= '0';
            else
                estado    <= estado_n;
                origen    <= origen_n;
                falla_s_r <= falla_s_n;
                bomba_r   <= bomba_n;
                comp_r    <= comp_n;
                if cmd_nivel = '1' and estado = REPOSO then
                    obj_r <= unsigned(objetivo);    -- guardar el objetivo
                end if;
            end if;
        end if;
    end process;

    -- ============ P2: siguiente estado ============
    process (estado, origen, falla_s_r, hay_falla, err_sensor, lleno, s5,
             cmd_nivel, cmd_tiempo, cmd_cancelar, objetivo, obj_r, nivel,
             man_bomba, man_comp, ack_alarma, t_cero)
    begin
        estado_n  <= estado;            -- por defecto: quedarse
        origen_n  <= origen;
        falla_s_n <= falla_s_r;
        t_cargar  <= '0';

        -- prioridad 1: falla (desde cualquier estado excepto FALLA)
        if estado /= FALLA and hay_falla = '1' then
            estado_n  <= FALLA;
            falla_s_n <= err_sensor;    -- 1 = sensor (F-S), 0 = bomba (F-b)
        else
            case estado is
                when REPOSO =>
                    if cmd_nivel = '1' and s5 = '1'
                       and unsigned(nivel) < unsigned(objetivo) then
                        estado_n <= LLENAR_NIVEL;
                    elsif cmd_tiempo = '1' and s5 = '1' then
                        estado_n <= LLENAR_TIEMPO;
                        t_cargar <= '1';
                    elsif man_bomba = '1' or man_comp = '1' then
                        estado_n <= MANUAL;
                    end if;

                when LLENAR_NIVEL | LLENAR_TIEMPO =>
                    if lleno = '1' then                 -- prioridad 2
                        estado_n <= VACIAR;
                    elsif s5 = '0' then                 -- prioridad 3
                        estado_n <= PAUSA;
                        origen_n <= estado;
                    elsif cmd_cancelar = '1' then       -- prioridad 4
                        estado_n <= REPOSO;
                    elsif estado = LLENAR_NIVEL and unsigned(nivel) >= obj_r then
                        estado_n <= REPOSO;             -- objetivo alcanzado
                    elsif estado = LLENAR_TIEMPO and t_cero = '1' then
                        estado_n <= REPOSO;             -- se acabo el tiempo
                    end if;

                when PAUSA =>
                    -- TODO 1: prioridades: lleno -> VACIAR ; cmd_cancelar -> REPOSO ;
                    --         s5 = '1' -> volver a 'origen'
                    null;

                when VACIAR =>
                    -- TODO 2: enclavado: solo sale a REPOSO cuando nivel = N_0
                    null;

                when MANUAL =>
                    -- TODO 3: lleno -> VACIAR ; sin pedidos manuales -> REPOSO
                    null;

                when FALLA =>
                    -- TODO 4: sale a REPOSO solo con ack_alarma = '1' y sin
                    --         error de sensor activo
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
            when LLENAR_NIVEL | LLENAR_TIEMPO =>
                bomba_n <= '1';
            -- TODO 5: VACIAR -> compuerta
            -- TODO 6: MANUAL -> compuerta = man_comp ;
            --         bomba = man_bomba AND s5 AND NOT man_comp   (por que? RF6)
            when others =>
                null;
        end case;
    end process;

    -- ============ salidas ============
    bomba_en       <= bomba_r;
    compuerta_en   <= comp_r;
    t_contar       <= '1' when estado = LLENAR_TIEMPO else '0';
    inicio_vaciado <= '1' when estado_n = VACIAR and estado /= VACIAR else '0';

    estado_proc <= P_NIVEL   when estado = LLENAR_NIVEL  else
                   P_TIEMPO  when estado = LLENAR_TIEMPO else
                   P_PAUSA   when estado = PAUSA         else
                   P_VACIAR  when estado = VACIAR        else
                   P_MANUAL  when estado = MANUAL        else
                   P_FALLA_S when estado = FALLA and falla_s_r = '1' else
                   P_FALLA_B when estado = FALLA         else
                   P_REPOSO;
end architecture rtl;
