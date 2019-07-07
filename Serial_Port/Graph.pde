class Graph {
  
  int w, h;
  float pW, pH;
  int topMargin;
  int [] values;
  Scale scale;
  
  public Graph(int w, int h, int topMargin, float voltage, int levels){
    this.w = w;
    this.h = h;
    this.topMargin = topMargin;
    scale = new Scale(this, voltage , levels, 60);
  }
  
  public void loadValues(int [] values){
    if(values != null){
      pW = (float)w/values.length;
      pH = (float)(h-topMargin)/max(values);
      this.values = values;
    }
  }
  
  public void display(int mostRightIndex){
    noStroke();
    if(values != null){
      for(int i = 0; i < mostRightIndex; i++){
        fill(0, 255*values[i]/resolution, 51);
        float t = pH*values[i];
        rect(pW*i, h-t, pW, t);
      }
      scale.display(max(values));
    } 
  }
  
  public void display(){
    if(values != null){
      display(values.length);
    }
  }
  
}
