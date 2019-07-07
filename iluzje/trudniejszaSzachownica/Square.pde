class Square{

  //  ______
  // |1    2| 0 <- not displayed
  // |      |
  // |4    3|
  //  ------
  
  float x, y; // position on screen
  float side; // length of the side
  int pos1, pos2; // positions of two little squares inside
                  // according to the top image
  int colour;
  
  private boolean isMoving;
  private float smallOnex, smallOney;
  private float smallTwox, smallTwoy;
  private float smallSide;
  
  private float velocity;
  
  
  Square(int x, int y, int side, int pos1, int pos2, int colour){
    this.x = x;
    this.y = y;
    this.side = side;
    this.pos1 = pos1;
    this.pos2 = pos2;
    this.colour = colour;
    velocity = side / 50f;
    isMoving = false;
    smallSide = 3 * side / 10;
    setPositionsRelative();    
  }
  
  void update(){
    if(keyPressed)
      isMoving = true;
      
      moveSquares();
  }
  
  void display(){
    fill(colour);
    rect(x, y, side, side);   
    fill(255 - colour);
    if(pos1 != 0)
      rect(smallOnex, smallOney, smallSide, smallSide);
    if(pos2 != 0)
      rect(smallTwox, smallTwoy, smallSide, smallSide);
  }
  
  void setPositionsRelative(){
    smallOnex = setCoordinate(pos1).x;
    smallOney = setCoordinate(pos1).y;
    smallTwox = setCoordinate(pos2).x;
    smallTwoy = setCoordinate(pos2).y;
  }
  
  private void moveSquares(){
    if(isMoving){
      if(pos1 == 1) {
        smallOnex += velocity;
        if(smallOnex >= setCoordinate(2).x)
          pos1 = 2;
      }
      else if(pos1 == 2) {
        smallOney += velocity;
        if(smallOney >= setCoordinate(3).y)
          pos1 = 3;
      }
      else if(pos1 == 3) {
        smallOnex -= velocity;
        if(smallOnex <= setCoordinate(4).x)
          pos1 = 4;
      }
      else if(pos1 == 4) {
        smallOney -= velocity;
        if(smallOney <= setCoordinate(1).y)
          pos1 = 1;
      }
      
      if(pos2 == 1) {
        smallTwox += velocity;
        if(smallTwox >= setCoordinate(2).x){
          pos2 = 2;
          isMoving = false;
        }
      }
      else if(pos2 == 2) {
        smallTwoy += velocity;
        if(smallTwoy >= setCoordinate(3).y){
          pos2 = 3;
          isMoving = false;
        }
      }
      else if(pos2 == 3) {
        smallTwox -= velocity;
        if(smallTwox <= setCoordinate(4).x){
          pos2 = 4;
          isMoving = false;
        }
      }
      else if(pos2 == 4) {
        smallTwoy -= velocity;
        if(smallTwoy <= setCoordinate(1).y){
          pos2 = 1;
          isMoving = false;
        }
      }
    }
  }
  
  private PVector setCoordinate(int pos){
    float t = 2 * velocity;
    if(pos == 1){
      return new PVector(x+t, y+t);
    }
    else if (pos == 2){
      return new PVector(x+side-smallSide-t, y+t);
    }
    else if (pos == 3){
      return new PVector(x+side-smallSide-t, y+side-smallSide-t);
    }
    else if (pos == 4){
      return new PVector(x+t, y+side-smallSide-t);
    }
    return new PVector();
  }
  
}
