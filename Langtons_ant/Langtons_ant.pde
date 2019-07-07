byte [][] grid;
Ant ant;
PImage ANT;

void setup() {
  //size(400, 400);
  fullScreen();
  grid = new byte[width][height];
  ant = new Ant();
  ANT = createImage(width, height, RGB);
  
  ANT.loadPixels();
  for(int i = 0; i < ANT.pixels.length; i++)
    ANT.pixels[i] = color(255);
  ANT.updatePixels();
}

void draw() {
  ANT.loadPixels();
  
  for(int i = 0; i < 10000; i++){
    byte state = grid[ant.X][ant.Y];
    
    if(state == 0){
      grid[ant.X][ant.Y] = 1;
      ant.turnRight();
    } else if (state == 1){
      grid[ant.X][ant.Y] = 0;
      ant.turnLeft();
    }
    
    color col = color(0);
    if(grid[ant.X][ant.Y] == 0)
      col = color(255);
    int pix = ant.X + ant.Y * width;
    ANT.pixels[pix] = col;
    
    ant.moveForward();
  }
  
  ANT.updatePixels();
  
  image(ANT, 0, 0);
}
