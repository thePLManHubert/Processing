float ratio = 1/5.f;

class Canvas {

  float _width, _height;
  int x, y;
  int n, m;
  Grid g;
  
  Canvas(int n, int m, boolean adjust){
    x = y = 0;
    this.n = n;
    this.m = m;
    setParams(adjust);
  }
  
  void setParams(boolean adjust){
    _height = height;
    _width = (1 - ratio) * width;
    g = new Grid(x, y, _width, _height, m, n, adjust);
  }
  
  void update(){
    g.update();
  }
  
  void display(){
    g.display();
  }
  
}
