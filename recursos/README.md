# Recursos generales

Material que se usa en **todos los semestres y entregas** del curso.

| Archivo | Contenido |
|---|---|
| [`DE0_Nano_Manual_de_usuario.pdf`](DE0_Nano_Manual_de_usuario.pdf) | Manual oficial de la tarjeta DE0-Nano (Terasic): pines de la FPGA, LEDs, pulsadores, conectores GPIO, reloj y tutorial de Quartus |

## Dónde buscar en el manual

| Necesito | Sección del manual |
|---|---|
| Pines de LEDs, pulsadores (KEY) y switches | 3.2 General User Input/Output |
| Pines de los conectores GPIO-0 (JP1) y GPIO-1 (JP2) | 3.5 Expansion Headers: Figura 3-8 (distribución de pines, pág. 18), Figura 3-9 (dónde está el pin 1) y tablas 3-6 y 3-7 |
| Reloj de 50 MHz (CLOCK_50) | 3.8 Clock Circuitry |
| Crear un proyecto y asignar pines en Quartus | Capítulo 6, Tutorial |

## Pines más usados en el curso

| Señal | Pin de la FPGA | Dónde está en la tarjeta |
|---|---|---|
| `CLOCK_50` (reloj de 50 MHz) | PIN_R8 | Oscilador de la tarjeta |
| `KEY[0]` (pulsador, activo en 0) | PIN_J15 | Pulsador KEY0 |
| `KEY[1]` | PIN_E1 | Pulsador KEY1 |
| `LED[0]` … `LED[3]` | PIN_A15, PIN_A13, PIN_B13, PIN_A11 | LEDs verdes 0 a 3 |
| `LED[4]` … `LED[7]` | PIN_D1, PIN_F3, PIN_B1, PIN_L3 | LEDs verdes 4 a 7 |

### Conector GPIO-1 (JP2) · pines usados por el teclado matricial

| Pin de JP2 | Señal del manual | Pin de la FPGA | Uso en el curso |
|---|---|---|---|
| 4 | GPIO_11 | PIN_T15 | Fila 0 del teclado |
| 5 | GPIO_12 | PIN_T14 | Fila 1 |
| 6 | GPIO_13 | PIN_T13 | Fila 2 |
| 7 | GPIO_14 | PIN_R13 | Fila 3 |
| 8 | GPIO_15 | PIN_T12 | Columna 0 |
| 9 | GPIO_16 | PIN_R12 | Columna 1 |
| 10 | GPIO_17 | PIN_T11 | Columna 2 |
| 13 | GPIO_18 | PIN_T10 | Columna 3 |
| 11 | VCC_SYS | — | **5 V: no conectar nada aquí** |
| 12 · 30 | GND | — | Tierra |
| 29 | VCC3P3 | — | 3,3 V |

> Toda la E/S de la DE0-Nano trabaja a **3,3 V**. Nunca conecten 5 V a un pin de la FPGA.
