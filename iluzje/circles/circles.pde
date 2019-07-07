int hori;
int ver;
float d;
float space;
float center;
float angle;

void setup(){
  size(600, 400);
  //fullScreen();
  angle = 0;
  d = 30;
  space = 15;
  center = d/2;
  hori = floor(width / (d+space));
  ver = floor(height / (d+space));
}

void draw(){ 
  background(128,179,0);

  translate(5, 5);
  noStroke();
  
  angle = TWO_PI * mouseX / width;
  
  for(int y = 0; y < ver; y++){
    float Y = y*(d+space)+center;
    
    for(int x = 0; x < hori; x++){
      float X = x*(d+space)+center;
      
      float a = y*angle/ver + x*angle/hori;
      
      pushMatrix();
      translate(X, Y);
      rotate(a);     
      fill(255);
      ellipse(0, 4, d, d);
      popMatrix();
      
      pushMatrix();
      translate(X, Y);
      rotate(a);     
      fill(0);
      ellipse(0, -4, d, d);
      popMatrix();
      
      pushMatrix();
      fill(0, 0, 255);
      ellipse(X, Y, d, d);
      popMatrix();
    }
  }
  
}
