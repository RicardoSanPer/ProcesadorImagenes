public class SopaLetrasFilter extends BaseFilter
{
  Button save;
  //Tamaño de letra. 1 = 1 letra por pixel
  CustomNumberController kernelSize;
  
  String outputHTML;
  
  public SopaLetrasFilter()
  {
    super("Sopa de Letras");
  }
  
  public SopaLetrasFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int location, int[] input)
  {
    outputHTML += "<span style=\"color:#" + hex(input[location], 6)+"\">M</span>";
    return color(0,0,0);
  }
  
   public void ProcessImage(PImage input, PImage output)
  {
    //Cambiar el tamaño de la imagen de salida (previsualizacion) por cuestiones de rendimiento
    //El tamaño se calcula en base al tamaño del texto relativo a la imagen
    resizeImage(input, output); 
    
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = input.width;
    imageHeight = input.height;
    
    outputHTML = "<!DOCTYPE html><body>";
    for(int y = 0; y < output.height; y++)
    {
      String line = "";
      for(int x = 0; x < output.width; x++)
      {
        location = pixelLocation(x, y, output.width);
        //Por alguna razon es mas rápido hacer la construccion del texto aqui
        //en vez de en pixelProcessing
        if(location < output.pixels.length)
        {
          line += "<span style=\"color:#" + hex(output.pixels[location], 6)+"\">@</span>";
        }
        //output.pixels[location] = pixelProcessing(x, y, location, input.pixels);
      }
      outputHTML += line + "<br>";
      //println((float)y / imageHeight);
    }
    outputHTML += "</body></HTML>";
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Letras");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "KernelSoupSize" + name, "Tamaño Letra", 20);
    kernelSize.SetValue(5);
    
    save = new Button(p5, "GuardarSopa");
    save.getCaptionLabel().setText("Guardar HTML");
    save.setSize(100, 20);
    save.setPosition(0,40);
    save.setGroup(controls);
    save.onRelease(event -> guardarHTML());
    
  }
  
  /**
  *  Redimensiona la entrada en la salida. Igual al mosaico
  *
  *  @param input imagen a re
  *  @param output buffer de salida
  */
  private void resizeImage(PImage input, PImage output)
  {
    input.loadPixels();
    output.loadPixels();
    //Tamaño del kernel en pixeles
    float sizex = kernelSize.GetValue();
    float sizey = kernelSize.GetValue();
    
    //Numero de segmentos/mosaicos en los que se divide la imagen
    int nsegments = (int)(input.width / sizex);
    int msegments = (int)(input.height / sizey);
    
    output.resize(nsegments+1, msegments+1);
    
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
  
  private void guardarHTML()
  {
    saveStrings("sopa_letras.html", new String[] {outputHTML});
  }
  
  public void validateOutputText(File output)
  {
    if(output == null)
    {
      println("No se eligio ningun archivo de salida");
      return;
    }
    
    String path = output.getAbsolutePath();
    
  }
}
