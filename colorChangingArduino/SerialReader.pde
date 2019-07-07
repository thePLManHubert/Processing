import processing.serial.*;
import java.awt.Color;

class SerialReader implements Runnable {  
  private byte val;
  private Serial port;  
  public Color _color;
  
  SerialReader(PApplet applet){
    _color = new Color(0,0,0);
    port = new Serial(applet, Serial.list()[0], 9600);
    println(Serial.list()[0]);
  }
  
  @Override
  public void run(){
    while(true){
      if(port.available() > 0)
        val = (byte)port.readChar();
      port.clear();

      
      if ('R' == val){
        _color = Color.red;
      }
      else if ('G' == val){
        _color = Color.green;
      }
      else if ('B' == val){
        _color = Color.blue;
      }
      else if ('Y' == val){
        _color = Color.yellow;
      }
      else if ('C' == val){
        _color = Color.cyan;
      }
      else if ('M' == val){
        _color = Color.magenta;
      }
      else if ('W' == val){
        _color = Color.white;
      }
      
      try{
          Thread.sleep(1);
      } catch(Exception ex){}
    }    
  }
  
  public Color getColor(){
    return _color;
  }
  
}
