import java.util.HashMap;
import java.util.Map;

public class OilFilter extends BaseFilter
{
  Map<Integer, Integer> frequencies = new HashMap<>(); 
  int size = 6;
  public OilFilter()
  {
    super("Filtro Oleo");
  }
  
  public OilFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    frequencies = new HashMap<>();
    
    //Tomar frecuencias de valores
    for(int i = 0; i < size; i++)
    {
      int dy = y + (i - (size / 2));
      if(dy < 0 || dy >= imageHeight)
      {
        continue;
      }
      for(int j = 0; j < size; j++)
      {
        int dx = x + (j - (size / 2));
        
        if(dx < 0 || dx >= imageWidth)
        {
          continue;
        }
        
        int loc = pixelLocation(dx,dy,imageWidth);
        int k = (int) grayscale(input[loc]);
        if(frequencies.containsKey(k))
        {
          int v = frequencies.get(k);
          frequencies.put(k, v+1);
        }
        else
        {
          frequencies.put(k, 1);
        }
      }
    }
    
    int h = 0;
    int kv = 0;
    
    //Obtener el valor con mayor frecuencia
    for(Map.Entry<Integer, Integer> entry : frequencies.entrySet())
    {
      if(entry.getValue() > h)
      {
        h = entry.getValue();
        kv = entry.getKey();
      }
    }
    
    return color(kv,kv,kv);
  }
  
}
