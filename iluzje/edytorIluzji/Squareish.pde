class Squareish extends Picture {
  int first, second;      // not modified
  
  float smallw, smallh;   // original value
  PVector pos1, pos2;     // original value positions of small squares
  
  float smallwc, smallhc; // for cells (modifications)
  PVector pos1c, pos2c;   // for cells (modifications)
  
  float xvelocity, yvelocity;
  color colour;
  boolean isFirstMoving = false;
  boolean isSecondMoving = false;
  boolean initialized = false;
  
  Squareish(int first, int second, color colour){
    this.x = 0;
    this.y = 0;
    _width = 50;
    _height = 50;
    xvelocity = 1.f;
    yvelocity = 1.f;
    
    this.first = first;
    this.second = second;
    
    this.colour = colour;
    
    pos1 = new PVector();
    pos2 = new PVector();
    pos1c = new PVector();
    pos2c = new PVector();
    
    setAddition(first, second); // set once
  }
  
  void setAddition(int first, int second){
    smallw = 3 * _width / 10;
    smallh = 3 * _height / 10;
    pos1 = setVector(first);
    pos2 = setVector(second);
  }
  
   PVector setVector(int pos){ // for cursor icon
    float t = 2;
  
    if(pos == 1)
      return new PVector(x + t, y + t);
    else if(pos == 2)
      return new PVector(x + _width - smallw - t, y + t);
    else if(pos == 3)
      return new PVector(x + _width - smallw - t, y + _height - smallh - t);
    else if(pos == 4)
      return new PVector(x + t, y + _height - smallh - t);
    return null;
  }
  
  PVector setVector(int pos, Cell c){ // for cells //<>//
    float gapX = 2 * c._width / 50;
    float gapY = 2 * c._height / 50;
    
    if(pos == 1)
      return new PVector(c.x + gapX, c.y + gapY);
    else if(pos == 2)
      return new PVector(c.x + c._width - smallwc - gapX, c.y + gapY);
    else if(pos == 3)
      return new PVector(c.x + c._width - smallwc - gapX, c.y + c._height - smallhc - gapY); //<>//
    else if(pos == 4)
      return new PVector(c.x + gapX, c.y + c._height - smallhc - gapY);
    return null;
  }
  
  //--------------------------------BEGIN-----------------------------------------
  
  /*------------------- Cell based values modifications---------------------------*/
  
  private void animate(Cell c){

    if(isFirstMoving){
      if(first == 1) {
        pos1c.x += xvelocity;
        if(pos1c.x >= setCoordinate(2,c).x){
          first = 2;
          isFirstMoving = false;
        }
      }
      else if(first == 2) {
        pos1c.y += yvelocity;
        if(pos1c.y >= setCoordinate(3,c).y){
          first = 3;
          isFirstMoving = false;
        }
      }
      else if(first == 3) {
        pos1c.x -= xvelocity;
        if(pos1c.x <= setCoordinate(4,c).x){
          first = 4;
          isFirstMoving = false;
        }
      }
      else if(first == 4) {
        pos1c.y -= yvelocity;
        if(pos1c.y <= setCoordinate(1,c).y){
          first = 1;
          isFirstMoving = false;
        }
      }
    }
    
    if(isSecondMoving){
      if(second == 1) {
        pos2c.x += xvelocity;
        if(pos2c.x >= setCoordinate(2,c).x){
          second = 2;
          isSecondMoving = false;
        }
      }
      else if(second == 2) {
        pos2c.y += yvelocity;
        if(pos2c.y >= setCoordinate(3,c).y){
          second = 3;
          isSecondMoving = false;
        }
      }
      else if(second == 3) {
        pos2c.x -= xvelocity;
        if(pos2c.x <= setCoordinate(4,c).x){
          second = 4;
          isSecondMoving = false;
        }
      }
      else if(second == 4) {
        pos2c.y -= yvelocity;
        if(pos2c.y <= setCoordinate(1,c).y){
          second = 1;
          isSecondMoving = false;
        }
      }
    }
    
  }
  
  private PVector setCoordinate(int pos, Cell c){
    return setVector(pos, c);
  }
  
  //------------------------------------------------------------------------------
  
  @Override // Clonable
  Picture pasteNew(){
    return new Squareish(first, second, colour);
  }
  
  @Override // Drawable
  void update(Cell c){
    if(keyPressed)
      isSecondMoving = isFirstMoving = true;
        
    if(key == 'a' && c.isOnCanvas)
      animate(c);  
    
    if(key == 'r' && !c.isOnCanvas)
      animate(c);
    
  }
  
  void display(){ // for cursor icon
    stroke(127);
    fill(colour);
    rect(x, y, _width, _height);
    fill(255 - colour);
    if(pos1 != null)
      rect(pos1.x, pos1.y , smallw, smallh);
    if(pos2 != null)
      rect(pos2.x, pos2.y , smallw, smallh);
  }
  
  @Override // Drawable
  void displayOnCell(Cell c){
      
    if(!initialized){
      initialized = true;
      xvelocity = c._width / 50.f;
      yvelocity = c._height / 50.f;
      
      smallwc = 3 * c._width / 10;
      smallhc = 3 * c._height / 10;
      
      pos1c = setVector(first, c);
      pos2c = setVector(second, c);
    }
    
    noStroke();
    fill(colour);
    rect(c.x, c.y, c._width, c._height);
    fill(255 - colour);
      if(pos1c != null)
    rect(pos1c.x, pos1c.y , smallwc, smallhc);
      if(pos2 != null)
    rect(pos2c.x, pos2c.y, smallwc, smallhc);
  }
  
  @Override // Drawable
  void displayOnCursor(){
    pushMatrix();
    
    translate(mouseX, mouseY);
    scale(0.3);
    translate(-pic._width / 2, -pic._height / 2);
    display();
    
    popMatrix();
  }
  
}
