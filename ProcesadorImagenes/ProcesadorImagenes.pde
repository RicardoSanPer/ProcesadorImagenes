import controlP5.*;

ControlP5 p5;
ProcesadorUI ui;

void setup()
{
  size(800,600);
  p5 = new ControlP5(this);
  ui = new ProcesadorUI(p5);
}

void draw()
{
  background(0);
}

void test()
{
  println("test");
}
