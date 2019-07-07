class Container {

  int [] values;
  int len = 0;
  
  Container(int size){
    values = new int[size];
  }

  void putValue(int v){
    if(v > resolution)
      v = resolution;
    if(len < values.length){
      values[len] = v;
      len++;
    } else {
      for(int i = 0; i < values.length-1; i++){
        values[i] = values[i+1];
        values[len-1] = v;
      }
    }
  }
  
  int [] getValues(){
    return values;
  }

}
