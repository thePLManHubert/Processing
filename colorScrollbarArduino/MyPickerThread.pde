class MyPickerThread extends Thread {
  
  void run(){
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
