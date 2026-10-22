-- =============================================================================
-- CLASE 5 - PLANTILLA: fsm_sesion.vhd
-- Maquina de estados de la INTERFAZ: contrasenas, menus, captura del nivel,
-- modo administrador e inactividad. NO maneja la planta: solo envia comandos
-- a fsm_proceso (R4). Estilo de 2 procesos: logica de siguiente estado
-- (combinacional) + registros (secuencial).
-- HECHO EN CLASE: captura de contrasena (BLOQ), VERIF, CASTIGO, MSG, cambio de
--   clave (CLAVE1/CLAVE2), inactividad y TODO el proceso de registros.
-- PENDIENTE (TODO 1..4): MENU, CAPT, MENU_ADM y VER.
-- Recuerden: deben entregar el diagrama de estados COMPLETO de esta FSM.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tanque_pkg.all;

entity fsm_sesion is
    generic (
        CLAVE_USR_INI : std_logic_vector(15 downto 0) := x"1234";
        CLAVE_ADM     : std_logic_vector(15 downto 0) := x"2580"
    );
    port (
        clk, rst      : in  std_logic;
        tecla_valida  : in  std_logic;
        tecla_cod     : in  std_logic_vector(3 downto 0);
        entrada       : in  std_logic_vector(15 downto 0);  -- reg. desplazamiento
        ndig          : in  std_logic_vector(2 downto 0);
        t_msg_fin     : in  std_logic;
        t_inact_fin   : in  std_logic;
        castigo_cero  : in  std_logic;
        estado_proc   : in  std_logic_vector(2 downto 0);
        reg_push, reg_pop, reg_clr : out std_logic;
        castigo_cargar: out std_logic;
        castigo_activo: out std_logic;
        msg_activo    : out std_logic;
        sesion_activa : out std_logic;
        es_admin      : out std_logic;
        cmd_nivel, cmd_cancelar, ack_alarma : out std_logic;
        objetivo      : out std_logic_vector(2 downto 0);
        man_bomba, man_comp : out std_logic;
        vista         : out std_logic_vector(3 downto 0)
    );
end entity fsm_sesion;

architecture rtl of fsm_sesion is
    type t_estado is (BLOQ, VERIF, CASTIGO, MENU, CAPT, MENU_ADM,
                      CLAVE1, CLAVE2, VER, MSG);
    signal estado, estado_n, retorno, ret_val : t_estado := BLOQ;

    -- registros de datos
    signal clave_usr, clave_tmp : std_logic_vector(15 downto 0) := CLAVE_USR_INI;
    signal intentos   : unsigned(1 downto 0) := "00";
    signal logueado, admin_r, login_adm : std_logic := '0';
    signal mb_r, mc_r : std_logic := '0';
    signal obj_r      : std_logic_vector(2 downto 0) := "000";
    signal cn_r, cc_r, ack_r : std_logic := '0';

    -- acciones que pide la logica combinacional
    signal a_login, a_logout, a_fallo, a_adm_on, a_adm_off, a_ret : std_logic;
    signal a_tmp, a_clave, a_tog_b, a_tog_c : std_logic;
    signal a_cn, a_cc, a_ack : std_logic;
    -- condiciones auxiliares
    signal k, n : unsigned(3 downto 0);
    signal es_dig, clave_ok, nivel_ok : std_logic;
    signal obj_val : std_logic_vector(2 downto 0);
begin
    k <= unsigned(tecla_cod);
    n <= unsigned('0' & ndig);
    es_dig    <= '1' when k <= 9 else '0';
    -- comparacion COMPLETA de 16 bits al presionar # (R9)
    clave_ok  <= '1' when (login_adm = '1' and entrada = CLAVE_ADM) or
                          (login_adm = '0' and entrada = clave_usr) else '0';
    with entrada(11 downto 0) select
        obj_val <= N_25 when x"025", N_50 when x"050",
                   N_75 when x"075", N_100 when x"100", "000" when others;
    nivel_ok  <= '1' when obj_val /= "000" and n >= 2 else '0';

    -- ================= logica de siguiente estado =================
    process (estado, retorno, tecla_valida, k, n, es_dig, clave_ok, nivel_ok,
             intentos, logueado, login_adm, entrada, clave_tmp, t_msg_fin,
             t_inact_fin, castigo_cero)
    begin
        estado_n <= estado; ret_val <= estado; castigo_cargar <= '0';
        reg_push <= '0'; reg_pop <= '0'; reg_clr <= '0'; a_login <= '0'; a_logout <= '0';
        a_fallo <= '0'; a_ret <= '0'; a_adm_on <= '0'; a_adm_off <= '0';
        a_tmp <= '0'; a_clave <= '0'; a_tog_b <= '0'; a_tog_c <= '0';
        a_cn <= '0'; a_cc <= '0'; a_ack <= '0';

        if logueado = '1' and t_inact_fin = '1' then        -- RF7
            estado_n <= BLOQ; reg_clr <= '1'; a_logout <= '1';
        else
            case estado is
            when BLOQ | CLAVE1 | CLAVE2 =>                  -- capturar 4 digitos
                if tecla_valida = '1' then
                    if es_dig = '1' then reg_push <= '1';
                    elsif k = unsigned(K_AST) then
                        reg_pop <= '1';
                        if n = 0 and estado /= BLOQ then estado_n <= MENU_ADM; end if;
                        if n = 0 and estado = BLOQ then a_adm_off <= '1'; end if;
                    elsif k = unsigned(K_D) and estado = BLOQ then
                        a_adm_on <= '1'; reg_clr <= '1';
                    elsif k = unsigned(K_NUM) then
                        reg_clr <= '1';
                        if n /= 4 then                      -- incompleta
                            estado_n <= MSG; a_ret <= '1';
                                if estado = BLOQ then ret_val <= BLOQ; else ret_val <= MENU_ADM; end if;
                        elsif estado = BLOQ then
                            estado_n <= VERIF; reg_clr <= '0';
                        elsif estado = CLAVE1 then
                            a_tmp <= '1'; estado_n <= CLAVE2;
                        elsif entrada = clave_tmp then      -- CLAVE2 coincide
                            a_clave <= '1'; estado_n <= MENU_ADM;
                        else
                            estado_n <= MSG; a_ret <= '1'; ret_val <= MENU_ADM;
                        end if;
                    end if;
                end if;
            when VERIF =>
                reg_clr <= '1';
                if clave_ok = '1' then
                    a_login <= '1';
                    if login_adm = '1' then estado_n <= MENU_ADM; else estado_n <= MENU; end if;
                else
                    a_fallo <= '1';
                    if intentos = 2 then                    -- tercer fallo
                        estado_n <= CASTIGO; castigo_cargar <= '1';
                    else
                        estado_n <= MSG; a_ret <= '1'; ret_val <= BLOQ;
                    end if;
                end if;
            when CASTIGO => if castigo_cero = '1' then estado_n <= BLOQ; end if; -- ignora teclas
            when MENU =>
                -- TODO 1: menu de usuario (seccion 3.1 de la guia)
                --   A -> limpiar registro e ir a CAPT
                --   C -> pulso de cancelar ;  * -> cerrar sesion
                null;
            when CAPT =>
                -- TODO 2: captura del nivel objetivo
                --   digito -> push (maximo 3 digitos, para poder escribir 100)
                --   *      -> borrar; si no hay digitos, volver a MENU
                --   C      -> volver a MENU
                --   #      -> validar con nivel_ok:
                --             valido -> a_cn ; invalido -> MSG (Err) y volver a MENU
                null;
            when MENU_ADM =>
                -- TODO 3: menu de administrador (RF6): opciones 1 a 5 y *
                null;
            when VER =>
                -- TODO 4: cualquier tecla vuelve a MENU_ADM
                null;
            when MSG => if t_msg_fin = '1' then estado_n <= retorno; end if;
            end case;
        end if;
    end process;

    -- ================= registros =================
    process (clk)
    begin
        if rising_edge(clk) then
            -- los comandos son pulsos de un ciclo
            cn_r <= a_cn; cc_r <= a_cc; ack_r <= a_ack;
            if rst = '1' then
                estado <= BLOQ; retorno <= BLOQ; clave_usr <= CLAVE_USR_INI;
                clave_tmp <= (others => '0'); intentos <= "00";
                logueado <= '0'; admin_r <= '0'; login_adm <= '0';
                mb_r <= '0'; mc_r <= '0'; obj_r <= "000";
                cn_r <= '0'; cc_r <= '0'; ack_r <= '0';
            else
                estado <= estado_n;
                if a_ret = '1' then retorno <= ret_val; end if;
                if a_tmp = '1' then clave_tmp <= entrada; end if;
                if a_clave = '1' then clave_usr <= entrada; end if;
                if a_adm_on = '1' then login_adm <= '1'; elsif a_adm_off = '1' then login_adm <= '0'; end if;
                if a_cn = '1' then obj_r <= obj_val; end if;
                if a_fallo = '1' then
                    login_adm <= '0';
                    if intentos = 2 then intentos <= "00"; else intentos <= intentos + 1; end if;
                end if;
                if a_login = '1' then
                    logueado <= '1'; admin_r <= login_adm;
                    login_adm <= '0'; intentos <= "00";
                end if;
                -- manual: solo uno a la vez (RF5 tambien aqui)
                if a_tog_b = '1' then mb_r <= not mb_r; mc_r <= '0';
                elsif a_tog_c = '1' then mc_r <= not mc_r; mb_r <= '0'; end if;
                if a_logout = '1' or estado_proc = P_VACIAR
                   or estado_proc = P_FALLA_B or estado_proc = P_FALLA_S then
                    mb_r <= '0'; mc_r <= '0';
                end if;
                if a_logout = '1' then logueado <= '0'; admin_r <= '0'; login_adm <= '0'; end if;
            end if;
        end if;
    end process;

    -- ================= salidas =================
    cmd_nivel <= cn_r; cmd_cancelar <= cc_r; ack_alarma <= ack_r;
    objetivo  <= obj_r;
    man_bomba <= mb_r;  man_comp <= mc_r;
    sesion_activa  <= logueado;
    es_admin       <= admin_r;
    castigo_activo <= '1' when estado = CASTIGO else '0';
    msg_activo     <= '1' when estado = MSG else '0';

    vista <= V_ERR        when estado = MSG else
             V_CASTIGO    when estado = CASTIGO else
             V_CLAVE_ADM  when (estado = BLOQ and login_adm = '1')
                               or estado = CLAVE1 or estado = CLAVE2 else
             V_CLAVE_USR  when estado = BLOQ or estado = VERIF else
             V_CAP_NIVEL  when estado = CAPT else
             V_VACIADOS   when estado = VER else
             V_PROC_ADM   when admin_r = '1' else
             V_PROC_USR;
end architecture rtl;
