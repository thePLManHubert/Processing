class Panel {
  int x, y;
  float _width, _height;
  int columns;
  int total = 0;
  Cell [] cells;
  
  Panel(int num, int columns){
    y = 0;
    x = (int)((1 - ratio) * width);
    _height = height;
    _width = width * ratio;
    this.columns = columns;
    cells = new Cell[num];
  }
  
  void add(Picture pic){
    if(total < cells.length)
      cells[total++] = new Cell(pic);
  }
  
  void update(){
    for(int i = 0; i < total; i++)
      cells[i].update();
  }
  
  void display(){
    fill(102);
    rect(x, y, _width, _height);
    int space = 2;
    
    for(int j = 0; j < columns; j++){
      for(int i = 0; i < cells.length / columns; i++){
        
        int idx = i + j * cells.length / columns;
        
        if(cells[idx] != null){
          
          cells[idx].x = x + j * cells[idx]._width + space * (j + 1);
          cells[idx].y = y + i * cells[idx]._height + space * (i + 1);
          
          cells[idx].display();
        }
      }
    }
  }
  
}
