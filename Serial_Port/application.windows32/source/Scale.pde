class Scale {

  Graph g;
  float maxVoltage;
  int levels;
  int timeScale;
  float highestVoltage;
  float mouseVoltage;
  int h;
  
  Scale(Graph graph, float maxVoltage, int levels, int timeScale){
    g = graph;
    this.maxVoltage = maxVoltage;
    this.levels = levels;
    this.timeScale = timeScale;
  }
  
  void update(int maxValue){
    highestVoltage = maxVoltage * maxValue/resolution;
    if(mouseX < graph.w){
      mouseVoltage = maxVoltage*graph.values[mouseX]/resolution;
      h = g.h - (g.h-g.topMargin) * g.values[mouseX]/((maxValue == 0)?1:maxValue);
    }
  }
  
  void display(int maxValue){
    update(maxValue);
    stroke(255);
    
    //horizontal lines
    for(int v = 0; v <= levels; v++){
      float h = (float)resolution/maxValue * (g.h-g.topMargin) * v/levels;
      line(0, g.h-h, g.w, g.h-h);
      fill(0);
      text(maxVoltage * v/levels, 10, g.h-h-2);
    }
    
    //vertical lines
    line(0, 0, 0, g.h);
    for(int t = timeScale; t <= graph.w; t+=timeScale){
      line(t, 0 + g.topMargin, t, g.h);
    }
    
    //voltage measurements
    fill(255);
    text(String.format("Max %.3f[V]", highestVoltage), 64, 14);
    text(String.format("Curr %.3f[V]", maxVoltage*portValue/resolution), 184, 14);
    
    //pointer and tracker
    text(String.format("%.3f[V]", mouseVoltage), mouseX+2, mouseY);
    fill(255, 0, 0);
    ellipse(mouseX, h, 3, 3);
    line(mouseX, g.h, mouseX, h+1);
  }
  
}
