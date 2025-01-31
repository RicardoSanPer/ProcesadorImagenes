import java.util.Random;

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
  protected void setupControls(ControlP5 cp5)
  {
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
  
  protected void setupControls(ControlP5 cp5)
  {
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
  
  protected void setupControls(ControlP5 cp5)
  {
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
  
  private float quantize(float c)
  {
     if(useDithering.getBooleanValue())
     {
       c = c + ((float)rand.nextDouble() - 0.5) * ditherRandom.GetValue();
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
