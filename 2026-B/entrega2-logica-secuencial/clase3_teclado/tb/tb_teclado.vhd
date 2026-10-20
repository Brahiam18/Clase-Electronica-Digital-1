-- =============================================================================
-- CLASE 3 - TESTBENCH: tb_teclado.vhd
-- Modelo REALISTA del teclado: el testbench no fuerza el codigo de tecla.
-- Observa que fila pone la FPGA en '0' y, si la tecla "presionada" esta en esa
-- fila, pone en '0' la columna correspondiente (como los contactos reales).
-- Ademas simula el REBOTE al presionar y al soltar.
-- Este modelo y el procedure 'presionar' se reutilizan en el testbench final.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity tb_teclado is
end entity tb_teclado;

architecture sim of tb_teclado is
    constant CLK_HZ : positive := 10_000;
    constant T      : time := 1 sec / CLK_HZ;
    signal clk      : std_logic := '0';
    signal fin_sim  : boolean := false;
    signal rst      : std_logic := '1';
    signal tick_1ms : std_logic;
    signal columnas, filas, cod : std_logic_vector(3 downto 0);
    signal valida   : std_logic;
    signal pulsos   : natural := 0;

    -- ---------- modelo del teclado ----------
    signal k_fila, k_col   : integer range 0 to 3 := 0;
    signal k_on            : boolean := false;
    signal k2_on           : boolean := false;       -- segunda tecla simultanea
    signal k2_fila, k2_col : integer range 0 to 3 := 0;

    type t_teclas is array (0 to 3, 0 to 3) of character;
    constant MAPA : t_teclas := (('1', '2', '3', 'A'),
                                 ('4', '5', '6', 'B'),
                                 ('7', '8', '9', 'C'),
                                 ('*', '0', '#', 'D'));
    type t_codigos is array (0 to 3, 0 to 3) of std_logic_vector(3 downto 0);
    constant CODIGOS : t_codigos := (("0001", "0010", "0011", "1010"),
                                     ("0100", "0101", "0110", "1011"),
                                     ("0111", "1000", "1001", "1100"),
                                     ("1110", "0000", "1111", "1101"));
begin
    clk <= not clk after T / 2 when not fin_sim else '0';

    u_bt : entity work.base_tiempo generic map (CLK_HZ => CLK_HZ)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms,
                  tick_4hz => open, tick_1hz => open, onda_2hz => open);

    dut : entity work.teclado_4x4 generic map (N_REBOTE => 20)
        port map (clk => clk, rst => rst, tick_1ms => tick_1ms, columnas => columnas,
                  filas => filas, tecla_valida => valida, tecla_cod => cod);

    -- contactos: la columna cae a 0 si su tecla esta presionada Y su fila esta en 0
    gen_col : for c in 0 to 3 generate
        columnas(c) <= '0' when (k_on  and k_col  = c and filas(k_fila)  = '0') or
                                (k2_on and k2_col = c and filas(k2_fila) = '0')
                       else '1';
    end generate;

    -- contador de pulsos de tecla_valida
    process (clk)
    begin
        if rising_edge(clk) then
            if valida = '1' then pulsos <= pulsos + 1; end if;
        end if;
    end process;

    process
        variable ok, mal : natural := 0;
        variable antes   : natural;

        procedure verificar (c : boolean; nombre : string) is
        begin
            if c then ok := ok + 1; report "  OK    " & nombre;
            else mal := mal + 1; report "  FALLA " & nombre severity error; end if;
        end procedure;

        -- presiona (f, c) con rebote, la mantiene 'dur' y la suelta con rebote
        procedure presionar (f, c : integer; dur : time) is
        begin
            k_fila <= f; k_col <= c;
            for i in 1 to 3 loop
                k_on <= true;  wait for 2 ms;
                k_on <= false; wait for 1 ms;
            end loop;
            k_on <= true;  wait for dur;
            for i in 1 to 2 loop
                k_on <= false; wait for 1 ms;
                k_on <= true;  wait for 1 ms;
            end loop;
            k_on <= false; wait for 60 ms;
        end procedure;
    begin
        wait for 1 ms; rst <= '0'; wait for 10 ms;

        -- 1) las 16 teclas: codigo correcto y UN pulso por pulsacion
        for f in 0 to 3 loop
            for c in 0 to 3 loop
                antes := pulsos;
                presionar(f, c, 60 ms);
                verificar(pulsos = antes + 1 and cod = CODIGOS(f, c),
                          "tecla " & MAPA(f, c) & ": un pulso y codigo correcto");
            end loop;
        end loop;

        -- 2) tecla mantenida 2 s: sigue siendo un solo pulso
        antes := pulsos;
        presionar(1, 1, 2 sec);
        verificar(pulsos = antes + 1, "tecla mantenida 2 s -> un solo pulso");

        -- 3) pulso mas corto que el antirrebote: se ignora
        antes := pulsos;
        k_fila <= 0; k_col <= 0; k_on <= true; wait for 10 ms; k_on <= false;
        wait for 60 ms;
        verificar(pulsos = antes, "toque de 10 ms ignorado");

        -- 4) dos teclas de la MISMA fila a la vez: se descarta
        antes := pulsos;
        k2_fila <= 2; k2_col <= 2; k2_on <= true;
        k_fila  <= 2; k_col  <= 0; k_on  <= true;
        wait for 200 ms;
        k_on <= false; k2_on <= false; wait for 60 ms;
        verificar(pulsos = antes, "dos teclas en la misma fila -> descartada");

        report "===== RESUMEN: " & integer'image(ok) & " OK, "
               & integer'image(mal) & " FALLAS =====";
        fin_sim <= true;
        wait;
    end process;
end architecture sim;
