
void drawMCU(float x, float y, int pins, float _width, float _height, float tall,
             String text, float lineHeight, float lineLength){
  
  pushMatrix();
    translate(x*s, y*s);
    scale(0.25);
    
    pushMatrix();
      for(int i = 0; i < pins-1; i++){
        translate(1.5*8*s, 0);
      }
      translate(5*s, tall/2*s);
      drawPin();
    popMatrix();
    
    pushMatrix();
      translate(0, ((_height+tall)/2) *s);
      drawLine(lineLength, 2, lineHeight);
    popMatrix();
    
    drawPackage(_width, _height, tall);
    
    pushMatrix();
      translate(-8*s, (_height+tall/2) *s);
      for(int i = 0; i < pins; i++){
        drawPin();
        translate(1.5*8*s, 0);
      }   
    popMatrix();
    
  popMatrix();
  
  fill(255);
  PFont font = createFont("Arial Italic",12,true);
  textFont(font);
  textAlign(LEFT, TOP);
  textSize(4.1*s);
  text(text, (x+3)*s, y*s);
  
}

/*-----drawPackage()---------------------------------*/

void drawPackage(float posX, float posY, float _width, float _height, float tall){
  PShape p = createShape();
  int x = 0;
  int y = 0;
  p.beginShape();
  p.fill(40);
  p.noStroke();
  p.vertex(x, y);
  p.vertex((x+=_width+11) *s, y *s);
  p.vertex(x *s, (y+=tall) *s);
  p.vertex((x-=11) *s, (y+=_height) *s);
  p.vertex((x-=_width+11) *s, y *s);
  p.vertex(x *s, (y-=tall) *s);
  p.endShape(CLOSE); 
  shape(p, posX, posY);
  
  stroke(102);
  strokeWeight(1);
  line(-11*s, _height*s, _width*s, _height*s);
  line((_width+11)*s, 0, _width*s, _height*s);
  line(_width*s, _height*s, _width*s, (_height+tall)*s);
  
  pushMatrix();
    fill(255);
    noStroke();
    translate(-6.5*s, _height/2*s);
    ellipse(0, 0, 8*s, 10*s);
    fill(20);
  popMatrix();
  
  pushMatrix();
    translate(-3*s, _height/2*s);
    rotate(-PI/2.8);
    arc(0, 0, 10*s, 10*s, 0, PI, CHORD);
  popMatrix();
  
  pushMatrix();
    translate((_width-5)*s, (_height/2-1)*s);
    rotate(PI/3);
    fill(20);
    ellipse(0, 0, 8*s, 10*s);
  popMatrix();
  
  pushMatrix();
    translate((_width-4)*s, _height/2*s);
    rotate(PI/3);
    fill(55);
    ellipse(0, 0, 8*s, 10*s);
  popMatrix();
  
}

void drawPackage(float _width, float _height, float tall){
  drawPackage(0, 0, _width, _height, tall);
}

/*-----drawLine()----------------------------------*/

void drawLine(float len, float posY, float lineHeight){
  strokeCap(SQUARE);
  stroke(40); //<>//
  strokeWeight(lineHeight*s);
  line(0, posY*s, len*s, posY*s);
}

/*-----drawPin()-----------------------------------*/

void drawPin(float posX, float posY){
  PShape pin = createShape();
  int x = 0;
  int y = 0;
  pin.beginShape();
  pin.fill(127);
  pin.noStroke();
  pin.vertex(x *s, y *s);
  pin.vertex(x *s, (y+=6) *s);
  pin.vertex((x+=2) *s, (y+=4) *s);
  pin.vertex(x *s, (y+=10) *s);
  pin.vertex((x+=2) *s, (y+=2) *s);
  pin.vertex((x+=2) *s, (y-=2) *s);
  pin.vertex(x *s, (y-=10) *s);
  pin.vertex((x+=2) *s, (y-=4) *s);
  pin.vertex(x *s, (y-=6) *s);
  pin.endShape(CLOSE); 
  shape(pin, posX, posY);
}

void drawPin(){
  drawPin(0, 0);
}
