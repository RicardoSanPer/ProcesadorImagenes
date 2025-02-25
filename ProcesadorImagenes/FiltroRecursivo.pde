/*
*  Filtro recursivo.
*  Toma la imagen original y crea dos buffers:
*  1) Buffer de color. Efectivamente la imagen "original" que contiene los colores que cada imagen recursiva usará
*  2) Buffer de valor. Efectivemente la imagen recursiva. A blanco y negro para obtener mejores colores
*  
*  Posteriormente crea una imagen de salida cuyas dimensiones se obitenen multiplicando las dimensiones del buffer de
*  color y el buffer de valor.
*  
*  Iterando sobre cada pixel de la imagen de salida, toma como muestra el color del buffer de color que le corresponde
*  (color del pixel de la imagen "original" correspondiente) y el valor del buffer de valor (pixel de la imagen recursiva que le corresponde)
*  y los multiplica para obtener el color resultante. Puesto que es una multiplicación la imagen resultante puede verse mas
*  oscura que la oriinal.
*
*/

public class RecursiveFilter extends BaseFilter
{
  //Tamaño de letra. 1 = 1 letra por pixel
  CustomNumberController kernelSize;
  CustomNumberController subimgSize;
  //Toggles
  Toggle useQ;
  Toggle useBN;
  
  //Filtros
  GrayScaleFilter filtrobn;
  QuantizeFilter filtroq;
  
  PImage valueBuffer;
  PImage colorBuffer;
  
  public RecursiveFilter()
  {
    super("Recursivo");
    filtrobn = new GrayScaleFilter("FiltroRecBN");
    filtroq = new QuantizeFilter("FiltroRecQ");
    colorBuffer = createImage(50,50, RGB);
    valueBuffer = createImage(50,50,RGB);
  }
  
  public RecursiveFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int loc, int[] pix)
  {
    
    return color(0,0,0);
  }
  
  
  
  public void ProcessImage(PImage input, PImage output)
  {
    int ksize = (int)kernelSize.GetValue();
    int subsize = (int)subimgSize.GetValue();
    
    //Cambiar el tamaño del bufer de color por cuestiones de rendimiento. Basicamente divide las dmiensiones de la imagen
    resizeImage(input, colorBuffer, ksize, ksize);
    
    //Cambiar el tamaño de la imagen recursiva. Basicamente divide el tamaño de la imagen
    resizeImage(input, valueBuffer, subsize, subsize);
    
    //Cambiar tamaño de imagen de salida
    output.resize(colorBuffer.width * valueBuffer.height, colorBuffer.height * valueBuffer.height);
    
    //El buffer de valor se convierte a blanco y negro
    filtrobn.ProcessImage(valueBuffer, valueBuffer);
    
    //Procesar filtros
    if(useBN.getBooleanValue())
    {
      filtrobn.ProcessImage(colorBuffer, colorBuffer);
    }
    if(useQ.getBooleanValue())
    {
      //Realizar dithering en los tres canales con el mismo valor cuando es imagen a blanco y negro
      filtroq.SetSingleChannelRandom(useBN.getBooleanValue());
      filtroq.ProcessImage(colorBuffer, colorBuffer);
      filtroq.ProcessImage(valueBuffer, valueBuffer);
    }
    
    output.loadPixels();
    colorBuffer.loadPixels();
    valueBuffer.loadPixels();
    
    for(int y = 0; y < output.height; y++)
    {
      int vy = y % valueBuffer.height;
      int cy = y / valueBuffer.height;
      
      for(int x = 0; x < output.width; x++)
      {
          int vx = x % valueBuffer.width;
          int cx = x / valueBuffer.height;
          
          //Pixel del buffer de valor a samplear
          int vl = pixelLocation(vx, vy, valueBuffer.width);
          //PIxel del buffer de color a samplear
          int cl = pixelLocation(cx, cy, colorBuffer.width);
          
          int location = pixelLocation(x,y, output.width);
          
          //valor
          float value = red(valueBuffer.pixels[vl]) / 255;
          
          //Color
          float r = red(colorBuffer.pixels[cl]) * value;
          float g = green(colorBuffer.pixels[cl]) * value;
          float b = blue(colorBuffer.pixels[cl]) * value;
          
          output.pixels[location] = color(r,g,b); 
      }
    }
    
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Letras");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "KernelRecSize" + name, "Tamaño Mosaico (Imagen Original)", 20);
    kernelSize.SetValue(5);
    
    subimgSize = new CustomNumberController(controls, p5, "KernelRecImgSize" + name, "Tamaño Mosaico (Imagen Recursiva)", 60);
    subimgSize.SetValue(5);
    
    //Usar blanco y negro
    useBN = new Toggle(p5, "RecursiveBN");
    SetupToggle(useBN, "Grises", 90);
    useBN.setPosition(0, 90);
    useBN.setGroup(controls);
    
    //Usar cuantizacion
    useQ = new Toggle(p5, "RecursiveQ");
    SetupToggle(useQ, "Cuantizacion", 120);
    useQ.setPosition(0, 120);
    useQ.setGroup(controls);
    
    //Controles blanco y negro
    filtrobn.StartControls(p5);
    filtrobn.GetGroup().setGroup(controls);
    filtrobn.GetGroup().setPosition(0,180);
    filtrobn.GetGroup().show();
    
    //Controles cuantizacion
    filtroq.StartControls(p5);
    filtroq.GetGroup().setGroup(controls);
    filtroq.GetGroup().setPosition(0, 240);
    filtroq.GetGroup().show();
    
  }
  
}
