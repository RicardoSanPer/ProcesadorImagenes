import java.util.HashMap;
import java.util.Map;

/*
*
*  Filtro Oleo
*  Efecto de oleo
*
*
*/
public class OilFilter extends BaseFilter
{
  CustomNumberController kernelSize;
  
  Map<Integer, Integer> frequencies = new HashMap<>(); 
  int size = 6;
  public OilFilter()
  {
    super("Filtro Oleo");
  }
  
  public OilFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    frequencies = new HashMap<>();
    size = (int)kernelSize.GetValue();
    
    //Tomar frecuencias de valores
    for(int i = 0; i < size; i++)
    {
      int dy = y + (i - (size / 2));
      if(dy < 0 || dy >= imageHeight)
      {
        continue;
      }
      for(int j = 0; j < size; j++)
      {
        int dx = x + (j - (size / 2));
        //Continuar si se sale de la imagen
        if(dx < 0 || dx >= imageWidth)
        {
          continue;
        }
        
        
        //Usar kernel circular
        //Comentar de aqui
        int cx = dx - x;
        int cy = dy - y;
        float distance = sqrt((cx * cx) + (cy * cy));
        if(distance > size/2)
        {
          continue;
        }
        //a aqui para usar el kernel cuadrado
        
        int loc = pixelLocation(dx,dy,imageWidth);
        int k = (int) grayscale(input[loc]);
        //Agregar frecuencia
        if(frequencies.containsKey(k))
        {
          int v = frequencies.get(k);
          frequencies.put(k, v+1);
        }
        else
        {
          frequencies.put(k, 1);
        }
      }
    }
    
    int h = 0;
    int kv = 0;
    
    //Obtener el valor con mayor frecuencia
    for(Map.Entry<Integer, Integer> entry : frequencies.entrySet())
    {
      if(entry.getValue() > h)
      {
        h = entry.getValue();
        kv = entry.getKey();
      }
    }
    
    return color(kv,kv,kv);
  }

  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Oleo");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "OilKernelSize" + name, "Tamaño Kernel", 20);
    kernelSize.SetValue(3); 
  }
}
/*
*
*
*  Filtro AT&T
*  Convierte una imagen a señales
*
*/
public class ATTFilter extends BaseFilter
{
  CustomNumberController kernelSize;
  PImage colorBuffer;
  int nsignals;
  int signalResolution = 30;
  public ATTFilter()
  {
    super("Filtro AT&T");
    colorBuffer = createImage(32,32,RGB);
  }
  
  public ATTFilter(String n)
  {
    super(n);
    colorBuffer = createImage(32,32,RGB);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input) 
  {
    
    return color(0,0,0);
  }
  
  public void ProcessImage(PImage input, PImage output)
  {
    nsignals = (int)kernelSize.GetValue();
    signalResolution = input.height / nsignals;
    
    //Crear buffer de color
    resizeImage(input, colorBuffer, 1, signalResolution);
    
    //Cambiar a tamaño de salida apropiado
    output.resize(colorBuffer.width, colorBuffer.height * signalResolution);
    imageWidth = output.width;
    imageHeight = output.height;
    
    colorBuffer.loadPixels();
    output.loadPixels();
    
    for(int y = 0; y < imageHeight; y++)
    {
      //mosaico de señal actual
      int nsig = y / signalResolution;
      
      //Valor de frecuencia
      float signalk =((float)(y % signalResolution) / signalResolution);
      
      //Normalizar
      signalk = abs((signalk - 0.5) * 2);
       
      for(int x = 0; x < imageWidth; x++)
      {
        int loc = pixelLocation(x,y,imageWidth);
        
        //Valor del pixel para la señal
        int colorLoc = pixelLocation(x, nsig, colorBuffer.width);
        float c = grayscale(colorBuffer.pixels[colorLoc])/255;
        
        c = 1 - c;
        
        //Colorear
        if(signalk > c)
        {
          output.pixels[loc] = color(255,255,255);
        }
        else
        {
          output.pixels[loc] = color(0,0,0);
        }
        //output.pixels[loc] = color(c,c,c); //color(signalk * 255, 0,0);  
      }
    }
    
    output.updatePixels();
  }
 
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de AT&T");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "ATTFrequency" + name, "Numero Señales", 20);
    kernelSize.SetValue(15); 
  }
}

/*
*
*  Filtro Semitonos (Circulos)
*
*
*/

public class MaskFilter extends BaseFilter
{
  PImage circle;
  PGraphics star;
  PImage colorBuffer;
  
  //Indica el tamaño en pixeles del circulo en la imagen final
  CustomNumberController kernelSize;
  //Indica el numero de pixeles que cada circulo cubre en la imagen original
  CustomNumberController cellSize;
  //Idica si usar estrella o circulo
  Toggle useStar;
  
  public MaskFilter()
  {
    super("Mascaras");
    circle = createImage(32,32,RGB);
    colorBuffer = createImage(16,16,RGB);
    star = createGraphics(40,40);
  }
  
  public MaskFilter(String n)
  {
    super(n);
    circle = createImage(32,32,RGB);
    colorBuffer = createImage(16,16,RGB);
    star = createGraphics(40,40);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    int lx = x % star.height;
    int ly = y % star.height;
    int loc = pixelLocation(lx, ly, star.width);
    
    float k = 0;
    if(useStar.getBooleanValue())
    {
      k = red(star.pixels[loc]);
    }
    else
    {
      k = red(circle.pixels[loc]);
    }
    if(k < 1)
    {
      return color(255,255,255);
    }
    
    int lc = pixelLocation((int)(x / star.height), (int)(y / star.height), colorBuffer.width);
    
    
    
    return colorBuffer.pixels[lc];
  }
  
    
  public void ProcessImage(PImage input, PImage output)
  {
    int cSize = (int) cellSize.GetValue();
    
    //Crear circulo del tamaño adecuado
    createCircle();
    createStar();
    //Crear buffer de color
    resizeImage(input, colorBuffer, cSize, cSize);
    //filtroq.ProcessImage(circle, circle);
    //Cambiar tamaño de salida a color apropiado
    output.resize(colorBuffer.width * circle.height, colorBuffer.height * circle.height);
    
    colorBuffer.loadPixels();
    output.loadPixels();
    circle.loadPixels();
    
    int location = 0;
    imageWidth = output.width;
    imageHeight = output.height;
    
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, output.width);
        output.pixels[location] = pixelProcessing(x, y, location, output.pixels);
      }
    }
    
    output.updatePixels();
  }
  
  
  //Crear ek circulo
  private void createCircle()
  {
    
    circle.resize((int)kernelSize.GetValue(),(int)kernelSize.GetValue());
    circle.loadPixels();
    float radius = circle.height / 2;
    for(int y = 0; y < circle.height; y++)
    {
      float dy = y - radius;
      for(int x = 0; x < circle.width; x++)
      {
        float dx = x - radius;
        float k =(1 - (sqrt(dx * dx + dy * dy) / radius));// / sqrt(2 * (radius * radius)));
        k *= 255;
        int l = pixelLocation(x,y,circle.width);
        
        circle.pixels[l] = color(k,k,k);
      }
    }
    circle.updatePixels();
  }
  
  //Crea la estrella a usar como mascara
  private void createStar()
  {
    int size = (int)kernelSize.GetValue();
    int c = size / 2;
    star = createGraphics(size, size);
    //star.background(255,255,255);
    star.beginDraw();
    float angle = (TWO_PI / 5);
    float halfAngle = angle/2.0;
    star.beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = c + cos(a) * (size / 2);
      float sy = c + sin(a) * (size / 2);
      star.vertex(sx, sy);
      sx = c + cos(a+halfAngle) * (size / 4);
      sy = c + sin(a+halfAngle) * (size / 4);
      star.vertex(sx, sy);
    }
    star.endShape(CLOSE);
    star.endDraw();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Semitonos");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "MaskCircleRad" + name, "Resolución Mascara", 20);
    kernelSize.SetValue(25); 
    
    cellSize = new CustomNumberController(controls, p5, "MaskCellSize" + name, "Tamaño Celda", 60);
    cellSize.SetValue(5);
    
    useStar = new Toggle(p5, "MaskUseStarToggle");
    useStar.setPosition(0, 100);
    useStar.getCaptionLabel().setText("Estrellas");
    useStar.setGroup(controls);
  }
  
}
