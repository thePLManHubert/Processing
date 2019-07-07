import java.util.logging.*;
import org.jnativehook.*;
import org.jnativehook.keyboard.*;

Button b, r;
Counter c, bpm;
int keyCaptured;
Encoder encoder;

void setup() {
  size(350, 200);
  surface.setAlwaysOnTop(true);
  
  encoder = new Encoder(width - 120, 10, 48, 72, 2, 60, 20);
  bpm = new BpmConstraintCounter(encoder.getValue());
  
  b = new Button(         20, 120, 100, 60, "Count", NativeKeyEvent.VC_B);
  r = new Button(width - 120, 120, 100, 60, "Reset", NativeKeyEvent.VC_R);
  b.addClickListener(((BpmConstraintCounter)bpm).new CountButtonAdapter());
  r.addClickListener(((BpmConstraintCounter)bpm).new ResetButtonAdapter());  
  
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
  background(180);
  
  b.display();
  r.display();
  
  textSize(20);
  textAlign(LEFT, CENTER);
  text(((BpmConstraintCounter)bpm).getBpm(), 20, 20);
  text(((BpmConstraintCounter)bpm).getAvg(), 20, 60);
  text(((BpmConstraintCounter)bpm).times.length , width - 50, 45);
  
  encoder.display();
}
