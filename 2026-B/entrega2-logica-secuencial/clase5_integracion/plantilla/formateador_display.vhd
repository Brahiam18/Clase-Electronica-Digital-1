-- =============================================================================
-- CLASE 5 - PLANTILLA: formateador_display.vhd   (Etapa C ampliada)
-- Decide QUE caracter va en cada uno de los 4 displays (D3 = izquierda) segun
-- la vista pedida por fsm_sesion y el estado de fsm_proceso. Tambien maneja
-- el LED de alarma (fijo = falla, parpadeo 2 Hz = bloqueo por intentos).
-- Es logica COMBINACIONAL: todas las salidas reciben valor por defecto al
-- inicio del process para que no se infieran latches (R12).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tanque_pkg.all;

entity formateador_display is
    port (
        vista        : in  std_logic_vector(3 downto 0);
        ndig         : in  std_logic_vector(2 downto 0);
        entrada      : in  std_logic_vector(15 downto 0);
        estado_proc  : in  std_logic_vector(2 downto 0);
        cen, dec, uni: in  std_logic_vector(3 downto 0);   -- nivel en BCD
        castigo_bcd  : in  std_logic_vector(7 downto 0);   -- bloqueo 30 s
        vaciados_bcd : in  std_logic_vector(7 downto 0);
        onda_2hz     : in  std_logic;
        c3, c2, c1, c0 : out std_logic_vector(4 downto 0);
        led_alarma   : out std_logic
    );
end entity formateador_display;

architecture rtl of formateador_display is
    signal n : unsigned(2 downto 0);
    signal en_falla, en_castigo : std_logic;
begin
    n <= unsigned(ndig);
    en_falla <= '1' when estado_proc = P_FALLA_B or estado_proc = P_FALLA_S else '0';

    process (vista, n, entrada, estado_proc, cen, dec, uni,
             castigo_bcd, vaciados_bcd, en_falla)
    begin
        -- valores por defecto: todo apagado
        c3 <= CH_BLANCO; c2 <= CH_BLANCO; c1 <= CH_BLANCO; c0 <= CH_BLANCO;

        case vista is
            when V_CLAVE_USR | V_CLAVE_ADM =>
                -- letra de modo + un guion por digito (nunca el numero, RF1)
                if vista = V_CLAVE_USR then c3 <= CH_B; else c3 <= CH_A; end if;
                if n >= 1 then c0 <= CH_GUION; end if;
                if n >= 2 then c1 <= CH_GUION; end if;
                if n >= 3 then c2 <= CH_GUION; end if;
                if n >= 4 then c3 <= CH_GUION; end if;

            when V_ERR =>
                c3 <= CH_E; c2 <= CH_R; c1 <= CH_R;

            when V_CASTIGO =>
                c3 <= CH_B;
                c1 <= '0' & castigo_bcd(7 downto 4);
                c0 <= '0' & castigo_bcd(3 downto 0);

            -- TODO 1: V_CAP_NIVEL: letra L en D3 y los digitos escritos
            --         (solo los que hay, segun n) en D2..D0
            -- TODO 2: V_VACIADOS: 'n' en D3 y el contador en D1 D0
            when others =>      -- V_PROC_USR / V_PROC_ADM: estado de la planta
                c2 <= '0' & cen; c1 <= '0' & dec; c0 <= '0' & uni;
                -- TODO 3: letra de D3 segun estado_proc (tabla 3.4 de la guia):
                --   P_NIVEL L, P_PAUSA P, P_VACIAR C, P_MANUAL A,
                --   P_FALLA_B "F-b", P_FALLA_S "F-S"
                -- TODO 4: si vista = V_PROC_ADM y no hay falla, D3 = 'A'
        end case;
    end process;

    en_castigo <= '1' when vista = V_CASTIGO else '0';
    led_alarma <= en_falla or (onda_2hz and en_castigo);
end architecture rtl;
