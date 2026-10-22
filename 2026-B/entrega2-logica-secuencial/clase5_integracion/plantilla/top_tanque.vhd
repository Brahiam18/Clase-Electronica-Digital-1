-- =============================================================================
-- CLASE 5 - PLANTILLA: top_tanque.vhd
-- Entidad superior: SOLO instancias y conexiones (R13). Ver Figura 1.
-- Tarjeta: DE0-Nano (Cyclone IV E EP4CE22F17C6), reloj de 50 MHz.
-- Todos los tiempos son generics (R10): para simular se usa un CLK_HZ pequeno.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity top_tanque is
    generic (
        CLK_HZ        : positive := 50_000_000;
        T_REBOTE_MS   : positive := 20;
        T_FILTRO_MS   : positive := 200;
        T_SENSOR_MS   : positive := 1000;
        T_WDOG_S      : positive := 15;
        T_INACT_S     : positive := 20;
        T_MSG_S       : positive := 2;
        T_BLOQ_BCD    : std_logic_vector(7 downto 0)  := x"30";
        CLAVE_USR_INI : std_logic_vector(15 downto 0) := x"1234";
        CLAVE_ADM     : std_logic_vector(15 downto 0) := x"2580"
    );
    port (
        clk          : in  std_logic;
        rst_n        : in  std_logic;
        s1, s2, s3, s4, s5 : in std_logic;
        columnas     : in  std_logic_vector(3 downto 0);
        filas        : out std_logic_vector(3 downto 0);
        dis3, dis2, dis1, dis0 : out std_logic_vector(6 downto 0);
        led_s5       : out std_logic;
        led_admin    : out std_logic;
        led_alarma   : out std_logic;
        bomba_en     : out std_logic;
        compuerta_en : out std_logic
    );
end entity top_tanque;

architecture estructural of top_tanque is
    -- reloj, reset y tiempo
    signal rst, tick_1ms, tick_4hz, tick_1hz, onda_2hz : std_logic;
    -- sensores
    signal sens_s  : std_logic_vector(4 downto 0);     -- S5..S1 sincronizados
    signal sens_f  : std_logic_vector(3 downto 0);     -- S4..S1 filtrados
    signal nivel   : std_logic_vector(2 downto 0);
    signal err_raw, err_conf, falla_b : std_logic;
    -- teclado
    signal tecla_valida : std_logic;
    signal tecla_cod    : std_logic_vector(3 downto 0);
    -- sesion
    signal entrada : std_logic_vector(15 downto 0);
    signal ndig    : std_logic_vector(2 downto 0);
    signal r_push, r_pop, r_clr : std_logic;
    signal cast_cargar, cast_activo, cast_cero, msg_activo, msg_fin : std_logic;
    signal ses_activa, inact_fin, admin : std_logic;
    signal cmd_n, cmd_c, ack : std_logic;
    signal objetivo : std_logic_vector(2 downto 0);
    signal cast_bcd, vac_bcd : std_logic_vector(7 downto 0);
    signal man_b, man_c : std_logic;
    signal vista : std_logic_vector(3 downto 0);
    -- proceso
    signal ini_vac : std_logic;
    signal est_proc : std_logic_vector(2 downto 0);
    signal bomba_s, comp_s : std_logic;
    -- display
    signal cen, dec, uni : std_logic_vector(3 downto 0);
    signal c3, c2, c1, c0 : std_logic_vector(4 downto 0);
begin
    -- ===================== reloj, reset y base de tiempo =====================
    u_rst : entity work.reset_sync port map (clk => clk, rst_n => rst_n, rst => rst);

    u_bt : entity work.base_tiempo
        generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms,
                  tick_4hz => tick_4hz, tick_1hz => tick_1hz, onda_2hz => onda_2hz);

    -- ===================== sensores =====================
    u_sync_s : entity work.sincronizador
        generic map (ANCHO => 5)
        port map (clk => clk, entrada(4) => s5, entrada(3) => s4, entrada(2) => s3,
                  entrada(1) => s2, entrada(0) => s1, salida => sens_s);

    u_filtro : entity work.antirrebote
        generic map (ANCHO => 4, N_TICKS => T_FILTRO_MS)
        port map (clk => clk, rst => rst, tick => tick_1ms,
                  entrada => sens_s(3 downto 0), salida => sens_f);

    u_nivel : entity work.detector_nivel
        port map (sensores => sens_f, nivel => nivel, error => err_raw);

    u_t_sensor : entity work.temporizador
        generic map (N_TICKS => T_SENSOR_MS)
        port map (clk => clk, rst => rst, tick => tick_1ms, ena => err_raw,
                  reiniciar => '0', fin => err_conf);

    u_wdog : entity work.watchdog_bomba
        generic map (T_S => T_WDOG_S)
        port map (clk => clk, rst => rst, tick_1hz => tick_1hz,
                  bomba_en => bomba_s, nivel => nivel, falla => falla_b);

    -- ===================== teclado =====================
    u_teclado : entity work.teclado_4x4
        generic map (N_REBOTE => T_REBOTE_MS)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms, columnas => columnas,
                  filas => filas, tecla_valida => tecla_valida, tecla_cod => tecla_cod);

    -- ===================== sesion =====================
    -- TODO 1: reg_desplazamiento (dato = tecla_cod)
    -- TODO 2: fsm_sesion (generics CLAVE_USR_INI y CLAVE_ADM)
    -- TODO 3: temporizador de mensajes (tick_4hz, N_TICKS => 4 * T_MSG_S, ena => msg_activo)
    -- TODO 4: temporizador de inactividad (tick_1hz, N_TICKS => T_INACT_S,
    --         ena => ses_activa, reiniciar => tecla_valida)
    -- TODO 5: temporizador_bcd del castigo (valor => T_BLOQ_BCD, ena => cast_activo)

    -- ===================== proceso =====================
    -- TODO 6: fsm_proceso (s5 => sens_s(4))
    -- TODO 7: contador_bcd de vaciados (inc => ini_vac)

    -- ===================== displays =====================
    -- TODO 8: selector_nivel, formateador_display y 4 decodificador_7seg

    -- ===================== conexiones directas a pines =====================
    led_s5       <= sens_s(4);
    led_admin    <= admin;
    bomba_en     <= bomba_s;
    compuerta_en <= comp_s;
end architecture estructural;
