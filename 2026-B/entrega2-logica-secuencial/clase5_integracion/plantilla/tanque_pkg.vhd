-- =============================================================================
-- tanque_pkg.vhd
-- Constantes compartidas por varios bloques. Un paquete evita "numeros
-- magicos" repetidos y garantiza que todos usen la misma codificacion.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;

package tanque_pkg is
    -- ---------- codigos de tecla (salida del teclado) ----------
    constant K_A    : std_logic_vector(3 downto 0) := "1010";
    constant K_B    : std_logic_vector(3 downto 0) := "1011";
    constant K_C    : std_logic_vector(3 downto 0) := "1100";
    constant K_D    : std_logic_vector(3 downto 0) := "1101";
    constant K_AST  : std_logic_vector(3 downto 0) := "1110";   -- *
    constant K_NUM  : std_logic_vector(3 downto 0) := "1111";   -- #

    -- ---------- nivel del tanque (salida del detector) ----------
    constant N_0    : std_logic_vector(2 downto 0) := "000";
    constant N_25   : std_logic_vector(2 downto 0) := "001";
    constant N_50   : std_logic_vector(2 downto 0) := "010";
    constant N_75   : std_logic_vector(2 downto 0) := "011";
    constant N_100  : std_logic_vector(2 downto 0) := "100";

    -- ---------- estado del proceso (fsm_proceso -> fsm_sesion/display) ----------
    constant P_REPOSO  : std_logic_vector(2 downto 0) := "000";
    constant P_NIVEL   : std_logic_vector(2 downto 0) := "001";
    constant P_PAUSA   : std_logic_vector(2 downto 0) := "011";
    constant P_VACIAR  : std_logic_vector(2 downto 0) := "100";
    constant P_MANUAL  : std_logic_vector(2 downto 0) := "101";
    constant P_FALLA_B : std_logic_vector(2 downto 0) := "110";
    constant P_FALLA_S : std_logic_vector(2 downto 0) := "111";

    -- ---------- que debe mostrar el display (fsm_sesion -> formateador) ----------
    constant V_CLAVE_USR : std_logic_vector(3 downto 0) := "0000";
    constant V_CLAVE_ADM : std_logic_vector(3 downto 0) := "0001";
    constant V_ERR       : std_logic_vector(3 downto 0) := "0010";
    constant V_CASTIGO   : std_logic_vector(3 downto 0) := "0011";
    constant V_CAP_NIVEL : std_logic_vector(3 downto 0) := "0100";
    constant V_PROC_USR  : std_logic_vector(3 downto 0) := "0110";
    constant V_PROC_ADM  : std_logic_vector(3 downto 0) := "0111";
    constant V_VACIADOS  : std_logic_vector(3 downto 0) := "1000";

    -- ---------- caracteres del display (formateador -> decodificador) ----------
    -- 0..9 son los digitos; el resto son letras y simbolos.
    constant CH_A     : std_logic_vector(4 downto 0) := "01010";
    constant CH_B     : std_logic_vector(4 downto 0) := "01011";   -- b
    constant CH_C     : std_logic_vector(4 downto 0) := "01100";
    constant CH_E     : std_logic_vector(4 downto 0) := "01101";
    constant CH_F     : std_logic_vector(4 downto 0) := "01110";
    constant CH_L     : std_logic_vector(4 downto 0) := "01111";
    constant CH_R     : std_logic_vector(4 downto 0) := "10000";   -- r
    constant CH_S     : std_logic_vector(4 downto 0) := "10001";
    constant CH_N     : std_logic_vector(4 downto 0) := "10011";   -- n
    constant CH_P     : std_logic_vector(4 downto 0) := "10100";
    constant CH_GUION : std_logic_vector(4 downto 0) := "10101";   -- -
    constant CH_BLANCO: std_logic_vector(4 downto 0) := "11111";
end package tanque_pkg;
