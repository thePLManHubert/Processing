Thread thread, t, tin;
//SerialReader sr;
Boundaries b, in;
Rectangle r;
ArrayList<Rectangle> k;

class Runner implements Runnable {
  Boundaries b;
  
  public Runner(Boundaries x){
    b = x;
  }
  @Override
  void run(){
    while(true){
      for(Rectangle t : b.rectangles)
      t.move();
      try{
        Thread.sleep(16);
      }catch(Exception ex){}
    }
  }

}

void setup() { 
  noCursor();
  //size(500, 500);
  fullScreen();
  
  r = new Rectangle(0,0,500,500);
  r.setSpeed(2.f);
  
  b = new Boundaries(width, height);
  b.putRectangle(r);
  
  in = new Boundaries(r);
    
  k = new ArrayList<Rectangle>();

  for(int i = 0; i < 1000; i++){
    k.add(new Rectangle(10, 40,  5,  5, new Angle(0.7f),  3f, Direction.NW, new Color(225,240,20)));
  }
  
  for(Rectangle x : k)
    in.putRectangle(x);
  
  //sr = new SerialReader(this);
  //thread = new Thread(sr);
  //thread.start();
  t = new Thread(new Runner(b));
  t.start();
  tin = new Thread(new Runner(in));
  tin.start();
}

void draw() {
  background(0);
  
  //r.setColor(sr.getColor());
  r.setColor(new Color(50,50,50));
  r.paint();
  
  for(Rectangle t : k)
    t.paint();
    
  textSize(32);
  fill(200);
  text((int)frameRate, 10, 30);
} 
