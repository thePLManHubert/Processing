class IntHSVThread extends MyHSVThread {
  int cases = 0;
  float cumulation = 0;
  
  IntHSVThread(){
    r = 255;
  }
  
  void increaseSpeed(){
    if (speed < 0.5f)
      speed += 0.001;
  }
  
  void decreaseSpeed(){
    if (speed > -0.0f)
      speed -= 0.001;
  }
  
  void run(){
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
