class ColoredSquare {

  int x,y,w,h;
  color c, prevc, col;
  boolean pressed, changing;
  int val;
  float pr, pg, pb;
  
  ColoredSquare(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  boolean over(){
    if(mouseX >= x && mouseX < x+w && mouseY >= y && mouseY < y+h)
      return true;
      else return false;
  }
  
  void update(color c){
    this.c = c;
  }
  
  void display(color c){
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
