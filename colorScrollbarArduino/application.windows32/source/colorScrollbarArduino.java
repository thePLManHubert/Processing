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

public class colorScrollbarArduino extends PApplet {


// compatible with arduino colorScrollbarV2

ColorPicker cp;
Serial port;
HScrollbar red, green, blue;
byte [] values= new byte[4];
int r,g,b;
int modulo = 256; // liczba odcieni
int prescaler = 256/modulo;
Thread autoHSV, customRGB, customPicker;
boolean appStart = false;
Encoder encoder;
ColoredSquare square;
 
boolean rgbOn = false;
boolean hsvOn = false;
boolean pickerOn = false;
 
public void setup() { 
   
  red = new HScrollbar(0, 8, width, 16, 16);
  green = new HScrollbar(0, 58, width, 16, 16);
  blue = new HScrollbar(0, 108, width, 16, 16);
  square = new ColoredSquare(width/2 - 20, 108 + 20, 40, 40);
  encoder = new Encoder(60, 108+20, 30, 40, 1, 128);
  cp = new ColorPicker(0, 180, 260, 260, 0);
  print(Serial.list()[0]);
  port = new Serial(this, Serial.list()[0], 9600);
}

public void draw() { 
  background(255);

  pickMode();

  red.display();
  green.display();
  blue.display();
  
  updateValues();
  
  int rval = ((r != 255)?r/prescaler*prescaler:255);
  int gval = ((g != 255)?g/prescaler*prescaler:255);
  int bval = ((b != 255)?b/prescaler*prescaler:255);
  
  textAlign(LEFT, CENTER);
  text("Red: "   + rval,   5, 8+20);
  text("Green: " + gval,   5, 58+20);
  text("Blue: "  + bval,   5, 108+20);

  square.display(color(rval, gval, bval));
  
  fill(50);
  if(autoHSV != null)
    text(String.format("Speed: % .3f",((MyHSVThread)autoHSV).speed),  width - 100, 108 + 20);
  
  text("Presc: ", 20, 148);
  
  encoder.display();
  if(!hsvOn)
    cp.display();
}

public void updateValues(){
  prescaler = encoder.getValue();
  modulo = 256/prescaler;
}

public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(autoHSV != null)
    if(0 > e) ((MyHSVThread)autoHSV).increaseSpeed();
    else if (0 < e) ((MyHSVThread)autoHSV).decreaseSpeed();
}
 
public void pickMode(){
  if(appStart == false){
    appStart = true;
    rgbOn = true;
    customRGB = new MyRGBThread();
    customRGB.start(); 
  }
  
  if (keyPressed) {
    if (key == 'r') {
      if (!rgbOn) {
        square.changing = false;
        rgbOn = true;
        hsvOn = false;
        pickerOn = false;
        autoHSV = null;
        customPicker = null;
        customRGB = new MyRGBThread();
        customRGB.start();     
      }
    }
    if (key == 'p') {
      if (!pickerOn) {
        square.changing = false;
        pickerOn = true;
        rgbOn = false;
        hsvOn = false;
        autoHSV = null;
        customRGB = null;
        customPicker = new MyPickerThread();
        customPicker.start();     
      }
    }
    if (key == 'h') {
      if (!hsvOn) {
        square.changing = false;
        hsvOn = true;
        rgbOn = false;
        pickerOn = false;
        customRGB = null;
        customPicker = null;
        autoHSV = new IntHSVThread();
        autoHSV.start();
      }
    }
  }
}
public class ColorPicker 
{
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker(int x, int y, int w, int h, int c){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    init();
  }
  
  private void init(){
    cpImage = loadImage("pictures/palette.png");
  }
  
  public void display()
  {
    image( cpImage, x, y, w, h); 
    if(pickerOn){
      if(mouseX >= x && mouseX < x + w && mouseY >= y && mouseY < y + h ){
        if(mousePressed)
          c = get(mouseX, mouseY);
        int horiBound = (mouseX < width-16-10)?mouseX+10:mouseX-24;
        int vertBound = (mouseY < height-4)?mouseY-12:height-16-1;
        int over = get(mouseX, mouseY);
        fill(over);
        rect(horiBound, vertBound, 16, 16);
      } 
    } 
  }
}
class ColoredSquare {

  int x,y,w,h;
  int c, prevc, col;
  boolean pressed, changing;
  int val;
  float pr, pg, pb;
  
  ColoredSquare(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public boolean over(){
    if(mouseX >= x && mouseX < x+w && mouseY >= y && mouseY < y+h)
      return true;
      else return false;
  }
  
  public void update(int c){
    this.c = c;
  }
  
  public void display(int c){
    update(c);
    
    if(over() && mousePressed){
      if(!pressed){
        pressed = true;
        changing = true;
        
        rgbOn = false;
        hsvOn = false;
        pickerOn = false;
        
        autoHSV = null; 
        customRGB = null;
        customPicker = null;
        
        if((c & 0x00ffffff) != 0){
          prevc = c;
          col = 0;
          val = 1;
        }
        else {
          col = prevc;
          val = -1;
        }
      }
    }
    else if(!mousePressed) pressed = false;
      
    if(changing){
      int t = 0;
      
      if(r != (col & 0x00ff0000)>>>16){r-=val; t++;}
      if(g != (col & 0x0000ff00)>>>8){g-=val; t++;}
      if(b != (col & 0x000000ff)){b-=val; t++;}
      
      if(t == 0) changing = false;
      
      red.setColor(r,0,0);
      green.setColor(0,g,0);
      blue.setColor(0,0,b);
      
      values[0] = (r != 255)?(byte)(r/prescaler):(byte)255;
      values[1] = (g != 255)?(byte)(g/prescaler):(byte)255;
      values[2] = (b != 255)?(byte)(b/prescaler):(byte)255;
      values[3] = (byte)modulo;
      port.write(values);
    }
    
    fill(c);
    rect(x, y, w, h);
  }

}
class Encoder {
  float x, y;
  float _width, _height;
  
  private int value;
  private int topConstraint, bottomConstraint;
  private int hover, clicked, normal;
  private int currentTop, currentBottom;
  private boolean lockedTop, lockedBottom;
  private float wdiv2;
  private float hdiv3;
  
  Encoder(float x, float y, float w, float h, int bc, int tc){
    modifySettings(x, y, w, h);
    topConstraint = tc;
    bottomConstraint = bc;
    value = bc;
    hover = color(0xff6FE1FF);
    clicked = color(0xff0084A7);
    currentTop = currentBottom = normal = color(0xff05B6E5);
  }
  
  public int getValue(){
    return value;
  }
  
  public void modifySettings(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    wdiv2 = w / 2;
    hdiv3 = h / 3;
  }
  
  public void update(){
    if(mouseOverTop() && !mousePressed){
      lockedTop = false;
      currentTop = hover;
    }
    else if(mouseOverTop() && mousePressed){
      if(!lockedTop){
        lockedTop = true;
        currentTop = clicked;
        onTopPressed();
      }
    }
    else {
      if(!mousePressed)
        lockedTop = false;
      currentTop = normal;
    }
    
    if(mouseOverBottom() && !mousePressed){
      lockedBottom = false;
      currentBottom = hover;
    }
    else if(mouseOverBottom() && mousePressed){
      if(!lockedBottom){
        lockedBottom = true;
        currentBottom = clicked;
        onBottomPressed();
      }    
    }
    else {
      if(!mousePressed)
        lockedBottom = false;
      currentBottom = normal;
    }
  }
  
  public void onTopPressed(){
    if(value < topConstraint)
      value*=2;
  }
  
  public void onBottomPressed(){
    if(value > bottomConstraint)
      value/=2;
  }
  
  private boolean mouseOverTop(){
    if(mouseX >= x && mouseX <= x + _width &&
       mouseY >= y && mouseY <= y + _height / 3)
       return true;
    return false;
  }
  
  private boolean mouseOverBottom(){
    if(mouseX >= x && mouseX <= x + _width &&
       mouseY >= y + 2 * _height / 3 && mouseY <= y + _height)
       return true;
    return false;
  }
  
  public void display(){
    update();
    
    stroke(240);
    
    fill(240);
    rect(x, y + hdiv3, _width, hdiv3);
    
    fill(currentTop);
    triangle(x, y + hdiv3, x + wdiv2, y, x + _width, y + hdiv3);
    
    fill(currentBottom);
    triangle(x, y + 2 * hdiv3, x + wdiv2, y + _height, x + _width, y + 2 * hdiv3);
    
    fill(0);
    textSize((wdiv2 < hdiv3) ? wdiv2 : hdiv3);
    textAlign(CENTER, CENTER);
    text(value, x + wdiv2, y + _height / 2);
  }
  
}
class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  int r,g,b;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = 0;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  public void setColor(int red, int green, int blue){
    r = red;
    g = green;
    b = blue;
  }
  
  public void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    } 
  }

  public float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    noStroke();
    fill(r,g,b);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(70, 70, 70);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  public float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
class IntHSVThread extends MyHSVThread {
  int cases = 0;
  float cumulation = 0;
  
  IntHSVThread(){
    r = 255;
  }
  
  public void increaseSpeed(){
    if (speed < 0.5f)
      speed += 0.001f;
  }
  
  public void decreaseSpeed(){
    if (speed > -0.0f)
      speed -= 0.001f;
  }
  
  public void run(){
    while (hsvOn) {
      
      int rp = r;
      int gp = g;
      int bp = b;
      
      cumulation += speed;
      
      if(cumulation >= 1){
        switch(cases){
          case 0:
            g += 1;
            if(g == 255) cases = 1;
          break;
          case 1:
            r -= 1;
            if(r == 0) cases = 2;
          break;
          case 2:
            b += 1;
            if(b == 255) cases = 3;
          break;
          case 3:
            g -= 1;
            if(g == 0) cases = 4;
          break;
          case 4:
            r += 1;
            if(r == 255) cases = 5;
          break;
          case 5:
            g += 1;
            if(g == 255) cases = 6;
          break;
          case 6:
            g -= 1;
            if(g == 0) cases = 7;
          break;
          case 7:
            b -= 1;
            if(b == 0) cases = 0;
          break;
        }
        cumulation = 0;
      }

      red.setColor(r,0,0);
      green.setColor(0,g,0);
      blue.setColor(0,0,b);
      
      values[0] = (r != 255)?(byte)(r/prescaler):(byte)255;
      values[1] = (g != 255)?(byte)(g/prescaler):(byte)255;
      values[2] = (b != 255)?(byte)(b/prescaler):(byte)255;
      values[3] = (byte)modulo;
      
      if(rp != r || gp != g || bp != b)
        port.write(values);
      try{
        Thread.sleep(1);
      }catch(Exception ex){}
    }
  }
}
class MyHSVThread extends Thread {
  float H = 0, S = 1, V = 1;
  
  float speed = 0.1f;
  
  public void increaseSpeed(){
    if (speed < 0.5f)
      speed += 0.001f;
  }
  
  public void decreaseSpeed(){
    if (speed > -0.5f)
      speed -= 0.001f;
  }
  
  public void run(){
    while (hsvOn) {
      
      float C = V*S;
      float hh = H/60;
      float X = C*(1-abs(hh%2 - 1));
      float Rx, Gx, Bx;
      Rx = Gx = Bx = 0;
      if ( hh>=0 && hh<1 ) {
        Rx = C;
        Gx = X;
      } else if ( hh>=1 && hh<2 ) {
        Rx = X;
        Gx = C;
      } else if ( hh>=2 && hh<3 ) {
        Gx = C;
        Bx = X;
      } else if ( hh>=3 && hh<4 ) {
        Gx = X;
        Bx = C;
      } else if ( hh>=4 && hh<5 ) {
        Rx = X;
        Bx = C;
      } else {
        Rx = C;
        Bx = X;
      }
      
      float m = V - C;
      Rx = 255*(Rx + m);
      Gx = 255*(Gx + m);
      Bx = 255*(Bx + m);

      int rp = r;
      int gp = g;
      int bp = b;
      
      r = (int)Rx;
      g = (int)Gx;
      b = (int)Bx;
      
      H = (((H + speed) % 360) + 360) % 360;

      red.setColor(r,0,0);
      green.setColor(0,g,0);
      blue.setColor(0,0,b);
      
      values[0] = (r != 255)?(byte)(r/prescaler):(byte)255;
      values[1] = (g != 255)?(byte)(g/prescaler):(byte)255;
      values[2] = (b != 255)?(byte)(b/prescaler):(byte)255;
      values[3] = (byte)modulo;
      
      if(rp != r || gp != g || bp != b)
        port.write(values);
      try{
        Thread.sleep(1);
      }catch(Exception ex){}
    }
  }
}
class MyPickerThread extends Thread {
  
  public void run(){
    while (pickerOn) {
      
      int rp = r;
      int gp = g;
      int bp = b;
      
      r = (cp.c & 0x00ff0000)>>>16;
      g = (cp.c & 0x0000ff00)>>>8;
      b = cp.c & 0x000000ff;
      
      red.setColor(r,0,0);
      green.setColor(0,g,0);
      blue.setColor(0,0,b);
      
      values[0] = (r != 255)?(byte)(r/prescaler):(byte)255;
      values[1] = (g != 255)?(byte)(g/prescaler):(byte)255;
      values[2] = (b != 255)?(byte)(b/prescaler):(byte)255;
      values[3] = (byte)modulo;
      
      if(rp != r || gp != g || bp != b)
        port.write(values);
      try{
        Thread.sleep(1);
      }catch(Exception ex){}
    }
  }
}
class MyRGBThread extends Thread {
  
  public void run(){
    while (rgbOn) {
      red.update();
      green.update();
      blue.update();
      
      int rp = r;
      int gp = g;
      int bp = b;
      
      r = (int)map(red.getPos(),   1, width-2, 0, 255);
      g = (int)map(green.getPos(), 1, width-2, 0, 255);
      b = (int)map(blue.getPos(),  1, width-2, 0, 255);
      
      red.setColor(r,0,0);
      green.setColor(0,g,0);
      blue.setColor(0,0,b);
      
      values[0] = (r != 255)?(byte)(r/prescaler):(byte)255;
      values[1] = (g != 255)?(byte)(g/prescaler):(byte)255;
      values[2] = (b != 255)?(byte)(b/prescaler):(byte)255;
      values[3] = (byte)modulo;
      
      if(rp != r || gp != g || bp != b)
        port.write(values);
      try{
        Thread.sleep(1);
      }catch(Exception ex){}
    }
  }
}
  public void settings() {  size(260, 440); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "colorScrollbarArduino" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
