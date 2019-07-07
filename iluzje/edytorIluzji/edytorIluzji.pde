Canvas canvas;
Panel panel;
MouseBag mb;
Picture pic;

void setup(){
  size(800, 470);
  //fullScreen();
  int ver = 15;
  int hori = int(ver * 16/9.f * (1-ratio));
  
  canvas = new Canvas(hori, ver, true);
  panel = new Panel(2);
  mb = new MouseBag();
  mb.attachPicture(new Squareish(0, 0, 0));
  
  panel.add(new Squareish(1, 2, 0));
  panel.add(new Squareish(1, 3, 0));
  panel.add(new Squareish(0, 0, 0));
  panel.add(new Squareish(1, 2, 255));
  panel.add(new Squareish(1, 3, 255));
  panel.add(new Squareish(0, 0, 255));
  
  noCursor();
}

boolean init = false;

void draw(){
  background(153);
  
  canvas.update();
  panel.update();
  
  canvas.display();
  panel.display(); 

  pic = mb.picture;
  pic.displayOnCursor();
}
