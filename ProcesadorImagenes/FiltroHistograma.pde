/*
*  Muestra el histograma por canal de la imagen original y lo ecualiza (expande el rango
*  de valores por canal para que vayan de 0 a 255).
*  
*
*
*
*/

public class HistogramFilter extends BaseFilter
{
  float mink = 300;
  float maxk = 0;
  
  float rmin = 300;
  float rmax = 0;
  
  float gmin = 300;
  float gmax = 0;
  
  float bmin = 300;
  float bmax = 0;
  
  int maxCount = 0;
  int rmaxCount = 0;
  int gmaxCount = 0;
  int bmaxCount = 0;
  
  int[] values = new int[256];
  
  int[] rvalues = new int[256];
  int[] gvalues = new int[256];
  int[] bvalues = new int[256];
  
  
  
  PGraphics histogram = createGraphics(256,256);
  Group hCanvas;
  
  public HistogramFilter()
  {
    super("Histograma");
  }
  
  public HistogramFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int loc, int[] input)
  {
    float factor = (maxk - mink);
        
    float r = remap(red(input[loc]), rmin, rmax);
    float g = remap(green(input[loc]), gmin, gmax);
    float b = remap(blue(input[loc]), bmin, bmax);
    
    float k = (float)grayscale(input[loc]);
    float nk = k - mink;
    nk = nk / factor;
    nk = nk * 255;
    
    
    return color(r,g,b);
  }
  
  float remap(float value, float min, float max)
  {
    float k = value - min;
    k = k / (max - min);
    k = k * 255;
    
    return k;
  }
  
  public void ProcessImage(PImage input, PImage output)
  { 
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = output.width;
    imageHeight = output.height;
    
    maxCount = 0;
    rmaxCount = 0;
    gmaxCount = 0;
    bmaxCount = 0;
    
    maxk = 0;
    mink = 300;
    
    rmax = 0;
    rmin = 300;
    gmax = 0;
    gmin = 300;
    bmax = 0;
    bmin = 300;
    
    for(int i = 0; i < values.length; i++)
    {
      values[i] = 0;
      rvalues[i] = 0;
      gvalues[i] = 0;
      gvalues[i] = 0;
    }
    
    //Cuenta de valores
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, imageWidth);
        
        float k = (float)grayscale(input.pixels[location]);
        float r = red(input.pixels[location]);
        float g = green(input.pixels[location]);
        float b = blue(input.pixels[location]);
        
        mink = k < mink? k : mink;
        maxk = k > maxk? k : maxk;
        
        rmin = r < rmin? r : rmin;
        rmax = r > rmax? r : rmax;
        
        gmin = g < gmin? g : gmin;
        gmax = g > gmax? g : gmax;
        
        bmin = b < bmin? b : bmin;
        bmax = b > bmax? b : bmax;
        
        values[(int) k]++;
        
        rvalues[(int)r]++;
        gvalues[(int)g]++;
        bvalues[(int)b]++;
        
        maxCount = values[(int) k] > maxCount ? values[(int) k] : maxCount;
        rmaxCount = rvalues[(int) r] > rmaxCount ? rvalues[(int) r] : rmaxCount; 
        gmaxCount = gvalues[(int) g] > gmaxCount ? gvalues[(int) g] : gmaxCount; 
        bmaxCount = bvalues[(int) b] > bmaxCount ? bvalues[(int) b] : bmaxCount; 
      }
    }
    updateHistogram();
    
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, imageWidth);
        output.pixels[location] = pixelProcessing(x,y,location, input.pixels);
      }
    }
    
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Histograma");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    hCanvas = new Group(p5, "HistogramView");
    hCanvas.setGroup(controls);
    hCanvas.addDrawable(new HistoDrawable(histogram));
    hCanvas.setPosition(0, 80);
    hCanvas.setSize(256, 256);
  }
  
  //Dibuja el histograma de la imagen original
  void updateHistogram()
  {
    histogram.beginDraw();
    histogram.loadPixels();
    for(int x = 0; x < histogram.width; x++)
    {
      for(int y = 0; y < histogram.height; y++)
      {
        int location = pixelLocation(x,y, histogram.width);
        //Obtener el valor y normalizar a 255 para que quepa en la imagen
        float k = 255 - (((float)values[x] / (float)maxCount) * 255);
        float r = 255 - (((float)rvalues[x] / (float)rmaxCount) * 255);
        float g = 255 - (((float)gvalues[x] / (float)gmaxCount) * 255);
        float b = 255 - (((float)bvalues[x] / (float)bmaxCount) * 255);
        
        //Color del pixel en base a la cuenta de valores
        r = r < y ? 255 : 0;
        g = g < y ? 255 : 0;
        b = b < y ? 255 : 0;
        
        histogram.pixels[location] = color(r,g,b);
      }
    }
    histogram.updatePixels();
  }
  
  private class HistoDrawable implements CDrawable
  {
    PGraphics histogram;
    
    public HistoDrawable(PGraphics h)
    {
      histogram = h;
      h.beginDraw();
      h.background(255,255,255);
      h.endDraw();
    }
    public void draw(PGraphics histo)
    {
      histo.beginDraw();
      histo.image(histogram, width - 270, 100);
      histo.endDraw();
    }
  }
}
