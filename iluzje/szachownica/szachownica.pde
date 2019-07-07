int kwadratyPoziomo;
int kwadratyPionowo;
float bok;

void setup(){
  //fullScreen();
  size(600, 400);
  kwadratyPoziomo = 20;
  bok = width / kwadratyPoziomo;
  kwadratyPionowo = (int)(height / bok);
}

void draw(){
  println(kwadratyPoziomo);
  background(255);
  for(int y = 0; y < kwadratyPionowo; y++){
    for(int x = 0; x < kwadratyPoziomo; x++){
      int idx = x + y * kwadratyPoziomo;
      
      stroke(150);
      if(idx % 2 == 0) fill(0);
      //else fill(255);
      
      if(y % 2 == 1 && idx % 2 == 0)
        rect(x*bok, y*bok, bok, bok);
      else if(idx % 2 == 0)
        rect(x*bok+bok*mouseX/width, y*bok, bok, bok);
    }
  }
  
  for(int i = 0; i <= kwadratyPionowo; i++){
    stroke(150);
    line(0, i*bok, width, i*bok);
  }
}
