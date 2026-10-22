# Clase 5 · Integración y Quartus

Diseñar la máquina de sesión (menús, contraseña, administrador), unir todos los bloques en el top, verificar el sistema completo y prepararlo en Quartus para la DE0-Nano.

📑 Diapositivas: [Clase5_Integracion_Quartus.pdf](../diapositivas/Clase5_Integracion_Quartus.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

> **Antes de empezar:** Antes de simular, copien a la carpeta **`rtl/`** todos sus archivos `.vhd` terminados de las clases 1 a 4 y los de `plantilla/` de esta clase. El `run.do` y el proyecto de Quartus (`quartus/`) leen desde `rtl/`.

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_top_tanque.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |
| `rtl/` | Aquí copian **todos** sus archivos terminados |
| `quartus/` | Proyecto de Quartus con pines y restricciones de tiempo |

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `fsm_sesion.vhd` | estados MENU, CAPT, MENU_ADM y VER (TODO 1 a 4) |
| 2 | `formateador_display.vhd` | vistas de captura, vaciados y estado del proceso |
| 3 | `top_tanque.vhd` | instancias de sesión, proceso y displays (TODO 1 a 8) |
| 4 | `tanque_pkg, decodificador_7seg, detector_nivel, selector_nivel, contador_bcd` | completos: solo revisarlos |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase5_integracion
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Con la plantilla incompleta aparecen errores o fallas: es normal.
   - Meta: **0 fallas en los 12 casos (TC1, TC2, TC4 y TC5 vienen hechos; escriban TC3 y TC6 a TC12)**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).

## Proyecto de Quartus

La carpeta `quartus/` trae `top_tanque.qpf`, `top_tanque.qsf` (pines de la DE0-Nano, E/S a 3,3 V, pull-ups del teclado) y `top_tanque.sdc` (reloj de 50 MHz).

1. **File › Open Project** › `quartus/top_tanque.qpf`.
2. **Verifiquen los pines** del `.qsf` contra el manual de la DE0-Nano y su cableado.
3. Compilen con **Ctrl+L** y revisen: **0 latches**, Fmax mayor que 50 MHz, elementos lógicos y registros.
4. Solo con el testbench en verde: **Tools › Programmer** y programen la tarjeta.
