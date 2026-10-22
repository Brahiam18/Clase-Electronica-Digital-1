-- =============================================================================
-- CLASE 2 - BLOQUE DE APOYO: base_tiempo.vhd   (YA ESTA COMPLETO, no se modifica)
-- El teclado necesita un pulso cada 1 ms para el barrido y el antirrebote.
-- Este bloque se lo da. Como funciona por dentro se estudia en la CLASE 3,
-- donde ustedes mismos completaran su version en clase3_contadores/plantilla.
-- -----------------------------------------------------------------------------
-- Unica fuente de tiempo del sistema (R1). NO genera relojes: genera pulsos
-- "tick" de UN ciclo de reloj que los demas bloques usan como habilitacion.
--   tick_1ms : cada 1 ms   (barrido de teclado, antirrebote, filtros)
--   tick_4hz : cada 250 ms (mensajes, parpadeo)
--   tick_1hz : cada 1 s    (temporizadores en segundos)
--   onda_2hz : onda cuadrada de 2 Hz (flip-flop T habilitado por tick_4hz)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity base_tiempo is
    generic (
        CLK_HZ : positive := 50_000_000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;   -- reset sincrono, activo en alto (ya sincronizado)
        tick_1ms : out std_logic;
        tick_4hz : out std_logic;
        tick_1hz : out std_logic;
        onda_2hz : out std_logic
    );
end entity base_tiempo;

architecture rtl of base_tiempo is
    -- Division entre CONSTANTES: se resuelve al compilar, no genera hardware.
    constant CICLOS_MS : positive := CLK_HZ / 1000;

    signal cnt_clk : integer range 0 to CICLOS_MS - 1 := 0;
    signal cnt_ms  : integer range 0 to 249 := 0;
    signal cnt_4   : integer range 0 to 3   := 0;
    signal t1ms, t4hz, t1hz, onda : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- por defecto los ticks valen 0: duran exactamente un ciclo
            t1ms <= '0';
            t4hz <= '0';
            t1hz <= '0';
            if rst = '1' then
                cnt_clk <= 0; cnt_ms <= 0; cnt_4 <= 0; onda <= '0';
            else
                -- etapa 1: reloj -> 1 ms
                if cnt_clk = CICLOS_MS - 1 then
                    cnt_clk <= 0;
                    t1ms    <= '1';
                    -- etapa 2: 1 ms -> 250 ms (contador en cascada)
                    if cnt_ms = 249 then
                        cnt_ms <= 0;
                        t4hz   <= '1';
                        onda   <= not onda;          -- flip-flop T
                        -- etapa 3: 250 ms -> 1 s
                        if cnt_4 = 3 then
                            cnt_4 <= 0;
                            t1hz  <= '1';
                        else
                            cnt_4 <= cnt_4 + 1;
                        end if;
                    else
                        cnt_ms <= cnt_ms + 1;
                    end if;
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
