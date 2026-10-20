-- =============================================================================
-- CLASE 2 - ANALIZAR: dos formas de hacer que un LED parpadee a 1 Hz
-- La arquitectura A es la forma "intuitiva" y esta PROHIBIDA en el proyecto
-- (R1). La B es la forma correcta.
-- Preguntas:
--   1. En A, cuantas senales distintas aparecen dentro de rising_edge()?
--   2. Compilen A y miren el Timing Analyzer: que advertencia aparece sobre
--      'clk_lento'? (pista: "ripple clock" / "clock derived from logic")
--   3. En B, cuantos ciclos de reloj dura 'tick'? Que pasaria si durara 2?
--   4. En B, como cambiarian el codigo para que el LED parpadee a 4 Hz?
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity parpadeo is
    generic (
        CLK_HZ : positive := 50_000_000
    );
    port (
        clk : in  std_logic;
        led : out std_logic
    );
end entity parpadeo;

-- -----------------------------------------------------------------------------
-- A) MAL: se fabrica un reloj nuevo con logica y se usa como reloj.
--    'clk_lento' sale de un flip-flop -> llega tarde y con retardo variable
--    (skew) a los flip-flops que lo usan. Con muchos relojes asi el diseno
--    falla de forma aleatoria y la herramienta no puede verificar tiempos.
-- -----------------------------------------------------------------------------
architecture reloj_derivado of parpadeo is
    signal cuenta    : integer range 0 to CLK_HZ / 2 - 1 := 0;
    signal clk_lento : std_logic := '0';
    signal q         : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if cuenta = CLK_HZ / 2 - 1 then
                cuenta    <= 0;
                clk_lento <= not clk_lento;    -- "reloj" de 1 Hz
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;

    process (clk_lento)                        -- <- SEGUNDO RELOJ: prohibido
    begin
        if rising_edge(clk_lento) then
            q <= not q;
        end if;
    end process;

    led <= q;
end architecture reloj_derivado;

-- -----------------------------------------------------------------------------
-- B) BIEN: un solo reloj. El contador genera un PULSO 'tick' de un ciclo y
--    el segundo flip-flop solo cambia cuando tick = '1' (clock enable).
--    Todos los flip-flops ven el MISMO flanco de 'clk'.
-- -----------------------------------------------------------------------------
architecture clock_enable of parpadeo is
    constant N : positive := CLK_HZ / 2;      -- constante: no genera hardware
    signal cuenta : integer range 0 to N - 1 := 0;
    signal tick   : std_logic := '0';
    signal q      : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            tick <= '0';                       -- por defecto: 0
            if cuenta = N - 1 then
                cuenta <= 0;
                tick   <= '1';                 -- dura exactamente 1 ciclo
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;

    process (clk)                              -- <- el MISMO reloj
    begin
        if rising_edge(clk) then
            if tick = '1' then                 -- habilitacion
                q <= not q;
            end if;
        end if;
    end process;

    led <= q;
end architecture clock_enable;
