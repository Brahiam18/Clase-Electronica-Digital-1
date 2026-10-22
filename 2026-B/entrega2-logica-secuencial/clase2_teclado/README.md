# Clase 2 · Teclado matricial

Entender cómo funciona un teclado matricial 4×4, identificar sus pines, conectarlo a la DE0-Nano y leerlo en VHDL: barrido de filas, antirrebote y un pulso limpio por cada tecla.

📑 Diapositivas: [Clase2_Teclado_matricial.pdf](../diapositivas/Clase2_Teclado_matricial.pdf)  ·  📘 [Cómo correr el testbench (guía detallada)](../docs/COMO_CORRER_EL_TESTBENCH.md)

> **Antes de empezar:** Esta clase usa sus archivos **terminados** de la clase 1 (`sincronizador` y `detector_flanco`); el `run.do` los toma de `../clase1_registros/plantilla/`. La carpeta `apoyo/` trae `base_tiempo.vhd` ya completo (el pulso de 1 ms del barrido): no se modifica y se estudia en la clase 3.

## Guía de laboratorio

La **[Guía de laboratorio del teclado matricial](../guia/Guia_Laboratorio_Teclado_Matricial.pdf)** explica cómo identificar los pines del teclado con el multímetro, cómo conectarlo a la DE0-Nano con sus protecciones y el procedimiento completo de la práctica en la tarjeta.

## Contenido de la carpeta

| Carpeta | Qué hacer |
|---|---|
| `analizar/` | Ejemplos para leer y compilar en clase (no se modifican) |
| `apoyo/` | Bloques ya completos que necesita esta clase (no se modifican) |
| `plantilla/` | **Aquí escriben su código**: completen los `-- TODO` |
| `tb/` | Testbench autoverificable (`tb_teclado.vhd`): **no se modifica** |
| `run.do` | Compila todo y corre el testbench (**no se modifica**) |

## Ejemplos para analizar

| Archivo | De qué se trata |
|---|---|
| `demo_teclado.vhd + demo_teclado.qsf` | Práctica de laboratorio en la tarjeta: LED[3:0] muestran el código de la última tecla y LED[7:4] cuántas se aceptaron. Top-level: `demo_teclado`. |

Para verlos en Quartus: creen un proyecto en una carpeta aparte, agreguen el archivo y pongan como *top-level entity* el nombre indicado. Compilen con **Ctrl+K** y abran **Tools › Netlist Viewers › RTL Viewer**. Si el archivo tiene varias arquitecturas, Quartus usa la **última**.

## Qué completar (en este orden)

| # | Archivo | Qué completar |
|---|---|---|
| 1 | `antirrebote.vhd` | aceptar un valor solo si se mantiene igual N ticks (el rebote del pulsador) |
| 2 | `barrido_teclado.vhd` | barrido de filas, detección de columna y tabla de códigos |
| 3 | `teclado_4x4.vhd` | bloque estructural: instancias del antirrebote y del detector de flanco |

## Cómo correr el testbench

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript** vayan a esta carpeta (usen `/`, no `\`):

   ```
   cd C:/Users/Usuario/Desktop/dig1/clase2_teclado
   ```

3. Corran el script:

   ```
   do run.do
   ```

4. Al final del Transcript lean la línea `RESUMEN`:

   - Plantilla sin completar: **3 OK, 19 FALLAS**
   - Meta: **22 OK, 0 FALLAS**

5. Cada vez que cambien código: **guardar (Ctrl+S)** y otra vez `do run.do` (flecha ↑ y Enter).

Cada línea `FALLA` dice qué bloque y qué caso fallaron. Para revisarlo, usen la ventana **Wave** (tecla **F** para ver todo).
