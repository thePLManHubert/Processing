import java.lang.*;

class Panel {
  int x, y;
  float _width, _height;
  int columns;
  int total = 0;
  ArrayList<Cell> cells; 
  
  Panel(int columns){
    y = 0;
    x = (int)((1 - ratio) * width);
    _height = height;
    _width = width * ratio;
    this.columns = columns;
    cells = new ArrayList<Cell>();
  }
  
  void add(Picture pic){
    cells.add(new Cell(pic));
    total++;
  }
  
  void update(){
    for(Cell c : cells)
      c.update();
  }
  
  void display(){
    fill(102);
    rect(x, y, _width, _height);
    int space = 2;
    
    int k = cells.size() / columns;
    int modulo = cells.size() % columns;
    int i = 0, j = 0;
    int idx = 0;
    
    for(j = 0; j < columns; j++){
      for(i = 0; i < k; i++){
        
        if(idx < total){
          
          cells.get(idx).x = x + j * cells.get(idx)._width + space * (j + 1);
          cells.get(idx).y = y + i * cells.get(idx)._height + space * (i + 1);
          
          cells.get(idx).display();
          idx++;
        }
      }
      if(modulo != 0 && idx < total){

        cells.get(idx).x = x + j * cells.get(idx)._width + space * (j + 1);
        cells.get(idx).y = y + i * cells.get(idx)._height + space * (i + 1);
          
        cells.get(idx).display();
        modulo--;
        idx++;
      }
        
    }
  }
  
}
