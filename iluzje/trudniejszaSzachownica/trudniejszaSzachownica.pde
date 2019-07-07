int squaresNum = 15;
int side;
Square[] squares;
int frames = 0;
float f;

void setup(){
  size(750, 750);
  side = width / squaresNum;
  
  squares = new Square[squaresNum*squaresNum];
  int center = squaresNum / 2;
  
  for(int y = 0; y < squaresNum; y++){
    for(int x = 0; x < squaresNum; x++){   
      
      if(x < center && y < center || x > center && y > center)
        setSquare(x, y, 2, 4);
      else if(x > center && y < center || x < center && y > center)
        setSquare(x, y, 1, 3);
        
      else if(x == center && y < center)
        setSquare(x, y, 3, 4);
      else if(x == center && y > center)
        setSquare(x, y, 1, 2);
      else if(x < center && y == center)
        setSquare(x, y, 2, 3);
      else if(x > center && y == center)
        setSquare(x, y, 1, 4);
        
      else if(x == center && y == center)
        setSquare(x, y, 0, 0);       
    }
  }
  
}

void draw(){
  background(255);
  
  noStroke();
  
  for(int y = 0; y < squaresNum; y++){
    for(int x = 0; x < squaresNum; x++){   
      int idx = x+y*squaresNum;
      squares[idx].update();
      squares[idx].display();
    }
  }
  
  showFrameRate();
}

void setSquare(int x, int y, int p1, int p2){
  int idx = x+y*squaresNum;
  if(idx % 2 == 1)
        squares[idx] = new Square(x*side, y*side, side, p1, p2, 255);
      else
        squares[idx] = new Square(x*side, y*side, side, p1, p2, 0);
}

void showFrameRate(){
  if(++frames % 6 == 0)
  f = frameRate;
  
  textSize(24);
  fill(0xff, 0, 0);
  text(String.format("%.0f", f), 0, 20);
}
