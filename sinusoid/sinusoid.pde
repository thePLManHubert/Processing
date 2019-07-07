float step = 5.0f / 60;
PVector v = new PVector(0, 0);
int limit = 1365;
PVector [] line = new PVector[2];
float c = 0;

void setup(){
  //fullScreen();
  size(1366, 400);
  background(0);
  
  resetLine(line);
}


void draw(){ 
  v.x += step;
  v.y = height/2 * -sin(6.28f * v.x / 500.0f) + height/2;
  
  c = 255 * v.x / limit;
  
  addPoint(line, v);

  stroke(255, 255 - c, c);
  line(line[0].x, line[0].y, line[1].x, line[1].y);
  
  if(v.x >= limit){
    background(0);
    resetLine(line);
    v.x = 0;
  }
}

void addPoint(PVector [] line, PVector point){
  line[0] = line[1];
  line[1] = point.copy();
}

void resetLine(PVector [] line){
  line[0] = new PVector(0, height/2);
  line[1] = new PVector(0, height/2);
}
