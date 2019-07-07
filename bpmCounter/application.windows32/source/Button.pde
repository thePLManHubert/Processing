class Button {
  int _width, _height;
  String _text;
  int x, y;
  boolean locked, pressed;
  ArrayList<ClickListener> listeners;
  int keyAttached;
  color hover, clicked, normal, current;
  
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
    hover = color(#6FE1FF);
    clicked = color(#0084A7);
    current = normal = color(#05B6E5);
  }
  
  void addClickListener(ClickListener cl){
    listeners.add(cl);
  }
  
  boolean overEvent() {
    if(mouseX > x && mouseX < x+_width
       && mouseY > y && mouseY < y +_height){
         return true;
       }
     return false;
  }
  
  void buttonAction(){
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
  
  void clickEvent(){
    for(ClickListener cl : listeners)
      cl.onClick();
  }
  
  void update(){
    buttonAction();
  }
  
  void display() {
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
  void onClick();
}
