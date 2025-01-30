/*
*  Filtro monocromatico
*/  

public class GrayScaleFilter extends BaseFilter
{
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
    
    float k = r * 0.2126 + g * 0.7152 + b * 0.0722;
    return color(k,k,k);
  }
  
  protected void setupControls(ControlP5 cp5)
  {
  }
}

public class BinarizationFilter extends BaseFilter
{
  Slider slider;
  Button plus;
  Button minus;
  
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
    k = k > slider.getValue() ? 255 : 0;
    return color(k,k,k);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Binarizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 230, 30);
    
    //Slider
    slider = new Slider(p5, "Rango");
    slider.setLabel("");
    slider.setSize(160, 15);
    slider.setPosition(20, 10);
    
    slider.setRange(0,255);
    slider.setValue(128);
    slider.setSliderMode(0);
    
    slider.setScrollSensitivity(0);
    
    slider.onRelease(event -> updateSlider());
    slider.onReleaseOutside(event -> updateSlider());
    
    
    slider.setGroup(controls);
    
    plus = new Button(p5, "Addition");
    plus.setLabel("+");
    plus.setSize(15,15);
    plus.setPosition(190,10);
    plus.setGroup(controls);
    plus.onRelease(event -> addValue());
    
    minus = new Button(p5, "minus");
    minus.setLabel("-");
    minus.setSize(15,15);
    minus.setPosition(0,10);
    minus.setGroup(controls);
    minus.onRelease(event -> minusValue());
  }
  
  //Actualiza el slider para tener un valor entero
  private void updateSlider()
  {
    slider.setValue((float)Math.floor(slider.getValue()));
  }
  
  private void addValue()
  {
    slider.setValue(slider.getValue()+1);
    updateSlider();
  }
  
  private void minusValue()
  {
    slider.setValue(slider.getValue()-1);
    updateSlider();
  }
}
