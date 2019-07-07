import processing.serial.*;
// compatible with arduino colorScrollbarV2

ColorPicker cp;
Serial port;
HScrollbar red, green, blue;
byte [] values= new byte[4];
int r,g,b;
int modulo = 256; // liczba odcieni
int prescaler = 256/modulo;
Thread autoHSV, customRGB, customPicker;
boolean appStart = false;
Encoder encoder;
ColoredSquare square;
 
boolean rgbOn = false;
boolean hsvOn = false;
boolean pickerOn = false;
 
void setup() { 
  size(260, 440); 
  red = new HScrollbar(0, 8, width, 16, 16);
  green = new HScrollbar(0, 58, width, 16, 16);
  blue = new HScrollbar(0, 108, width, 16, 16);
  square = new ColoredSquare(width/2 - 20, 108 + 20, 40, 40);
  encoder = new Encoder(60, 108+20, 30, 40, 1, 128);
  cp = new ColorPicker(0, 180, 260, 260, 0);
  print(Serial.list()[0]);
  port = new Serial(this, Serial.list()[0], 9600);
}

void draw() { 
  background(255);

  pickMode();

  red.display();
  green.display();
  blue.display();
  
  updateValues();
  
  int rval = ((r != 255)?r/prescaler*prescaler:255);
  int gval = ((g != 255)?g/prescaler*prescaler:255);
  int bval = ((b != 255)?b/prescaler*prescaler:255);
  
  textAlign(LEFT, CENTER);
  text("Red: "   + rval,   5, 8+20);
  text("Green: " + gval,   5, 58+20);
  text("Blue: "  + bval,   5, 108+20);

  square.display(color(rval, gval, bval));
  
  fill(50);
  if(autoHSV != null)
    text(String.format("Speed: % .3f",((MyHSVThread)autoHSV).speed),  width - 100, 108 + 20);
  
  text("Presc: ", 20, 148);
  
  encoder.display();
  if(!hsvOn)
    cp.display();
}

void updateValues(){
  prescaler = encoder.getValue();
  modulo = 256/prescaler;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(autoHSV != null)
    if(0 > e) ((MyHSVThread)autoHSV).increaseSpeed();
    else if (0 < e) ((MyHSVThread)autoHSV).decreaseSpeed();
}
 
void pickMode(){
  if(appStart == false){
    appStart = true;
    rgbOn = true;
    customRGB = new MyRGBThread();
    customRGB.start(); 
  }
  
  if (keyPressed) {
    if (key == 'r') {
      if (!rgbOn) {
        square.changing = false;
        rgbOn = true;
        hsvOn = false;
        pickerOn = false;
        autoHSV = null;
        customPicker = null;
        customRGB = new MyRGBThread();
        customRGB.start();     
      }
    }
    if (key == 'p') {
      if (!pickerOn) {
        square.changing = false;
        pickerOn = true;
        rgbOn = false;
        hsvOn = false;
        autoHSV = null;
        customRGB = null;
        customPicker = new MyPickerThread();
        customPicker.start();     
      }
    }
    if (key == 'h') {
      if (!hsvOn) {
        square.changing = false;
        hsvOn = true;
        rgbOn = false;
        pickerOn = false;
        customRGB = null;
        customPicker = null;
        autoHSV = new IntHSVThread();
        autoHSV.start();
      }
    }
  }
}
