int photocellPin = 0;
int photocellReading;
int LEDgreenpin = 11;
int LEDyellowpin = 12;
int LEDredpin = 13;
int LEDbrightness;

void setup(void) {
  pinMode(LEDgreenpin, OUTPUT);
  pinMode(LEDredpin, OUTPUT);
  pinMode(LEDyellowpin, OUTPUT);
  Serial.begin(9600);
}

void loop(void) {
  photocellReading = analogRead(photocellPin);
  
  if (photocellReading < 300)
  {
    digitalWrite(LEDredpin, HIGH);
    digitalWrite(LEDgreenpin, LOW);
    digitalWrite(LEDyellowpin, LOW);
    // Serial.print("RED\n");
  } 
  else if (photocellReading > 300 && photocellReading < 700)
  {
    digitalWrite(LEDyellowpin, HIGH);
    digitalWrite(LEDgreenpin, LOW);
    digitalWrite(LEDredpin, LOW);
    // Serial.print("YELLOW\n");
  }
  else if (photocellReading > 700)
  {
    digitalWrite(LEDgreenpin, HIGH);
    digitalWrite(LEDyellowpin, LOW);
    digitalWrite(LEDredpin, LOW);
    // Serial.print("GREEN\n");
  }
  Serial.println(photocellReading);
  delay(100);
}
