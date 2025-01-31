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
  
  ScrollableList listaFiltros;
  
  public UIManager(ControlP5 p5)
  {
    this.cp5 = p5;
    loadImageButton = new Button(p5, "Cargar Imagen");
    saveImageButton = new Button(p5, "Guardar Imagen");
    applyFilterButton = new Button(p5, "Aplicar");
    listaFiltros = new ScrollableList(p5, "Lista de filtros");
    
    //Boton para cargar imagen
    loadImageButton.setLabel("Cargar Imagen");
    loadImageButton.setPosition(10,10);
    loadImageButton.setSize(120, 30);
    loadImageButton.onRelease(event -> LoadImage());
    
    //Boton para guardar imagen
    saveImageButton.setLabel("Guardar Imagen");
    saveImageButton.setPosition(140,10);
    saveImageButton.setSize(120, 30);
    saveImageButton.onRelease(event -> SaveProcessed());
    
    //Boton para guardar imagen
    applyFilterButton.setLabel("Processar Filtro");
    applyFilterButton.setPosition(width - 570,10);
    applyFilterButton.setSize(120, 30);
    applyFilterButton.onRelease(event -> ApplyProcessing());
    
    setupFilterList();
  }
  
  private void setupFilterList()
  { 
    //UI
    listaFiltros.setOpen(false);
    listaFiltros.setPosition(width - 440, 10);
    listaFiltros.setBarHeight(30);
    listaFiltros.setWidth(120);
    listaFiltros.setItemHeight(25);
    listaFiltros.onLeave(event -> listaFiltros.close());
    listaFiltros.onChange(event -> updateUI());
  }
  /**
  *  Agrega una lista de filtros a la lista de la UI
  *
  *  @param filtros lista de filtros
  */
  public void AddFilterList(ArrayList<BaseFilter> filtros)
  {
    for(BaseFilter f : filtros)
    {
      listaFiltros.addItem(f.GetName(), listaFiltros);
    }
  }
  
  /**
  *  Regresa el indice del filtro seleccionado actualmente
  *
  *  @return indice del filtro seleccionado
  */
  public int GetCurrentSelectedFilter()
  {
    return (int)listaFiltros.getValue();
  }
  
}
