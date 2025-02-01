public class MosaicFilter extends BaseFilter
{
  CustomNumberController kernelX;
  CustomNumberController kernelY;
  
  public MosaicFilter()
  {
    super("Mosaico");
  }
  
  public MosaicFilter(String n)
  {
    super(n);
  }
  
  /*
  *  Implementacion rapida y sucia
  *  Por cada pixel revisa los pixeles adyacentes en un area dada por el kernel. Es decir, si el
  *  kernel es de 16x16, revisa 16x16 pixeles por cada pixel, lo cual es ineficiente y lento para 
  * kernels grandes.
  */
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    int startx = (int) (x - (x % kernelX.GetValue()));
    int starty = (int) (y - (y % kernelY.GetValue()));
    
    float count = 0;
    float r = 0;
    float g = 0;
    float b = 0;
    
    for(int i = startx; i < startx + kernelX.GetValue(); i++)
    {
      for(int j = starty; j < starty + kernelY.GetValue(); j++)
      {
        int location = pixelLocation(i, j);
        if(location < input.length)
        {
          int col = input[pixelLocation(i, j)];
          
          r += red(col);
          g += green(col);
          b += blue(col);
          
          count++;
        }
      }
    }
    
    return color(r / count, g / count, b / count);
  }
  /**
  * Implementacion mas eficiente. Divide la imagen en mosaicos de tamaño dado por el kernel y por cada mosaico
  * itera sobre cada pixel dentro del mismo para tomar una muestra y calcular el color final, y
  * luego itera de nuevo sobre cada uno para asignar este valor calculado, con lo que
  * se itera por cada pixel solo dos veces.
  *
  *
  *  Para comparar la diferencia de eficiencia, se puede comentar la funcion ProcessImage para que el programa utilice
  *  la funcion pixelProcessing con la implementación ineficiente
  *
  */
  public void ProcessImage(PImage input, PImage output)
  {
    input.loadPixels();
    output.loadPixels();
    
    imageWidth = input.width;
    imageHeight = input.height;
    
    //Tamaño del kernel en pixeles
    float sizex = kernelX.GetValue();
    float sizey = kernelY.GetValue();
    
    //Numero de segmentos/mosaicos en los que se divide la imagen
    int nsegments = (int)(input.width / sizex);
    int msegments = (int)(input.height / sizey);
    
    //Iterar por mosaicos de arriba a abajo. Contar uno mas en caso de mosaicos truncados
    for(int j = 0; j <= msegments; j++)
    {
      //Contar uno mas para tomar en cuenta casos en que hay mosaicos truncados
      for(int i = 0; i <= nsegments; i++)
      {
        float count = 0;
        float r = 0;
        float g = 0;
        float b = 0;
        
        //Iterar por cada pixel dentro del mosaico actual para tomar muestra de color
        for(int x = 0; x < sizex && x + (i * sizex) < input.width; x++)
        {
          for(int y = 0; y < sizey && y + (j * sizey) < input.height; y++)
          {
            int posy = (int) (y + (j * sizey));
            int posx = (int) (x + (i * sizex));
            int loc = pixelLocation(posx, posy);
            
            if(loc < output.pixels.length)
            {
              r += red(input.pixels[loc]);
              g += green(input.pixels[loc]);
              b += blue(input.pixels[loc]);
              
              count++;
            }
          }
        }
        
        r /= count;
        g /= count;
        b /= count;
        
        //Iterar por cada pixel dentro del mosaico para asignar el color calculado
        for(int x = 0; x < sizex && x + (i * sizex) < input.width; x++)
        {
          for(int y = 0; y < sizey && y + (j * sizey) < input.height; y++)
          {
            int posy = (int) (y + (j * sizey));
            int posx = (int) (x + (i * sizex));
            int loc = pixelLocation(posx, posy);
            
            if(loc < output.pixels.length)
            {
              output.pixels[loc] = color(r,g,b);
            }
          }
        }
      }
    }
    
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Mosaico");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelX = new CustomNumberController(controls, p5, "KernelX" + name, "Tamaño X", 20);
    kernelY = new CustomNumberController(controls, p5, "KernelY" + name, "Tamaño Y", 60);
    
    kernelX.SetValue(5);
    kernelY.SetValue(5);
  }
  
}
