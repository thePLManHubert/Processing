PVector center;
int partAngle;

void setup(){
  size(400, 400);
  frameRate(5);
  
  center = new PVector(width/2, height/2);
  partAngle = 360 / 12;
}

int current = 0;

void draw(){
  background(178);  
  translate(center.x, center.y);
  
  noStroke();
  
  for(int i = 0; i < 12; i++){
    pushMatrix();
    rotate(radians(partAngle * i));
    fill(0xF2, 0x27, 0xF3);
    if(i != current)
      ellipse(0, 120, 21, 21);
    popMatrix();   
  }
  filter(BLUR, 4);
  current = (++current) % 12;
  
  stroke(0);
  strokeWeight(2);
  line(0, -5, 0, 5);
  line(-5, 0, 5, 0);
}
