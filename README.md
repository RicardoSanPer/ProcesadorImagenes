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
- Tarea 3 (```FiltroMarcaAgua.pde```)
    Filtro que remueve marcas de agua:
    - Asume que la imagen es a blanco y negro, y la marca de agua esta dada por un color prominente (ie texto rojo y semitransparente sobre la imagen).
    - Devuelve una imagen a blanco y negro con una aproximación de la marca de agua removida.
- Tarea 4 (```FiltroRecursivo.pde```)
    Filtro que recrea la imagen recursivamente.
    - Tamaño Mosaico (Imagen Original): Tamaño de mosaico que se usará para la imagen original. Reduce el numero de imagenes
    recursivas ("resolución") que tendrá la imagen final.
    - Tamaño Mosaico (Imagen Recursiva): Tamaño de mosaico que se usará para la imagen recursiva. Reduce la resolución de las
    imagenes recursivas.
    - Grises: La imagen resultante será a blanco y negro.
    - Cuantización: Reduce la paleta de colores (tonos por canal). Usar 6 tonos por canal para obtener la paleta web (216 tonos en total). 
    La cuantización se aplicará tambien a las imagenes recursivas.

    ** Puesto que se preserva la relación de dimensiones para las imagenes recursivas, puede que las imagenes resultantes tengan una relación de dimensiones exagerada.
- Tarea 5(```FiltroDithering.pde```)
    Filtro que implementa los algoritmos de dither:
    - Azar
    - Ordenado (2x2)
    - Ordenado (4x4)
    - Difusión Simple
    - Floyd-Steinberg
    - Floyd-Steinberg falso
    - Jarvis, Judice, y Ninke

    **Debido al tamaño de la imagen de previsualizacion es posible que no se pueda apreciar el resultado correcto del dithering en el programa, pero se puede ver
    guardando y abriendo la imagen resultante en un programa externo.
- Tarea 6(```FiltroSemitonos```)
    - Semitonos circulares:
        Recrea la imagen utilizando circulos negros sobre un fondo blanco para simular semitonos.
        
        Controles:
        - Tamaño Circulo: Tamaño en pixeles de un circulo completo en la imagen final.
        - Tamaño Celda: Cuantos pixeles de la imagen original son cubiertos por cada circulo.
        - Lista de modos:
            - Circulos: El tamaño de cada circulo depende de la luminosidad de la celda que cubre
            - Circulos 2x2: Se utiliza una matriz 2x2 con un patron de dither.
            - Circulos 3x3: Se utiliza una matriz 3x3 con un patron de dither.
    - Filtro Dados:
        Recrea la imagen utilizando imagenes de dados, donde el numero del dado depende del brillo de la celda. 
        
        Controles:
        - Tamaño celda: Cuantos pixeles de la imagen original son cubiertos por la imagen original
        - Invertir Brillo: Invierte el brillo de la imagen. Util para corregir el numero de los dados
        cuando se eligen paletas de colores donde los puntos son mas brillantes que las caras.
        - Dirección: Dirección de la luz.
        - Altura: Altura de la luz.
        - Intensidad de luz: Intensidad de la luz que ilumina los dados.
        - Suavidad de Superficie: Controla que tanto se difumina la luz sobre la superficie de los dados.
        - Intensidad de brillo: Controla que tanta luz reflejan los dados.
        - Color Puntos: Color de los puntos.
        - Color Caras: Color de las caras.
    - Filtro Solar:
        Aplica un efecto de solarizacion. Mapea los valores de un pixel de 0 a N (umbral) al rango [155,0], y los valores
        de N a 255 al rango [0,255].
    - Posterizacion:
        Limita el numero de tonos por cada canal.

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

### Implementación de Filtro Recursivo

Para el filtro recursivo se utilizó una implementación similar al filtro de sopa de letras. Se crea un buffer de color del cual se determina
el color de cada "pixel" o imagen recursiva en la imagen resultante.  Se crea tambien un buffer de valor que es la imagen a repetir (a blanco y negro).

La imagen resultante tiene una resolución con dimensiones equivalentes al producto de las dimensiones de los buffers. Para crear la imagen,
se toma la coordenada de la imagen de salida, y su modulo respecto las dimensiones del buffer de valor nos da la coordenada del pixel del buffer de valor a
usar (permitiendo repetir la imagen recursiva), mientras su cociente con las dimensiones del buffer de color nos da la coordenada del pixel del
buffer de color con el color a usar (permitiendonos pintar la imagen recursiva "actual" del color correspondiente del pixel en la imagen original).

## Implementación de Dithering

Para los algoritmos de dithering se implementó tal que el dithering pueda aplicarse entre cualesquiera dos tonos arbirtrarios. Particularmente para
el algoritmo de dithering ordenado se logró usando el error para determinar si un color usa su valor cuantizado, o el valor cuantizado "anterior" o "siguiente".
Entonces el filtro funciona para cualquier numero de tonos.

El filtro se implementó para que el dithering se pueda aplicar a un valor cualquiera (como el filtro de cuantización), por lo que puede utilizarse para
generar imagenes a color o blanco y negro.

## Implementación de Semitonos
### Semitonos circulares
Para los filtros de semitonos con circulos se crea el circulo de forma procedural en una bufer interno, donde el valor de cada pixel es su distancia al centro (normalizado). De este modo para
variar el tamaño de los circulos simplemente se compara la distancia de cada pixel con un umbral.
Tiene la ventaja de que puede permitir cualquier numero de tonos, pero limitado al tamaño en pixeles del circulo.

Para la implementación de los semitonos que usan un patron de 2x2 y 3x3 se utilizó un metodo similar al del filtro de dithering.

Para los tres filtros se crea primero un bufer de color del cual se toman las muestras de colores, y el buffer con el circulo. Se cambia el tamaño de la imagen para que sea del tamaño
de numero de celdas x el tamaño de los pixeles. Al procesar el filtro se calcula el pixel correspondiente del buffer de color y del buffer de circulo para cada pixel de la imagen de salida, y tambien del kernel del patron donde aplique.

### Filtro Dados
Las imagenes de los dados se crearon con Substance Designer. Se creo para cada dado una mascara de color (para colorear los puntos y las caras de distintos colores), junto con un mapa de normales y una mascara de color (para diferenciar el dado del fondo). El filtro elije un dado
dependiendo del brillo del pixel en el buffer de color y realiza calculos de iluminación basicos
simulando una luz. El muestreo de las imageens de dados es similar al de los semitonos circulares.

### Filtro Solar
El filtro solar toma el umbral como "Punto medio" y mapea cada valor a ambos lados a un valor nuevo entro 0 y 255, tal que valores cercanos al umbral sean cercanos a 0 y los valores mas lejanos son 255. Si se aplica el filtro sobre una gradiente de negro a blanco se obtendría una
gradiente que "rebota" donde el umbral se encuentra. Como consecuencia, si se usa un umbral de
0 se obtiene la imagen original, y un umbral de 255 invierte los colores.