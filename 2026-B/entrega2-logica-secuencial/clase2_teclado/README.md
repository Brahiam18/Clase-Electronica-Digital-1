# Clase 2 · Teclado matricial

Conectar un teclado matricial 4×4 a la DE0-Nano y leerlo en VHDL: cada tecla enciende su código en los LEDs y el contador sube **una sola vez** por cada pulsación.

📑 Diapositivas: [Clase2_Teclado_matricial.pdf](../diapositivas/Clase2_Teclado_matricial.pdf)  ·  🧪 [Guía de laboratorio del teclado](../guia/Guia_Laboratorio_Teclado_Matricial.pdf)  ·  📘 [Manual de la DE0-Nano](../../../recursos/DE0_Nano_Manual_de_usuario.pdf)

## Contenido de la carpeta

La carpeta [`proyecto_teclado/`](proyecto_teclado/) es un proyecto de Quartus listo para abrir:

| Archivo | Qué es | ¿Se modifica? |
|---|---|---|
| `demo_teclado.qpf` / `.qsf` | Proyecto de Quartus con los pines de la DE0-Nano | No |
| `demo_teclado.vhd` | Top: LED[3:0] = código de la tecla, LED[7:4] = contador de teclas | **Sí · COMPLETAR 3** |
| `barrido_teclado.vhd` | Barrido de filas, lectura de columnas y tabla de códigos | **Sí · COMPLETAR 1 y 2** |
| `teclado_4x4.vhd` | Une sincronizador, barrido, antirrebote y detector de flanco | No |
| `antirrebote.vhd` | Acepta una tecla solo si se mantiene 20 ms | No |
| `generador_1ms.vhd` | Pulso de 1 ms a partir del reloj de 50 MHz | No |
| `sincronizador.vhd`, `reset_sync.vhd`, `detector_flanco.vhd` | Bloques de la clase 1 | No |

## Qué completar

| # | Archivo | Qué escribir |
|---|---|---|
| 1 | `barrido_teclado.vhd` | Decodificador de filas: la fila activa en `'0'` y las demás en `'Z'` |
| 2 | `barrido_teclado.vhd` | Tabla de códigos de las filas 1, 2 y 3 (la fila 0 viene de ejemplo) |
| 3 | `demo_teclado.vhd` | Process que guarda la última tecla (`ultima`) y cuenta las pulsaciones (`contador`) |

El proyecto compila aunque no se hayan completado los tres puntos; simplemente el teclado no responde hasta terminarlos.

## Conexión (sin resistencias)

El teclado va al conector **GPIO-1 (JP2)**. Las filas inactivas quedan en `'Z'` (drenaje abierto), así que se conecta directo, sin resistencias. Las columnas usan el pull-up interno de la FPGA, ya activado en el `.qsf`.

| Pin del teclado | Señal | Pin de JP2 | Pin de la FPGA |
|---|---|---|---|
| 1 | Fila 0 (1 2 3 A) | 4 | PIN_T15 |
| 2 | Fila 1 (4 5 6 B) | 5 | PIN_T14 |
| 3 | Fila 2 (7 8 9 C) | 6 | PIN_T13 |
| 4 | Fila 3 (* 0 # D) | 7 | PIN_R13 |
| 5 | Columna 0 (1 4 7 *) | 8 | PIN_T12 |
| 6 | Columna 1 (2 5 8 0) | 9 | PIN_R12 |
| 7 | Columna 2 (3 6 9 #) | 10 | PIN_T11 |
| 8 | Columna 3 (A B C D) | **13** | PIN_T10 |

> **Los pines 11 (5 V) y 12 (GND) de JP2 no se usan.** La columna 3 va al pin 13. Cableen siempre con el USB desconectado. El pin 1 del conector se ubica con la Figura 3-9 del manual.

## Pasos

1. Completen los tres `-- COMPLETAR` y guarden.
2. En Quartus: **File › Open Project** › `proyecto_teclado/demo_teclado.qpf`.
3. Compilen con **Ctrl+L** y revisen que no haya errores ni `inferring latch`.
4. Con el USB desconectado, conecten el teclado como en la tabla.
5. Conecten el USB: **Tools › Programmer** › `output_files/demo_teclado.sof` › **Start**.
6. Presionen **KEY0** (reset) y prueben las 16 teclas.

## Qué deben ver

LED3–LED0 muestran el código de la última tecla (1 = encendido). LED7–LED4 suben de a 1 por pulsación.

| Tecla | LED3…LED0 | Tecla | LED3…LED0 | Tecla | LED3…LED0 | Tecla | LED3…LED0 |
|---|---|---|---|---|---|---|---|
| 1 | 0001 | 2 | 0010 | 3 | 0011 | A | 1010 |
| 4 | 0100 | 5 | 0101 | 6 | 0110 | B | 1011 |
| 7 | 0111 | 8 | 1000 | 9 | 1001 | C | 1100 |
| * | 1110 | 0 | 0000 | # | 1111 | D | 1101 |

| Si pasa esto | Revisen |
|---|---|
| A, B, C y D no responden | El cable de la columna 3 debe ir al pin **13** de JP2, no al 11, 12 ni 14 |
| 1 se lee como A (espejo) | Columnas en orden invertido |
| 2 se lee como 4 (transpuesto) | Filas y columnas intercambiadas |
| El contador sube 2 o más por pulsación | El antirrebote (`N_REBOTE = 20` en `demo_teclado.vhd`) |
