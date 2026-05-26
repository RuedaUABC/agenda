# Reporte de pruebas de rendimiento - Agenda

## 1. Datos generales

| Campo | Valor |
| --- | --- |
| Sistema evaluado | Agenda |
| Tipo de sistema | Aplicacion Flutter multiplataforma para tareas, horario, calendario, ajustes y persistencia local |
| Fecha de ejecucion | 2026-05-26 |
| Fuente base | Lectura "Pruebas de rendimiento" |
| Tipos seleccionados | Pruebas de carga y pruebas de volumen |
| Numero de corridas | 25 corridas por cada tipo de prueba |
| Herramienta de medicion | Script reproducible `tools/performance_benchmark.py` |
| Subsistema medido | SQLite local con esquema equivalente a las tablas `tareas` y `eventos` |

## 2. Base teorica usada

De acuerdo con la lectura "Pruebas de rendimiento", estas pruebas permiten
evaluar el comportamiento de un sistema bajo condiciones de carga, volumen y
uso. La lectura propone medir atributos como rapidez, estabilidad, capacidad de
respuesta, escalabilidad y consumo de recursos.

Para este proyecto se eligieron dos tipos que aplican directamente a la
naturaleza de Agenda:

| Tipo de prueba | Objetivo segun la lectura | Aplicacion en Agenda |
| --- | --- | --- |
| Pruebas de carga | Evaluar el comportamiento bajo una carga esperada de usuarios o transacciones. | La app realiza operaciones frecuentes de crear, consultar, actualizar y eliminar tareas o eventos. |
| Pruebas de volumen | Evaluar el desempeno con grandes cantidades de datos. | La app conserva informacion local en SQLite; por tanto, debe responder correctamente cuando el usuario acumula muchas tareas y eventos. |

## 3. Sistema bajo prueba

Agenda es una aplicacion local y multiplataforma desarrollada con Flutter. Sus
funcionalidades principales son:

- Administracion de tareas academicas o personales.
- Administracion de eventos de calendario.
- Administracion de horario de clases.
- Configuracion de preferencias y recordatorios.
- Persistencia offline mediante SQLite.

El punto critico de rendimiento para este alcance es la persistencia local,
porque las pantallas principales dependen de operaciones de lectura y escritura
sobre las tablas de tareas, eventos y clases. En estas pruebas se midieron
`tareas` y `eventos`, ya que representan las transacciones mas comunes del
sistema.

## 4. Metodologia

Las pruebas se ejecutaron con un benchmark local y reproducible:

```powershell
C:\Users\rueda\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe tools\performance_benchmark.py --runs 25
```

El benchmark crea una base SQLite en memoria con el esquema funcional de Agenda.
Cada corrida inicia con una base limpia, ejecuta el escenario correspondiente y
registra los tiempos medidos con reloj de alta resolucion.
Los valores reportados corresponden a la ejecucion registrada para este
documento; al repetir el script pueden existir variaciones normales por carga
del equipo y planificacion del sistema operativo.

### 4.1 Prueba de carga

Escenario por corrida:

- 150 inserciones de tareas.
- 75 inserciones de eventos.
- 25 actualizaciones de tareas.
- 25 eliminaciones logicas de tareas.
- 25 consultas de tareas por estado.
- Total: 300 operaciones por corrida.

Metricas seleccionadas:

| Metrica | Descripcion |
| --- | --- |
| Tiempo de respuesta promedio | Tiempo promedio por operacion en milisegundos. |
| Throughput | Operaciones procesadas por segundo. |
| Tasa de errores | Porcentaje de operaciones fallidas durante la corrida. |

### 4.2 Prueba de volumen

Escenario por corrida:

- Insercion de 5,000 tareas.
- Insercion de 2,000 eventos.
- Total: 7,000 registros por corrida.
- Consultas posteriores sobre tareas activas, eventos por dia y tareas
  pendientes por ventana de fechas.

Metricas seleccionadas:

| Metrica | Descripcion |
| --- | --- |
| Tiempo de carga de datos | Tiempo requerido para insertar el conjunto de 7,000 registros. |
| Tiempo de consulta a BD | Tiempo requerido para ejecutar consultas representativas sobre el volumen cargado. |
| Latencia de acceso por fila | Microsegundos promedio por fila tocada durante las consultas. |

Para cada metrica se calcularon media, mediana y varianza muestral.

## 5. Resultados: prueba de carga

| Corrida | Operaciones | Tiempo respuesta prom. ms | Throughput ops/s | Tasa errores % |
| --- | --- | --- | --- | --- |
| 1 | 300 | 0.0102 | 97630.8254 | 0.0000 |
| 2 | 300 | 0.0100 | 100046.6879 | 0.0000 |
| 3 | 300 | 0.0100 | 100153.5691 | 0.0000 |
| 4 | 300 | 0.0100 | 99647.9110 | 0.0000 |
| 5 | 300 | 0.0100 | 99634.6731 | 0.0000 |
| 6 | 300 | 0.0100 | 100180.3212 | 0.0000 |
| 7 | 300 | 0.0100 | 99538.8030 | 0.0000 |
| 8 | 300 | 0.0102 | 98354.2044 | 0.0000 |
| 9 | 300 | 0.0101 | 99199.7891 | 0.0000 |
| 10 | 300 | 0.0103 | 97175.4343 | 0.0000 |
| 11 | 300 | 0.0100 | 99700.8980 | 0.0000 |
| 12 | 300 | 0.0103 | 97434.2305 | 0.0000 |
| 13 | 300 | 0.0101 | 98837.0195 | 0.0000 |
| 14 | 300 | 0.0101 | 98882.6246 | 0.0000 |
| 15 | 300 | 0.0101 | 98810.9724 | 0.0000 |
| 16 | 300 | 0.0101 | 99065.4820 | 0.0000 |
| 17 | 300 | 0.0100 | 99578.4549 | 0.0000 |
| 18 | 300 | 0.0101 | 98674.4734 | 0.0000 |
| 19 | 300 | 0.0102 | 97955.9876 | 0.0000 |
| 20 | 300 | 0.0102 | 98512.4611 | 0.0000 |
| 21 | 300 | 0.0102 | 98360.6539 | 0.0000 |
| 22 | 300 | 0.0101 | 99331.1680 | 0.0000 |
| 23 | 300 | 0.0101 | 98710.1839 | 0.0000 |
| 24 | 300 | 0.0101 | 98850.0426 | 0.0000 |
| 25 | 300 | 0.0100 | 99797.0769 | 0.0000 |

### 5.1 Estadistica basica: prueba de carga

| Metrica | Media | Mediana | Varianza muestral |
| --- | --- | --- | --- |
| Tiempo de respuesta promedio ms | 0.0101 | 0.0101 | 0.0000 |
| Throughput ops/s | 98962.5579 | 98882.6246 | 692069.7700 |
| Tasa de errores % | 0.0000 | 0.0000 | 0.0000 |

### 5.2 Interpretacion de carga

El sistema mostro un comportamiento estable bajo una carga esperada de
transacciones locales. El tiempo promedio por operacion se mantuvo alrededor de
0.0101 ms y la mediana fue igual a la media, lo que indica baja dispersion en
la respuesta. El throughput promedio fue de 98,962.5579 operaciones por segundo.

La tasa de errores fue 0% en las 25 corridas. Con base en estos resultados, las
operaciones comunes de crear, actualizar, eliminar logicamente y consultar
tareas/eventos no representan un cuello de botella para el alcance local del
proyecto.

## 6. Resultados: prueba de volumen

| Corrida | Registros | Tiempo carga ms | Tiempo consulta ms | Latencia us/fila |
| --- | --- | --- | --- | --- |
| 1 | 7000 | 22.3327 | 8.6641 | 1.4961 |
| 2 | 7000 | 22.2223 | 8.2063 | 1.4171 |
| 3 | 7000 | 22.0891 | 8.3058 | 1.4343 |
| 4 | 7000 | 22.1448 | 8.2662 | 1.4274 |
| 5 | 7000 | 22.3981 | 8.1960 | 1.4153 |
| 6 | 7000 | 22.3603 | 8.2344 | 1.4219 |
| 7 | 7000 | 22.1165 | 8.6413 | 1.4922 |
| 8 | 7000 | 22.1787 | 8.1040 | 1.3994 |
| 9 | 7000 | 23.6728 | 8.5216 | 1.4715 |
| 10 | 7000 | 22.3461 | 8.4096 | 1.4522 |
| 11 | 7000 | 22.2107 | 8.1817 | 1.4128 |
| 12 | 7000 | 22.4876 | 8.6808 | 1.4993 |
| 13 | 7000 | 22.5629 | 8.1811 | 1.4130 |
| 14 | 7000 | 22.3096 | 8.2733 | 1.4289 |
| 15 | 7000 | 22.2833 | 8.4123 | 1.4529 |
| 16 | 7000 | 22.3600 | 8.1688 | 1.4108 |
| 17 | 7000 | 22.1775 | 8.2334 | 1.4220 |
| 18 | 7000 | 22.3202 | 8.3794 | 1.4472 |
| 19 | 7000 | 22.2302 | 8.3051 | 1.4344 |
| 20 | 7000 | 22.2367 | 8.3774 | 1.4466 |
| 21 | 7000 | 22.3256 | 8.3376 | 1.4398 |
| 22 | 7000 | 22.3637 | 8.1642 | 1.4098 |
| 23 | 7000 | 22.2971 | 8.1573 | 1.4086 |
| 24 | 7000 | 22.3161 | 8.7023 | 1.5027 |
| 25 | 7000 | 22.1722 | 8.3146 | 1.4358 |

### 6.1 Estadistica basica: prueba de volumen

| Metrica | Media | Mediana | Varianza muestral |
| --- | --- | --- | --- |
| Tiempo de carga de datos ms | 22.3406 | 22.3096 | 0.0894 |
| Tiempo de consulta a BD ms | 8.3367 | 8.3051 | 0.0318 |
| Latencia de acceso us/fila | 1.4397 | 1.4343 | 0.0009 |

### 6.2 Interpretacion de volumen

Con un volumen de 7,000 registros por corrida, el sistema mantuvo tiempos de
carga y consulta consistentes. La carga promedio fue de 22.3406 ms y la mediana
de 22.3096 ms, por lo que no se observo una diferencia relevante entre el valor
central y el promedio. La consulta promedio fue de 8.3367 ms, con una latencia
media de 1.4397 microsegundos por fila tocada.

La varianza de los tiempos de consulta fue baja, lo que indica estabilidad ante
el volumen probado. La corrida 9 tuvo el mayor tiempo de carga, pero no produjo
fallas ni una degradacion sostenida en corridas posteriores.

## 7. Comportamiento y desempeno observado

Con base en las pruebas realizadas, Agenda presenta un buen desempeno en el
subsistema de persistencia local para los escenarios evaluados.

En carga esperada, el sistema procesa operaciones de escritura, actualizacion,
eliminacion logica y consulta con tiempos muy bajos y sin errores. Esto sugiere
que el uso normal de la agenda no deberia verse afectado por la cantidad tipica
de operaciones generadas por un usuario individual.

En volumen, el sistema tambien se mantuvo estable al trabajar con miles de
registros. Las consultas sobre tareas y eventos continuaron dentro de tiempos
bajos, por lo que SQLite es adecuado para el alcance offline actual de la
aplicacion.

El comportamiento general fue estable: no se detectaron errores, bloqueos ni
variaciones bruscas. La diferencia entre media y mediana fue pequena en todas
las metricas, lo que indica que los resultados no dependen de valores extremos
aislados.

## 8. Limitaciones

Estas pruebas se enfocaron en la capa de persistencia local y no sustituyen una
prueba completa de interfaz en dispositivo fisico. Para una evaluacion final de
experiencia de usuario seria recomendable complementar con:

- Medicion de tiempo de arranque de la app Flutter.
- Medicion de renderizado de pantallas con listas grandes.
- Ejecucion sobre almacenamiento real de Windows, Android o iOS.
- Monitoreo de memoria y CPU durante sesiones largas.

## 9. Conclusion

Los resultados obtenidos permiten concluir que Agenda cumple satisfactoriamente
con el desempeno esperado para una aplicacion local de gestion academica y
personal. Las pruebas de carga muestran alta capacidad de procesamiento de
transacciones locales, mientras que las pruebas de volumen evidencian que la
base SQLite puede manejar miles de registros con tiempos de consulta bajos y
comportamiento estable.

Para el alcance actual del proyecto, la persistencia local no se identifica
como cuello de botella. El mayor riesgo futuro estaria en la interfaz si se
presentan listas muy grandes sin paginacion, filtros o virtualizacion; por ello
se recomienda mantener pruebas de rendimiento cuando se agreguen nuevas vistas,
sincronizacion externa o mayor volumen de datos.
