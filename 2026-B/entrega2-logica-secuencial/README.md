# Electrónica Digital I · 2026-B · Segunda entrega
## Sistema de control de nivel de un tanque en FPGA: lógica secuencial en VHDL

Material del curso para la **segunda entrega**: el sistema de monitoreo del tanque de la primera entrega ahora **recuerda**. Se controla desde un teclado matricial 4×4, tiene contraseña y modo administrador, llena el tanque hasta un nivel objetivo y abre una compuerta de vaciado automática.

Todo se construye en VHDL con flip-flops, registros, contadores y máquinas de estado, sobre la tarjeta **DE0-Nano** (Cyclone IV E · EP4CE22F17C6).

> **Universidad de Ibagué** · Electrónica Digital I
> Monitores: Brahiam Campiño · Luisa Gallo

---

## Qué hay en este repositorio

| Carpeta | Contenido |
|---|---|
| [`guia/`](guia/) | **Guía oficial de la entrega** (requerimientos RF1–RF10, restricciones R1–R13, diagramas, casos de prueba y rúbrica) y **guía de laboratorio del teclado matricial** |
| [`diapositivas/`](diapositivas/) | Presentaciones de las 5 clases (PDF) |
| [`docs/`](docs/) | **[Cómo correr el testbench paso a paso](docs/COMO_CORRER_EL_TESTBENCH.md)** y hoja rápida en PDF |
| [`clase1_registros/`](clase1_registros/) | Flip-flops, registros y reset |
| [`clase2_teclado/`](clase2_teclado/) | Teclado matricial: proyecto de Quartus para completar y probar en la tarjeta |
| [`clase3_contadores/`](clase3_contadores/) | Contadores y base de tiempo |
| [`clase4_fsm/`](clase4_fsm/) | Máquinas de estado: `fsm_proceso` |
| [`clase5_integracion/`](clase5_integracion/) | `fsm_sesion`, sistema completo y proyecto de Quartus |

Cada carpeta de clase tiene la misma estructura:

```
claseN_tema/
├── README.md    ← qué hacer en esa clase
├── run.do        ← comandos para simular (no se modifica)
├── analizar/     ← ejemplos para leer y compilar en clase
├── plantilla/    ← AQUÍ escriben su código (completar los -- TODO)
└── tb/           ← testbench autoverificable (no se modifica)
```

---

## Plan de clases

| Clase | Tema | Bloques que construyen | Meta del testbench |
|---|---|---|---|
| 1 | Flip-flops, registros y reset | `sincronizador`, `reset_sync`, `detector_flanco`, `reg_desplazamiento` | **13 OK** |
| 2 | Teclado matricial | `barrido_teclado` y `demo_teclado` (3 partes para completar) + práctica en la tarjeta | **16 teclas en los LEDs** |
| 3 | Contadores y base de tiempo | `base_tiempo`, `temporizador`, `digito_bcd`, `temporizador_bcd`, `watchdog_bomba` (tarea) | **16 OK** |
| 4 | Máquinas de estado | `fsm_proceso` (estados PAUSA, VACIAR, MANUAL, FALLA y salidas) | **22 OK** |
| 5 | Integración y Quartus | `fsm_sesion`, `formateador_display`, `top_tanque` y casos TC3, TC6–TC12 | **12 casos, 0 fallas** |

Los bloques de cada clase se usan en la siguiente. **No avancen con un bloque que no pase su testbench.**

---

## Programas necesarios

- **Quartus Prime Lite** (versión 16.1 o superior) con soporte para Cyclone IV E.
- **ModelSim – Intel FPGA Starter Edition** o **Questa – Intel/Altera FPGA Starter Edition** (viene con Quartus).
- Tarjeta **DE0-Nano** ([manual con los pines](../../recursos/DE0_Nano_Manual_de_usuario.pdf)), teclado matricial 4×4 y componentes de protección de la compuerta (ver sección 8 de la guía).

---

## Cómo empezar

### 1. Descargar el material

En la página principal del repositorio: botón verde **Code › Download ZIP**, descomprimirlo y entrar a `2026-B/entrega2-logica-secuencial/`. O con Git:

```
git clone https://github.com/Brahiam18/Clase-Electronica-Digital-1.git
```

> Copien la carpeta `entrega2-logica-secuencial` a una ruta **sin espacios ni tildes**, por ejemplo `C:/Users/Usuario/Desktop/dig1`.

### 2. Simular una clase (ejemplo: clase 1)

> Guía completa con capturas de los mensajes, metas por clase y errores comunes: **[docs/COMO_CORRER_EL_TESTBENCH.md](docs/COMO_CORRER_EL_TESTBENCH.md)**. Cada carpeta de clase también tiene su propio `README` con los pasos.

1. Abran **ModelSim** (o Questa) desde el menú Inicio.
2. En la consola **Transcript**, vayan a la carpeta de la clase, usando `/` y no `\`:
   ```
   cd C:/Users/Usuario/Desktop/dig1/clase1_registros
   ```
3. Ejecuten el script:
   ```
   do run.do
   ```
4. Al final del Transcript aparece:
   ```
   # ===== RESUMEN: X OK, Y FALLAS =====
   ```

Con la plantilla sin completar **deben salir fallas**. Eso confirma que todo está bien instalado.

### 3. Ciclo de trabajo

```
1. Completar un  -- TODO  en plantilla/   (y borrar el null; de ese bloque)
2. Guardar (Ctrl+S)
3. En ModelSim:  do run.do    (o flecha ↑ y Enter)
4. ¿Subieron los OK?  sí → siguiente TODO
                      no → leer la línea FALLA, revisar la ventana Wave (tecla F) y corregir
```

### 4. Ver un ejemplo de `analizar/` en Quartus

1. Creen una carpeta aparte para el proyecto, por ejemplo `quartus_latch`.
2. **File › New Project Wizard**:
   - **Top-level entity**: el nombre que aparece después de `entity` en el archivo (`ejemplo_memoria`, `cadena3`, `parpadeo`...).
   - **Add Files**: el `.vhd` de `analizar/`.
   - **Dispositivo**: Cyclone IV E · EP4CE22F17C6.
3. **Processing › Start › Analysis & Synthesis** (Ctrl+K).
4. **Tools › Netlist Viewers › RTL Viewer** para ver el circuito.

> Si el archivo tiene varias arquitecturas, Quartus usa la **última**. Para ver otra, muévanla al final del archivo.

---

## Notas por clase

- **Clase 2** es un proyecto de Quartus completo en `clase2_teclado/proyecto_teclado/`: se completan 3 partes, se compila y se prueba en la tarjeta. El teclado se conecta sin resistencias (filas en drenaje abierto). Pines en el [README de la clase](clase2_teclado/README.md) y en el [manual de la DE0-Nano](../../recursos/DE0_Nano_Manual_de_usuario.pdf).
- **Clase 5**: antes de simular, copien **todos** sus archivos terminados (clases 1 a 4 y `clase5_integracion/plantilla/`) a la carpeta `clase5_integracion/rtl/`. El `run.do` y el proyecto de Quartus (`quartus/`) leen desde ahí.
- El archivo `quartus/top_tanque.qsf` trae la asignación de pines de la DE0-Nano. **Verifíquenla contra el manual de la tarjeta y su cableado** antes de programar.

---

## Reglas que más se olvidan (resumen de la guía)

| Regla | En pocas palabras |
|---|---|
| R1 | Un solo reloj. Nada de `rising_edge` sobre señales distintas de `clk`: se usan *ticks* de un ciclo |
| R2 | Un solo reset, síncrono, sincronizado con 2 flip-flops |
| R6 | `bomba_en` y `compuerta_en` salen directo de un flip-flop |
| R7 | Nada de `/`, `mod`, `rem` ni `*` sobre señales |
| R8 | Nada de `variable`, `wait` ni `after` en código sintetizable (en el testbench sí) |
| R10 | Todos los tiempos son `generic` |
| R11 | Toda entrada externa pasa por un sincronizador de 2 flip-flops |
| R12 | **Cero latches** en el reporte de Quartus |
| R13 | Una entidad por archivo; el top solo conecta bloques |

---

## Errores comunes

| Mensaje o síntoma | Causa probable |
|---|---|
| `cd` no encuentra la carpeta | Usaron `\` en vez de `/`, o la ruta tiene espacios (pónganla entre llaves: `cd {C:/ruta con espacios}`) |
| `couldn't read file "run.do"` | No están en la carpeta de la clase, o el archivo quedó como `run.do.txt` |
| Los OK no suben después de corregir | No guardaron el `.vhd` antes de `do run.do` |
| `Warning (10631) ... inferring latch` | Un `process` sin reloj donde una señal no se asigna en todos los casos: falta un valor por defecto o un `else` |
| Error de ancho (`length mismatch`) | Los dos lados de `<=` no tienen el mismo número de bits |

---

## Entrega

La fecha, los entregables y la rúbrica están en la **sección 11 de la [guía](guia/Guia_Segunda_Entrega.pdf)**. En la sustentación, cualquier integrante debe poder explicar cualquier bloque del código.
