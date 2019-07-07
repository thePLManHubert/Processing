import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class nibyKwadrat extends PApplet {

IllusionModel im;

public void setup(){
  
  im = new IllusionModel(0, 0);
}

public void draw(){
  background(0);
  
  translate(width/2, height/2);
  im.display();
}

class Square {
  float x, y;
  float _width, _height;
  int c;
  
  Square(float x, float y, float w, float h, int c){
    this.x = x;
    this.y = y;
    this.c = c;
    _width = w;
    _height = h;
  }
  
  public void display(){
    noStroke();
    fill(c);
    rect(x, y, _width, _height);
  }
}

enum Orientation {vertical, horizontal}

class Lines {
  float x, y, _length;
  float x1, y1, x2, y2;
  float separation;
  float speed;
  Orientation orientation;
  
  Lines(float x, float y, float l, float separation, Orientation o, float startPoint, float speed){   
    this.x = x;
    this.y = y;
    _length = l;
    this.separation = separation;
    orientation = o;
    this.speed = speed;
    
    init(startPoint);
  }
  
  private void init(float startPoint){
    
    if(orientation == Orientation.vertical){
      x1 = x2 = x + startPoint;
      y1 = y;
      y2 = y + _length;
    }
    else if(orientation == Orientation.horizontal){
      y1 = y2 = y + startPoint;
      x1 = x;
      x2 = x + _length;
    }
  }
  
  public void update(){
    move();
  }
  
  public void display(){
    update();
    strokeWeight(2);
    stroke(255);
    line(x1, y1, x2, y2);
    
    if(orientation == Orientation.vertical){
      line(x1 + separation, y1, x2 + separation, y2);
    }
    else if(orientation == Orientation.horizontal){
      line(x1, y1 + separation, x2, y2 + separation);
    }
  }
  
  public void move(){
    if(orientation == Orientation.vertical){
      x1 += speed;
      x2 += speed;
      if(x1 <= x + 0 || x1 >= x + 50){
        speed *= -1;
      }
    }
    else if(orientation == Orientation.horizontal){
      y1 += speed;
      y2 += speed;
      if(y1 <= y + 0 || y1 >= y + 50){
        speed *= -1;
      }
    }
  }
}

class IllusionModel {
  float x, y;
  Square [] squares;
  Lines l1, l2;
  
  IllusionModel(float x, float y){
    squares = new Square[4];
    squares[0] = new Square(-100 + x, -100 + y, 50, 50, color(255,255,0));
    squares[1] = new Square(50 + x, -100 + y, 50, 50, color(255,255,0));
    squares[2] = new Square(-100 + x, 50 + y, 50, 50, color(255,255,0));
    squares[3] = new Square(50 + x, 50 + y, 50, 50, color(255,255,0));
  
    l1 = new Lines(-50 + x, -100 + y, 100, 150, Orientation.horizontal, 0, 1);
    l2 = new Lines(-100 + x, -50 + y, 100, 150, Orientation.vertical, 25, 1);
  }
  
  public void display(){
    pushMatrix();
    float angle = map(mouseX, 0, width, 0, TWO_PI);
    rotate(angle);
    
    l1.display();
    l2.display();
    
    if(!mousePressed){   
      for(Square square : squares)
        square.display();
    }
    popMatrix();
  }
  
}
  public void settings() {  size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "nibyKwadrat" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
