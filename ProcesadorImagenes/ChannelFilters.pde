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
  protected void setupControls()
  {
    controls.setSize(100,300);
    controls.setPosition(100,100);
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
  
  protected void setupControls()
  {
    controls.setSize(100,300);
    controls.setPosition(100,100);
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
  
  protected void setupControls()
  {
    controls.setSize(100,300);
    controls.setPosition(100,100);
  }
}
