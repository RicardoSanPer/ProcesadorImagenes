public class RedFilter extends BaseFilter
{
  public RedFilter()
  {
    name = "Escala de Rojos";
  }
  public RedFilter(String n)
  {
    super(n);
  }
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(red(input[l]), 0, 0);
  }
}

public class GreenFilter extends BaseFilter
{
  public GreenFilter()
  {
    name = "Escala de Verdes";
  }
  public GreenFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(0, green(input[l]), 0);
  }
}

public class BlueFilter extends BaseFilter
{
  public BlueFilter()
  {
    name = "Escala de Grises";
  }
  
  public BlueFilter(String n)
  {
    super(n);
  }
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    return color(0, 0, blue(input[l]));
  }
}
