import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Serial_Port extends PApplet {



Serial port;
Container container;
Graph graph;
float maxVoltage = 5f;
int resolution = 1023; // ADC resolution
int portValue = 0;

public void setup() {
  //fullScreen();
  
  noStroke();
  
  graph = new Graph(width, height, 20, maxVoltage, 10);
  container = new Container(width);
  
  for(String s : Serial.list()) println(s);
  port = new Serial(this, Serial.list()[1], 4800);
  
  new Thread(){
    public void run(){
      while(true){
        if(1 < port.available()){
            int t = port.read();
            portValue = t;
            portValue += port.read() << 8; 
          if(portValue > resolution){ // compensate with another byte of data
            portValue = ((portValue << 8) + port.read()) & 0xFF;
          }
        } 
        try{
          Thread.sleep(1);
        } catch(Exception ex){}
      }
    }
  }.start();
}
 
public void draw() {
  background(102);
  
  container.putValue( portValue );
  graph.loadValues(container.getValues());
  graph.display();
}
class Container {

  int [] values;
  int len = 0;
  
  Container(int size){
    values = new int[size];
  }

  public void putValue(int v){
    if(v > resolution)
      v = resolution;
    if(len < values.length){
      values[len] = v;
      len++;
    } else {
      for(int i = 0; i < values.length-1; i++){
        values[i] = values[i+1];
        values[len-1] = v;
      }
    }
  }
  
  public int [] getValues(){
    return values;
  }

}
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
  
  public void update(int maxValue){
    highestVoltage = maxVoltage * maxValue/resolution;
    if(mouseX < graph.w){
      mouseVoltage = maxVoltage*graph.values[mouseX]/resolution;
      h = g.h - (g.h-g.topMargin) * g.values[mouseX]/((maxValue == 0)?1:maxValue);
    }
  }
  
  public void display(int maxValue){
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
  public void settings() {  size(600, 275); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Serial_Port" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
