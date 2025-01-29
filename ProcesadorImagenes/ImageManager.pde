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
    if(base != null)
    {
      image(base, 10, 60, (width - base.width) * 0.5, (height - base.height) * 0.5);
    }
    if(processed != null)
    {
      image(processed, ((width - base.width)/2) + 10, 60, (width - processed.width) * 0.5, (height - processed.height) * 0.5);
    }
  }
  /**
  * Aplica un filtro actual a la imagen
  * @param seleccion Numero de filtro a aplicar
  */
  public void Apply(int seleccion)
  {
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
