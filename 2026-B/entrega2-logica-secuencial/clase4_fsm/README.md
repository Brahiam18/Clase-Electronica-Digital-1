# Clase 4 · Máquinas de estado

Pasar de un diagrama de estados a VHDL con el estilo de tres procesos, prioridades y salidas registradas: la máquina que controla la bomba y la compuerta.

📑 Diapositivas: [Clase4_Maquinas_de_estado.pdf](../diapositivas/Clase4_Maquinas_de_estado.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

> **Antes de empezar:** Antes de escribir código, completen en papel la tabla de transiciones (diapositiva 7) usando la Figura 2 de la guía.

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_fsm_proceso.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `fsm_tanque_simple.vhd` | La misma FSM escrita con un proceso y con tres. Top-level: `fsm_tanque_simple`. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `tanque_pkg.vhd` | constantes compartidas (completo, solo leer) |
| 2 | `fsm_proceso.vhd` | estados PAUSA, VACIAR, MANUAL y FALLA, y las salidas de P3 (TODO 1 a 6) |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase4_fsm
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **8 OK, 14 FALLAS**
   - Meta: **22 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
