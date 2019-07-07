import processing.serial.*;

Serial port;
Container container;
Graph graph;
float maxVoltage = 5f;
int resolution = 1023; // ADC resolution
int portValue = 0;
boolean fail = false;
boolean newFrame = false;
int count, sum = 0;

void setup() {
  //fullScreen();
  size(600, 275);
  noStroke();
  
  graph = new Graph(width, height, 20, maxVoltage, 10);
  container = new Container(width);
  
  for(String s : Serial.list()) println(s);
  port = new Serial(this, Serial.list()[1], 4800);
  
  new Thread(){
    public void run(){
      while(true){
        if(1 < port.available()){
            int t = port.read();
            portValue = t;
            portValue += port.read() << 8; 
          if(portValue > resolution){ // compensate with another byte of data
            portValue = ((portValue << 8) + port.read()) & 0xFF;
            fail = !fail;
          }
          sum += portValue;
          count++;
          
          if(newFrame){
            newFrame = false;
            portValue = sum/count;
            count = sum = 0;
          }
            
          
        } 
        try{
          Thread.sleep(1);
        } catch(Exception ex){}
      }
    }
  }.start();
}
 
void draw() {
  background(102);
  
  container.putValue( portValue );
  graph.loadValues(container.getValues());
  graph.display();
  newFrame = true;
  if(fail) {
    fill(255, 0, 0);
    text("FAIL",270, 15);
  }
  else {
    fill(0, 255, 0);
    text("OK",270, 15);
  }
  text(count,310, 15);
}
