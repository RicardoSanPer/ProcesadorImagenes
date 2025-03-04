
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
  
  //Determina si aplicar valores aleatorios por canal o a los tres por igual
  Boolean singleChannelRandom = false;
  
  public QuantizeFilter()
  {
    super("Cuantizacion");
    rand = new Random();
  }
  
  public QuantizeFilter(String n)
  {
    super(n);
    rand = new Random();
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    //Si se aplica el randomizador a los tres canales (como cuando la imagen esta a blanco y negro)
    //Actualmente usado por el filtro de sopa de letras
    if(useDithering.getBooleanValue() && singleChannelRandom)
    {
      float c = ((float)rand.nextDouble() - 0.5) * 2 * ditherRandom.GetValue();
      r += c;
      g += c;
      b += c;
    }
   
    return color(quantize(r), quantize(g), quantize(b));
  }
  
  /** Cuantiza el valor de un pixel
  * @param c valor de un canal
  * @return valor cuantizado
  */
  private float quantize(float c)
  {
    //Si se usa dithering varia aleatoriamente el valor de entrada en base a la cantidad de aleatoreidad
     if(!singleChannelRandom && useDithering.getBooleanValue())
     {
       c = c + ((float)rand.nextDouble() - 0.5) * 2 * ditherRandom.GetValue();
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
    slider = new CustomSliderController(controls, p5, "Tones" + name, "Tonos por Canal", 20);
    slider.SetRange(2, 256);
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
  
  //Cambiar el tipo de aleatoreidad, si usar un solo valor para los
  //tres canales (brillo) o para cada uno individual
  public void SetSingleChannelRandom(boolean v)
  {
    singleChannelRandom = v;
  }
}
