float angle = 0;
float r = 140;
int parts = 180;
float frag = TWO_PI / parts;
int lineLength = 150;
float [][] pos;

void setup(){
  size(400, 400);
  //frameRate(20);
  colorMode(HSB, 360, 100, 100);
  stroke(0);
  translate(width/2, height/2);
  line(0,lineLength,0,-lineLength);
  line(lineLength,0,-lineLength,0);
  stroke(255);
  
  pos = new float[parts][2];
  for(int i = 0; i < parts; i++){
    pos[i][0] = cos(angle);
    pos[i][1] = sin(angle);
    angle += frag;
  }
  angle = 0;
}

int i = 0;
float c = 0;
int speed = 4;

void draw(){
  translate(width/2, height/2);
  
  for(int k = 0; k < speed; k++){           
    c = (c + 360/parts) % 360;
    fill(c, 100, 100);
    stroke(c, 100, 100);
    
    ellipse(r*pos[i][0], r*pos[i][1], 20, 20);
    i = ++i % parts;
    
    angle += frag;
    
    r -= 360/parts * 0.1;
    if(r < 0) noLoop();
  }
}
