class Counter {
  int count;
  
  public Counter(){}
  
  void count(){
    count++;
  }
  
  void reset(){
    count = 0;
  }
  
  class CountButtonAdapter implements ClickListener {
    @Override
    void onClick(){
      count();
    }
  }
  
  class ResetButtonAdapter implements ClickListener {
    @Override
    void onClick(){
      reset();
    }
  }
  
}
