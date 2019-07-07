import java.util.logging.*;
import org.jnativehook.*;
import org.jnativehook.keyboard.*;

Button b, r;
Counter kpm;
int keyCaptured;

void setup() {
  size(350, 50);
  surface.setAlwaysOnTop(true);
  
  b = new AnyButton();
  r = new Button(NativeKeyEvent.VC_DELETE);
  kpm = new KpmCounter();
  b.addClickListener(((KpmCounter)kpm).new CountButtonAdapter());
  r.addClickListener(((KpmCounter)kpm).new ResetButtonAdapter());
  
  LogManager.getLogManager().reset();
  Logger logger = Logger.getLogger(GlobalScreen.class.getPackage().getName());
  logger.setLevel(Level.OFF);
  
  try {
      GlobalScreen.registerNativeHook();
      GlobalScreen.addNativeKeyListener(new NativeKeyAdapter(){       
        @Override
        public void nativeKeyPressed(NativeKeyEvent nativeEvent){
          keyCaptured = nativeEvent.getKeyCode();
        }
      });
    } catch (NativeHookException e){}
}

void draw() {
  background(100);
  b.update();
  r.update();
  textSize(20);
  text(((KpmCounter)kpm).getKpm(), 20, 20);
  text(((KpmCounter)kpm).getAvg(), 20, 40);
}


class Button {
  ArrayList<ClickListener> listeners;
  int keyAttached;
  
  public Button(int ka) {
    keyAttached = ka;
    listeners = new ArrayList<ClickListener>();
  }
  
  void addClickListener(ClickListener cl){
    listeners.add(cl);
  }
  
  void buttonAction(){
    if(keyCaptured == NativeKeyEvent.VC_DELETE) {
      clickEvent();
      keyCaptured = 0;
    }
  }
  
  void clickEvent(){
    for(ClickListener cl : listeners)
      cl.onClick();
  }
  
  void update(){
    buttonAction();
  }
}

class Counter {
  int num;
  
  void count(){
    num++;
  }
  
  void reset(){
    num = 0;
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

class KpmCounter extends Counter {
  float kpm, avg;
  long currentTime, prevTime, startTime;
  
  void countKps(){
    if(num == 0) {
      startTime = prevTime = currentTime = System.currentTimeMillis();
    }
    else {
      currentTime = System.currentTimeMillis();
      kpm = (60000./(currentTime - prevTime));
      avg = 60000. * num / (currentTime - startTime);
      prevTime = currentTime;
    }  
    num++;
  }
  
  String getKpm() {
    if(kpm == 0)
      return "Start";
    return String.format("Kpm: %.2f", kpm);
  }
    
  String getAvg(){
    if(avg == 0)
      return "Start";
    return String.format("Avg: %.2f", avg);
  }
  
  @Override
  void reset(){
    super.reset();
    kpm = avg = 0.;
  }
  
  class CountButtonAdapter implements ClickListener {
    @Override
    void onClick(){
      countKps();
    }
  }
    
}

class AnyButton extends Button {
  public AnyButton() {
    super(0);
  }
  
  @Override
  void buttonAction(){
    if(keyCaptured != NativeKeyEvent.VC_DELETE &&
       keyCaptured != NativeKeyEvent.VC_SHIFT &&
       keyCaptured != NativeKeyEvent.VC_ALT &&
       keyCaptured != NativeKeyEvent.VC_CONTROL &&
       keyCaptured != NativeKeyEvent.VC_BACKSPACE &&
       keyCaptured != 3638 && // Right Shift
       keyCaptured != 0) {
         clickEvent();
         keyCaptured = 0;
    }
  }
}

interface ClickListener {
  void onClick();
}
