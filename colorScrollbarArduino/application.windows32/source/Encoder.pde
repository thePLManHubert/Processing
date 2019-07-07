class Encoder {
  float x, y;
  float _width, _height;
  
  private int value;
  private int topConstraint, bottomConstraint;
  private color hover, clicked, normal;
  private color currentTop, currentBottom;
  private boolean lockedTop, lockedBottom;
  private float wdiv2;
  private float hdiv3;
  
  Encoder(float x, float y, float w, float h, int bc, int tc){
    modifySettings(x, y, w, h);
    topConstraint = tc;
    bottomConstraint = bc;
    value = bc;
    hover = color(#6FE1FF);
    clicked = color(#0084A7);
    currentTop = currentBottom = normal = color(#05B6E5);
  }
  
  int getValue(){
    return value;
  }
  
  void modifySettings(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    wdiv2 = w / 2;
    hdiv3 = h / 3;
  }
  
  void update(){
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
  
  void onTopPressed(){
    if(value < topConstraint)
      value*=2;
  }
  
  void onBottomPressed(){
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
  
  void display(){
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
