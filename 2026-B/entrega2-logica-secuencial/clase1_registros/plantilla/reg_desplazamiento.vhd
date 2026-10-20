-- =============================================================================
-- CLASE 1 - PLANTILLA: reg_desplazamiento.vhd   (R9)
-- Registro de 4 digitos BCD (16 bits) para capturar la contrasena.
--   clr  : borra todo                      (prioridad 1)
--   push : entra 'dato' por la derecha     (prioridad 2, solo si n < 4)
--   pop  : borra el ultimo digito          (prioridad 3, solo si n > 0)
--
--   q = | d3 | d2 | d1 | d0 |      push 7:  | d2 | d1 | d0 | 7  |
--        15..12 11..8 7..4 3..0     pop:     | 0  | d3 | d2 | d1 |
-- Ejemplo: push 1, 2, 3, 4  ->  q = x"1234", n = 4
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_desplazamiento is
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        clr  : in  std_logic;
        push : in  std_logic;
        pop  : in  std_logic;
        dato : in  std_logic_vector(3 downto 0);
        q    : out std_logic_vector(15 downto 0);
        n    : out std_logic_vector(2 downto 0)   -- cuantos digitos hay (0..4)
    );
end entity reg_desplazamiento;

architecture rtl of reg_desplazamiento is
    signal r   : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt : unsigned(2 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or clr = '1' then
                r   <= (others => '0');
                cnt <= (others => '0');
            elsif push = '1' and cnt < 4 then
                -- TODO 1: desplazar a la izquierda e insertar 'dato'
                --         (pista: concatenacion con &)
                -- TODO 2: incrementar cnt
                null;
            elsif pop = '1' and cnt > 0 then
                -- TODO 3: desplazar a la derecha e insertar "0000"
                -- TODO 4: decrementar cnt
                null;
            end if;
        end if;
    end process;

    q <= r;
    n <= std_logic_vector(cnt);
end architecture rtl;
