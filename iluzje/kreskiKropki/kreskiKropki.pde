int stripe;
float d;
float space;
float m, n;
float maxScale;

void setup(){
  size(600, 400);
  //fullScreen();
  
  space = 20;
  stripe = 10;
  d = sqrt(2) * stripe;
  maxScale = 100f;
}

void draw(){
  background(0);
  
  if(mouseX != 0)
    space = 20 + mouseX * maxScale / width;
  n = height / space + 1;
  m = width / space + 1;
  
  stroke(153);
  strokeWeight(stripe);
  
  for(int y = 0; y < n; y++){
    float Y = y * space;
    line(0, Y, width, Y);
  } 
  for(int x = 0; x < m; x++){
    float X = x * space;
    line(X, 0, X, height);
  }
  for(int i = 0; i < m; i++){
    for(int j = 0; j < n; j++){
      noStroke();
      fill(255);
      ellipse(i*space, j*space, d, d);
    }
  }
}
