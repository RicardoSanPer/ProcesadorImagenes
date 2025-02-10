import java.util.Random;
/*
*
*        FILTROS TAREA 1
*
*
*
*/



/**
* Filtro de canal rojo
*/
public class RedFilter extends BaseFilter
{
  public RedFilter()
  {
    super("Escala de Rojos");
  }
  public RedFilter(String n)
  {
    super(n);
  }
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(red(input[l]), 0, 0);
  }
}

/**
* Filtro de canal verde
*/

public class GreenFilter extends BaseFilter
{
  public GreenFilter()
  {
    super("Escala de Verdes");
  }
  public GreenFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(0, green(input[l]), 0);
  }
}

/**
* Filtro de canal Azul
*/

public class BlueFilter extends BaseFilter
{
  public BlueFilter()
  {
    super("Escala de Azules");
  }
  
  public BlueFilter(String n)
  {
    super(n);
  }
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(0, 0, blue(input[l]));
  }
}

/**
*
*  Filtro de mosaico
*
*/

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
        int location = pixelLocation(i, j, imageWidth);
        if(location < input.length)
        {
          int col = input[pixelLocation(i, j, imageWidth)];
          
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
  * Implementacion mas eficiente. Divide la imagen en bloques de tamaño dado por el kernel y por cada bloque
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
    //Tamaño del kernel en pixeles
    float sizex = kernelX.GetValue();
    float sizey = kernelY.GetValue();
    
    //Numero de segmentos/mosaicos en los que se divide la imagen
    int nsegments = (int)(input.width / sizex);
    int msegments = (int)(input.height / sizey);
    
    input.loadPixels();
    output.loadPixels();
    
    imageWidth = input.width;
    imageHeight = input.height;
    
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
        
        //Iterar por cada pixel dentro del mosaico para asignar el color calculado
        for(int x = 0; x < sizex && x + (i * sizex) < input.width; x++)
        {
          for(int y = 0; y < sizey && y + (j * sizey) < input.height; y++)
          {
            int posy = (int) (y + (j * sizey));
            int posx = (int) (x + (i * sizex));
            int loc = pixelLocation(posx, posy, output.width);
            
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


/**
*
*  Filtro de brillo
*  Suma/resta un valor a los canales de la imagen
*
*/

public class BrightnessFilter extends BaseFilter
{
  CustomSliderController slider;
  
  public BrightnessFilter()
  {
    super("Brillo");
  }
  
  public BrightnessFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    r += slider.GetValue();
    r = r < 0 ? 0 : r > 255? 255 : r;
    
    g += slider.GetValue();
    g = g < 0 ? 0 : g > 255? 255 : g;
    
    b += slider.GetValue();
    b = b < 0 ? 0 : b > 255? 255 : b;
    return color(r,g,b);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Brillo");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    slider = new CustomSliderController(controls, p5, "Brightness"+name, "Ganancia", 20);
    slider.SetRange(-255, 255);
    slider.SetValue(0);
  }
}

/**
*
*  Filtro de niveles
*  Similar al filtro de brillo, pero el calculo se hace por canal
*
*/

public class RGBLevelsFilter extends BaseFilter
{
  CustomSliderController rojo;
  CustomSliderController verde;
  CustomSliderController azul;
  
  public RGBLevelsFilter()
  {
    super("Niveles RGB");
  }
  
  public RGBLevelsFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    //Multiplicar canales por la intensidad deseada (normalizado a rango 0-1)
    r *= rojo.GetValue()/255;
    r = r < 0 ? 0 : r > 255? 255 : r;
    
    g *= verde.GetValue()/255;
    g = g < 0 ? 0 : g > 255? 255 : g;
    
    b *= azul.GetValue()/255;
    b = b < 0 ? 0 : b > 255? 255 : b;
    return color(r,g,b);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Niveles");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    rojo = new CustomSliderController(controls, p5, "RLevel" + name, "Rojo", 20);
    rojo.SetRange(0, 255);
    rojo.SetValue(255);
    rojo.SetColor(color(128,0,0));
    
    verde = new CustomSliderController(controls, p5, "GLevel" + name, "Verde", 60);
    verde.SetRange(0, 255);
    verde.SetValue(255);
    verde.SetColor(color(0,128,0));
    
    azul = new CustomSliderController(controls, p5, "BLevel" + name, "Azul", 100);
    azul.SetRange(0, 255);
    azul.SetValue(255);
    azul.SetColor(color(0,0,218));
  }
}

/*
*  Filtro monocromatico (blacno/negro)
* Incluye control para usar pesos ponderados
*/  

public class GrayScaleFilter extends BaseFilter
{
  Toggle usarPesos;
  public GrayScaleFilter()
  {
    super("Escala de Grises");
  }
  
  public GrayScaleFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    float k = 128;
    
    //Usar pesos ponderados
    if(usarPesos.getBooleanValue())
    {
      k = r * 0.2126 + g * 0.7152 + b * 0.0722;
    }
    //Usar promedio de los canales
    else
    {
      k = (r + g + b) / 3;
    }
    return color(k,k,k);
  }
  
  protected void setupControls(ControlP5 cp5)
  {
    controls.setLabel("Controles de Escala de Grises");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    usarPesos = new Toggle(p5, "UsarPesos" + name);
    SetupToggle(usarPesos, "Usar Pesos Ponderados", 15);
    usarPesos.setGroup(controls);
  }
}

/**
*  Filtro binarizacion/alto contraste. Cambia el valor de un pixel a negro o blanco
*  dependiendo de un valor umbral (por defecto 128). Incluye control para invertir el resultado
*
*/

public class BinarizationFilter extends BaseFilter
{
  CustomSliderController slider;
  Toggle invert;
  
  public BinarizationFilter()
  {
    super("Alto Contraste");
  }
  
  public BinarizationFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    float k = r * 0.2126 + g * 0.7152 + b * 0.0722;
    k = k > slider.GetValue() ? 255 : 0;
    if(invert.getBooleanValue())
    {
      k = 255 - k;
    }
    return color(k,k,k);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Binarizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    slider = new CustomSliderController(controls, p5, "Binarization"+name, "Umbral", 20);
    
    invert = new Toggle(p5, "InvertirBinario" + name);
    SetupToggle(invert, "Invertir", 45);
    invert.setGroup(controls);
    
  }
  
}

/**
*
*  Filtro que invierte el valor de los canales
*
*/
public class InvertFilter extends BaseFilter
{
  public InvertFilter()
  {
    super("Invertir Colores");
  }
  
  public InvertFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    return color(255 - r, 255 - g, 255 - b);
  }
}



/**
*  Filtro de cuantizacion de pixeles. Basicamente restringe la cantidad de tonos por
*  canal. Adicionalmente puede aplicar dithering usando variaciones aleatorias en los
*  valores de los pixeles para evitar el banding de tonos
*/
public class QuantizeFilter extends BaseFilter
{
  CustomSliderController slider;
  Toggle useDithering;
  CustomSliderController ditherRandom; //Slider que controla la intensidad de la variacion
  Random rand;
  
  public QuantizeFilter()
  {
    super("Cuantizacion");
    rand = new Random();
  }
  
  public QuantizeFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
   
    return color(quantize(r), quantize(g), quantize(b));
  }
  
  /** Cuantiza el valor de un pixel
  * @param c valor de un canal
  * @return valor cuantizado
  */
  private float quantize(float c)
  {
    //Si se usa dithering varia aleatoriamente el valor de entrada en base a la cantidad de aleatoreidad
     if(useDithering.getBooleanValue())
     {
       c = c + ((float)rand.nextDouble() - 0.5) * 2 * ditherRandom.GetValue();
     }
     
     float factor = 255 / (slider.GetValue() - 1);
     float k = c / factor;
     k = (k % 1 > 0.5)? (float)Math.ceil(k) : (float)Math.floor(k);
     k = k * factor;
     k = k > 255 ? 255 : k < 0 ? 0 : k;
     return k;
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Quantizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    //Numero de tonos
    slider = new CustomSliderController(controls, p5, "Tones" + name, "Tonos", 20);
    slider.SetRange(2, 16);
    slider.SetValue(2);
    
    //Controles de dithering
    //Toggle
    useDithering = new Toggle(p5, "Dithering" + name);
    SetupToggle(useDithering, "Dithering", 45);
    useDithering.setGroup(controls);
    
    //Intensidad de dithering
    ditherRandom = new CustomSliderController(controls, p5, "DitherRandom" + name, "Intensidad", 80);
    ditherRandom.SetRange(0, 255);
    ditherRandom.SetValue(32);
    
    
  }
  
}
