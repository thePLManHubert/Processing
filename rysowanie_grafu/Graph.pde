class Graph {
  
  int w, h;
  color c;
  float pW, pH;
  int [] values;
  
  public Graph(int w, int h){
    this.w = w;
    this.h = h;
    c = color(0,0,255);
  }
  
  public void setColor(int c){
    this.c = c;
  }
  
  public void loadValues(int [] values){
    if(values != null){
      pW = (float)w/values.length;
      pH = (float)h/max(values);
      this.values = values;
    }
  }
  
  public void update(int value){
    if(values != null){
      for(int i = 0; i < value; i++){
        rect(pW*i, h-pH*values[i], pW, pH*values[i]);
      }
    }
  }
  
  public void display(int value){
    fill(c);
    noStroke();
    update(value);
  }
  
}
