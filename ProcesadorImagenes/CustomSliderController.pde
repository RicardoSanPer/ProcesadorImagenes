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
  public CustomSliderController(Group controls, ControlP5 p5, String name, String text, float posY)
  {
    //Slider
    slider = new Slider(p5, "Rango" + name);
    slider.setSize(160, 15);
    slider.setPosition(20, posY);
    
    slider.setRange(0,255);
    slider.setValue(128);
    slider.setSliderMode(0);
    
    slider.setScrollSensitivity(0);
    
    slider.onRelease(event -> updateSlider());
    slider.onReleaseOutside(event -> updateSlider());
    
    
    slider.setGroup(controls);
    
    slider.getCaptionLabel().setText(text);
    //slider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
    slider.getCaptionLabel().getStyle().marginTop = -15;
    slider.getCaptionLabel().getStyle().marginLeft = -180;
    //slider.getCaptionLabel().setPadding(-150, 0);
    
    
    //slider.moveTo(controls);
    
    //Boton +
    plus = new Button(p5, "Addition" + name);
    plus.getCaptionLabel().setText("+");
    plus.setSize(15,15);
    plus.setPosition(185,posY);
    plus.setGroup(controls);
    plus.onRelease(event -> addValue());
    
    //boton -
    minus = new Button(p5, "Minus" + name);
    minus.getCaptionLabel().setText("-");
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
    updateSlider();
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

/*
*  Similar a CustomSliderController, pero para numbox
*
*/

public class CustomNumberController
{
  Numberbox number;
  Button plus;
  Button minus;
  
  /*
  *   Constructor
  *  @param controls grupo de controles al que pertenece
  *  @param p5 control de ui del programa
  *  @param name nombre del control, para evitar nombres repetidos
  *  @param y traslacion en y respecto al origen del grupo
  */
  public CustomNumberController(Group controls, ControlP5 p5, String name, String text, float posY)
  {
    //Slider
    number = new Numberbox(p5, "Number" + name);
    number.setPosition(25, posY);
    
    number.setMin(1);
    number.setValue(128);
    
    number.setScrollSensitivity(0);
    
    number.onRelease(event -> updateNumber());
    number.onReleaseOutside(event -> updateNumber());
    
    
    number.setGroup(controls);
    
    number.getCaptionLabel().setText(text);
    //slider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
    number.getCaptionLabel().getStyle().marginTop = -35;
    number.getCaptionLabel().getStyle().marginLeft = -5;
    //slider.getCaptionLabel().setPadding(-150, 0);
    
    
    //slider.moveTo(controls);
    
    //Boton +
    plus = new Button(p5, "Addition" + name);
    plus.getCaptionLabel().setText("+");
    plus.setSize(20,20);
    plus.setPosition(100,posY);
    plus.setGroup(controls);
    plus.onRelease(event -> addValue());
    
    //boton -
    minus = new Button(p5, "Minus" + name);
    minus.getCaptionLabel().setText("-");
    minus.setSize(20,20);
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
    return number.getValue();
  }
  
  /*
  *  Cambia el valor del slider
  *  @param val valor nuevo
  */
  public void SetValue(float val)
  {
    number.setValue(val);
  }
  
  public void SetRange(float min, float max)
  {
    number.setRange(min,max);
  }
  
  //Actualiza el numberbox para tener un valor entero
  private void updateNumber()
  {
    number.setValue((float)Math.floor(number.getValue()));
  }
  
  //suma 1 al valor del numberbox
  private void addValue()
  {
    number.setValue(number.getValue()+1);
    updateNumber();
  }
  
  //resta 1 al valor del numberbox
  private void minusValue()
  {
    number.setValue(number.getValue()-1);
    updateNumber();
  }
}
/*
*  Funcion para estilizar el toggle
*
*/
public void SetupToggle(Toggle toggle, String label, float posY)
{
  toggle.getCaptionLabel().setText(label);
  toggle.setValue(false);
  toggle.setSize(15,15);
  toggle.setPosition(0, posY);
  toggle.getCaptionLabel().getStyle().marginTop = -15;
  toggle.getCaptionLabel().getStyle().marginLeft = 20;
}
