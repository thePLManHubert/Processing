
float angle = 0;
int startOne;
int startTwo;
int offset;

void setup(){
  size(600, 400);
  print(angle);
  
  startOne = height / 3;
  startTwo = startOne * 2;
  offset = 100;
}

void draw(){
  background(204);
  
  angle = HALF_PI*(mouseX - offset)/(width - 2*offset);
  if(angle > HALF_PI) angle = HALF_PI;
  if(angle < 0) angle = 0;
  
  fill(255);
  textSize(24);
  text(String.format("%.2f \u00b0",angle*180/PI), width/2-32, 32);

  strokeWeight(5);
  line(offset,startOne,width-offset,startOne);
  line(offset,startTwo,width-offset,startTwo);
  
  // left top
  pushMatrix();
  translate(offset,startOne);
  rotate(angle);
  line(0,0,50,0);  
  popMatrix();
  pushMatrix();
  translate(offset,startOne);
  rotate(-angle);
  line(0,0,50,0);
  popMatrix();
  
  //right top
  pushMatrix();
  translate(width-offset,startOne);
  rotate(PI-angle);
  line(0,0,50,0);
  popMatrix();
  pushMatrix();
  translate(width-offset,startOne);
  rotate(PI+angle);
  line(0,0,50,0);
  popMatrix();
  
  //left bottom
  pushMatrix();
  translate(offset,startTwo);
  rotate(PI-angle);
  line(0,0,50,0);
  popMatrix();
  pushMatrix();
  translate(offset,startTwo);
  rotate(PI+angle);
  line(0,0,50,0);
  popMatrix();
  
  //right bottom
  pushMatrix();
  translate(width-offset,startTwo);
  rotate(-angle);
  line(0,0,50,0);
  popMatrix();
  pushMatrix();
  translate(width-offset,startTwo);
  rotate(angle);
  line(0,0,50,0);
  popMatrix();
}
