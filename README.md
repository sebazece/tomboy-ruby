# Aplicacion Tomboy Rails

## Acerca de
La herramienta permite la manipulación tanto de notas como de cuadernos, permitiendo la creación, eliminación, editado, listado, y exportado para cada una.



Todas las notas se alamacenan en un cuaderno, si no se especifica uno, se guarda en el cuaderno por defecto (`cuaderno_global`)


### Estructura de la aplicación

Por defecto Rails utiliza el patrón de arquitectura MVC, En donde, la vista es lo que el usuario final ve, los modelos representan
las tablas de la bd (un modelo, una tupla) y el controlador es el ecargado de recibir la petición del cliente y darle una respuesta.
Adicionalmente se incluyó (en algunos controladores) un servicio, el cual retira la lógica del controlador y se encarga de resolver
la lógica del modelo de negocios.



### Importante:
Para que el modulo de exportaciones funcione correctametne se debe tener instalado en el siste operativo las siguientes herramientas:

* [pandoc](https://pandoc.org/installing.html)
* [Latex](https://www.latex-project.org/get/)

***


