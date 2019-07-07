enum Direction {N, E, S, W}

class Ant {
  int X, Y;
  Direction dir;
  int maxX, maxY;
  
  Ant() {
    this(width/2, height/2);
  }
  
  Ant(int x, int y){
    this(x, y, Direction.N);
  }
  
  Ant(int x, int y, Direction d){
    maxX = width;
    maxY = height;
    dir = d;
    setPosition(x, y);
  }
  
  void setPosition(int x, int y){
    X = x;
    Y = y;
  }
  
  void moveForward(){
    switch(dir){
      case N:
        Y--; if(Y < 0) Y = height - 1;
      break;
      case E: 
        X++; if(X >= width) X = 0;
      break;
      case S: 
        Y++; if(Y >= height) Y = 0;  
      break;
      case W: 
        X--; if(X < 0) X = width - 1;
      break;
    }
  }
  
  void turnLeft(){
    switch(dir){
      case N:
        dir = Direction.W;
      break;
      case E:
        dir = Direction.N;
      break;
      case S:
        dir = Direction.E;
      break;
      case W:
        dir = Direction.S;
      break;
    }
  }
  
  void turnRight(){
    switch(dir){
      case N:
        dir = Direction.E;
      break;
      case E:
        dir = Direction.S;
      break;
      case S:
        dir = Direction.W;
      break;
      case W:
        dir = Direction.N;
      break;
    }
  }
  
  
}
