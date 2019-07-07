interface Modifier{
  int getValue();
  void update();
}

abstract class ModifierAdapter implements Modifier {
  int value;
  
  @Override
  void update(){}
  
  @Override
  int getValue(){
    return value;
  }
}


class Sinusoid extends ModifierAdapter {
  int step = 0;
  int factor = 1;
  int maxStep = 10;
  
  Sinusoid(){}
  Sinusoid(int maxStep){
    this.maxStep = maxStep;
  }
  
  @Override
  void update(){
    value = (int)(128 * (sin(step * HALF_PI/maxStep)+1));
    step += factor;
    if(step <= -maxStep || step >= maxStep)
      factor *= -1;
  }
  
}

class Triangle extends ModifierAdapter {
  int step = 0;
  int factor = 1;
  int maxStep = 20;
  
  Triangle(){}
  Triangle(int maxStep){
    this.maxStep = maxStep;
  }
  
  @Override
  void update(){
    value = (int)(256 * (step * 1.f/maxStep));
    step += factor;
    if(step <= 0 || step >= maxStep)
      factor *= -1;
  }
  
}

class Mouse extends ModifierAdapter {
  
  @Override
  void update(){
    value = mouseX/2;
  }
  
}
