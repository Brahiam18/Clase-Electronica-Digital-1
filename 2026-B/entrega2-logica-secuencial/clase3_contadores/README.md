# Clase 3 · Contadores y base de tiempo

Medir tiempo con un solo reloj de 50 MHz: contadores, pulsos *tick* de un ciclo, temporizadores y contadores BCD en cascada.

📑 Diapositivas: [Clase3_Contadores_base_tiempo.pdf](../diapositivas/Clase3_Contadores_base_tiempo.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_clase3.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `01_reloj_derivado_vs_tick.vhd` | Por qué no se fabrican relojes con lógica (R1): reloj derivado frente a tick con clock enable. Top-level: `parpadeo`. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `base_tiempo.vhd` | etapas 2 y 3 de la cascada: tick_4hz, tick_1hz y onda_2hz (en la clase 2 lo usaron ya hecho; ahora lo construyen) |
| 2 | `temporizador.vhd` | temporizador binario genérico (inactividad, error de sensor, mensajes) |
| 3 | `digito_bcd.vhd` | un dígito BCD descendente con `presta` |
| 4 | `temporizador_bcd.vhd` | dos dígitos BCD en cascada: cuenta regresiva del bloqueo de 30 s |
| 5 | `watchdog_bomba.vhd` | **tarea**: protección de marcha en seco (RF8) |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase3_contadores
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **6 OK, 10 FALLAS**
   - Meta: **16 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
