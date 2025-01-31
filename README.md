# Procesador de Imagenes

Por Ricardo Sánchez Pérez

## Requisitos

Para abrir el codigo fuente y compilarlo se requiere Processing.

Se requiere la libreria ControlP5. Se puede instalar dentro de la interfaz de Processing. Se realiza en
 
```Sketch -> Import Library -> Manage Libraries```

```Filter -> "ControlP5" -> Install```

## Ejecución

Para abrir el proyecto:

``` File -> Open...```

Y abrir el archivo ```ProcesadorImagenes.pde``` en el directorio del mismo nombre.

El programa se puede ejecutar en el boton ```Run``` ubicado bajo el boton ```File``` o en ```Skecth -> Run```.

### Ejecutable

El programa se puede compilar a un ejecutable en ```File -> Export Application...``` y eligiendo la configuracion de compilación.

El ejecutable se guarda en un directorio nuevo en ```ProcesadorImagenes``` con el nombre del sistema para el cual fue compilado. Dentro
se encuentra el ejecutable. Adicionalmente se debe copiar el archivo ```sample.jpg``` al directorio.

## Sobre el programa

El programa puede cargar imagenes y guardar las imagenes con el filtro aplicado como un archivo nuevo. Al guardar una imagen se guarda como jpg
por defecto si no se especifica una extension de archivo de imagen al elegir el nombre del archivo.

Los filtros se eligen de una lista. Al elegir un filtro, este puede adicionalmente mostrar parametros para modificar el filtro.

Para aplicar el filtro, hacer click en "Procesar Filtro".

## Implementacion

Se implemento una clase ImageProcessor que se encarga de procesar las imagenes y una clase UIManager que se encarga de la UI del programa.

Se implementó una clase base BaseFilter de la cual heredan todos los filtros que se implementan. Cada filtro implementa su procesamiento
de los pixeles.