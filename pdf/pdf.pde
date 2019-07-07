import processing.pdf.*;

void setup() {
  size(800, 1131);
  noLoop();
  beginRecord(PDF, "filename.pdf"); 
}

void draw() {

  
  endRecord();
}
