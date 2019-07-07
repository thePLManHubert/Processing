PImage img;
PImage myImage;
float[] brg;
Modifier modifier;


void setup(){
  size(1024, 384);
  
  img = loadImage("1.jpg");
  img.resize(512, 384); 
  brg = new float[img.pixels.length];
  myImage = createImage(512, 384, RGB);

  for(int i = 0; i < img.pixels.length; i++){
    brg[i] = brightness(img.pixels[i]);
  } 
  
  modifier = new Triangle();
  image(img, 0, 0, 512, 384);
}


void draw(){ 
  new Thread(new ToBinary(0, brg.length)).start();
  myImage.updatePixels();
  image(myImage, 512, 0, 512, 384);
}


void keyPressed(){
  if (key == 't')
    modifier = new Triangle(40);
  if (key == 's')
    modifier = new Sinusoid(20);
  if (key == 'm')
    modifier = new Mouse();
}


class ToBinary implements Runnable {
  int from;
  int to;
  
  ToBinary(int f, int t){
    from = f;
    to = t;
  }
  
  public void run(){
    for(int idx = from; idx < to; idx++){
      if(brg[idx] > 255 - modifier.getValue())
           myImage.pixels[idx] = color(255);
      else myImage.pixels[idx] = color(0);
    }
    modifier.update();
  }
  
}
