abstract class Picture implements Clonable, Drawable {
  float x, y;
  float _width, _height;
}

interface Clonable {
  Picture pasteNew();
}

interface Drawable {
  void update(Cell c);
  void displayOnCell(Cell c);
  void displayOnCursor();
}
