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
    controls.setLabel("Controles de Niveles");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    slider = new CustomSliderController(controls, p5, "Brightness", 10);
    slider.SetRange(-255, 255);
    slider.SetValue(0);
  }
}

/**
*
*  Filtro de niveñes
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
    
    r += rojo.GetValue();
    r = r < 0 ? 0 : r > 255? 255 : r;
    
    g += verde.GetValue();
    g = g < 0 ? 0 : g > 255? 255 : g;
    
    b += azul.GetValue();
    b = b < 0 ? 0 : b > 255? 255 : b;
    return color(r,g,b);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Brillo");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    rojo = new CustomSliderController(controls, p5, "RLevel", 10);
    rojo.SetRange(-255, 255);
    rojo.SetValue(0);
    rojo.SetColor(color(128,0,0));
    
    verde = new CustomSliderController(controls, p5, "GLevel", 30);
    verde.SetRange(-255, 255);
    verde.SetValue(0);
    verde.SetColor(color(0,128,0));
    
    azul = new CustomSliderController(controls, p5, "BLevel", 50);
    azul.SetRange(-255, 255);
    azul.SetValue(0);
    azul.SetColor(color(0,0,218));
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
    super("Invertir");
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
  
  protected void setupControls(ControlP5 p5){}
}
