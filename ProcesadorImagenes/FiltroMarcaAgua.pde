/*
*  Filtro para remover marca de agua
*
*  El filtro remueve marcas de agua. Se asume que:
*  1) La imagen está a blanco y negro
*  2) La marca de agua es de un color transparente
*  3) La marca de agua extá sobre un solo canal (rojo, verde o azul)
*
*  El filtro primero intenta encontrar el color de la marca de agua, registrando 
*  el valor más alto y bajo del color rojo en pixeles donde el color rojo es el más predominante.
*  Teniendo este valor, convierte la imagen a blanco y negro. En los pixeles donde el rojo
*  es el color predominante suma o resta un valor al rojo en base a los valores altos y bajos del
*  rojo obtenido previamente para intentar igualar el valor de los tres canales y obtener un
*  valor aproximado correcto de la iluminación original del pixel.
*
*  El filtro remueve la marca de agua cas. Los unicos artefactos ocurren:
*  1) en los bordes de la marca de agua, donde la prominencia del rojo no es tan pronunciada, por lo que el pixel es ignorado
*  y convertido a tono de gris sin reducir el rojo, causando que los bordes de la marca de agua sean visibles al engrandecer la imagen.
*  2) Al ser una aproximación del brillo, la marca de agua es ligeramente visible en regiones oscuras de la imagen
*  
*
*/

public class RmvAguaFilter extends BaseFilter
{
  //Umbral de prominencia del color rojo
  float watermarkTreshold = 20;
  
  float redHigh = 255;
  float redLow = 0;
  float redMid = 128;
  
  public RmvAguaFilter()
  {
    super("Remover Marca de Agua");
  }
  public RmvAguaFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int loc, int[] pixel)
  { 
    float r = red(pixel[loc]);
    float g = green(pixel[loc]);
    float b = blue(pixel[loc]);
    
    float k = grayscale(pixel[loc]);
    
    //Si es un pixel de la marca de agua (el rojo es prominente)
    //se otiene la diferencia del valor del rojo en el pixel
    //con el valor medio del rojo de la marca de agua
    //y se agrega la diferencia al canal rojo para intentar igualar
    //la luminosidad del pixel
    if(abs(r - g)  > watermarkTreshold || abs(r - b) > watermarkTreshold)
    {
      //float gs = (g+b)/2;
      k += r - redMid;
    }
    
    //Se regresa un valor en la escala de blanco/negro
    return color(k,k,k);
  }
  
  public void ProcessImage(PImage input, PImage output)
  {
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = input.width;
    imageHeight = input.height;
    
    //Primero se obtiene el rango de valores del canal rojo
    //especificamente de los pixeles en donde se encuentra la marca de agua
    //(pixeles donde el rojo es mas prominente)
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, imageWidth);
        float r = red(input.pixels[location]);
        float g = green(input.pixels[location]);
        float b = blue(input.pixels[location]);
        
        if(abs(r - g)  > watermarkTreshold || abs(r-b) > watermarkTreshold)
        {
          redHigh = r > redHigh? r : redHigh;
          redLow = r < redLow? r : redLow;
        }
      }
    }
    //Se obtiene el valor medio
    redMid = (redHigh - redLow)/2;
    
    //Filtro para reducir/eliminar el rojo
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, imageWidth);
        output.pixels[location] = pixelProcessing(x, y, location, input.pixels);
      }
    }
    
    output.updatePixels();
  }
}
