# Clase 3 · Teclado matricial

Leer un teclado 4×4 con barrido de filas y convertir cada pulsación en un pulso limpio de un ciclo con su código.

📑 Diapositivas: [Clase3_Teclado_matricial.pdf](../diapositivas/Clase3_Teclado_matricial.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

> **Antes de empezar:** Esta clase usa sus archivos **terminados** de las clases 1 y 2 (`sincronizador`, `detector_flanco`, `base_tiempo`, `antirrebote`). El `run.do` los toma de `../clase1_registros/plantilla/` y `../clase2_contadores/plantilla/`, así que esas carpetas deben estar al lado de esta y completas.

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_teclado.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `demo_teclado.vhd + demo_teclado.qsf` | Prueba en la tarjeta: LED[3:0] muestran la última tecla y LED[7:4] cuántas se aceptaron. Respondan las preguntas del encabezado. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `barrido_teclado.vhd` | barrido de filas, detección de columna y tabla de códigos |
| 2 | `teclado_4x4.vhd` | bloque estructural: instancias del antirrebote y del detector de flanco |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase3_teclado
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **2 OK, 17 FALLAS**
   - Meta: **19 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
