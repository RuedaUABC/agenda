# Casos de Uso

## CU-001. Navegar entre modulos

Actor: Usuario.

Precondicion: La aplicacion esta abierta.

Flujo principal:

1. El usuario toca una opcion de la barra inferior.
2. El sistema cambia a la pantalla seleccionada.
3. El sistema conserva el estado de las pantallas ya cargadas.

Resultado: El usuario visualiza Tareas, Horario, Calendario o Ajustes.

## CU-002. Crear tarea

Actor: Usuario.

Precondicion: El usuario esta en el modulo de tareas.

Flujo principal:

1. El usuario toca el boton de agregar.
2. El sistema abre el formulario de tarea.
3. El usuario captura titulo, asignatura, descripcion, fecha y hora.
4. El usuario guarda.
5. El sistema persiste la tarea y recarga la lista.

Alternativa:

- Si el titulo esta vacio, el sistema muestra validacion y no guarda.

Resultado: La tarea aparece en la categoria correspondiente.

## CU-003. Gestionar tarea existente

Actor: Usuario.

Precondicion: Existe al menos una tarea.

Flujo principal:

1. El usuario abre el detalle de una tarea.
2. El sistema muestra sus datos.
3. El usuario puede completar, devolver a pendiente, editar o eliminar.
4. El sistema actualiza el estado y recarga las listas.

Resultado: La tarea refleja la accion realizada.

## CU-004. Recuperar tarea de papelera

Actor: Usuario.

Precondicion: Existe una tarea marcada como eliminada.

Flujo principal:

1. El usuario abre la seccion Papelera.
2. El usuario selecciona una tarea.
3. El usuario toca Recuperar.
4. El sistema cambia `eliminada` a `false` y recarga tareas.

Resultado: La tarea vuelve a las tareas activas.

## CU-005. Consultar progreso de tareas

Actor: Usuario.

Precondicion: Existen tareas cargadas.

Flujo principal:

1. El usuario entra al modulo de tareas.
2. El sistema calcula progreso diario.
3. El sistema calcula estadisticas de los proximos siete dias.
4. El sistema muestra el panel de progreso.

Resultado: El usuario visualiza avance y carga de trabajo proxima.

## CU-006. Crear clase semanal

Actor: Usuario.

Precondicion: El usuario esta en el modulo Horario.

Flujo principal:

1. El usuario toca el boton de agregar.
2. El sistema abre el formulario de clase.
3. El usuario captura materia, aula, dia, hora de inicio, hora de fin y color.
4. El sistema valida materia y rango horario.
5. El sistema crea una regla semanal segun el dia seleccionado.
6. El sistema guarda la clase y recarga el horario.

Resultado: La clase aparece en calendario semanal y lista del dia.

## CU-007. Consultar horario

Actor: Usuario.

Precondicion: Existen clases guardadas.

Flujo principal:

1. El usuario entra al modulo Horario.
2. El sistema muestra calendario semanal.
3. El usuario selecciona una fecha.
4. El sistema lista clases cuyo dia de semana coincide con la fecha.

Resultado: El usuario consulta clases del dia seleccionado.

## CU-008. Consultar calendario de eventos

Actor: Usuario.

Precondicion: Existen eventos guardados.

Flujo principal:

1. El usuario entra al modulo Calendario.
2. El sistema muestra una vista mensual.
3. El usuario selecciona una fecha.
4. El sistema lista eventos que ocurren en esa fecha.

Resultado: El usuario consulta los eventos del dia.

## CU-009. Configurar notificaciones globales

Actor: Usuario.

Precondicion: El usuario esta en Ajustes.

Flujo principal:

1. El sistema muestra las preferencias actuales.
2. El usuario selecciona anticipacion para clases.
3. El usuario selecciona anticipacion para el primer aviso de tareas.
4. El sistema guarda las preferencias.
5. Si hay repositorio de tareas inyectado, el sistema reprograma tareas
   pendientes.

Resultado: Las preferencias quedan persistidas localmente.

## CU-010. Iniciar sesion con Google

Actor: Usuario.

Precondicion: Firebase esta inicializado y `LoginPage` esta conectada al flujo
de inicio.

Flujo principal:

1. El usuario toca Continuar con Google.
2. El sistema autentica con Google.
3. El sistema intercambia credenciales con Firebase Auth.
4. El sistema muestra bienvenida y navega a la app.

Estado actual: caso de uso parcial, porque la pantalla y servicio existen pero
no estan conectados desde `main.dart`.
