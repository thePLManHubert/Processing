class BpmCounter extends Counter {
  float bpm, avg;
  long currentTime, prevTime, startTime;
  
  void countBps(){
    if(count == 0) {
      startTime = prevTime = currentTime = System.currentTimeMillis();
    }
    else {
      currentTime = System.currentTimeMillis();
      bpm = 60000. / (currentTime - prevTime);
      avg = 60000. * count / (currentTime - startTime);
      prevTime = currentTime;
    }
    count++;
  }
  
  String getBpm() {
    if(bpm == 0)
      return "Start";
    return String.format("Bpm: %.2f", bpm);
  }
    
  String getAvg(){
    if(avg == 0)
      return "Start";
    return String.format("Avg:  %.2f", avg);
  }
  
  @Override
  void reset(){
    super.reset();
    bpm = avg = 0.;
  }
  
  class CountButtonAdapter implements ClickListener {
    @Override
    void onClick(){
      countBps();
    }
  }

}

class BpmConstraintCounter extends BpmCounter {
  int current;
  long [] times;
  
  BpmConstraintCounter(int samples){
    times = new long[samples];
    current = 0;
  }
  
  @Override
  void countBps(){
    if(count == 0) {
      times[0] = prevTime = currentTime = System.currentTimeMillis();
    }
    else {  
      
      if(current < times.length - 1){
        current++;
      }
      else {
        for(int i = 1; i < times.length; i++)
          times[i-1] = times[i];
      }
      
      times[current] = currentTime = System.currentTimeMillis();
      bpm = 60000. / (currentTime - prevTime);
      
      avg = 60000. * current / (times[current] - times[0]);
      prevTime = currentTime;
    }
    
    count++;
  }
  
  @Override
  void reset(){
    super.reset();
    times = new long[encoder.getValue()];
    current = 0;
  }
  
}
