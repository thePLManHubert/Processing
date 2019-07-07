class Cell {

  float _width, _height;
  float x, y;
  Picture picture;
  boolean isOnCanvas;
  
  Cell(Picture p){
    setWithPicture(p);
    isOnCanvas = false;
  }
  
  Cell(float x, float y, float w, float h, boolean canv){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    isOnCanvas = canv;
  }
  
  void setWithPicture(Picture p){
    this._width = p._width;
    this._height = p._height;
    picture = p.pasteNew();
  }
  
  void update(){
    
    if(keyPressed && key == DELETE){
      if(isOnCanvas)
        picture = null;
    }
    
    if(picture != null)
      picture.update(this);
      
    if(mouseOn()){
      if(mousePressed){
        if(mouseButton == RIGHT){
          mb.onRightClick(this);
        }
        if(mouseButton == LEFT){   
          mb.onLeftClick(this);
        }
      }
    }
    
  }
  
  void display(){
    if(picture == null){
      stroke(153);
      fill(255);
      rect(x, y, _width, _height);
    }
    else
      picture.displayOnCell(this);
  }
  
  private boolean mouseOn(){
    if(mouseX >= x && mouseX <= x + _width
        && mouseY >= y && mouseY <= y + _height)
      return true;
    return false;
  }
  
}


interface Clickable {
  void onLeftClick(Cell other);
  void onRightClick(Cell other);
}
