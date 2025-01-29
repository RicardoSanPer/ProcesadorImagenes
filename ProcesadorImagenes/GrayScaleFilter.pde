public class GrayScaleFilter extends BaseFilter
{
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float r = red(input[l]);
    float g = green(input[l]);
    float b = blue(input[l]);
    
    return color(r,r,r);
  }
}
