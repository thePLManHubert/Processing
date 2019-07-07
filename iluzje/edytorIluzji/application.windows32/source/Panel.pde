class Panel {
  int x, y;
  float _width, _height;
  int total = 0;
  Cell [] cells;
  
  Panel(int num){
    y = 0;
    x = (int)((1 - ratio) * width);
    _height = height;
    _width = width * ratio;
    cells = new Cell[num];
  }
  
  void add(Picture pic){
    cells[total] = new Cell(pic);
    //cells[total]._width = cells[total]._height = _width / 2 - 25;
    total++;
  }
  
  void update(){
    for(int i = 0; i < total; i++)
      cells[i].update();
  }
  
  void display(){
    fill(102);
    rect(x, y, _width, _height);
    
    for(int j = 0; j < 2; j++){
      for(int i = 0; i < cells.length / 2; i++){
        
        int idx = i + j * cells.length / 2;
        
        if(cells[idx] != null){
          
          cells[idx].x = j*cells[idx]._width + x + cells.length / 2 * (j+1); 
          cells[idx].y = i*cells[idx]._height + y + cells.length / 2 * (i+1);
          
          cells[idx].display();
        }
      }
    }
  }
  
}
