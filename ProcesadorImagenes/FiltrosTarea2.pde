
/**
*  Filtro de sesenfoque (media) eficiente
*  El filtro aplica el desenfoque (convolucion) primero de forma horizontal como primer pase.
*  Luego aplica el desenfoque verticalmente sobre el resultado del primer pase. Equivalente
*  a la convolución, pero mas eficiente.
*  
*  Para aumentar la eficiencia se guarda la suma de los vecinos, y conforme el kernel se mueve, se resta a la
*  suma los valores de los pixeles que van saliendo, y se suma el de los pixeles que entran. De esta forma
*  en vez de checar los n vecinos de un pixel, solo se checa el pixel que entra y el que sale
*
*
*  La diferencia en eficiencia se puede notar con kernels muy grandes
*
*  Computacionalmente equivalente al filtro original, pero puede tener ligeros variaciones (practicamente imperceptibles) por valores decimales
*
*/
public class EfficientBlurFilter extends BaseConvolucion
{
  public EfficientBlurFilter()
  {
    super("Media (Eficiente)");
  }
  public void ProcessImage(PImage input, PImage output)
  {
    //Actualiza el kernel (si se cambio su tamaño)
    updateKernel();
    
    input.loadPixels();
    output.loadPixels();
    
    //Imagen que actua de buffer para guardar el resultado del pase horizontal del filtro
    PImage temp = createImage(input.width, input.height, RGB);
    
    temp.loadPixels();
    
    imageWidth = input.width;
    imageHeight = input.height;
    
    int kx = kernel[0].length;
    int ky = kernel.length;
    
    factor = kx * ky;
    
    int dx = kx /2;
    int dy = ky / 2;
    
    //Aplicar el desenfoque horizontalmente primero
    for(int y = 0; y < input.height; y++)
    {
      float rsum = 0;
      float gsum = 0;
      float bsum = 0;
      
      int location = pixelLocation(0, y);
      
      //Se suman los primeros n valores para el promedio del primer pixel (suma inicial)
      for(int i = 0; i < kx; i++)
      {
        int ddx = i - dx;
        ddx = (ddx < 0)? 0 : (ddx >= input.width) ? input.width - 1 : ddx;
        
        int tl = pixelLocation(ddx, y);
        rsum += red(input.pixels[tl]);
        gsum += green(input.pixels[tl]);
        bsum += blue(input.pixels[tl]);
      }
      temp.pixels[location] = color(rsum / kx, gsum / kx, bsum / kx);
      
      
      //En vez de sumar n valores para cada pixel, se resta el valor del pixel que acaba de salir del kernel y se suma el
      //valor del pixel que acaba de entrar
      for(int x = 1; x < input.width; x++)
      {
          //Coordenada x del pixel que salió de la vecindad
          int last = x - dx - 1;
          last = (last < 0)? 0 : last;
          
          //Coordenada x del pixel que entra a la vecindad
          int next = x + dx;
          next = (next >= input.width) ? input.width - 1 : next;
          
          //Indice de los pixeles
          int tminus = pixelLocation(last, y);
          int tplus = pixelLocation(next, y);
          
          //Colores de los pixeles
          int lcolor = input.pixels[tminus];
          int ncolor = input.pixels[tplus];
          
          //Restar valores del pixel saliente
          rsum -= red(lcolor);
          gsum -= green(lcolor);
          bsum -= blue(lcolor);
          
          //Sumar valores del pixel entrante
          rsum += red(ncolor);
          gsum += green(ncolor);
          bsum += blue(ncolor);
          
          location = pixelLocation(x, y);
          
          temp.pixels[location] = color(rsum / kx, gsum / kx, bsum / kx);
      }
    }
    
    
    //Mismo proceso, pero ahora verticalmente. Se realiza usando el resultado del pase horizontal
    for(int x = 0; x < input.width; x++)
    {
      float rsum = 0;
      float gsum = 0;
      float bsum = 0;
      
      int location = pixelLocation(x, 0);
      
      //Se suman los primeros n valores para el promedio del primer pixel (suma inicial)
      for(int i = 0; i < ky; i++)
      {
        int ddy = i - dy;
        ddy = (ddy < 0)? 0 : (ddy >= input.height) ? input.height - 1 : ddy;
        
        int tl = pixelLocation(x, ddy);
        rsum += red(temp.pixels[tl]);
        gsum += green(temp.pixels[tl]);
        bsum += blue(temp.pixels[tl]);
      }
      output.pixels[location] = color(rsum / ky, gsum / ky, bsum / ky);
      
      
      for(int y = 1; y < input.height; y++)
      {
          //Coordenada y del pixel saliente
          int last = y - dy - 1;
          last = (last < 0)? 0 : last;
          
          //Coordenada y del pixel entrante
          int next = y + dy;
          next = (next >= input.height) ? input.height - 1 : next;
          
          //Indices de los pixeles
          int tminus = pixelLocation(x, last);
          int tplus = pixelLocation(x, next);
          
          //Colores de los pixeles
          int lcolor = temp.pixels[tminus];
          int ncolor = temp.pixels[tplus];
          
          //Restar pixel saliente
          rsum -= red(lcolor);
          gsum -= green(lcolor);
          bsum -= blue(lcolor);
          
          //Sumar pixel entrante
          rsum += red(ncolor);
          gsum += green(ncolor);
          bsum += blue(ncolor);
          
          location = pixelLocation(x, y);
          
          output.pixels[location] = color(rsum / ky, gsum / ky, bsum /ky);
      }
    }
    temp.updatePixels();
    output.updatePixels();
  }
}


public class MotionBlurFilter extends BaseConvolucion
{
  Knob directionKnob;
  
  float slopex;
  float slopey;
  float distance;
  
  public MotionBlurFilter()
  {
    super("Movimiento");
  }
  
   protected color pixelProcessing(int x, int y, int location, int[] pix)
   {
     float px = x;
     float py = y;
     
     float r = 0;
     float g = 0;
     float b = 0;
     
     float f = 0;
     while(px < imageWidth && px > 0 && py < imageHeight && py > 0)
     {
       float dx = px - x;
       float dy = py - y;
       if(dx * dx + dy * dy > distance * distance)
       {
         break;
       }
       location = pixelLocation((int)px,(int)py);
       r += red(pix[location]);
       g += green(pix[location]);
       b += blue(pix[location]);
       
       px += slopex;
       py += slopey;
       
       f++;
     }
     return color(r/f, g/f, b/f);
   }
  
  protected void updateKernel()
  {
    distance = sizek.GetValue() + 1;
    int size = (int) (sizek.GetValue() * 2 + 1);
    kernel = new float[size][size];
    float angle = directionKnob.getValue() / 360;
    angle *= PI * 2;
    
    slopex = cos(angle);
    slopey = sin(angle);
    
    //float posx = size / 2;
    //float posy = size / 2;
    
    factor = 1;
    
    /*
    while(posx < size && posy < size && posx > 0 && posy > 0)
    {
      float dx = posx - (size / 2);
      float dy = posy - (size / 2);
      
      if(dx * dx + dy * dy >= distance * distance)
      {
        break;
      }
      
      kernel[(int)posy][(int)posx] = 1;
      posy += slopey;
      posx += slopex;
    }
    
    for(int i = 0; i < kernel.length; i++)
    {
      for(int j = 0; j < kernel[0].length; j++)
      {
        print((int)kernel[i][j] + ",");
      }
      println();
    }
    
    for(int i = 0; i < kernel.length; i++)
    {
      for(int j = 0; j < kernel[0].length; j++)
      {
        factor += kernel[i][j];
      }
    }
    */
    
    //println(factor);
  }
  
  
  protected void setupControls(ControlP5 p5)
  {
    controls.setLabel("Controles de Desenfoque de Movimiento");
    controls.setSize(200, 400);
    controls.setPosition(width - 250, 30);
    
    sizek = new CustomNumberController(controls, p5, "KernelX" + name, "Distancia", 20);
    
    sizek.SetValue(5);
    
    directionKnob = new Knob(p5, "MotionBlurDirection");
    directionKnob.setPosition(0, 60);
    directionKnob.setAngleRange(2 * PI);
    directionKnob.setStartAngle(0);
    directionKnob.setViewStyle(Knob.LINE);
    directionKnob.setRange(0,360);
    directionKnob.getCaptionLabel().setText("Direccion");
    directionKnob.setShowAngleRange(false);
    directionKnob.getValueLabel().hide();
    directionKnob.setGroup(controls);
    
  }
}
