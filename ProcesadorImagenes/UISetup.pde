/***
*
*  
*
*
*/

public class UIManager
{
  ControlP5 cp5;
  Button loadImageButton;
  Button saveImageButton;
  Button applyFilterButton;
  
  public UIManager(ControlP5 cp5)
  {
    this.cp5 = cp5;
    loadImageButton = new Button(p5, "Cargar Imagen");
    saveImageButton = new Button(p5, "Guardar Imagen");
    applyFilterButton = new Button(p5, "Aplicar");
    
    //Boton para cargar imagen
    loadImageButton.setLabel("Cargar Imagen");
    loadImageButton.setPosition(10,10);
    loadImageButton.setSize(100, 30);
    
    
    loadImageButton.onClick(event -> LoadImage());
    
    //Boton para guardar imagen
    saveImageButton.setLabel("Guardar Imagen");
    saveImageButton.setPosition(120,10);
    saveImageButton.setSize(100, 30);
    
    saveImageButton.onClick(event -> SaveProcessed());
    
    //Boton para guardar imagen
    applyFilterButton.setLabel("Processar Filtro");
    applyFilterButton.setPosition(230,10);
    applyFilterButton.setSize(100, 30);
    
    applyFilterButton.onClick(event -> ApplyProcessing());
  }
  
}
