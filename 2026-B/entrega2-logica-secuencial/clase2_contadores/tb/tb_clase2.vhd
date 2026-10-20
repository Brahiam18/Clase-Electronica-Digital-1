-- =============================================================================
-- CLASE 2 - TESTBENCH AUTOVERIFICABLE
-- Prueba: base_tiempo, antirrebote, temporizador, digito_bcd,
--         temporizador_bcd y (tarea) watchdog_bomba.
-- Se usa CLK_HZ = 10 kHz para que 1 s de simulacion sean solo 10 000 ciclos.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity tb_clase2 is
end entity tb_clase2;

architecture sim of tb_clase2 is
    constant CLK_HZ : positive := 10_000;
    constant T      : time := 1 sec / CLK_HZ;      -- 100 us
    signal clk : std_logic := '0';
    signal fin_sim : boolean := false;
    signal rst : std_logic := '1';

    signal t1ms, t4hz, t1hz, onda : std_logic;
    signal tick : std_logic := '0';                 -- tick manual del testbench
    signal ar_in, ar_out : std_logic_vector(0 downto 0) := "0";
    signal t_ena, t_rei, t_fin : std_logic := '0';
    signal b_carg, b_ena, b_cero : std_logic := '0';
    signal b_val, b_q : std_logic_vector(7 downto 0) := x"00";
    signal w_bomba, w_falla : std_logic := '0';
    signal w_nivel : std_logic_vector(2 downto 0) := "001";
begin
    clk <= not clk after T / 2 when not fin_sim else '0';

    u_bt : entity work.base_tiempo generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst => rst, tick_1ms => t1ms, tick_4hz => t4hz,
                  tick_1hz => t1hz, onda_2hz => onda);
    u_ar : entity work.antirrebote generic map (ANCHO => 1, N_TICKS => 5)
        port map (clk => clk, rst => rst, tick => tick, entrada => ar_in, salida => ar_out);
    u_tm : entity work.temporizador generic map (N_TICKS => 5)
        port map (clk => clk, rst => rst, tick => tick, ena => t_ena,
                  reiniciar => t_rei, fin => t_fin);
    u_tb : entity work.temporizador_bcd
        port map (clk => clk, rst => rst, tick => tick, cargar => b_carg,
                  valor => b_val, ena => b_ena, bcd => b_q, cero => b_cero);
    u_wd : entity work.watchdog_bomba generic map (T_S => 3)
        port map (clk => clk, rst => rst, tick_1hz => tick, bomba_en => w_bomba,
                  nivel => w_nivel, falla => w_falla);

    process
        variable ok, mal : natural := 0;
        variable t0, t1 : time;
        variable n : natural;

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
        procedure pulsos (k : natural) is            -- k ticks manuales
        begin
            for i in 1 to k loop
                tick <= '1'; ciclos(1); tick <= '0'; ciclos(2);
            end loop;
        end procedure;
    begin
        ciclos(3); rst <= '0'; ciclos(1);

        -- ---------- base de tiempo ----------
        wait until t1ms = '1' for 10 ms; t0 := now; ciclos(1);
        wait until t1ms = '1' for 10 ms; t1 := now;
        verificar(t1 - t0 = 1 ms, "base_tiempo: tick_1ms cada 1 ms");
        ciclos(1);
        verificar(t1ms = '0', "base_tiempo: tick_1ms dura 1 ciclo");
        wait until t4hz = '1' for 2 sec; t0 := now; ciclos(1);
        wait until t4hz = '1' for 2 sec; t1 := now;
        verificar(t1 - t0 = 250 ms, "base_tiempo: tick_4hz cada 250 ms");
        wait until t1hz = '1' for 3 sec; t0 := now; ciclos(1);
        wait until t1hz = '1' for 3 sec; t1 := now;
        verificar(t1 - t0 = 1 sec, "base_tiempo: tick_1hz cada 1 s");
        wait until onda'event for 2 sec; t0 := now; wait until onda'event for 2 sec; t1 := now;
        verificar(t1 - t0 = 250 ms, "base_tiempo: onda_2hz (medio periodo 250 ms)");

        -- ---------- antirrebote (N = 5) ----------
        ar_in <= "1"; pulsos(2); ar_in <= "0"; pulsos(1); ar_in <= "1"; pulsos(3);
        verificar(ar_out = "0", "antirrebote: rebote rechazado");
        pulsos(3);
        verificar(ar_out = "1", "antirrebote: acepta tras 5 ticks estable");

        -- ---------- temporizador (N = 5) ----------
        t_ena <= '1'; pulsos(4);
        verificar(t_fin = '0', "temporizador: no termina en 4 ticks");
        pulsos(1);
        verificar(t_fin = '1', "temporizador: termina en 5 ticks");
        pulsos(3);
        verificar(t_fin = '1', "temporizador: fin se mantiene");
        t_rei <= '1'; ciclos(1); t_rei <= '0'; ciclos(1);
        verificar(t_fin = '0', "temporizador: reiniciar lo pone en 0");
        t_ena <= '0';

        -- ---------- temporizador BCD ----------
        b_val <= x"12"; b_carg <= '1'; ciclos(1); b_carg <= '0';
        verificar(b_q = x"12" and b_cero = '0', "bcd: carga 12");
        b_ena <= '1'; pulsos(3);
        verificar(b_q = x"09", "bcd: 12 -> 09 en cascada (presta)");
        b_ena <= '0'; pulsos(4);
        verificar(b_q = x"09", "bcd: ena = 0 pausa la cuenta");
        b_ena <= '1'; pulsos(12);
        verificar(b_q = x"00" and b_cero = '1', "bcd: se detiene en 00");

        -- ---------- watchdog (tarea, T_S = 3) ----------
        w_bomba <= '1'; pulsos(2); w_nivel <= "010"; ciclos(1); pulsos(2);
        verificar(w_falla = '0', "watchdog: el nivel subio, no hay falla");
        pulsos(1);
        verificar(w_falla = '1', "watchdog: 3 s sin subir -> falla");
        w_bomba <= '0'; ciclos(2);
        verificar(w_falla = '0', "watchdog: se limpia al apagar la bomba");

        report "===== RESUMEN: " & integer'image(ok) & " OK, "
               & integer'image(mal) & " FALLAS =====";
        fin_sim <= true;
        wait;
    end process;
end architecture sim;
