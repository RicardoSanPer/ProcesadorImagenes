/*
*
*  Filtro de solarizacion
*
*
*/

public class SolarFilter extends BaseFilter
{
  CustomSliderController slider;
  
  
  QuantizeFilter filtroq;
  
  public SolarFilter()
  {
    super("Filtro Solar");
  }
  public SolarFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    float umbral = slider.GetValue();
    float r = evaluateColor(red(input[l]), umbral);
    float g = evaluateColor(green(input[l]), umbral);
    float b = evaluateColor(blue(input[l]), umbral);
    
    return color(r,g,b);
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Solarizacion");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    slider = new CustomSliderController(controls, p5, "TresholdSolar"+name, "Umbral", 20);
    slider.SetRange(0, 255);
    slider.SetValue(128);
  }
  
  private float evaluateColor(float k, float umbral)
  {
    k -= umbral;
    
    //Normalizar los tonos
    if(k < 0)
    {
      k = abs(k) * (255 / umbral);
    }
    else
    {
      k = abs(k) * (255 / (255- umbral));
    }
    return k;
  }
}

/*
*
*  Filtro Semitonos (Circulos)
*
*
*/

public class SemiCirclesFilter extends BaseFilter
{
  PImage circle;
  PImage colorBuffer;
  
  //Indica el tamaño en pixeles del circulo en la imagen final
  CustomNumberController kernelSize;
  //Indica el numero de pixeles que cada circulo cubre en la imagen original
  CustomNumberController cellSize;
  //Tipo de semitono
  ScrollableList modo;
  
  float[][] kernel3_3 = {{6, 8, 4},
                         {1, 0, 3},
                         {5, 2, 7}};
  float[][] kernel2_2 = {{0,2},
                        {3,1}};
  
  QuantizeFilter filtroq;
  
  public SemiCirclesFilter()
  {
    super("Semitonos Circular");
    circle = createImage(32,32,RGB);
    colorBuffer = createImage(16,16,RGB);
    filtroq = new QuantizeFilter("FiltroQSemiCircle");
  }
  
  public SemiCirclesFilter(String n)
  {
    super(n);
    circle = createImage(32,32,RGB);
    colorBuffer = createImage(16,16,RGB);
    filtroq = new QuantizeFilter("FiltroQSemiCircle"+n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    int lx = x % circle.height;
    int ly = y % circle.height;
    
    int lc = pixelLocation((int)(x / circle.height), (int)(y / circle.height), colorBuffer.width);
    
    int loc = pixelLocation(lx, ly, circle.width);
    float k = grayscale(colorBuffer.pixels[lc]);
    float v = red(circle.pixels[loc]);
    
    if(modo.getValue() == 0)
    {
      if(k < v)
      {
        return color(0,0,0);
      }
      return color(255,255,255);
    }
    int kx = x / circle.height;
    int ky = y / circle.height;
    
    float kv = quantizeValue(k, 10, 255);
    float sample = kernel3_3[ky%3][kx%3];
    
    //Ajustar valores si se usa el semitono de circulos en patron de 2x2
    if(modo.getValue() == 1)
    {
      sample = kernel2_2[ky%2][kx%2];
      kv = floor(kv / 2);
    }
    if(kv <= sample && v > 0)
    {
      return color(0,0,0);
    }
    return color(255,255,255);
    
  }
  
  //Crear ek circulo
  private void createCircle()
  {
    
    circle.resize((int)kernelSize.GetValue(),(int)kernelSize.GetValue());
    circle.loadPixels();
    float radius = circle.height / 2;
    for(int y = 0; y < circle.height; y++)
    {
      float dy = y - radius;
      for(int x = 0; x < circle.width; x++)
      {
        float dx = x - radius;
        float k =(1 - (sqrt(dx * dx + dy * dy) / radius));// / sqrt(2 * (radius * radius)));
        k *= 255;
        int l = pixelLocation(x,y,circle.width);
        
        circle.pixels[l] = color(k,k,k);
      }
    }
    circle.updatePixels();
  }
    
  public void ProcessImage(PImage input, PImage output)
  {
    int cSize = (int) cellSize.GetValue();
    
    //Crear circulo del tamaño adecuado
    createCircle();
    //Crear buffer de color
    resizeImage(input, colorBuffer, cSize, cSize);
    if(modo.getValue() == 0)
    {
      filtroq.ProcessImage(colorBuffer, colorBuffer);
    }
    //filtroq.ProcessImage(circle, circle);
    //Cambiar tamaño de salida a color apropiado
    output.resize(colorBuffer.width * circle.height, colorBuffer.height * circle.height);
    
    colorBuffer.loadPixels();
    output.loadPixels();
    circle.loadPixels();
    
    int location = 0;
    imageWidth = output.width;
    imageHeight = output.height;
    
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, output.width);
        output.pixels[location] = pixelProcessing(x, y, location, output.pixels);
      }
    }
    
    output.updatePixels();
  }
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Semitonos");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "SemiCircleRad" + name, "Tamaño Circulo", 20);
    kernelSize.SetValue(25); 
    
    cellSize = new CustomNumberController(controls, p5, "SemiCellSize" + name, "Tamaño Celda", 60);
    cellSize.SetValue(5); 
    
    //Controles Q
    filtroq.StartControls(p5);
    filtroq.GetGroup().setGroup(controls);
    filtroq.GetGroup().setPosition(0,120);
    filtroq.GetGroup().show();
    filtroq.SetNumberTones(16);
    
    modo = new ScrollableList(p5, "SemiCircleTonesMode");
    modo.getCaptionLabel().setText("Modo");
    modo.setPosition(140, 20);
    modo.setWidth(80);
    modo.setBarHeight(20);
    modo.addItem("Circulos",modo);
    modo.addItem("Circulos 2x2",modo);
    modo.addItem("Circulos 3x3",modo);
    modo.setValue(0);
    modo.setGroup(controls);
    modo.setItemHeight(20);
    modo.close();
  }
  
}


/*
*  Filtro de dados
*  
*  Filtro de dados con 0 a 6 puntos. Utiliza calculos de iluminación básica.
*  Se pueden elegir colores para las caras y los puntos de los dados.
*
*
*  Mascaras y mapas de normales creados con substance designer
*
*
*/

/**
*TODO:
  - GUI para elegir colores
  - GUI para mover luz
*/
public class DiceFilter extends BaseFilter
{
  CustomNumberController cellSize;
  Toggle invert;
  Knob directionKnob;
  Knob heightKnob;
  CustomSliderController intensidadLuz;
  CustomSliderController suavidad;
  CustomSliderController intensidadBrillo;
  ColorWheel colorpicker1;
  ColorWheel colorpicker2;
  
  //Color de los puntos
  int color1 = color(255,255,255);
  //Color de la cara
  int color2 = color(0,0,0);
  
  //Mascaras
  float colormask1 = 255;
  float colormask2 = 124;
  
  //Posicion de la "luz"
  PVector lightPos = new PVector(1,1,1);
  //Posicion de la "camara"
  PVector viewPos = new PVector(0,0,1);
  
  //Bufer de color
  PImage colorBuffer = createImage(32,32,RGB);
  //Mascara de colores. Diferencia los dados del fondo
  PImage colorMask = loadImage("../dados/mask.png");
  
  //Mascaras de colores para diferenciar los dos colores distintos del dado.
  //Se asume (255,255,255) para el color 1 y (124,124,124) para el color 2
  PImage[] colorImage = new PImage[]
  {
    loadImage("../dados/c0.png"),
    loadImage("../dados/c1.png"),
    loadImage("../dados/c2.png"),
    loadImage("../dados/c3.png"),
    loadImage("../dados/c4.png"),
    loadImage("../dados/c5.png"),
    loadImage("../dados/c6.png"),
  };
  
  //Mapas de normales
  PImage[] normalImage = new PImage[]
  {
    loadImage("../dados/n0.png"),
    loadImage("../dados/n1.png"),
    loadImage("../dados/n2.png"),
    loadImage("../dados/n3.png"),
    loadImage("../dados/n4.png"),
    loadImage("../dados/n5.png"),
    loadImage("../dados/n6.png"),
  };
  public DiceFilter()
  {
    super("Filtro Dados");
  }
  public DiceFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int l, int[] input)
  {
    //Posicion del pixel correspondiente en el buffer de color
    int cx = x / 64;
    int cy = y / 64;
    int lc = pixelLocation(cx, cy, colorBuffer.width);
    
    //Cuantizar para determina cual dado usar
    float k = grayscale(colorBuffer.pixels[lc]);
    
    //Invertir color
    if(invert.getBooleanValue())
    {
      k = 255-k;
    }
    
    int i = (int)quantizeValue(k, 7, 255);
    
    //Posicion del pixel correspondiente en el dado
    int dx = x % colorImage[i].width;
    int dy = y % colorImage[i].height;
    int loc = pixelLocation(dx, dy, colorImage[i].width);
    
    //Primero determinar si se descarta el pixel
    float mask = red(colorMask.pixels[loc]) / 255;
    if(mask < 1)
    {
      return color(0,0,0);
    }
    
    //Valor t para interpolar entre las dos mascaras de color
    float colort = red(colorImage[i].pixels[loc]) - 124;
    colort /= (255 - 124);
    
    //Normal
    //Color
    int normal = normalImage[i].pixels[loc];
    //Vector normalizado
    PVector nvector = new PVector(red(normal)-128, green(normal)-128, blue(normal)-128);
    nvector.normalize();
    //Intensidad de la luz
    float d = lightPos.dot(nvector);
    
    
    //Calculo de Brillo especular
    //Posicion del pixel en un espacio tridimensional
    PVector pos = new PVector((((float)x / imageWidth) - 0.5), (((float)y / imageHeight) - 0.5), 0);
    //Posicion de la vista
    PVector view = new PVector(viewPos.x, viewPos.y, viewPos.z);
    view.sub(pos);
    view.normalize();
    
    //Vector medio
    PVector h = new PVector(lightPos.x + pos.x, lightPos.y + pos.y, lightPos.z + pos.z);
    h.add(view);
    h.normalize();
    //Especular
    float s = pow(max(0, nvector.dot(h)), suavidad.GetValue()) * (255 * (intensidadLuz.GetValue() / 100));
    s *= intensidadBrillo.GetValue() / 100;
    
    //Calcular color
    float r = lerp(red(color1), red(color2), colort) * d;
    float g = lerp(green(color1), green(color2), colort) * d;
    float b = lerp(blue(color1), blue(color2), colort) * d;
    
    r += s;
    g += s;
    b += s;
    
    return color(r,g,b);
  }
  
  public void ProcessImage(PImage input, PImage output)
  {
    color1 = colorpicker1.getRGB();
    color2 = colorpicker2.getRGB();
    
    int size = (int)cellSize.GetValue();
    //Crear buffer de color
    resizeImage(input, colorBuffer, size, size);
    //Cambiar tamaño de salida
    output.resize(colorBuffer.width * 64, colorBuffer.height * 64);
    
    float angle = directionKnob.getValue() / 360;
    angle *= PI * 2;
    
    float h = (90 - heightKnob.getValue())/360;
    h *= PI / 2;
    
    
    
    lightPos.x = cos(angle) * sin(h);
    lightPos.y = sin(angle) * sin(h);
    lightPos.z = cos(h);
    
    lightPos.normalize();
    
    input.loadPixels();
    output.loadPixels();
    colorMask.loadPixels();
    colorBuffer.loadPixels();
    //Cargar imagenes
    for(int i = 0; i < 6; i++)
    {
      colorImage[i].loadPixels();
      normalImage[i].loadPixels();
    }
    
    int location = 0;
    imageWidth = output.width;
    imageHeight = output.height;
    
    for(int y = 0; y < imageHeight; y++)
    {
      for(int x = 0; x < imageWidth; x++)
      {
        location = pixelLocation(x, y, output.width);
        output.pixels[location] = pixelProcessing(x, y, location, output.pixels);
      }
    }
    
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Semitonos");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    cellSize = new CustomNumberController(controls, p5, "SemiCellSize" + name, "Tamaño Celda", 20);
    cellSize.SetValue(10); 
    
    //Direccion de la luz
    directionKnob = new Knob(p5, "DiceLightDirection");
    directionKnob.setPosition(5, 50);
    directionKnob.setAngleRange(2 * PI);
    directionKnob.setStartAngle(0);
    directionKnob.setViewStyle(Knob.LINE);
    directionKnob.setRange(0,360);
    directionKnob.getCaptionLabel().setText("Dirección");
    directionKnob.setShowAngleRange(false);
    directionKnob.getValueLabel().hide();
    directionKnob.setGroup(controls);
    
    invert = new Toggle(p5, "InvertDice");
    invert.setPosition(150, 20);
    invert.getCaptionLabel().setText("Invertir Brillo");
    invert.setGroup(controls);
    
    //Altura de la luz
    heightKnob = new Knob(p5, "DiceLightHeight");
    heightKnob.setPosition(65, 50);
    heightKnob.setAngleRange(PI/2);
    heightKnob.setStartAngle(PI);
    heightKnob.setViewStyle(Knob.LINE);
    heightKnob.setRange(0,90);
    heightKnob.getCaptionLabel().setText("Altura");
    heightKnob.setShowAngleRange(false);
    heightKnob.getValueLabel().hide();
    heightKnob.setValue(45);
    heightKnob.setGroup(controls);
    
    //Intensidad de la luz
    intensidadLuz = new CustomSliderController(controls, p5, "LightIntensity" + name, "Intensidad Luz", 130);
    intensidadLuz.SetRange(0, 100);
    intensidadLuz.SetValue(50);
    
    //Suavidad de la intensidad
    suavidad = new CustomSliderController(controls, p5, "Smoothness" + name, "Suavidad de Superficie", 170);
    suavidad.SetRange(0, 100);
    suavidad.SetValue(32);
    
    intensidadBrillo = new CustomSliderController(controls, p5, "SmoothnessIntensity" + name, "Intensidad de Brillo", 210);
    intensidadBrillo.SetRange(0, 100);
    intensidadBrillo.SetValue(32);

    //Colores
    colorpicker1 = p5.addColorWheel("DiceColorPicker1", 0, 240, 200);
    colorpicker1.setGroup(controls);
    colorpicker1.getCaptionLabel().setText("Color Puntos");
    
    colorpicker2 = p5.addColorWheel("DiceColorPicker2", 0, 460, 200);
    colorpicker2.setGroup(controls);
    colorpicker2.setRGB(color(0,0,0));
    colorpicker2.getCaptionLabel().setText("Color Caras");   
  }
}
