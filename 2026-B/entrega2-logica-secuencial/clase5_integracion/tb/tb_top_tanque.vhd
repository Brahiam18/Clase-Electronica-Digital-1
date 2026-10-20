-- =============================================================================
-- CLASE 5 - PLANTILLA: tb_top_tanque.vhd
-- Testbench AUTOVERIFICABLE del sistema completo (casos TC1..TC12 de la guia).
-- HECHOS: modelos, utilidades, TC1, TC2, TC4 y TC5. PENDIENTES: TC3, TC6..TC12.
--   * Modelo de teclado matricial con rebote: el testbench NO fuerza el codigo
--     de tecla; responde a las filas que maneja la FPGA, como el teclado real.
--   * Modelo de tanque: sube un escalon cada T_PASO mientras la bomba esta
--     encendida y baja uno por segundo con la compuerta abierta.
--   * Se usa CLK_HZ = 10 kHz (R10) para que la simulacion sea rapida.
--   * Un assert concurrente vigila RF6 en TODOS los flancos de reloj.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity tb_top_tanque is
end entity tb_top_tanque;

architecture sim of tb_top_tanque is
    constant CLK_HZ  : positive := 10_000;
    constant T_CLK   : time := 1 sec / CLK_HZ;

    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal s1, s2, s3, s4, s5 : std_logic := '0';
    signal columnas, filas : std_logic_vector(3 downto 0);
    signal dis3, dis2, dis1, dis0 : std_logic_vector(6 downto 0);
    signal led_s5, led_admin, led_alarma, bomba_en, compuerta_en : std_logic;

    -- modelo de teclado
    signal k_fila, k_col : integer range 0 to 3 := 0;
    signal k_on          : boolean := false;
    -- modelo de tanque
    signal nivel_tq   : integer range 0 to 4 := 0;
    signal congelar   : boolean := false;               -- nivel no cambia
    signal forzar     : boolean := false;               -- sensores manuales
    signal s_forzado  : std_logic_vector(3 downto 0) := "0000";
    signal nivel_ini  : integer range 0 to 4 := 0;
    signal cargar_niv : boolean := false;
    signal t_paso     : time := 2 sec;
    signal fin_sim    : boolean := false;

    -- ----------------- utilidades -----------------
    function seg2chr (s : std_logic_vector(6 downto 0)) return character is
    begin
        case s is
            when "1111110" => return '0';  when "0110000" => return '1';
            when "1101101" => return '2';  when "1111001" => return '3';
            when "0110011" => return '4';  when "1011011" => return '5';
            when "1011111" => return '6';  when "1110000" => return '7';
            when "1111111" => return '8';  when "1111011" => return '9';
            when "1110111" => return 'A';  when "0011111" => return 'b';
            when "1001110" => return 'C';  when "1001111" => return 'E';
            when "1000111" => return 'F';  when "0001110" => return 'L';
            when "0000101" => return 'r';  when "0001111" => return 't';
            when "0010101" => return 'n';  when "1100111" => return 'P';
            when "0000001" => return '-';  when "0000000" => return ' ';
            when others    => return '?';
        end case;
    end function;
begin
    -- ----------------- DUT -----------------
    dut : entity work.top_tanque
        generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst_n => rst_n, s1 => s1, s2 => s2, s3 => s3,
                  s4 => s4, s5 => s5, columnas => columnas, filas => filas,
                  dis3 => dis3, dis2 => dis2, dis1 => dis1, dis0 => dis0,
                  led_s5 => led_s5, led_admin => led_admin, led_alarma => led_alarma,
                  bomba_en => bomba_en, compuerta_en => compuerta_en);

    clk <= not clk after T_CLK / 2 when not fin_sim else '0';

    -- ----------------- modelo del teclado -----------------
    gen_col : for c in 0 to 3 generate
        columnas(c) <= '0' when k_on and k_col = c and filas(k_fila) = '0' else '1';
    end generate;

    -- ----------------- modelo del tanque -----------------
    tanque : process
        variable t_b, t_c : time := 0 ns;
    begin
        wait until rising_edge(clk);
        if cargar_niv then
            nivel_tq <= nivel_ini; t_b := 0 ns; t_c := 0 ns;
        elsif not congelar then
            if bomba_en = '1' then t_b := t_b + T_CLK; else t_b := 0 ns; end if;
            if compuerta_en = '1' then t_c := t_c + T_CLK; else t_c := 0 ns; end if;
            if t_b >= t_paso then
                t_b := 0 ns;
                if nivel_tq < 4 then nivel_tq <= nivel_tq + 1; end if;
            end if;
            if t_c >= 1 sec then
                t_c := 0 ns;
                if nivel_tq > 0 then nivel_tq <= nivel_tq - 1; end if;
            end if;
        end if;
    end process;

    s1 <= s_forzado(0) when forzar else '1' when nivel_tq >= 1 else '0';
    s2 <= s_forzado(1) when forzar else '1' when nivel_tq >= 2 else '0';
    s3 <= s_forzado(2) when forzar else '1' when nivel_tq >= 3 else '0';
    s4 <= s_forzado(3) when forzar else '1' when nivel_tq >= 4 else '0';

    -- ----------------- RF6: vigilancia permanente -----------------
    process (clk)
    begin
        if rising_edge(clk) then
            assert not (bomba_en = '1' and compuerta_en = '1')
                report "RF6 VIOLADO: bomba y compuerta activas a la vez"
                severity failure;
        end if;
    end process;

    -- ----------------- estimulos y verificacion -----------------
    estimulos : process
        variable pasaron, fallaron : natural := 0;
        variable t0 : time;

        impure function pantalla return string is
            variable r : string(1 to 4);
        begin
            r(1) := seg2chr(dis3); r(2) := seg2chr(dis2);
            r(3) := seg2chr(dis1); r(4) := seg2chr(dis0);
            return r;
        end function;

        procedure verificar (cond : boolean; nombre : string) is
        begin
            if cond then
                pasaron := pasaron + 1;
                report "  OK    " & nombre;
            else
                fallaron := fallaron + 1;
                report "  FALLA " & nombre & "  (display='" & pantalla & "')"
                    severity error;
            end if;
        end procedure;

        procedure esperar (t : time) is
        begin
            wait for t;
        end procedure;

        -- presiona una tecla con rebote al presionar y al soltar
        procedure tecla (ch : character) is
            variable f, c : integer;
        begin
            case ch is
                when '1' => f := 0; c := 0; when '2' => f := 0; c := 1;
                when '3' => f := 0; c := 2; when 'A' => f := 0; c := 3;
                when '4' => f := 1; c := 0; when '5' => f := 1; c := 1;
                when '6' => f := 1; c := 2; when 'B' => f := 1; c := 3;
                when '7' => f := 2; c := 0; when '8' => f := 2; c := 1;
                when '9' => f := 2; c := 2; when 'C' => f := 2; c := 3;
                when '*' => f := 3; c := 0; when '0' => f := 3; c := 1;
                when '#' => f := 3; c := 2; when others => f := 3; c := 3; -- D
            end case;
            k_fila <= f; k_col <= c;
            for i in 1 to 3 loop                    -- rebote al presionar
                k_on <= true;  wait for 2 ms;
                k_on <= false; wait for 1 ms;
            end loop;
            k_on <= true;  wait for 60 ms;           -- presion estable
            for i in 1 to 2 loop                    -- rebote al soltar
                k_on <= false; wait for 1 ms;
                k_on <= true;  wait for 1 ms;
            end loop;
            k_on <= false; wait for 60 ms;
        end procedure;

        procedure teclear (s : string) is
        begin
            for i in s'range loop
                tecla(s(i));
            end loop;
        end procedure;

        procedure tanque_en (n : integer) is
        begin
            nivel_ini <= n; cargar_niv <= true;
            wait until rising_edge(clk); wait until rising_edge(clk);
            cargar_niv <= false;
            wait for 400 ms;                        -- filtro de 200 ms
        end procedure;
    begin
        report "===== Inicio de la simulacion =====";
        s5 <= '1';
        rst_n <= '0'; wait for 20 ms; rst_n <= '1'; wait for 500 ms;

        -- ---------------- TC1: reset ----------------
        report "TC1 - reset";
        verificar(bomba_en = '0' and compuerta_en = '0', "TC1 salidas en 0");
        verificar(pantalla = "b   ", "TC1 display bloqueado");
        verificar(led_s5 = '1', "TC1 LED S5 sigue a S5");

        -- ---------------- TC2: contrasena correcta ----------------
        report "TC2 - contrasena correcta";
        teclear("12");
        verificar(pantalla = "b --", "TC2 dos guiones, no los digitos");
        teclear("34#");
        verificar(pantalla = " 000", "TC2 menu de usuario (nivel 000)");
        tecla('*');                                  -- cerrar sesion
        verificar(pantalla = "b   ", "TC2 cierre de sesion con *");

        -- ---------------- TC3: tres intentos fallidos ----------------
        -- TODO: 3 claves incorrectas -> "b 30" en el display, LED de alarma
        --       parpadeando, teclas ignoradas, y "b   " despues de 30 s.
        --       (pista: wait until led_alarma = '1' for 1 sec;)

        -- ---------------- TC4 y TC5: nivel objetivo ----------------
        report "TC4/TC5 - nivel objetivo";
        tanque_en(1);
        teclear("1234#");
        verificar(pantalla = " 025", "TC4 menu muestra 025");
        teclear("A60#");
        verificar(pantalla = "Err ", "TC5 60 % rechazado");
        verificar(bomba_en = '0', "TC5 bomba apagada");
        wait for 2.5 sec;
        teclear("A75#");
        verificar(bomba_en = '1' and pantalla = "L025", "TC4 bomba encendida");
        wait until nivel_tq = 3 for 10 sec;
        wait for 300 ms;
        verificar(bomba_en = '0', "TC4 bomba apagada al llegar a 75 %");
        verificar(pantalla = " 075", "TC4 display 075");

        -- ---------------- TC6 a TC12 ----------------
        -- TODO: escribir un bloque por caso, con la tabla 10.1 de la guia.
        --   TC6  B10#, S5 = 0 en el segundo 4 y vuelve en el 7 -> ~10 s de bombeo
        --        (usen congelar <= true para que el tanque no suba)
        --   TC7  llegar a 100 % -> compuerta 1 y bomba 0 en el mismo flanco;
        --        compuerta abierta hasta 0 %
        --   TC8  cambio de clave con confirmacion distinta y luego igual
        --   TC9  manual: bomba encendida y luego compuerta (RF6)
        --   TC10 20 s sin teclas con llenado en curso (t_paso <= 6 sec)
        --   TC11 bomba encendida con el nivel congelado 15 s -> "F-b "
        --   TC12 pulso de 50 ms en S3 (forzar/s_forzado) y luego combinacion
        --        invalida estable 2 s -> "F-5 " (la S y el 5 se ven igual)

        -- ---------------- resumen ----------------
        report "===== RESUMEN: " & integer'image(pasaron) & " verificaciones OK, "
               & integer'image(fallaron) & " fallas =====";
        assert fallaron = 0 report "HAY FALLAS" severity error;
        fin_sim <= true;
        wait;
    end process;
end architecture sim;
