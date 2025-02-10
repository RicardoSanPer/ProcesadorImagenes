public class SopaLetrasFilter extends BaseFilter
{
  Button save;
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
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = input.width;
    imageHeight = input.height;
    
    outputHTML = "<!DOCTYPE html><body>";
    for(int y = 0; y < imageHeight; y++)
    {
      String line = "";
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y);
        //Por alguna razon es mas rápido hacer la construccion del texto aqui
        //en vez de en pixelProcessing
        
        line += "<span style=\"color:#" + hex(input.pixels[location], 6)+"\">M</span>";
        //output.pixels[location] = pixelProcessing(x, y, location, input.pixels);
      }
      outputHTML += line + "<br>";
      println((float)y / imageHeight);
    }
    outputHTML += "</body></HTML>";
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Letras");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    save = new Button(p5, "GuardarSopa");
    save.getCaptionLabel().setText("Guardar HTML");
    save.setSize(100, 20);
    save.setPosition(0,20);
    save.setGroup(controls);
    save.onRelease(event -> guardarHTML());
    
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
