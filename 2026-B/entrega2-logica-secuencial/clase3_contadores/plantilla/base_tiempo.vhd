-- =============================================================================
-- CLASE 3 - PLANTILLA: base_tiempo.vhd   (R1, R10)
-- Unica fuente de tiempo. Tres contadores EN CASCADA:
--
--   clk --[cuenta CLK_HZ/1000]--> tick_1ms --[cuenta 250]--> tick_4hz --[cuenta 4]--> tick_1hz
--                                                               |
--                                                            onda_2hz (flip-flop T)
--
-- Cada tick dura UN ciclo de reloj. La etapa 1 ya esta hecha: usenla de modelo.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity base_tiempo is
    generic (
        CLK_HZ : positive := 50_000_000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        tick_1ms : out std_logic;
        tick_4hz : out std_logic;
        tick_1hz : out std_logic;
        onda_2hz : out std_logic
    );
end entity base_tiempo;

architecture rtl of base_tiempo is
    -- Division entre CONSTANTES: Quartus la calcula al compilar (no es hardware).
    constant CICLOS_MS : positive := CLK_HZ / 1000;

    signal cnt_clk : integer range 0 to CICLOS_MS - 1 := 0;
    signal cnt_ms  : integer range 0 to 249 := 0;
    signal cnt_4   : integer range 0 to 3   := 0;
    signal t1ms, t4hz, t1hz, onda : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            t1ms <= '0';
            t4hz <= '0';
            t1hz <= '0';
            if rst = '1' then
                cnt_clk <= 0; cnt_ms <= 0; cnt_4 <= 0; onda <= '0';
            else
                -- ---------- etapa 1: reloj -> 1 ms (HECHA) ----------
                if cnt_clk = CICLOS_MS - 1 then
                    cnt_clk <= 0;
                    t1ms    <= '1';
                    -- TODO 1: etapa 2. Contar 250 milisegundos con cnt_ms.
                    --         Al completar: reiniciar cnt_ms, t4hz <= '1'
                    --         e invertir 'onda'.
                    -- TODO 2: etapa 3 (DENTRO de la etapa 2). Contar 4 ticks de
                    --         250 ms con cnt_4. Al completar: t1hz <= '1'.
                else
                    cnt_clk <= cnt_clk + 1;
                end if;
            end if;
        end if;
    end process;

    tick_1ms <= t1ms;
    tick_4hz <= t4hz;
    tick_1hz <= t1hz;
    onda_2hz <= onda;
end architecture rtl;
