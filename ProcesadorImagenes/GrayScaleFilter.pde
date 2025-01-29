public class GrayScaleFilter extends BaseFilter
{
  public GrayScaleFilter()
  {
    name = "Escala de Grises";
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
}
