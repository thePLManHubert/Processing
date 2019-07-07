Graph g;
float [] t; 
int [] w;

void setup(){
  size(1200, 400);
  
  g = new Graph(width, height);
  g.setColor(color(13,227,219));
  g.setColor(color(128,0,0));
  t = new float[width];
  w = new int[width];
  for(int i = 0; i < t.length; i++){
    t[i] = sin(i*TWO_PI/width*2 - HALF_PI) + 1;
  }
}

float k = 0;

void draw(){
  background(204);
  
  float kp = k;
  k = (-log10(-(99*mouseX/1199f-100))+2)*(mouseX/2);
  
  if(kp != k){
    for(int i = 0; i < t.length; i++){
      w[i] = (int)(t[i]*k);
    }
    g.loadValues(w);
  }

  g.display(w.length);
  fill(255);
  text(k, 20, 20);
}

float log10 (float x) {
  return (log(x) / log(10));
}
