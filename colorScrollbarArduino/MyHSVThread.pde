class MyHSVThread extends Thread {
  float H = 0, S = 1, V = 1;
  
  float speed = 0.1;
  
  void increaseSpeed(){
    if (speed < 0.5f)
      speed += 0.001;
  }
  
  void decreaseSpeed(){
    if (speed > -0.5f)
      speed -= 0.001;
  }
  
  void run(){
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
