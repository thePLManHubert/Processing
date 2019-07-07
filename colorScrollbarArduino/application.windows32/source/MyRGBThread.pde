class MyRGBThread extends Thread {
  
  void run(){
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
