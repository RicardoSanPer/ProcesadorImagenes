public abstract class BaseFilter
{
  protected String name;
  
  protected int imageWidth;
  protected int imageHeight;
  
  public BaseFilter(){}
  
  public BaseFilter(String name)
  {
    this.name = name;
  }
  
  /**
  * Funcion que aplica el filtro a la imagen de entrada, guardando el resultado en la imagen de salida
  *
  * @param input Imagen a procesar
  * @param output Imagen de salida procesada
  */
  public void ProcessImage(PImage input, PImage output)
  {
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = input.width;
    imageHeight = input.height;
    
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y);
        output.pixels[location] = pixelProcessing(x, y, location, input.pixels);
      }
    }
    
    output.updatePixels();
  }
  
  /**
  * Funcion por pixel para el procesamiento de la imagen
  *  @param x coordenada x del pixel en la imagen
  *  @param y coordenada y del pixel en la imagen
  *  @param location indice del pixel en el arreglo de pixeles
  *  @param pix arreglo que contiene la informacion de los pixeles de las imagenes
  *
  *  @return color resultante del procesamiento
  */
  protected abstract color pixelProcessing(int x, int y, int location, int[] pix);
  
  /**
  *  Calcula el indice de un pixel en el arreglo de pixeles dado su cordenada en la imagen
  *  @param x coordenada x del pixel en la imagen
  *  @param y coordenada y del pixel en la imagen
  *  @return indice correspondiente del pixel en el arreglo
  */
  private int pixelLocation(int x, int y)
  {
    return x + y * imageWidth;
  }
  
  public String GetName()
  {
    return name;
  }
}
