
## Acerca de
La herramienta permite la manipulación tanto de notas (archivos `.rn`) como de cuadernos (carpetas), permitiendo la creación, eliminación, editado y listado para cada una.

las notas y cuadernos se almacenan en la carpeta `.my_rns` dentro del directorio `home` del usuario que ejecuta la aplicación.

Todas las notas se alamacenan en un cuaderno, si no se especifica uno, se guarda en el cuaderno por defecto (`.cuaderno_global`)


Los nombres de las notas y cuadernos solo aceptan lo letras en minúsculas, mayúscula, números, guiones y guiones bajos

## Uso de `rn`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual
puede correrse de las siguientes manera:

```bash
$ ruby bin/rn [args]
```

O bien:

```bash
$ bundle exec bin/rn [args]
```

O simplemente:

```bash
$ bin/rn [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ rn [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.5 o posterior) y tener instaladas sus dependencias.


Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Documentación

Los comandos disponibles se listan a continuación.

Aclaración: la palabra notes o books se puede abreviar con `n` o `b` respectivamente

### Notas
A todos estos comandos se les puede especificar el cuaderno para realizar la acción, esto se hace colocando el flag `--book [book_name]`

- Crear

```bash
bin/rn notes create [note_name]
```

- Eliminar

```bash
bin/rn notes delete [note_name]
```

- Editar

```bash
bin/rn notes edit [note_name]
```

- Cambiar título

```bash
bin/rn notes retitle [current_name] [new_name]
```

- Listar notas


  - Si no se especifica ningún cuaderno se listan las notas de todos los cuadernos

```bash
bin/rn notes list # Si se agrega --global se listan todas las notas del cuaderno global
```

- Mostrar contenido de la nota

```bash
bin/rn notes show [note_name]
```

### Cuadernos
- Crear

```bash
bin/rn books create [book_name]
```

- Eliminar

```bash
bin/rn books delete [book_name]
```

- Cambiar título

```bash
bin/rn books retitle [current_name] [new_name]
```

- Listar todos los cuadernos

```bash
bin/rn notes list
```

### Estructura de la plantilla

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/rn`.
  * `lib/rn.rb` es la declaración del namespace `RN`, y las directivas de carga de clases
    o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/rn/` es el directorio que representa el namespace `RN`. Notá la convención de que
    el uso de un módulo como namespace se refleja en la estructura de archivos del proyecto
    como un directorio con el mismo nombre que el archivo `.rb` que define el módulo, pero
    sin la terminación `.rb`. Dentro de este directorio se ubicarán los elementos del
    proyecto que estén bajo el namespace `RN` - que, también por convención y para facilitar
    la organización, deberían ser todos. Es en este directorio donde deberías ubicar tus
    clases de modelo, módulos, clases de soporte, etc. Tené en cuenta que para que todo
    funcione correctamente, seguramente debas agregar nuevas directivas de carga en la
    definición del namespace `RN` (o dónde corresponda, según tus decisiones de diseño).
  * `lib/rn/commands.rb` y `lib/rn/commands/*.rb` son las definiciones de comandos de
    `dry-cli` que se utilizarán. En estos archivos es donde comenzarás a realizar la
    implementación de las operaciones en sí, que en esta plantilla están provistas como
    simples disparadores.
  * `lib/rn/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `rn`
  que se utiliza como punto de entrada para el uso de la herramienta.


### decisiones de diseño
Se decidió respetar la estructura basica de la aplicación. Aparte de los archivos generados por defecto se decidieron crear 2 mas, haciendo uso de los múdulos y mixins para agrupar métodos comunes para los comandos de las notas y cuadernos



### Funcionalidad de exportar
Para la funcionalidad de exportar se va a necesitar tener instalado en el sistema operativo las siguientes herramientas:
* [pandoc] (https://pandoc.org/installing.html)
