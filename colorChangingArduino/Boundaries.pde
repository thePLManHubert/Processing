

class Boundaries {
  private int _width, _height;
  private ArrayList<Rectangle> rectangles;
  private Rectangle main;
  
  public Boundaries(int w, int h){
    _width = w;
    _height = h;
    rectangles = new ArrayList<Rectangle>();
  }
  
  public Boundaries(Rectangle r){
    _width = r._width;
    _height = r._height;
    main = r;
    rectangles = new ArrayList<Rectangle>();
  }
  
  boolean putRectangle(Rectangle r){
    if(r._height <= _height && r._width <= _width){
      rectangles.add(r);
      r.setBoundaries(this);
      return true;
    }
    else return false;
  }
  
  public void manipulate(){
    for(Rectangle r : rectangles) {
      
      if(topOutOfBounds(r)){ // from S, SW, SE
        // back to previous position
        r.y += r.speed * r.angle._sin;
        
        // calculate next position
        r.angle = drawAngle();
        if (r.direction == Direction.NW){
          r.direction = Direction.SW;
        }
        else if(r.direction == Direction.NE){
          r.direction = Direction.SE;
        }
        else {
          if(((int)Math.random()*2) % 2 == 0)
            r.direction = Direction.SW;
          else r.direction = Direction.SE;
        }
      }
      
      else if(bottomOutOfBounds(r)){ // from N, NW, NE
        // back to previous position
        r.y -= r.speed * r.angle._sin;;
        
        // calculate next position
        r.angle = drawAngle();
        if (r.direction == Direction.SW){
          r.direction = Direction.NW;
        }
        else if(r.direction == Direction.SE){
          r.direction = Direction.NE;
        }
        else {
          if(((int)Math.random()*2) % 2 == 0)
            r.direction = Direction.NW;
          else r.direction = Direction.NE;
        }
      }
      
      else if(leftSideOutOfBounds(r)){ // from W, NW, SW
        // back to previous position
        r.x += r.speed * r.angle._cos;
        
        // calculate next position
        r.angle = drawAngle();
        if (r.direction == Direction.NW){
          r.direction = Direction.NE;
        }
        else if(r.direction == Direction.SW){
          r.direction = Direction.SE;
        }
        else {
          if(((int)Math.random()*2) % 2 == 0)
            r.direction = Direction.NE;
          else r.direction = Direction.SE;
        }
      }
      
      else if(rightSideOutOfBounds(r)){ // from E, NE, SE
        // back to previous position
        r.x -= r.speed * r.angle._cos;
        
        // calculate next position
        r.angle = drawAngle();
        if (r.direction == Direction.NE){
          r.direction = Direction.NW;
        }
        else if(r.direction == Direction.SE){
          r.direction = Direction.SW;
        }
        else {
          if(((int)Math.random()*2) % 2 == 0)
            r.direction = Direction.NW;
          else r.direction = Direction.SW;
        }
      }
    }
  }
  
  Rectangle getRectangle(int idx){
    return rectangles.get(idx);
  }
  
  private boolean topOutOfBounds(Rectangle r){
    float temp = 0;
    if(main != null)
      temp = main.y;
    if(r.y < temp)
      return true;
    return false;
  }
  private boolean bottomOutOfBounds(Rectangle r){
    float temp = _height;
    if(main != null)
      temp = main.y + main._height;
    if(r.y + r._height >= temp)
      return true;
    return false;
  }
  private boolean leftSideOutOfBounds(Rectangle r){
    float temp = 0;
    if(main != null)
      temp = main.x;
    if(r.x < temp)
      return true;
    return false;
  }
  private boolean rightSideOutOfBounds(Rectangle r){
    float temp = _width;
    if(main != null)
      temp = main.x + main._width;
    if(r.x + r._width >= temp)
      return true;
    return false;
  }
  
  private Angle drawAngle(){
    float result = (float)Math.random()*90;
    return new Angle(3.14 * result / 180.);
  }
  
}
