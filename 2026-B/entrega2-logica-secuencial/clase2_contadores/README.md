# Clase 2 · Contadores y base de tiempo

Medir tiempo con un solo reloj de 50 MHz: contadores, pulsos *tick* de un ciclo, antirrebote y temporizadores BCD en cascada.

📑 Diapositivas: [Clase2_Contadores_base_tiempo.pdf](../diapositivas/Clase2_Contadores_base_tiempo.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_clase2.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `01_reloj_derivado_vs_tick.vhd` | Por qué no se fabrican relojes con lógica (R1): reloj derivado frente a tick con clock enable. Top-level: `parpadeo`. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `base_tiempo.vhd` | etapas 2 y 3 de la cascada: tick_4hz, tick_1hz y onda_2hz |
| 2 | `temporizador.vhd` | temporizador binario genérico |
| 3 | `antirrebote.vhd` | aceptar un valor solo tras N ticks sin cambios |
| 4 | `digito_bcd.vhd` | un dígito BCD descendente con `presta` |
| 5 | `temporizador_bcd.vhd` | dos dígitos BCD en cascada |
| 6 | `watchdog_bomba.vhd` | **tarea**: protección de marcha en seco (RF9) |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase2_contadores
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **7 OK, 11 FALLAS**
   - Meta: **18 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
