/**
*  Controlador de slider extendido.
*  Contiene botones de suma y resta en ambos extremos
*  para facilitar la eleccion de un valor
*/


public class CustomSliderController
{
  Slider slider;
  Button plus;
  Button minus;
  
  /*
  *   Constructor
  *  @param controls grupo de controles al que pertenece
  *  @param p5 control de ui del programa
  *  @param name nombre del control, para evitar nombres repetidos
  *  @param y traslacion en y respecto al origen del grupo
  */
  public CustomSliderController(Group controls, ControlP5 p5, String name, float posY)
  {
    //Slider
    slider = new Slider(p5, "Rango" + name);
    slider.setLabel("");
    slider.setSize(160, 15);
    slider.setPosition(20, posY);
    
    slider.setRange(0,255);
    slider.setValue(128);
    slider.setSliderMode(0);
    
    slider.setScrollSensitivity(0);
    
    slider.onRelease(event -> updateSlider());
    slider.onReleaseOutside(event -> updateSlider());
    
    slider.setGroup(controls);
    
    //Boton +
    plus = new Button(p5, "Addition" + name);
    plus.setLabel("+");
    plus.setSize(15,15);
    plus.setPosition(190,posY);
    plus.setGroup(controls);
    plus.onRelease(event -> addValue());
    
    //boton -
    minus = new Button(p5, "Minus" + name);
    minus.setLabel("-");
    minus.setSize(15,15);
    minus.setPosition(0,posY);
    minus.setGroup(controls);
    minus.onRelease(event -> minusValue());
  }
  
  /*
  * Obtiene el valor del slider
  *  @return valor del slider
  */
  public float GetValue()
  {
    return slider.getValue();
  }
  
  /*
  *  Cambia el valor del slider
  *  @param val valor nuevo
  */
  public void SetValue(float val)
  {
    slider.setValue(val);
  }
  
  /*
  *  Establece el rango de valores del slider
  *  @param min valor minimo
  *  @param max valor maximo
  */
  public void SetRange(float min, float max)
  {
    slider.setRange(min,max);
  }
  
  public void SetColor(color rgb)
  {
    slider.setColorBackground(rgb);
    plus.setColorBackground(rgb);
    minus.setColorBackground(rgb);
    
  }
  
  //Actualiza el slider para tener un valor entero
  private void updateSlider()
  {
    slider.setValue((float)Math.floor(slider.getValue()));
  }
  
  //suma 1 al valor del slider
  private void addValue()
  {
    slider.setValue(slider.getValue()+1);
    updateSlider();
  }
  
  //resta 1 al valor del slider
  private void minusValue()
  {
    slider.setValue(slider.getValue()-1);
    updateSlider();
  }
}
