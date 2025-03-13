public class SolarFilter extends BaseFilter
{
  CustomSliderController slider;
  
  public SolarFilter()
  {
    super("Filtro Solar");
  }
  public SolarFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float umbral = slider.GetValue();
    float k = grayscale(input[l]);
    k -= umbral;
    if(k < 0)
    {
      k = abs(k) * (255 / umbral);
    }
    else
    {
      k = abs(k) * (255 / (255- umbral));
    }
    
    return color(k,k,k);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Solarizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    slider = new CustomSliderController(controls, p5, "TresholdSolar"+name, "Umbral", 20);
    slider.SetRange(0, 255);
    slider.SetValue(128);
  }
}
