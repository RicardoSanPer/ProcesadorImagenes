import controlP5.*;

ControlP5 p5;
UIManager ui;
ImageProcessor img;

void setup()
{
  size(1600,720);
  
  p5 = new ControlP5(this);
  p5.setFont(createFont("Arial", 10));
  
  img = new ImageProcessor();
  ui = new UIManager(p5);
  
  setupFilters();
}

void draw()
{
  background(0);
  img.DrawImages();
}


//Aplicar el procesado de la imagen
void ApplyProcessing()
{
  //Aplicar el filtro actualmente seleccionado
  img.Apply(ui.GetCurrentSelectedFilter());
}

void setupFilters()
{
  
  //Inicializar filtros
  img.addFilter(new GrayScaleFilter());
  img.addFilter(new RedFilter());
  img.addFilter(new GreenFilter());
  img.addFilter(new BlueFilter());
  img.addFilter(new BinarizationFilter());
  img.addFilter(new BrightnessFilter());
  img.addFilter(new RGBLevelsFilter());
  img.addFilter(new InvertFilter());
  img.addFilter(new QuantizeFilter());
  
  //Agregarlos a la ui
  ui.AddFilterList(img.GetFilterList());
  
  //Inicializa los controles de UI de los filtros
  for(BaseFilter f : img.GetFilterList())
  {
    f.StartControls(p5);
  }
  
  //Mostrar controles del filtro por defecto
  img.GetFilterList().get(0).ShowControls();
}

//Actualiza la UI para mostrar los controles del filtro seleccionado actualmente
void updateUI()
{
  img.SwitchUI(ui.GetCurrentSelectedFilter());
}


//// I/O DE IMAGENES
  
//Cargar imagen
void LoadImage()
{
  selectInput("Elige una imagen a procesar", "validateInput");
}

//Validar la seleccion de archivo a cargar
void validateInput(File input)
{
  if(input == null)
  {
    println("No se seleccionó ninguna imagen");
    return;
  }
  img.LoadImage(input.getAbsolutePath());
}

//Guardar imagen
void SaveProcessed()
{
  selectOutput("Elige donde guardar la imagen procesada", "validateOutput");
}

//Validar destino de guardado
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
