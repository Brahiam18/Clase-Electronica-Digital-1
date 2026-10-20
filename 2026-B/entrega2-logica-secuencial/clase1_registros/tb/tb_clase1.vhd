-- =============================================================================
-- CLASE 1 - TESTBENCH AUTOVERIFICABLE
-- Prueba: sincronizador, reset_sync, detector_flanco y reg_desplazamiento.
-- Uso en ModelSim/Questa:  compilar los 4 archivos de plantilla/ y este,
--                          simular tb_clase1 y ejecutar "run -all".
-- Al final aparece:  RESUMEN: X OK, Y FALLAS
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity tb_clase1 is
end entity tb_clase1;

architecture sim of tb_clase1 is
    constant T : time := 10 ns;
    signal clk : std_logic := '0';
    signal fin : boolean := false;

    signal s_in, s_out           : std_logic_vector(0 downto 0) := "0";
    signal rst_n, rst            : std_logic := '1';
    signal niv, pulso            : std_logic := '0';
    signal clr, push, pop        : std_logic := '0';
    signal dato                  : std_logic_vector(3 downto 0) := "0000";
    signal q                     : std_logic_vector(15 downto 0);
    signal n                     : std_logic_vector(2 downto 0);
begin
    clk <= not clk after T / 2 when not fin else '0';

    u_sync : entity work.sincronizador generic map (ANCHO => 1)
        port map (clk => clk, entrada => s_in, salida => s_out);
    u_rst  : entity work.reset_sync
        port map (clk => clk, rst_n => rst_n, rst => rst);
    u_flan : entity work.detector_flanco
        port map (clk => clk, rst => rst, nivel => niv, pulso => pulso);
    u_reg  : entity work.reg_desplazamiento
        port map (clk => clk, rst => rst, clr => clr, push => push, pop => pop,
                  dato => dato, q => q, n => n);

    process
        variable ok, mal : natural := 0;
        variable cuenta  : natural;

        procedure verificar (c : boolean; nombre : string) is
        begin
            if c then ok := ok + 1; report "  OK    " & nombre;
            else mal := mal + 1; report "  FALLA " & nombre severity error; end if;
        end procedure;

        procedure ciclos (k : natural) is
        begin
            for i in 1 to k loop wait until rising_edge(clk); end loop;
            wait for 1 ns;                       -- leer despues del flanco
        end procedure;

        procedure meter (d : std_logic_vector(3 downto 0)) is
        begin
            dato <= d; push <= '1'; ciclos(1); push <= '0';
        end procedure;
    begin
        -- ---------- reset_sync ----------
        rst_n <= '0'; ciclos(3);
        verificar(rst = '1', "reset_sync: rst_n=0 -> rst=1");
        rst_n <= '1'; ciclos(1);
        verificar(rst = '1', "reset_sync: tarda 2 ciclos en soltar (ciclo 1)");
        ciclos(1);
        verificar(rst = '0', "reset_sync: rst=0 despues de 2 ciclos");

        -- ---------- sincronizador ----------
        s_in <= "1"; ciclos(1);
        verificar(s_out = "0", "sincronizador: no pasa en 1 ciclo");
        ciclos(1);
        verificar(s_out = "1", "sincronizador: pasa en 2 ciclos");

        -- ---------- detector de flanco ----------
        niv <= '1'; wait for 1 ns;
        verificar(pulso = '1', "flanco: pulso al subir");
        cuenta := 0;
        for i in 1 to 5 loop
            ciclos(1);
            if pulso = '1' then cuenta := cuenta + 1; end if;
        end loop;
        verificar(cuenta = 0, "flanco: dura un solo ciclo con nivel mantenido");
        niv <= '0'; ciclos(2);
        verificar(pulso = '0', "flanco: no hay pulso al bajar");

        -- ---------- registro de desplazamiento ----------
        meter(x"1"); meter(x"2"); meter(x"3"); meter(x"4");
        verificar(q = x"1234" and n = "100", "registro: push 1,2,3,4 -> 1234");
        meter(x"9");
        verificar(q = x"1234" and n = "100", "registro: ignora el quinto digito");
        pop <= '1'; ciclos(1); pop <= '0';
        verificar(q = x"0123" and n = "011", "registro: pop borra el ultimo");
        clr <= '1'; ciclos(1); clr <= '0';
        verificar(q = x"0000" and n = "000", "registro: clr borra todo");
        pop <= '1'; ciclos(1); pop <= '0';
        verificar(n = "000", "registro: pop con registro vacio no hace nada");

        report "===== RESUMEN: " & integer'image(ok) & " OK, "
               & integer'image(mal) & " FALLAS =====";
        fin <= true;
        wait;
    end process;
end architecture sim;
