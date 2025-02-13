# Procesador de Imagenes

Por Ricardo Sánchez Pérez
315153327

## Requisitos

Para abrir el codigo fuente y compilarlo se requiere de Processing.
https://processing.org/

Se requiere la libreria ControlP5. Se puede instalar dentro de la interfaz de Processing. Se realiza en
 
```Sketch -> Import Library -> Manage Libraries```

```Filter -> "ControlP5" -> Install```

## Ejecución

Para abrir el proyecto:

``` File -> Open...```

Y abrir el archivo ```ProcesadorImagenes.pde``` en el directorio del mismo nombre.

El programa se puede ejecutar con el boton ```Run``` ubicado bajo el boton ```File```, o en ```Skecth -> Run```.

### Ejecutable

El programa se puede compilar a un ejecutable en ```File -> Export Application...``` y eligiendo la configuracion de compilación.

El ejecutable se guarda en un directorio nuevo en ```ProcesadorImagenes``` con el nombre del sistema para el cual fue compilado. Dentro
se encuentra el ejecutable. Adicionalmente se debe copiar manualmente el archivo ```sample.jpg``` al directorio.

## Sobre el programa

El programa puede cargar imagenes y guardar las imagenes con el filtro aplicado como una imagen nueva. Al guardar una imagen se guarda como jpg
por defecto si no se especifica una extension de archivo de imagen al elegir el nombre del archivo.

Los filtros se eligen de una lista. Al elegir un filtro, este puede adicionalmente mostrar parametros para modificar el filtro.

Para aplicar el filtro, hacer click en "Procesar Filtro".

Filtros implementados:

- Tarea 1 (```FiltrosTarea1.pde```)
    - Filtro mosaico
    - Filtro blanco y negro (Promedio de RGB)
    - Filtro blanco y negro (Pesos 0.2R, 0.7G, 0.1B)
    - Filtro rojo
    - Filtro verde
    - Filtro azul
    - Filtro de alto contraste
    - Filtro de alto contraste invertido
    - FIltro de brillo
    - Niveles RGB
- Tarea 2 (```FiltroSopaLetras.pde```)
    - Filtro Sopa de Letras:
    Tamaño de letra: Numero de pixeles que cada letra cubre. Entre más chica mas tarda el procesamiento.
    Modos de Texto:
        - Texto: Repite una letra o frase para construir la imagen.
        - Luminosidad: Elige una letra de la cadena 'MNH#QAO0Y2$%+. ' en base a la luminosidad del pixel
        - Poker: Elige una carta en base a la luminosidad del pixel (palo de la carta aleatorio).
        - Domino: Elige una pieza de domino en base a la luminosidad de dos pixeles adyacentes.
    Modo de color:
        - Sin color: No se asigna color a la letra. Usar con Luminosidad, Poker o Domino si solo se quiere usar
        el caracter para representar su luminosidad.
        - Color: Asigna un color a la letra.
        - Grises: Convierte la imagen a escala de grises.
        - En el caso de Color y Grises se coloca un fondo negro y se invierte la luminosidad del caracter a usar
        (en caso de Luminosidad, Poker o Domino) para mejorar el contraste.
    Cuantización: Restringe el número de tonos por canal.
    Adicionalmente se tienen los controles para los filtros de escala de grises y de cuantizacion.
    Para guardar el HTML resultante, primero se debe procesar el filtro con "Procesar Filtro" y luego presionar "Guardar HTML".

## Implementacion

Se implemento una clase ImageProcessor que se encarga de inicializar los filtros y procesar las imagenes, y una clase UIManager que se encarga de la UI del programa.

Se implementó una clase base BaseFilter de la cual heredan todos los filtros que se implementan. Cada filtro implementa su procesamiento
de los pixeles e inicializa sus controles de UI en caso de tener.

### Implementacion de Filtro de Sopa de Letras

Para el filtro de sopa de letras, primero se preprocesa la imagen de entrada. La imagen de entrada reduce su tamaño de acuerdo al numero de pixeles
por letra por cuestiones de rendimiento. Luego se le aplican los filtros aplicables y la imagen resultante sirve de buffer de color (esta misma imagen
se muestra tambien como previsualizacion). Para generar el HTML resultante se toman muestras de color de este buffer y se eligen los caracteres
de acuerdo a las especificaciones del usuario.

Para los casos de Poker y Domino se utilizan los caracteres UNICODE para que los caracteres se muestren independientemente de cualquier fuente,
siempre que dicha fuente tenga implementados los glifos correspondientes. El HTML se genera usando la fuente "Segoe UI Symbol" en caso de elegir
Poker o Domino.