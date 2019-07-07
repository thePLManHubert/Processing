class Grid {

  float _width, _height;
  int rows, cols;
  int x, y;
  Cell [] cells;
  
  private float xLen, yLen;
  
  Grid(int x, int y, float w, float h, int r, int c, boolean adjust){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    rows = r; //y
    cols = c; //x
    cells = new Cell[r * c];
    setAdditional(adjust);
  }
  
  private void setAdditional(boolean adjust){
    if(adjust){
      xLen = _width / cols;
      yLen = _height / rows;
    }
    else {
      xLen = 50;
      yLen = 50;
    }
    setCells();
  }
  
  private void setCells(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx] = new Cell(j * xLen, i * yLen, xLen, yLen, true);
      }
    }
  }
  
  void update(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx].update();
      }
    }
  }
  
  void display(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx].display();
      }
    }
  }

}
