public class ImageProcessor
{
  PImage base;
  PImage processed;
  
  BaseFilter currentFilter;
  
  public ImageProcessor()
  {
    base = loadImage("../sample.jpg");
    processed = loadImage("../sample.jpg");
    currentFilter = new GrayScaleFilter();
  }
  
  public void DrawImages()
  {
    if(base != null)
    {
      image(base, 10, 60, (width - base.width) * 0.5, (height - base.height) * 0.5);
    }
    if(processed != null)
    {
      image(processed, ((width - base.width)/2) + 10, 60, (width - processed.width) * 0.5, (height - processed.height) * 0.5);
    }
  }
  
  public void Apply()
  {
    currentFilter.ProcessImage(base, processed);
  }
  
  ///// GETTERS
  
  public PImage GetBaseImage()
  {
    return base;
  }
  
  public PImage GetProcessedImage()
  {
    return processed;
  }
  
  public void LoadImage(String path)
  {
    base = loadImage(path);
    processed = loadImage(path);
  }
  
  public void SaveProcessed(String path)
  {
    processed.save(path);
  }
}
