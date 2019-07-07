import processing.video.*;

Capture video;
PImage img;

void captureEvent(Capture video) {
  video.read();
}

void setup() {  
  size(640, 480);
  
  printArray(Capture.list());
  img = createImage(640, 480, RGB);
  video = new Capture(this, Capture.list()[6]);
  video.start();
}

int x = 100;
int speed = 4;

void draw() {
  video.loadPixels();
  
  for(int i = 0; i < video.pixels.length; i++){
    if(brightness(video.pixels[i]) < x - 100)
      img.pixels[i] = color(0);
    else if(brightness(video.pixels[i]) < x - 60)
      img.pixels[i] = color(51);
    else if(brightness(video.pixels[i]) < x - 30)
      img.pixels[i] = color(102);
    else if(brightness(video.pixels[i]) < x - 20)
      img.pixels[i] = color(153);
    else if(brightness(video.pixels[i]) < x + 50)
      img.pixels[i] = color(204);
    else
      img.pixels[i] = color(255);
      
    x += speed;
    if((x <= 100 || x >= 200) && i % 4 == 0)
      speed *= -1;
  }
  
  
  
  img.updatePixels();
  image(img, 0, 0);
}
