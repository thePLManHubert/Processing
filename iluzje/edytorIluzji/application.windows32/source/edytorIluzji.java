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

public class edytorIluzji extends PApplet {

Canvas canvas;
Panel panel;
MouseBag mb;
Picture pic;

public void setup(){
  //size(800, 470);
  
  int ver = 15;
  int hori = PApplet.parseInt(ver * 16/9.f * (1-ratio));
  
  canvas = new Canvas(hori, ver, false);
  panel = new Panel(14);
  mb = new MouseBag();
  mb.attachPicture(new Squareish(0, 0, 0));
  
  panel.add(new Squareish(1, 2, 0));
  panel.add(new Squareish(1, 3, 0));
  panel.add(new Squareish(1, 4, 0));
  panel.add(new Squareish(2, 3, 0));
  panel.add(new Squareish(2, 4, 0));
  panel.add(new Squareish(3, 4, 0));
  panel.add(new Squareish(0, 0, 0));
  panel.add(new Squareish(1, 2, 255));
  panel.add(new Squareish(1, 3, 255));
  panel.add(new Squareish(1, 4, 255));
  panel.add(new Squareish(2, 3, 255));
  panel.add(new Squareish(2, 4, 255));
  panel.add(new Squareish(3, 4, 255));
  panel.add(new Squareish(0, 0, 255));
}

public void draw(){
  background(153);
  noCursor();
  
  canvas.update();
  panel.update();
  
  canvas.display();
  panel.display(); 

  pic = mb.picture;
  pic.displayOnCursor();

}
float ratio = 1/5.f;

class Canvas {

  float _height, _width;
  int x, y;
  int n, m;
  Grid g;
  
  Canvas(int n, int m, boolean adjust){
    x = y = 0;
    this.n = n;
    this.m = m;
    setParams(adjust);
  }
  
  public void setParams(boolean adjust){
    _height = height;
    _width = (1 - ratio) * width;
    g = new Grid(x, y, _width, _height, m, n, adjust);
  }
  
  public void update(){
    g.update();
  }
  
  public void display(){
    g.display();
  }
  
}
class Cell {

  float _width, _height;
  float x, y;
  Picture picture;
  boolean isOnCanvas;
  
  Cell(Picture p){
    setPicture(p);
    isOnCanvas = false;
  }
  
  Cell(float x, float y, float w, float h, boolean canv){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    isOnCanvas = canv;
  }
  
  public void setPicture(Picture p){
    this._width = p._width;
    this._height = p._height;
    picture = p.pasteNew();
  }
  
  public void update(){
    
    if(keyPressed && key == DELETE){
      if(isOnCanvas)
        picture = null;
    }
    
    if(picture != null)
      picture.update(this);
      
    if(mouseOn()){
      if(mousePressed){
        if(mouseButton == RIGHT){
          mb.onRightClick(this);
        }
        if(mouseButton == LEFT){   
          mb.onLeftClick(this);
        }
      }
    }
    
  }
  
  public void display(){
    if(picture == null){
      stroke(153);
      fill(255);
      rect(x, y, _width, _height);
    }
    else
      picture.displayOnCell(this);
  }
  
  private boolean mouseOn(){
    if(mouseX >= x && mouseX <= x + _width
        && mouseY >= y && mouseY <= y + _height)
      return true;
    return false;
  }
  
}


interface Clickable {
  public void onLeftClick(Cell other);
  public void onRightClick(Cell other);
}
class Grid {

  float _width, _height;
  int rows, cols;
  int x, y;
  Cell [] cells;
  
  private float xLen, yLen;
  
  Grid(int x, int y, float w, float h, int r, int c, boolean adjust){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    rows = r; //y
    cols = c; //x
    cells = new Cell[r * c];
    setAdditional(adjust);
  }
  
  private void setAdditional(boolean adjust){
    if(adjust){
      xLen = _width / cols;
      yLen = _height / rows;
    }
    else {
      xLen = 50;
      yLen = 50;
    }
    setCells();
  }
  
  private void setCells(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx] = new Cell(j * xLen, i * yLen, xLen, yLen, true);
      }
    }
  }
  
  public void update(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx].update();
      }
    }
  }
  
  public void display(){
    for(int j = 0; j < cols; j++){
      for(int i = 0; i < rows; i++){
        int idx = i + j * rows;
        cells[idx].display();
      }
    }
  }

}
class MouseBag implements Clickable {
  
  Picture picture;
  
  MouseBag (){
    picture = null;
  }
  
  public void attachPicture(Picture p){
    picture = p.pasteNew();
  }
  
  public void detachPicture(){
    picture = null;
  }
  
  public boolean hasPicture(){
    if(picture == null)
      return false;
    return true;
  }
  
  public @Override
  void onLeftClick(Cell other){
    if(other.isOnCanvas){
      if(picture != null)
        other.picture = picture.pasteNew();
    }
    else{
      if(other.picture != null)
        picture = other.picture.pasteNew();
    }
  }
  
  public @Override
  void onRightClick(Cell other){
    if(other.isOnCanvas){
        other.picture = null;
    }
  }
      
}
class Panel {
  int x, y;
  float _width, _height;
  int total = 0;
  Cell [] cells;
  
  Panel(int num){
    y = 0;
    x = (int)((1 - ratio) * width);
    _height = height;
    _width = width * ratio;
    cells = new Cell[num];
  }
  
  public void add(Picture pic){
    cells[total] = new Cell(pic);
    //cells[total]._width = cells[total]._height = _width / 2 - 25;
    total++;
  }
  
  public void update(){
    for(int i = 0; i < total; i++)
      cells[i].update();
  }
  
  public void display(){
    fill(102);
    rect(x, y, _width, _height);
    
    for(int j = 0; j < 2; j++){
      for(int i = 0; i < cells.length / 2; i++){
        
        int idx = i + j * cells.length / 2;
        
        if(cells[idx] != null){
          
          cells[idx].x = j*cells[idx]._width + x + cells.length / 2 * (j+1); 
          cells[idx].y = i*cells[idx]._height + y + cells.length / 2 * (i+1);
          
          cells[idx].display();
        }
      }
    }
  }
  
}
abstract class Picture implements Clonable, Drawable {
  float x, y;
  float _width, _height;
}

interface Clonable {
  public Picture pasteNew();
}

interface Drawable {
  public void update(Cell c);
  public void displayOnCell(Cell c);
  public void displayOnCursor();
}
class Squareish extends Picture {
  int first, second;      // not modified
  
  float smallw, smallh;   // original value
  PVector pos1, pos2;     // original value
  
  float smallwc, smallhc; // for cells (modifications)
  PVector pos1c, pos2c;   // for cells (modifications)
  
  float velocity;
  int colour;
  boolean isMoving = false;
  boolean initialized = false;
  
  Squareish(int first, int second, int colour){
    this.x = 0;
    this.y = 0;
    _width = 50;
    _height = 50;
    velocity = 1.f;
    
    this.first = first;
    this.second = second;
    
    this.colour = colour;
    
    pos1 = new PVector();
    pos2 = new PVector();
    pos1c = new PVector();
    pos2c = new PVector();
    
    setAddition(first, second); // set once
  }
  
  public void setAddition(int first, int second){
    smallw = 3 * _width / 10;
    smallh = 3 * _height / 10;
    pos1 = setVector(first);
    pos2 = setVector(second);
  }
  
  public PVector setVector(int pos){ // for cursor icon
    float t = 2;
  
    if(pos == 1)
      return new PVector(x + t, y + t);
    else if(pos == 2)
      return new PVector(x + _width - smallw - t, y + t);
    else if(pos == 3)
      return new PVector(x + _width - smallw - t, y + _height - smallh - t);
    else if(pos == 4)
      return new PVector(x + t, y + _height - smallh - t);
    return null;
  }
  
  public PVector setVector(int pos, Cell c){ // for cells
    float gapX = 2 * c._width / 50;
    float gapY = 2 * c._height / 50;
    
    if(pos == 1)
      return new PVector(c.x + gapX, c.y + gapY);
    else if(pos == 2)
      return new PVector(c.x + c._width - smallw - gapX, c.y + gapY);
    else if(pos == 3)
      return new PVector(c.x + c._width - smallw - gapX, c.y + c._height - smallh - gapY);
    else if(pos == 4)
      return new PVector(c.x + gapX, c.y + c._height - smallh - gapY);
    return null;
  }
  
  public @Override // Clonable
  Picture pasteNew(){
    return new Squareish(first, second, colour);
  }
  
  public @Override // Drawable
  void update(Cell c){
    if(keyPressed && key != DELETE)
      isMoving = true; 
        
    if(c.isOnCanvas)
      animate(c);
  }
  
  //--------------------------------BEGIN-----------------------------------------
  
  /*------------------- Cell based values modifications---------------------------*/
  
  private void animate(Cell c){

    if(isMoving){
      if(first == 1) {
        pos1c.x += velocity;
        if(pos1c.x >= setCoordinate(2,c).x)
          first = 2;
      }
      else if(first == 2) {
        pos1c.y += velocity;
        if(pos1c.y >= setCoordinate(3,c).y)
          first = 3;
      }
      else if(first == 3) {
        pos1c.x -= velocity;
        if(pos1c.x <= setCoordinate(4,c).x)
          first = 4;
      }
      else if(first == 4) {
        pos1c.y -= velocity;
        if(pos1c.y <= setCoordinate(1,c).y)
          first = 1;
      }
      
      if(second == 1) {
        pos2c.x += velocity;
        if(pos2c.x >= setCoordinate(2,c).x){
          second = 2;
          isMoving = false;
        }
      }
      else if(second == 2) {
        pos2c.y += velocity;
        if(pos2c.y >= setCoordinate(3,c).y){
          second = 3;
          isMoving = false;
        }
      }
      else if(second == 3) {
        pos2c.x -= velocity;
        if(pos2c.x <= setCoordinate(4,c).x){
          second = 4;
          isMoving = false;
        }
      }
      else if(second == 4) {
        pos2c.y -= velocity;
        if(pos2c.y <= setCoordinate(1,c).y){
          second = 1;
          isMoving = false;
        }
      }
    }
  }
  
  private PVector setCoordinate(int pos, Cell c){
    return setVector(pos, c);
  }
  
  //------------------------------------------------------------------------------
  
  public void display(){
    stroke(127);
    fill(colour);
    rect(x, y, _width, _height);
    fill(255 - colour);
    if(pos1 != null)
      rect(pos1.x, pos1.y , smallw, smallh);
    if(pos2 != null)
      rect(pos2.x, pos2.y , smallw, smallh);
  }
  
  public @Override // Drawable
  void displayOnCell(Cell c){
      
    if(!initialized){
      initialized = true;
      
      smallwc = 3 * c._width / 10;
      smallhc = 3 * c._height / 10;
      
      pos1c = setVector(first, c);
      pos2c = setVector(second, c);
    }
    
    noStroke();
    fill(colour);
    rect(c.x, c.y, c._width, c._height);
    fill(255 - colour);
      if(pos1c != null)
    rect(pos1c.x, pos1c.y , smallwc, smallhc);
      if(pos2 != null)
    rect(pos2c.x, pos2c.y, smallwc, smallhc);
  }
  
  public @Override // Drawable
  void displayOnCursor(){
    pushMatrix();
    
    translate(mouseX, mouseY);
    scale(0.3f);
    translate(-pic._width / 2, -pic._height / 2);
    display();
    
    popMatrix();
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "edytorIluzji" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
