/**
*  Clase encargada de procesar la imagen
*
*/

import java.util.ArrayList;

public class ImageProcessor
{
  PImage base;        //Imagen a procesar
  PImage processed;   //Imagen procesada
  
  ArrayList<BaseFilter> filtros;
  
  public ImageProcessor()
  {
    base = loadImage("../sample.jpg");
    processed = loadImage("../sample.jpg");
    //Lista de filtros
    filtros = new ArrayList<BaseFilter>();
  }
  
  /**
  *  Dibuja la imagen y el resultado del procesamiento
  */
  public void DrawImages()
  {
    //Calcular el cociente de aspecto de la imagen y el espacio de
    //visualizacion para cambiar el tamaño de despliegue de la imagen
    //para que se vea completa
    
    //Se ajusta primero la anchura de la imagen
    float desiredWidth = ((width - 300) * 0.5) - 20 ;
    float xratio = desiredWidth / base.width;
    
    //Se ajusta la altura
    float desiredHeight = height - 100;
    float yratio  = 1;
    if(base.height * xratio > desiredHeight)
    {
      yratio = desiredHeight / (base.height * xratio);
    }
    
    float ratio = xratio * yratio;
    
    if(base != null)
    {
      image(base, 10, 60, base.width * ratio, base.height * ratio);
    }
    if(processed != null)
    {
      image(processed, (base.width * ratio) + 20, 60, base.width * ratio, base.height * ratio);
    }
  }
  /**
  * Aplica un filtro actual a la imagen
  * @param seleccion Numero de filtro a aplicar
  */
  public void Apply(int seleccion)
  {
    resetProcessed();
    if(filtros.size() < 0)
    {
      return;
    }
    if(seleccion < 0 || seleccion >= filtros.size())
    {
      return;
    }
    filtros.get(seleccion).ProcessImage(base, processed);
  }
  
  /**
  *  Cambia la UI para mostrar los controles del filtro actualmente seleccionado
  *
  *  @param i indice del filtro cuyos controles se van a mostrar
  */
  public void SwitchUI(int i)
  {
    for(BaseFilter f : filtros)
    {
      f.HideControls();
    }
    filtros.get(i).ShowControls();
    
    resetProcessed();
  }
  
  private void resetProcessed()
  {
    processed.resize(base.width, base.height);
    base.loadPixels();
    processed.loadPixels();
    for(int i = 0; i < base.height; i++)
    {
      for(int j = 0; j < base.width; j++)
      {
        int location = i * base.height + j;
        if(location < base.pixels.length)
        {
          processed.pixels[location] = base.pixels[location];
        }
      }
    }
    processed.updatePixels();
    base.updatePixels();
  }
  
  /**
  *  Agrega un filtro a la lista de filtros disponibles
  *  
  *  @param filtro filtro a agregar
  */
  public void addFilter(BaseFilter filtro)
  {
    if(filtros == null)
    {
      filtros = new ArrayList<BaseFilter>();
    }
    filtros.add(filtro);
  }
  
  /**
  * Regresa la lista de filtros
  * @retun lista de filtros
  */
  public ArrayList<BaseFilter> GetFilterList()
  {
    return filtros;
  }
  
  ///// GETTERS
  
  public PImage GetBaseImage()
  {
    return base;
  }
  
  public PImage GetProcessedImage()
  {
    return processed;
  }
   
  /**
  *  Carga una imagen para ser procesada
  *
  *  @param path ubicacion absoluta del archivo
  */
  public void LoadImage(String path)
  {
    base = loadImage(path);
    processed = loadImage(path);
  }
  
   /*
   *  Guarda la imagen procesada en el sistema
   *  
   *  @param path ubicacion absoluta del destino del archivo
   */
  public void SaveProcessed(String path)
  {
    processed.save(path);
  }
}
