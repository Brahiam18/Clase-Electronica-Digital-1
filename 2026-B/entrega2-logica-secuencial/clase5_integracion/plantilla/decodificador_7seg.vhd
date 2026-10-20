-- =============================================================================
-- decodificador_7seg.vhd
-- Caracter (5 bits) -> segmentos "abcdefg" (bit 6 = a), activos en ALTO
-- (catodo comun), igual que en la entrega 1.
--        a
--      f   b
--        g
--      e   c
--        d
-- Correccion respecto a la entrega 1: alli faltaba el 8 y el 9 se codificaba
-- con el patron del 8.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

entity decodificador_7seg is
    port (
        caracter : in  std_logic_vector(4 downto 0);
        seg      : out std_logic_vector(6 downto 0)
    );
end entity decodificador_7seg;

architecture flujo of decodificador_7seg is
begin
    with caracter select
        seg <= "1111110" when "00000",  -- 0
               "0110000" when "00001",  -- 1
               "1101101" when "00010",  -- 2
               "1111001" when "00011",  -- 3
               "0110011" when "00100",  -- 4
               "1011011" when "00101",  -- 5
               "1011111" when "00110",  -- 6
               "1110000" when "00111",  -- 7
               "1111111" when "01000",  -- 8
               "1111011" when "01001",  -- 9
               "1110111" when "01010",  -- A
               "0011111" when "01011",  -- b
               "1001110" when "01100",  -- C
               "1001111" when "01101",  -- E
               "1000111" when "01110",  -- F
               "0001110" when "01111",  -- L
               "0000101" when "10000",  -- r
               "1011011" when "10001",  -- S
               "0001111" when "10010",  -- t
               "0010101" when "10011",  -- n
               "1100111" when "10100",  -- P
               "0000001" when "10101",  -- -
               "0000000" when others;   -- apagado
end architecture flujo;
