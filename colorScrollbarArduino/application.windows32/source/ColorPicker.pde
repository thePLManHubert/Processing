public class ColorPicker 
{
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker(int x, int y, int w, int h, int c){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    init();
  }
  
  private void init(){
    cpImage = loadImage("pictures/palette.png");
  }
  
  public void display()
  {
    image( cpImage, x, y, w, h); 
    if(pickerOn){
      if(mouseX >= x && mouseX < x + w && mouseY >= y && mouseY < y + h ){
        if(mousePressed)
          c = get(mouseX, mouseY);
        int horiBound = (mouseX < width-16-10)?mouseX+10:mouseX-24;
        int vertBound = (mouseY < height-4)?mouseY-12:height-16-1;
        int over = get(mouseX, mouseY);
        fill(over);
        rect(horiBound, vertBound, 16, 16);
      } 
    } 
  }
}
