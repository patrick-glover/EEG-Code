#include <Servo.h>  // servo library

Servo servo2;
  int marker;
  int state = 1;
  int REDLED = 13;
  int BUTTON2 = 7;
  int Button2State;
  
void setup()
{
    servo2.attach(6);
    //Serial.begin(115200);
    pinMode(BUTTON2, INPUT);
    pinMode(REDLED, OUTPUT);
    servo2.write(90);
    
}



void loop()
{

    {
  Button2State = digitalRead(BUTTON2);
  if(Button2State == HIGH && state == 1)  
  {
  digitalWrite(REDLED, HIGH);
  servo2.write(30);
  delay(100);
  state = 2;
  
  }
  else if(Button2State == HIGH && state == 2)
  {
  digitalWrite(REDLED, LOW);
  servo2.write(90);
  delay(100);
  state = 1;
  }
 }
/*state =digitalRead(ClockX);
    servo2.write(86);
    
   if ( state  == HIGH)
    {
     marker = marker+1;
     delay(100);
      Serial.println(marker);
    }
   */
  }
  


 
