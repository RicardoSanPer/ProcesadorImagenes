/*
*  Clase base filtro de la cual heredan los filtros
*
*
*
*/

public abstract class BaseFilter
{
  protected String name;
  
  protected int imageWidth;
  protected int imageHeight;
  
  protected Group controls;
  
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
  *  Inicializa grupos para que los filtros puedan crear sus propios controles de UI
  *  @param cp5 ControlP5 de la ui
  */
  public void StartControls(ControlP5 cp5)
  {
    controls = cp5.addGroup(name);
    controls.setBarHeight(20);
    controls.getCaptionLabel().getStyle().marginTop = 5;
    setupControls(cp5);
    controls.hide();
  }
  
  //Funcion para que cada filtro pueda crear sus propios controles
  protected void setupControls(ControlP5 cp5) {};
  
  //Muestra los controles de este filtro
  public void ShowControls()
  {
    controls.show();
  }
  
  //Oculta los controles del filtro
  public void HideControls()
  {
    controls.hide();
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
  protected int pixelLocation(int x, int y)
  {
    return x + y * imageWidth;
  }
  
  public String GetName()
  {
    return name;
  }
  
}
