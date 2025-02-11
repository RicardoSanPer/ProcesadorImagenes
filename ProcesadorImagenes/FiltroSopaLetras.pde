import java.util.Random;

public class SopaLetrasFilter extends BaseFilter
{
  Button save;
  //Tamaño de letra. 1 = 1 letra por pixel
  CustomNumberController kernelSize;
  
  //Lista de texto
  ScrollableList modoTexto;
  ScrollableList modoColor;
  
  //Toggles
  Toggle useQ;
  
  Textfield frase;
  String luminosidad = "MNH#QAO0Y2$%+. ";
  int[][] suits = { //Espadas
                         {
                         unhex("1F0A0"),
                         unhex("1F0AA"),
                         unhex("1F0A9"),
                         unhex("1F0A8"),
                         unhex("1F0A7"),
                         unhex("1F0A6"),
                         unhex("1F0A5"),
                         unhex("1F0A4"),
                         unhex("1F0A3"),
                         unhex("1F0A2"),
                         unhex("1F0A1")},
                         //Corazones
                         {unhex("1F0A0"),
                         unhex("1F0BA"),
                         unhex("1F0B9"),
                         unhex("1F0B8"),
                         unhex("1F0B7"),
                         unhex("1F0B6"),
                         unhex("1F0B5"),
                         unhex("1F0B4"),
                         unhex("1F0B3"),
                         unhex("1F0B2"),
                         unhex("1F0B1")},
                         //Diamantes
                         {unhex("1F0A0"),
                         unhex("1F0CA"),
                         unhex("1F0C9"),
                         unhex("1F0C8"),
                         unhex("1F0C7"),
                         unhex("1F0C6"),
                         unhex("1F0C5"),
                         unhex("1F0C4"),
                         unhex("1F0C3"),
                         unhex("1F0C2"),
                         unhex("1F0C1")},
                         //Clubs
                         {unhex("1F0A0"),
                         unhex("1F0DA"),
                         unhex("1F0D9"),
                         unhex("1F0D8"),
                         unhex("1F0D7"),
                         unhex("1F0D6"),
                         unhex("1F0D5"),
                         unhex("1F0D4"),
                         unhex("1F0D3"),
                         unhex("1F0D2"),
                         unhex("1F0D1")}};
  int[][] dominos = {{unhex("1F093"),unhex("1F092"),unhex("1F091"),unhex("1F090"),unhex("1F08F"),unhex("1F08E"),unhex("1F08D")},
                     {unhex("1F08C"),unhex("1F08B"),unhex("1F08A"),unhex("1F089"),unhex("1F088"),unhex("1F087"),unhex("1F086")},
                     {unhex("1F085"),unhex("1F084"),unhex("1F083"),unhex("1F082"),unhex("1F081"),unhex("1F080"),unhex("1F07F")},
                     {unhex("1F07E"),unhex("1F07D"),unhex("1F07C"),unhex("1F07B"),unhex("1F07A"),unhex("1F079"),unhex("1F078")},
                     {unhex("1F077"),unhex("1F076"),unhex("1F075"),unhex("1F074"),unhex("1F073"),unhex("1F072"),unhex("1F071")},
                     {unhex("1F070"),unhex("1F06F"),unhex("1F06E"),unhex("1F06D"),unhex("1F06C"),unhex("1F06B"),unhex("1F06A")},
                     {unhex("1F069"),unhex("1F068"),unhex("1F067"),unhex("1F066"),unhex("1F065"),unhex("1F064"),unhex("1F063")},
                    };
  //String de salida para el codigo html
  String outputHTML;
  
  //Filtros
  GrayScaleFilter filtrobn;
  QuantizeFilter filtroq;
  
  //Random
  Random rand = new Random();
  
  public SopaLetrasFilter()
  {
    super("Sopa de Letras");
    filtrobn = new GrayScaleFilter("FiltroSopaBN");
    filtroq = new QuantizeFilter("FiltroSopaQ");
    
  }
  
  public SopaLetrasFilter(String n)
  {
    super(n);
  }
  
  protected color pixelProcessing(int x, int y, int location, int[] input)
  {
    outputHTML += "<span style=\"color:#" + hex(input[location], 6)+"\">M</span>";
    return color(0,0,0);
  }
  
  public void ProcessImage(PImage input, PImage output)
  {
    //Cambiar el tamaño de la imagen de salida (previsualizacion) por cuestiones de rendimiento
    //El tamaño se calcula en base al tamaño del texto relativo a la imagen
    resizeImage(input, output);
    
    int colorMode = (int)modoColor.getValue();
    int textMode = (int)modoTexto.getValue();
    
    //Usar escala de grises
    if(colorMode == 2 || textMode != 0)
    {
      filtrobn.ProcessImage(output,output);
    }
    
    //cuantizar si hay modo de color
    if(useQ.getBooleanValue())
    {
      //Realizar dithering en los tres canales con el mismo valor cuando es imagen a blanco y negro
      filtroq.SetSingleChannelRandom(modoColor.getValue() == 2 || textMode != 0);
      filtroq.ProcessImage(output, output);
    }
    
    //String de donde se sacan las letras
    String sample = "M";
    if(frase.getText().length() > 0)
    {
      sample = frase.getText();
      sample = sample.toUpperCase();
    }
    int sampleLength = sample.length();
    int counter = 0;
    
    input.loadPixels();
    output.loadPixels();
    
    int location = 0;
    imageWidth = input.width;
    imageHeight = input.height;
    
    //Encabezado de html
    outputHTML = "<!DOCTYPE html><body style=\"line-height:0.8; font-family: ";
    
    if(textMode < 2)
    {
      outputHTML += "Courier New;";
    }
    else
    {
      outputHTML += "Segoe UI Symbol;";
    }
    outputHTML += "\">";
    
    for(int y = 0; y < output.height; y++)
    {
      String line = "";
      for(int x = 0; x < output.width; x++)
      {
        location = pixelLocation(x, y, output.width);
        
        //Por alguna razon es mas rápido hacer la construccion del texto aqui
        //en vez de en pixelProcessing
        if(location < output.pixels.length)
        {
          String c = "M";
          
          //Si se usa modo de frase, iterar sobre las letras de la frase
          if(textMode == 0)
          {
            c = Character.toString(sample.charAt(counter));
          }
          //De otro modo tomar un caracter en base a la luminosidad del color
          else
          { 
            float k = grayscale(output.pixels[location]);
            
            int cociente = textMode == 1? luminosidad.length(): 
                            textMode == 2? suits[0].length :
                            textMode == 3? dominos[0].length : 1;
            //Similar a la cuantizacion
            float i = quantizeValue(k, cociente, 255);
            
            //Si se usa el modo luminosidad, tomar de la cadena "MNH#QAO0Y2$%+. "
            if(textMode == 1)
            {
              c = Character.toString(luminosidad.charAt((int)i));
            }
            //Si se usa el modo poker, tomar una carta del valor adecuado y de uno de los suits al azar
            else if(textMode == 2)
            {
              int rnd = (int) (rand.nextDouble() * 4);
              c = new String(Character.toChars(suits[rnd][(int)i]));
            }
            else if(textMode == 3)
            {
              int y2 = y + 1;
              if(y2 > output.height)
              {
                continue;
              }
              int l2 = pixelLocation(x,y2, output.width);
              l2 = l2 > output.height? output.height - 1 : l2;
              
              float k2 = grayscale(output.pixels[l2]);
              float i2 = quantizeValue(k2, dominos[0].length, 255);
              
              c = new String(Character.toChars(dominos[(int)i][(int)i2]));
            }
          }
 
          //Si se usa modo a color o a blanco/negro (grises), establecer un color a la letra
          if(colorMode != 0)
          {
            line += "<span style=\"color:#" + hex(output.pixels[location], 6)+"\">" + c + "</span>";  
          }
          //De otro modo simplemente agregar la letra
          else {
            line += c;
          }
          //Aumentar contador
          counter ++;
          counter = counter % sampleLength;
        }
        //output.pixels[location] = pixelProcessing(x, y, location, input.pixels);
      }
      
      if(textMode == 3)
      {
        y++;
      }
      outputHTML += line + "<br>";
      //println((float)y / imageHeight);
    }
    outputHTML += "</body></HTML>";
    output.updatePixels();
  }
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Letras");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    kernelSize = new CustomNumberController(controls, p5, "KernelSoupSize" + name, "Tamaño Letra", 20);
    kernelSize.SetValue(5);
    
    //Boton guardado texto
    save = new Button(p5, "GuardarSopa");
    save.getCaptionLabel().setText("Guardar HTML");
    save.setSize(100, 20);
    save.setPosition(0,440);
    save.setGroup(controls);
    save.onRelease(event -> guardarHTML());
    
    //Frase (o letra) a repetir
    frase = new Textfield(p5, "SoupText");
    frase.setCaptionLabel("Frase");
    frase.getCaptionLabel().hide();
    frase.setPosition(0, 120);
    frase.setGroup(controls);
    frase.setText("THE END IS NEVER ");
    
    //Usar cuantizacion
    useQ = new Toggle(p5, "SoupQ");
    SetupToggle(useQ, "Cuantizacion", 90);
    useQ.setPosition(120, 90);
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
    
    
    
    //Modos texto
    modoTexto = new ScrollableList(p5, "SoupMode");
    modoTexto.getCaptionLabel().setText("Modo de Texto");
    modoTexto.addItem("Texto", modoTexto);
    modoTexto.addItem("Luminosidad", modoTexto);
    modoTexto.addItem("Poker", modoTexto);
    modoTexto.addItem("Domino", modoTexto);
    modoTexto.setGroup(controls);
    modoTexto.setPosition(0, 50);
    modoTexto.setBarHeight(30);
    modoTexto.setItemHeight(25);
    modoTexto.setOpen(false);
    modoTexto.setValue(0);
    
    //Modos color
    modoColor = new ScrollableList(p5, "SoupColorMode");
    modoColor.getCaptionLabel().setText("Modo de color");
    modoColor.addItem("Sin Color", modoColor);
    modoColor.addItem("Color", modoColor);
    modoColor.addItem("Grises", modoColor);
    modoColor.setGroup(controls);
    modoColor.setPosition(120, 50);
    modoColor.setBarHeight(30);
    modoColor.setItemHeight(25);
    modoColor.setOpen(false);
    modoColor.setValue(0);
    
  }
  
  /**
  *  Redimensiona la imagen. Igual al mosaico
  *
  *  @param input imagen a re
  *  @param output buffer de salida
  */
  private void resizeImage(PImage input, PImage output)
  {
    input.loadPixels();
    output.loadPixels();
    //Tamaño del kernel en pixeles
    float sizex = kernelSize.GetValue();
    float sizey = kernelSize.GetValue();
    
    //Numero de segmentos/mosaicos en los que se divide la imagen
    int nsegments = (int)(input.width / sizex);
    int msegments = (int)(input.height / sizey);
    
    output.resize(nsegments+1, msegments+1);
    
    //Iterar por mosaicos de arriba a abajo. Contar uno mas en caso de mosaicos truncados
    for(int j = 0; j <= msegments; j++)
    {
      //Contar uno mas para tomar en cuenta casos en que hay mosaicos truncados
      for(int i = 0; i <= nsegments; i++)
      {
        float count = 0;
        float r = 0;
        float g = 0;
        float b = 0;
        
        //Iterar por cada pixel dentro del mosaico actual para tomar muestra de color
        for(int x = 0; x < sizex && x + (i * sizex) < input.width; x++)
        {
          for(int y = 0; y < sizey && y + (j * sizey) < input.height; y++)
          {
            int posy = (int) (y + (j * sizey));
            int posx = (int) (x + (i * sizex));
            int loc = pixelLocation(posx, posy, input.width);
            
            if(loc < input.pixels.length)
            {
              r += red(input.pixels[loc]);
              g += green(input.pixels[loc]);
              b += blue(input.pixels[loc]);
              
              count++;
            }
          }
        }
        
        r /= count;
        g /= count;
        b /= count;
        
        //Colorear la salida
        int loc = pixelLocation(i,j, output.width);
        if(loc < output.pixels.length)
        {
          output.pixels[loc] = color(r,g,b);
        }
      }
    }
    
    output.updatePixels();
    
  }
  
  private void guardarHTML()
  {
    saveStrings("sopa_letras.html", new String[] {outputHTML});
  }
  
  public void validateOutputText(File output)
  {
    if(output == null)
    {
      println("No se eligio ningun archivo de salida");
      return;
    }
    
    String path = output.getAbsolutePath();
    
  }
}
