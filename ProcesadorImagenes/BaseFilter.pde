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
        location = pixelLocation(x, y, imageWidth);
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
  
  //Funcion para obtener el grupo
  public Group GetGroup()
  {
    return controls;
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
  protected int pixelLocation(int x, int y, int w)
  {
    return x + y * w;
  }
  
  /** Dado un color regresa su valor blanco/negro
  *  @param col color
  *  @return float con el valor
  */
  protected float grayscale(int col)
  {
    return (red(col) + green(col) + blue(col))/3;
  }
  
  /**
  *  Cuantiza un valor
  *  @param value valor a cuanti
  *  @param tones numero de tonos/valores
  *  @param maxValue valor maximo del valor a cuantizar
  *  @return float valor cuantizado
  */
  protected float quantizeValue(float value, float tones, float maxValue)
  {
    float factor = maxValue / (tones - 1);
    float i = value / factor;
    i = (i % 1 > 0.5)? (float)Math.ceil(i) : (float)Math.floor(i);
    
    return i;
  }
  
  
  /**
  *  Redimensiona la imagen. Similar al mosaico
  *
  *  @param input imagen a re
  *  @param output buffer de salida
  *  @param sizex relacion de ancho en pixeles
  *  @param sizey relacion alto en pixeles
  */
  protected void resizeImage(PImage input, PImage output, int sizex, int sizey)
  {
    input.loadPixels();
    output.loadPixels();
    
    //Numero de segmentos/mosaicos en los que se divide la imagen
    int nsegments = (int)(input.width / sizex);
    int msegments = (int)(input.height / sizey);
    
    output.resize(nsegments, msegments);
    
    //Iterar por mosaicos de arriba a abajo. Contar uno mas en caso de mosaicos truncados
    for(int j = 0; j < msegments; j++)
    {
      //Contar uno mas para tomar en cuenta casos en que hay mosaicos truncados
      for(int i = 0; i < nsegments; i++)
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
            int loc = pixelLocation(posx, posy, input.width);
            
            if(loc < input.pixels.length)
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
        
        //Colorear la salida
        int loc = pixelLocation(i,j, output.width);
        if(loc < output.pixels.length)
        {
          output.pixels[loc] = color(r,g,b);
        }
      }
    }
    
    output.updatePixels();
    
  }
  
  /** Obtener nombre del filtro
  * @return nombre
  */
  public String GetName()
  {
    return name;
  }
  
}


/****
*
*  Clase base para filtros de convoluciones
*  Filtro base es filtro de media (blur)
*
*/

public class BaseConvolucion extends BaseFilter
{
  //Kernel con los valores de pesos
  float[][] kernel = {{1, 1, 1},
                      {1, 1, 1},
                      {1, 1, 1}};
    
  float factor = 9;
  float bias = 0;
  
  CustomNumberController sizek;
  
  public BaseConvolucion() 
  {
    super("convolucion"); 
  }
  public BaseConvolucion(String n) {super(n);}
  
  protected color pixelProcessing(int x, int y, int location, int[] pix)
  {
    float r = 0;
    float g = 0;
    float b = 0;
    
    //Desface para el pixel vecino
    int dx = kernel.length / 2;
    int dy = kernel[0].length / 2;
    
    //Procesar convolucion
    for(int i = 0; i < kernel.length; i++)
    {
      //Posicion x del pixel vecino
      int lx = x - dx + i;
      lx = lx < 0 ? 0 : lx >= imageWidth ? imageWidth - 1 : lx;
      
      for(int j = 0; j < kernel[0].length; j++)
      {
        //Posicion y del pixel vecino
        int ly = y - dy + j;
        ly = ly < 0 ? 0 : ly >= imageHeight ? imageHeight - 1 : ly;
        
        //Posicion en el arreglo de pixeles del pixel vecino
        int ld = pixelLocation(lx, ly, imageWidth);
        ld = ld < 0 ? 0 : ld > pix.length ? pix.length - 1 : ld;
        
        r += red(pix[ld]) * kernel[i][j];
        g += green(pix[ld]) * kernel[i][j];
        b += blue(pix[ld]) * kernel[i][j];
      }
    }
    return color(r/factor  + bias,g/factor + bias,b/factor + bias);
  }
  
   public void ProcessImage(PImage input, PImage output)
   {
     updateKernel();
     super.ProcessImage(input, output);
   }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Convolucion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    sizek = new CustomNumberController(controls, p5, "KernelX" + name, "Tamaño", 20);
    
    sizek.SetValue(5);
  }
  
  //Actualiza los valores del kernel antes de aplicar el filtro
  //Escencialmente es la función que crea los valores del kernel
  protected void updateKernel()
  {
    int size = (int)sizek.GetValue() * 2 + 1;
    kernel = new float[size][size];
    
    for(int i = 0; i < kernel.length; i++)
    {
      for(int j = 0; j < kernel[0].length; j++)
      {
        kernel[i][j] = 1;
      }
    }
    factor = size * size;
  }
}
