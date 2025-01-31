/*
*  Filtro monocromatico
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
*  dependiendo de un valor umbral (por defecto 128)
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
