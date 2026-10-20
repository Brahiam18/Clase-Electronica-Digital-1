-- =============================================================================
-- CLASE 2 - PLANTILLA: temporizador_bcd.vhd   (R7)
-- Cuenta regresiva 99..00 hecha con DOS digito_bcd EN CASCADA.
--
--   tick --+                 +----------+ presta_u  +----------+
--   ena  --+--[dec_u]------->| UNIDADES |---------->| DECENAS  |
--   not cero_tot ---+        +----------+           +----------+
--                                cero_u  ----+---- cero_d
--                                            +--> cero_tot (AND)
-- Usos: llenado por tiempo 01..99 s (RF4) y bloqueo de 30 s (RF2).
-- 'ena' = 0 PAUSA la cuenta sin perder el valor (S5 = 0 en RF4).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity temporizador_bcd is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        tick   : in  std_logic;
        cargar : in  std_logic;
        valor  : in  std_logic_vector(7 downto 0);
        ena    : in  std_logic;
        bcd    : out std_logic_vector(7 downto 0);
        cero   : out std_logic
    );
end entity temporizador_bcd;

architecture estructural of temporizador_bcd is
    signal cero_u, cero_d, cero_tot : std_logic;
    signal dec_u, presta_u          : std_logic;
begin
    -- TODO 1: cero_tot = las dos cifras en cero
    cero_tot <= '0';
    -- TODO 2: dec_u = llega tick, esta habilitado y NO ha llegado a 00
    dec_u    <= '0';

    unidades : entity work.digito_bcd
        port map (clk => clk, rst => rst, cargar => cargar,
                  valor => valor(3 downto 0), dec => dec_u,
                  q => bcd(3 downto 0), cero => cero_u, presta => presta_u);

    -- TODO 3: instanciar 'decenas' (digito_bcd) con valor(7 downto 4).
    --         Que senal va en su entrada 'dec'?  Que hacen con su 'presta'?
    cero_d <= '1';
    bcd(7 downto 4) <= "0000";

    cero <= cero_tot;
end architecture estructural;
