-- =============================================================================
-- CLASE 4 - TESTBENCH: tb_fsm_proceso.vhd
-- Prueba UNITARIA de fsm_proceso: se manejan sus entradas directamente
-- (sin teclado ni sensores), escenario por escenario.
-- Un proceso aparte vigila RF6 en cada flanco de reloj.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.tanque_pkg.all;

entity tb_fsm_proceso is
end entity tb_fsm_proceso;

architecture sim of tb_fsm_proceso is
    constant T : time := 10 ns;
    signal clk : std_logic := '0';
    signal fin_sim : boolean := false;
    signal rst : std_logic := '1';
    signal cmd_n, cmd_t, cmd_c, man_b, man_c, ack : std_logic := '0';
    signal s5 : std_logic := '1';
    signal err_s, falla_b, t_cero : std_logic := '0';
    signal objetivo, nivel, est : std_logic_vector(2 downto 0) := "000";
    signal t_cargar, t_contar, ini_vac, bomba, comp : std_logic;
begin
    clk <= not clk after T / 2 when not fin_sim else '0';

    dut : entity work.fsm_proceso
        port map (clk => clk, rst => rst, cmd_nivel => cmd_n, cmd_tiempo => cmd_t,
                  cmd_cancelar => cmd_c, objetivo => objetivo, man_bomba => man_b,
                  man_comp => man_c, ack_alarma => ack, s5 => s5, nivel => nivel,
                  err_sensor => err_s, falla_bomba => falla_b, t_cero => t_cero,
                  t_cargar => t_cargar, t_contar => t_contar, inicio_vaciado => ini_vac,
                  estado_proc => est, bomba_en => bomba, compuerta_en => comp);

    process (clk)
    begin
        if rising_edge(clk) then
            assert not (bomba = '1' and comp = '1')
                report "RF6 VIOLADO: bomba y compuerta a la vez" severity failure;
        end if;
    end process;

    process
        variable ok, mal : natural := 0;
        variable vio_carga, vio_vaciado : boolean;

        procedure verificar (c : boolean; nombre : string) is
        begin
            if c then ok := ok + 1; report "  OK    " & nombre;
            else mal := mal + 1; report "  FALLA " & nombre severity error; end if;
        end procedure;
        procedure ciclos (k : natural) is
        begin
            for i in 1 to k loop wait until rising_edge(clk); end loop;
            wait for 1 ns;
        end procedure;
        procedure pulso (signal s : out std_logic) is
        begin
            s <= '1'; ciclos(1); s <= '0'; ciclos(2);
        end procedure;
    begin
        ciclos(2); rst <= '0'; ciclos(1);
        verificar(est = P_REPOSO and bomba = '0' and comp = '0', "reset -> REPOSO");

        -- ---------- nivel objetivo ----------
        nivel <= N_25; objetivo <= N_75; pulso(cmd_n);
        verificar(est = P_NIVEL and bomba = '1', "cmd_nivel 75 % -> LLENAR_NIVEL");
        nivel <= N_50; ciclos(2);
        verificar(bomba = '1', "sigue llenando en 50 %");
        nivel <= N_75; ciclos(2);
        verificar(est = P_REPOSO and bomba = '0', "objetivo alcanzado -> REPOSO");
        objetivo <= N_50; pulso(cmd_n);
        verificar(est = P_REPOSO, "objetivo menor que el nivel -> se ignora");

        -- ---------- llenado por tiempo con pausa ----------
        cmd_t <= '1'; wait for 1 ns; vio_carga := (t_cargar = '1');
        ciclos(1); cmd_t <= '0'; ciclos(1);
        verificar(vio_carga and est = P_TIEMPO and bomba = '1' and t_contar = '1',
                  "cmd_tiempo -> carga temporizador y LLENAR_TIEMPO");
        s5 <= '0'; ciclos(2);
        verificar(est = P_PAUSA and bomba = '0' and t_contar = '0', "S5 = 0 -> PAUSA");
        s5 <= '1'; ciclos(2);
        verificar(est = P_TIEMPO and bomba = '1', "S5 = 1 -> vuelve a LLENAR_TIEMPO");
        t_cero <= '1'; ciclos(2); t_cero <= '0';
        verificar(est = P_REPOSO and bomba = '0', "tiempo agotado -> REPOSO");

        -- ---------- llegada a 100 % y vaciado enclavado ----------
        nivel <= N_25; objetivo <= N_100; pulso(cmd_n);
        nivel <= N_100; cmd_c <= '1';             -- prioridad: 100 % gana a cancelar
        wait for 1 ns; vio_vaciado := (ini_vac = '1');
        ciclos(1); cmd_c <= '0'; ciclos(1);
        verificar(est = P_VACIAR and comp = '1' and bomba = '0',
                  "100 % gana a cancelar -> VACIAR");
        verificar(vio_vaciado, "pulso inicio_vaciado");
        nivel <= N_50; pulso(cmd_c);
        verificar(est = P_VACIAR and comp = '1', "compuerta enclavada (ignora cancelar)");
        nivel <= N_0; ciclos(2);
        verificar(est = P_REPOSO and comp = '0', "nivel 0 % -> REPOSO");

        -- ---------- manual ----------
        nivel <= N_25; man_b <= '1'; ciclos(2);
        verificar(est = P_MANUAL and bomba = '1', "bomba manual");
        s5 <= '0'; ciclos(2);
        verificar(bomba = '0', "bomba manual se apaga sin agua");
        s5 <= '1'; man_c <= '1'; ciclos(2);
        verificar(bomba = '0' and comp = '1', "compuerta manual reemplaza a la bomba");
        man_b <= '0'; man_c <= '0'; ciclos(2);
        verificar(est = P_REPOSO, "sin pedidos manuales -> REPOSO");

        -- ---------- fallas ----------
        objetivo <= N_100; pulso(cmd_n);
        falla_b <= '1'; ciclos(2); falla_b <= '0'; ciclos(1);
        verificar(est = P_FALLA_B and bomba = '0', "watchdog -> FALLA (F-b)");
        pulso(ack);
        verificar(est = P_REPOSO, "ack -> REPOSO");
        err_s <= '1'; ciclos(2);
        verificar(est = P_FALLA_S, "error de sensor -> FALLA (F-S)");
        pulso(ack);
        verificar(est = P_FALLA_S, "ack con sensor aun en error -> sigue en FALLA");
        err_s <= '0'; pulso(ack);
        verificar(est = P_REPOSO, "ack con lectura valida -> REPOSO");

        report "===== RESUMEN: " & integer'image(ok) & " OK, "
               & integer'image(mal) & " FALLAS =====";
        fin_sim <= true;
        wait;
    end process;
end architecture sim;
