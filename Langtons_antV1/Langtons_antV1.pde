byte [][] grid;
Ant ant;

void setup() {
  //size(400, 400);
  fullScreen();
  grid = new byte[width][height];
  ant = new Ant();
}

void draw() {
  for(int i = 0; i < 10000; i++){
    byte state = grid[ant.X][ant.Y];
    
    if(state == 0){
      grid[ant.X][ant.Y] = 1;
      ant.turnRight();
    } else if (state == 1){
      grid[ant.X][ant.Y] = 0;
      ant.turnLeft();
    }
    ant.moveForward();
  }
  
  drawPixels();
  //noLoop();
}

void drawPixels(){
  loadPixels();
  for(int j = 0; j < height; j++) {
    for(int i = 0; i < width; i++) {
      int pix = i + j * width;
      if(grid[i][j] == 0)  
        pixels[pix] = color(255);
        else pixels[pix] = color(0);
    }
  }
  updatePixels();
}
