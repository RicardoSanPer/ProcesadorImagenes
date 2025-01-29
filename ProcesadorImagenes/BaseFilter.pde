public abstract class BaseFilter
{
  protected int imageWidth;
  protected int imageHeight;
  
  //Funcion para procesar imagenes
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
  
  //Funcion de procesado que se ejecuta por pixel
  protected abstract color pixelProcessing(int x, int y, int location, int[] pix);
  
  //Posicion de un pixel, puesto que son procesados como un arreglo de una sola dimension
  private int pixelLocation(int x, int y)
  {
    return x + y * imageWidth;
  }
}
