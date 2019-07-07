import java.awt.Color;

enum Direction {N, S, W, E, NW, NE, SW, SE}

class Rectangle {
  private int _width, _height;
  private Color _color;
  private Boundaries boundaries;
  
  public float x, y;
  public Angle angle; 
  public float speed;
  public Direction direction;
  
  public Rectangle(int x, int y, int w, int h){
    this(x, y, w, h, new Angle(PI/4.f), 1.f, Direction.SE, new Color(0,0,0));
  }
  
  public Rectangle(int x, int y, int w, int h, Angle angle, float speed, Direction dir, Color c){
    this.x = x;
    this.y = y;
    _width = w;
    _height = h;
    this.angle = angle;
    this.speed = speed;
    direction = dir;
    _color = c;
  }
  
  void paint(){
    fill(_color.getRed(), _color.getGreen(), _color.getBlue());
    rect(x, y, _width, _height);
  }
  
  void move(){ 
    // mooving
    switch(direction){
      case N:
        y -= speed;
      break;
      case S:
        y += speed;
      break;
      case W:
        x -= speed;
      break;
      case E:
        x += speed;
      break;
      case NW:
        x -= speed * angle._cos;
        y -= speed * angle._sin;
      break;
      case NE:
        x += speed * angle._cos;
        y -= speed * angle._sin;
      break;
      case SW:
        x -= speed * angle._cos;
        y += speed * angle._sin;
      break;
      case SE:
        x += speed * angle._cos;
        y += speed * angle._sin;
      break;
    }
    
    // adding boundary constraints
    if(boundaries != null){
      boundaries.manipulate();
    }
  }
  
  public void setBoundaries(Boundaries b){
    boundaries = b;
  }
  
  public void setColor(Color _color){
    this._color = _color;
  }
  
  public void setSpeed(float s){
    speed = s;
  }
  
  public void setAngle(Angle a){
    angle = a;
  }
  
  public int getWidth(){
    return _width;
  }
  public int getHeight(){
    return _height;
  }
}

class Angle {
  public float _sin, _cos;
  
  public Angle(float angle){
    _sin = sin(angle);
    _cos = cos(angle);
  }
}
