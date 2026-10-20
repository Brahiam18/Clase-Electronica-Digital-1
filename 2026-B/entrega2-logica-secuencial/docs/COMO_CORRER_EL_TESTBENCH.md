# Cómo correr el testbench (ModelSim / Questa)

El **testbench** es un archivo VHDL que prueba su código automáticamente: le aplica entradas, revisa las salidas y al final imprime cuántas pruebas pasaron. **No se modifica** y **no va a la FPGA**: solo corre en el simulador.

Cada clase trae un archivo **`run.do`** que compila todo y corre el testbench con un solo comando.

---

## Paso 1 · Tener la carpeta lista

Descarguen el repositorio (**Code › Download ZIP**), descompriman y copien la carpeta `entrega2-logica-secuencial` a una ruta **sin espacios ni tildes**. Por ejemplo, renómbrenla `dig1` y pónganla en el escritorio:

```
C:\Users\Usuario\Desktop\dig1\
├── clase1_registros\
│   ├── run.do
│   ├── plantilla\
│   └── tb\
├── clase2_contadores\
└── ...
```

> No muevan ni renombren `run.do`, `plantilla` ni `tb`: el script los busca con esos nombres.

## Paso 2 · Copiar la ruta de la carpeta de la clase

1. Abran la carpeta de la clase (por ejemplo `clase1_registros`) en el Explorador de Windows.
2. Hagan clic en la barra de direcciones y copien la ruta: `C:\Users\Usuario\Desktop\dig1\clase1_registros`
3. Cambien cada `\` por `/` → `C:/Users/Usuario/Desktop/dig1/clase1_registros`

## Paso 3 · Abrir el simulador

Menú Inicio de Windows → busquen **ModelSim** (*ModelSim – Intel FPGA Starter Edition*) o **Questa**.

Abajo de la ventana está la consola **Transcript**, donde aparece `ModelSim>`. Ahí se escriben los comandos.

## Paso 4 · Ir a la carpeta y correr

Escriban cada línea y pulsen **Enter**:

```
cd C:/Users/Usuario/Desktop/dig1/clase1_registros
do run.do
```

Si la ruta tiene espacios, va entre llaves: `cd {C:/Users/Mi Usuario/Desktop/dig1/clase1_registros}`

Para comprobar que están en la carpeta correcta: `ls` debe mostrar `plantilla`, `run.do` y `tb`.

## Paso 5 · Leer el resultado

Al final del Transcript aparece:

```
# ===== RESUMEN: 6 OK, 7 FALLAS =====
```

Arriba de esa línea hay una línea por prueba:

```
# ** Note:  OK    reset_sync: rst_n=0 -> rst=1
# ** Error: FALLA sincronizador: pasa en 2 ciclos
```

- **OK** → esa prueba pasó.
- **FALLA** → esa prueba falló. El texto dice **qué bloque** y **qué caso**.

Con la plantilla sin completar **deben salir fallas**: eso confirma que todo está bien instalado.

## Paso 6 · Ciclo de trabajo

```
1. Completar un  -- TODO  en plantilla/  (y borrar el null; de ese bloque)
2. Guardar el archivo (Ctrl+S)
3. En ModelSim:  do run.do      (atajo: flecha ↑ y Enter)
4. ¿Subieron los OK?
      sí → siguiente TODO
      no → leer la FALLA, revisar la forma de onda, corregir
```

Si cierran ModelSim, al abrirlo de nuevo repitan el `cd` antes de `do run.do`.

## Paso 7 · Ver la forma de onda cuando algo falla

1. Hagan clic en la ventana **Wave** y pulsen **F** para ver toda la simulación.
2. Busquen las señales del bloque que falló. Si no aparecen, expandan la instancia en el panel **Objects** o **sim** y arrástrenlas a Wave.
3. Comparen con el diagrama de tiempos de la diapositiva correspondiente.

---

## Metas por clase

| Clase | Comando (desde la carpeta de la clase) | Plantilla sin tocar | Meta |
|---|---|---|---|
| 1 | `do run.do` | 6 OK, 7 FALLAS | **13 OK, 0 FALLAS** |
| 2 | `do run.do` | 7 OK, 11 FALLAS | **18 OK, 0 FALLAS** |
| 3 | `do run.do` (requiere clases 1 y 2 completas) | 2 OK, 17 FALLAS | **19 OK, 0 FALLAS** |
| 4 | `do run.do` | 9 OK, 13 FALLAS | **22 OK, 0 FALLAS** |
| 5 | `do run.do` (requiere copiar todo a `rtl/`) | — | **0 fallas** en todos los casos |

---

## Errores comunes

| Síntoma | Causa y solución |
|---|---|
| `couldn't change working directory` | La ruta está mal: revisen que usen `/` y que exista la carpeta |
| `couldn't read file "run.do"` | No están en la carpeta de la clase (revisen con `ls`), o el archivo quedó como `run.do.txt` |
| `** Error: ... .vhd(23): near "...": syntax error` | Error de escritura en ese archivo y línea: falta `;`, `end if;`, o hay una palabra mal escrita |
| `length mismatch` / `array size mismatch` | Los dos lados de `<=` no tienen el mismo número de bits |
| Los OK no suben después de corregir | No guardaron el archivo antes de correr `do run.do` |
| `Unable to checkout a license` | El simulador no tiene licencia: hay que configurarla (pregunten al monitor) |
