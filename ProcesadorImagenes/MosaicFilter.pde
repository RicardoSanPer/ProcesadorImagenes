public class MosaicFilter extends BaseFilter
{
  CustomNumberController kernelX;
  CustomNumberController kernelY;
  
  public MosaicFilter()
  {
    super("Mosaico");
  }
  
  public MosaicFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    int startx = (int) (x - (x % kernelX.GetValue()));
    int starty = (int) (y - (y % kernelY.GetValue()));
    
    float count = 0;
    float r = 0;
    float g = 0;
    float b = 0;
    
    for(int i = startx; i < startx + kernelX.GetValue(); i++)
    {
      for(int j = starty; j < starty + kernelY.GetValue(); j++)
      {
        int location = pixelLocation(i, j);
        if(location < input.length)
        {
          int col = input[pixelLocation(i, j)];
          
          r += red(col);
          g += green(col);
          b += blue(col);
          
          count++;
        }
      }
    }
    
    return color(r / count, g / count, b / count);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Niveles");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelX = new CustomNumberController(controls, p5, "KernelX" + name, "Tamaño x", 20);
    kernelY = new CustomNumberController(controls, p5, "KernelY" + name, "Tamaño Y", 60);
    
    kernelX.SetValue(4);
    kernelY.SetValue(4);
  }
  
}
