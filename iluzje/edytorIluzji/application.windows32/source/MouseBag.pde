class MouseBag implements Clickable {
  
  Picture picture;
  
  MouseBag (){
    picture = null;
  }
  
  void attachPicture(Picture p){
    picture = p.pasteNew();
  }
  
  void detachPicture(){
    picture = null;
  }
  
  boolean hasPicture(){
    if(picture == null)
      return false;
    return true;
  }
  
  @Override
  void onLeftClick(Cell other){
    if(other.isOnCanvas){
      if(picture != null)
        other.picture = picture.pasteNew();
    }
    else{
      if(other.picture != null)
        picture = other.picture.pasteNew();
    }
  }
  
  @Override
  void onRightClick(Cell other){
    if(other.isOnCanvas){
        other.picture = null;
    }
  }
      
}
