import controlP5.*;

ControlP5 p5;
ProcesadorUI ui;
ImageManager img;

void setup()
{
  size(800,600);
  
  p5 = new ControlP5(this);
  
  img = new ImageManager();
  ui = new ProcesadorUI(p5);
}

void draw()
{
  background(0);
  img.DrawImages();
}

void test()
{
  println("test");
}


//// I/O DE IMAGENES
  
void LoadImage()
{
  selectInput("Elige una imagen a procesar", "validateInput");
}

void validateInput(File input)
{
  if(input == null)
  {
    println("No se seleccionó ninguna imagen");
    return;
  }
  img.LoadImage(input.getAbsolutePath());
}

void SaveProcessed()
{
  selectOutput("Elige donde guardar la imagen procesada", "validateOutput");
}

void validateOutput(File output)
{
  if(output == null)
  {
    println("No se eligio ningun archivo de salida");
    return;
  }
  
  String path = output.getAbsolutePath();
  
  //Si el usuario no especificó un formato de imagen (PGN o JPG), asignar JPG por defecto
  if(!path.toLowerCase().endsWith(".png") && !path.toLowerCase().endsWith(".jpg"));
  {
    path += ".jpg";
  }
  img.SaveProcessed(path);
}
