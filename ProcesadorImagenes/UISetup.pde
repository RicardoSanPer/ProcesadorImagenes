/***
*
*  
*
*
*/

public class ProcesadorUI
{
  ControlP5 cp5;
  Button selectImageButton;
  
  public ProcesadorUI(ControlP5 cp5)
  {
    this.cp5 = cp5;
    selectImageButton = new Button(p5, "CargarImagen");
    selectImageButton.setLabel("Cargar Imagen");
    selectImageButton.setPosition(10,10);
    selectImageButton.onClick(event -> test());
  }
  
  

}
