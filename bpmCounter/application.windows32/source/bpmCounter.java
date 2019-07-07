import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.logging.*; 
import org.jnativehook.*; 
import org.jnativehook.keyboard.*; 

import org.jnativehook.*; 
import org.jnativehook.dispatcher.*; 
import org.jnativehook.example.*; 
import org.jnativehook.keyboard.*; 
import org.jnativehook.mouse.*; 
import dev.hkor.Window.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class bpmCounter extends PApplet {





Button b, r;
Counter c, bpm;
int keyCaptured;
Encoder encoder;

public void setup() {
  
  surface.setAlwaysOnTop(true);
  
  encoder = new Encoder(width - 120, 10, 48, 72, 2, 60, 20);
  bpm = new BpmConstraintCounter(encoder.getValue());
  
  b = new Button(         20, 120, 100, 60, "Count", NativeKeyEvent.VC_B);
  r = new Button(width - 120, 120, 100, 60, "Reset", NativeKeyEvent.VC_R);
  b.addClickListener(((BpmConstraintCounter)bpm).new CountButtonAdapter());
  r.addClickListener(((BpmConstraintCounter)bpm).new ResetButtonAdapter());  
  
  LogManager.getLogManager().reset();
  Logger logger = Logger.getLogger(GlobalScreen.class.getPackage().getName());
  logger.setLevel(Level.OFF);
  
  try {
      GlobalScreen.registerNativeHook();
      GlobalScreen.addNativeKeyListener(new NativeKeyAdapter(){
        @Override
        public void nativeKeyPressed(NativeKeyEvent nativeEvent){
          keyCaptured = nativeEvent.getKeyCode();
        }
      });
    } catch (NativeHookException e){}
}

public void draw() {
  background(180);
  
  b.display();
  r.display();
  
  textSize(20);
  textAlign(LEFT, CENTER);
  text(((BpmConstraintCounter)bpm).getBpm(), 20, 20);
  text(((BpmConstraintCounter)bpm).getAvg(), 20, 60);
  text(((BpmConstraintCounter)bpm).times.length , width - 50, 45);
  
  encoder.display();
}
class BpmCounter extends Counter {
  float bpm, avg;
  long currentTime, prevTime, startTime;
  
  public void countBps(){
    if(count == 0) {
      startTime = prevTime = currentTime = System.currentTimeMillis();
    }
    else {
      currentTime = System.currentTimeMillis();
      bpm = 60000.f / (currentTime - prevTime);
      avg = 60000.f * count / (currentTime - startTime);
      prevTime = currentTime;
    }
    count++;
  }
  
  public String getBpm() {
    if(bpm == 0)
      return "Start";
    return String.format("Bpm: %.2f", bpm);
  }
    
  public String getAvg(){
    if(avg == 0)
      return "Start";
    return String.format("Avg:  %.2f", avg);
  }
  
  public @Override
  void reset(){
    super.reset();
    bpm = avg = 0.f;
  }
  
  class CountButtonAdapter implements ClickListener {
    public @Override
    void onClick(){
      countBps();
    }
  }

}

class BpmConstraintCounter extends BpmCounter {
  int current;
  long [] times;
  
  BpmConstraintCounter(int samples){
    times = new long[samples];
    current = 0;
  }
  
  public @Override
  void countBps(){
    if(count == 0) {
      times[0] = prevTime = currentTime = System.currentTimeMillis();
    }
    else {  
      
      if(current < times.length - 1){
        current++;
      }
      else {
        for(int i = 1; i < times.length; i++)
          times[i-1] = times[i];
      }
      
      times[current] = currentTime = System.currentTimeMillis();
      bpm = 60000.f / (currentTime - prevTime);
      
      avg = 60000.f * current / (times[current] - times[0]);
      prevTime = currentTime;
    }
    
    count++;
  }
  
  public @Override
  void reset(){
    super.reset();
    times = new long[encoder.getValue()];
    current = 0;
  }
  
}
class Button {
  int _width, _height;
  String _text;
  int x, y;
  boolean locked, pressed;
  ArrayList<ClickListener> listeners;
  int keyAttached;
  int hover, clicked, normal, current;
  
  public Button(int x, int y, int w, int h, String txt, int ka) {
    _width = w;
    _height = h;
    _text = txt;
    this.x = x;
    this.y = y;
    locked = false; //mouse
    pressed = false; //keyboard
    keyAttached = ka;
    listeners = new ArrayList<ClickListener>();
    hover = color(0xff6FE1FF);
    clicked = color(0xff0084A7);
    current = normal = color(0xff05B6E5);
  }
  
  public void addClickListener(ClickListener cl){
    listeners.add(cl);
  }
  
  public boolean overEvent() {
    if(mouseX > x && mouseX < x+_width
       && mouseY > y && mouseY < y +_height){
         return true;
       }
     return false;
  }
  
  public void buttonAction(){
    if(keyAttached == keyCaptured){
      current = clicked;
      keyCaptured = 0;
      clickEvent();
    }
    else if(overEvent() && !mousePressed){
      locked = false;
      current = hover;
    }
    else if(overEvent() && mousePressed){
      if(!locked){
        locked = true;
        current = clicked;
        clickEvent();
      }
    }
    else {
      if(!mousePressed)
        locked = false;
      current = normal;
    }
  }
  
  public void clickEvent(){
    for(ClickListener cl : listeners)
      cl.onClick();
  }
  
  public void update(){
    buttonAction();
  }
  
  public void display() {
    update();
    
    fill(current);
    rect(x, y, _width, _height);
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(_text, x + _width/2, y + _height/2);
  }
}

interface ClickListener {
  public void onClick();
}
class Counter {
  int count;
  
  public Counter(){}
  
  public void count(){
    count++;
  }
  
  public void reset(){
    count = 0;
  }
  
  class CountButtonAdapter implements ClickListener {
    public @Override
    void onClick(){
      count();
    }
  }
  
  class ResetButtonAdapter implements ClickListener {
    public @Override
    void onClick(){
      reset();
    }
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
  
  Encoder(float x, float y, float w, float h, int bc, int tc, int val){
    modifySettings(x, y, w, h);
    if(val >= bc && val <= tc)
      value = val;
    else value = bc;
    
    topConstraint = tc;
    bottomConstraint = bc;
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
    performAction();
  }
  
  public void performAction(){
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
      value++;
  }
  
  public void onBottomPressed(){
    if(value > bottomConstraint)
      value--;
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
  public void settings() {  size(350, 200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "bpmCounter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
