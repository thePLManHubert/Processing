int pagesTotal = 13;

color outsideColor = color(5, 18, 37);
color insideColorChecked = color(28, 58, 86);
color insideColorUnchecked = color(255);
color insideColorCurrent = color(252, 222, 124);

int space = 10;
int outsideCircleSize = 85;
int insideCircleSize = 70;

PImage idxImage;

void setup(){
  size(1250, 100, P2D);
  idxImage = createImage(width, height, ARGB);
  idxImage.loadPixels();
}

void draw(){
  noStroke();
  for(int pagesCounter = 0; pagesCounter < pagesTotal; pagesCounter++){
    background(255,0);
    for(int i = 0; i < pagesTotal; i++){
      int x = height/2 + (outsideCircleSize+space)*i;
      int y = height/2;
      
      fill(outsideColor);
      ellipse(x,y, outsideCircleSize, outsideCircleSize);
      
      if(i == pagesCounter) //<>//
        fill(insideColorCurrent);
      else if(i < pagesCounter)
        fill(insideColorChecked);
      else if(i > pagesCounter)
        fill(insideColorUnchecked);
      
      ellipse(x, y, insideCircleSize, insideCircleSize);
    }
    loadPixels();
    for(int p = 0; p < pixels.length; p++){
      idxImage.pixels[p] = pixels[p];
    }
    int idx = pagesCounter + 1;
    idxImage.updatePixels();
    idxImage.save("idx" + idx + ".png");
  }
  noLoop();
}
