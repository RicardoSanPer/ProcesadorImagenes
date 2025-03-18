import java.util.Random;
/**
*  Filtro de cuantizacion de pixeles. Basicamente restringe la cantidad de tonos por
*  canal. Adicionalmente puede aplicar dithering usando variaciones aleatorias en los
*  valores de los pixeles para evitar el banding de tonos
*/
public class QuantizeFilter extends BaseFilter
{
  CustomSliderController slider;
  //Determina si aplicar valores aleatorios por canal o a los tres por igual
  Boolean singleChannelRandom = false;
  
  public QuantizeFilter()
  {
    super("Posterizacion");
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
     float factor = 255 / (slider.GetValue() - 1);
     return quantizeValue(c, slider.GetValue(), 255) * factor;
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Posterizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    //Numero de tonos
    slider = new CustomSliderController(controls, p5, "Tones" + name, "Tonos por Canal", 20);
    slider.SetRange(2, 256);
    slider.SetValue(2); 
  }
  
  public float GetNumberTones()
  {
    return slider.GetValue();
  }
  
  public void SetNumberTones(float n)
  {
    slider.SetValue(n);
  }
}

/**
*
*  DITHERING
*
*  Aplica diferentes metodos de dithering
*
*
*/

public class DitherFilter extends BaseFilter
{
  //UI
  Toggle useBN;
  CustomSliderController intensidadAzar;
  ScrollableList modoDither;
  
  //filtros
  GrayScaleFilter filtrobn;
  QuantizeFilter filtroq;
  
  Random random;
  
  float tonos = 255;
  
  //Patrones de dither ordenado
  float[][] pattern_2_2 = {{0,2},{3,1}}; 
  
  float[][] pattern_4_4 = {{0,8,2,10},
                          {12,4,14,6},
                          {3,11,1,9},
                          {15,7,13,5}};
                          
  //Kernels de difusion
  float[][] diffuse_floyd = {{0,0,7},
                             {3,5,1},
                            };
  float[][] diffuse_fake = {{0,0,3},
                            {0,3,2}};
  float[][] diffuse_jjn = {{0,0,0,8,4},
                           {2,4,8,4,2},
                           {1,2,4,2,1}};
  
  
  public DitherFilter()
  {
    super("Dither");
    filtrobn = new GrayScaleFilter("FiltroBNDither");
    filtroq = new QuantizeFilter("FiltroQDither");
    random = new Random();
  }
  public DitherFilter(String n)
  {
    super(n);
    filtrobn = new GrayScaleFilter("FiltroBNDither"+n);
    filtroq = new QuantizeFilter("FiltroQDither"+n);
    random = new Random();
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return input[l];
  }
  
  public void ProcessImage(PImage input, PImage output)
  {
    imageWidth = input.width;
    imageHeight = input.height;
    tonos = filtroq.GetNumberTones();
    int modo = (int)modoDither.getValue();
    
    //Buffer de preprocesamiento
    PImage buffer = createImage(input.width, input.height, RGB);
    //"copia" la imagen original al buffer
    resizeImage(input, buffer, 1, 1);
    
    //Agrega ruido a la imagen si se usa dithering aleatorio
    if(modo == 0)
    {
      addNoise(buffer, buffer);
    }
    //Aplicar blanco/negro
    if(useBN.getBooleanValue())
    {
      filtrobn.ProcessImage(buffer, buffer);
    }
    
    //Aplicar dither aleatorio
    if(modo == 0)
    {
      filtroq.ProcessImage(buffer, output);
    }
    //aplicar dither ordenado
    else if(modo == 1 || modo == 2)
    {
      buffer.loadPixels();
      output.loadPixels();
      for(int y = 0; y < output.height; y++)
      {
        for(int x = 0; x < output.width; x++)
        {
          int location = pixelLocation(x,y, output.width);
          output.pixels[location] = ditherPattern(x,y,location, buffer.pixels);
        }
      }
      output.updatePixels();
    }
    //Aplicar dither por difusion
    else
    {
      buffer.loadPixels();
      output.loadPixels();
      //Aplicar difusión primero
      for(int y = 0; y < output.height; y++)
      {
        for(int x = 0; x < output.width; x++)
        {
          int location = pixelLocation(x,y, buffer.width);
          difusion(x,y,location, buffer.pixels);
        }
      }
      buffer.updatePixels();
      //Alicar cuantizacion
      filtroq.ProcessImage(buffer, output);
    }
  }
  
  //Agrega ruido para el dither al azar
  private void addNoise(PImage input, PImage output)
  {
    float intensidad = 0.01 * intensidadAzar.GetValue();
    
    input.loadPixels();
    output.loadPixels();
    for(int y = 0; y < input.height; y++)
    {
      for(int x = 0; x < input.width; x++)
      {
        int location = pixelLocation(x, y, input.width);
        float d = (randomColor() * (255 / tonos) * intensidad);
        //float d = (randomColor() * (255 / tonos) * intensidad);
        
        float r = red(input.pixels[location]) + d;
        float g = green(input.pixels[location]) + d;
        float b = blue(input.pixels[location]) + d;
        output.pixels[location] = color(r,g,b);
      }
    }
    output.updatePixels();
  }
  //Numero aleatorio entre -1 y 1
  private float randomColor()
  {
    return (random.nextFloat() * 2) - 1; 
  }
  
  //Funcion que devuelve el color de un pixel usando patrones de dither
  private color ditherPattern(int x, int y, int l, int[] input)
  {
    //tamaño del patron (matriz de dither)
    float size = 1;
    //Umbral de valor del dither del pixel correspondiente
    float value = 0;
    
    if(modoDither.getValue() == 1)
    {
      size = 4;
      value = pattern_2_2[y%2][x%2]; 
    }
    else if(modoDither.getValue()==2)
    {
      size = 16;
      value = pattern_4_4[y%4][x%4];
    }
    
    if(useBN.getBooleanValue())
    {
      //float k = ditherPatternColor(grayscale(input[l]), 5, pattern_2_2[my][mx]);
      float k = ditherPatternColor(grayscale(input[l]), size, value);
      return color(k,k,k);
    }
    float rk = ditherPatternColor(red(input[l]), size, value);
    float gk = ditherPatternColor(green(input[l]), size, value);
    float bk = ditherPatternColor(blue(input[l]), size, value);
    
    return color(rk, gk, bk);
  }
  
  //Difusion
  private void difusion(int x, int y, int l, int[] input)
  {
    int modo = (int)modoDither.getValue();
    
    float factor = (255 / (tonos - 1));
    
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    //Error de cuantizacion
    float re = getError(r, factor);
    float ge = getError(g, factor);
    float be = getError(b, factor);
    
    //Ubicacion del pixel al cual propagar el error
    int l2 = l;
    
    //Difusion simple (lineal)
    if(modo == 3)
    {
      if(x + 1 < imageWidth)
      {
        l2 = pixelLocation(x+1, y, imageWidth);
        
        //Sumar error al siguiente pixel
        float r2 = red(input[l2]) + re;
        float g2 = green(input[l2]) + ge;
        float b2 = blue(input[l2]) + be;
        
        input[l2] = color(r2, g2, b2);
      }
    }
    else
    {
      //usar floyd-steinberg por defecto
      float[][] kernel = diffuse_floyd;
      float kernelFactor = 1.0/16;
      
      //Fake floyd-steinberg
      if(modo == 5)
      {
        kernel = diffuse_fake;
        kernelFactor = 1.0/8;  
      }
      //JJ&N
      else if(modo == 6)
      {
        kernel = diffuse_jjn;
        kernelFactor = 1.0/48;
      }
      
      //Aplicar kernel de difusion. Similar a convolucion
      for(int ky = 0; ky < kernel.length; ky++)
      {
        for(int kx = 0; kx < kernel[0].length; kx++)
        {
          int dx = kx - (kernel[0].length / 2);
          //valor de la difusion
          float kv = kernel[ky][kx];
          if(kv == 0)
          {
            continue;
          }
          //Pixel al cual propargar la difusion
          int xx = x + dx;
          int yy = y + ky;
          if(xx < 0 || xx >= imageWidth || yy < 0 || yy >= imageHeight)
          {
            continue;
          }
          l2 = pixelLocation(xx, yy, imageWidth);
          
          //Difundir el error con el valor y el factor
          float r2 = red(input[l2]) + (re * kernelFactor * kv);
          float g2 = green(input[l2]) + (ge * kernelFactor * kv);
          float b2 = blue(input[l2]) + (be * kernelFactor * kv);
          
          input[l2] = color(r2, g2, b2);
        }
      }
    }
    //return color(r,g,b);
  }
  
  //error de un valor y el valor al cual es cuantizado
  private float getError(float v, float factor)
  {
    float quantizedSample = (quantizeValue(v, tonos , 255) * factor);
    //Diferencia entre el valor original y el valor cuantizado
    //(error)
    return v - quantizedSample;
  }
  
  //Obtiene el color que un pixel debería tener en base a su propio color, el tamaño de un patron de dither, y el valor umbral correspondiente del patron
  private float ditherPatternColor(float sampleColor, float ditherPatternSize, float ditherPatternValue)
  {
    float factor = 255 / (tonos - 1);
    float quantizedSample = (quantizeValue(sampleColor, tonos , 255) * factor);
    //Diferencia entre el valor original y el valor cuantizado
    //(error)
    float difference = sampleColor - quantizedSample;
    
    //Determina si usar el valor asignado por la cuantización, o usar el "siguente"/"anterior"
    boolean swap = false;
    
    //Normalizar diferencia
    if(difference <= 0)
    {
      difference += factor;
      swap = true;
    }
    //Cuantizar la diferencia para comparar con el patron
    float diffq = quantizeValue(difference, ditherPatternSize + 1, factor);
    
    //Si el color no pasa el umbral
    if(diffq > ditherPatternValue)
    {
      if(!swap)
      {
        //color "correcto"
        quantizedSample += factor;
      }
      return quantizedSample;
    }
    if(swap)
    {
      //color "correcto"
      quantizedSample -= factor;
    }
    return quantizedSample;
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Dither");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    useBN = new Toggle(p5, "DitherBN");
    SetupToggle(useBN, "Grises", 90);
    useBN.setPosition(140, 10);
    useBN.setGroup(controls);
    
    //Controles BN
    filtrobn.StartControls(p5);
    filtrobn.GetGroup().setGroup(controls);
    filtrobn.GetGroup().setPosition(0,80);
    filtrobn.GetGroup().show();
    
    //Controles Q
    filtroq.StartControls(p5);
    filtroq.GetGroup().setGroup(controls);
    filtroq.GetGroup().setPosition(0,150);
    filtroq.GetGroup().show();
    
    //Slider intensidad dithering al azar
    intensidadAzar = new CustomSliderController(controls, p5, "IntensidadAzarDither"+name, "Intensidad Azar", 210);
    intensidadAzar.SetRange(0, 100);
    intensidadAzar.SetValue(50);
    
    
    //Scroll modo
    //Modos texto
    modoDither = new ScrollableList(p5, "DitherMode");
    modoDither.getCaptionLabel().setText("Modo de Dither");
    modoDither.addItem("Azar", modoDither);
    modoDither.addItem("Ordenado 2x2", modoDither);
    modoDither.addItem("Ordenado 4x4", modoDither);
    modoDither.addItem("Difusión Simple", modoDither);
    modoDither.addItem("Floyd-Steinberg", modoDither);
    modoDither.addItem("Fake Floyd-S.", modoDither);
    modoDither.addItem("JJ&N", modoDither);
    modoDither.setGroup(controls);
    modoDither.setPosition(0, 10);
    modoDither.setBarHeight(30);
    modoDither.setItemHeight(25);
    modoDither.setOpen(false);
    modoDither.setValue(0);
  }
}
