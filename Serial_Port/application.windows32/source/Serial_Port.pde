import processing.serial.*;

Serial port;
Container container;
Graph graph;
float maxVoltage = 5f;
int resolution = 1023; // ADC resolution
int portValue = 0;

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
}
