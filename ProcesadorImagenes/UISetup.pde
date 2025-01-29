/***
*  Clase auxiliar para la interfaz del programa
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
  
  
  DropdownList listaFiltros;
  
  public UIManager(ControlP5 cp5)
  {
    this.cp5 = cp5;
    loadImageButton = new Button(p5, "Cargar Imagen");
    saveImageButton = new Button(p5, "Guardar Imagen");
    applyFilterButton = new Button(p5, "Aplicar");
    listaFiltros = new DropdownList(p5, "Lista de filtros");
    
    //Boton para cargar imagen
    loadImageButton.setLabel("Cargar Imagen");
    loadImageButton.setPosition(10,10);
    loadImageButton.setSize(100, 30);
    loadImageButton.onRelease(event -> LoadImage());
    
    //Boton para guardar imagen
    saveImageButton.setLabel("Guardar Imagen");
    saveImageButton.setPosition(120,10);
    saveImageButton.setSize(100, 30);
    saveImageButton.onRelease(event -> SaveProcessed());
    
    //Boton para guardar imagen
    applyFilterButton.setLabel("Processar Filtro");
    applyFilterButton.setPosition(230,10);
    applyFilterButton.setSize(100, 30);
    applyFilterButton.onRelease(event -> ApplyProcessing());
    
    setupFilterList();
  }
  
  private void setupFilterList()
  {
    
    //UI
    listaFiltros.setOpen(false);
    listaFiltros.setPosition(690, 10);
    listaFiltros.setBarHeight(30);
    listaFiltros.setWidth(100);
    listaFiltros.setItemHeight(25);
    listaFiltros.onLeave(event -> listaFiltros.close());
    
  }
  
  public void AddFilterList(ArrayList<BaseFilter> filtros)
  {
    for(BaseFilter f : filtros)
    {
      listaFiltros.addItem(f.GetName(), listaFiltros);
    }
  }
  
  public int GetCurrentSelectedFilter()
  {
    return (int)listaFiltros.getValue();
  }
  
  public void AddFilter(String name)
  {
    listaFiltros.addItem(name, listaFiltros);
  }
}
