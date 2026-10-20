# Clase 1 · Flip-flops, registros y reset

Construir los primeros bloques con memoria: flip-flops con reset síncrono, sincronización de entradas externas, detección de flancos y el registro que guarda la contraseña.

📑 Diapositivas: [Clase1_Flipflops_registros_reset.pdf](../diapositivas/Clase1_Flipflops_registros_reset.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_clase1.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `01_latch_vs_flipflop.vhd` | Tres arquitecturas: cuál genera latch, cuál flip-flop y cuál solo compuertas. Top-level: `ejemplo_memoria`. |
| `02_signal_vs_variable.vhd` | Por qué se prohíben las variables (R8): la misma cadena con señales da 3 flip-flops y con variables da 1. Top-level: `cadena3`. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `sincronizador.vhd` | dos flip-flops en cascada (R11) |
| 2 | `reset_sync.vhd` | sincronizador del pulsador KEY0 + inversión (R2) |
| 3 | `detector_flanco.vhd` | un flip-flop con reset y `pulso = nivel AND NOT anterior` |
| 4 | `reg_desplazamiento.vhd` | `push` y `pop` con concatenación `&` (R9) |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase1_registros
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **6 OK, 7 FALLAS**
   - Meta: **13 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
