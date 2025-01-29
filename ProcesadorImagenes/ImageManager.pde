public class ImageManager
{
  PImage base;
  PImage processed;
  
  public ImageManager()
  {
    base = loadImage("../sample.jpg");
    processed = loadImage("../sample.jpg");
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
