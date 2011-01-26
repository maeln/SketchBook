import processing.serial.*;

size(1024, 768);
noFill();
smooth();

Serial arduino;
println(Serial.list());
arduino = new Serial(this, "/dev/ttyACM0", 9600);
int number[] = { 15, 16, 18, 20, 10, 12, 12, 15, 18, 19, 21, 25, 30, 35, 54, 20 };

while(arduino.available() > 0) {
  println(arduino.last());
}

beginShape();
  for(int i=0; i < number.length; i++) {
    curveVertex(i*8+50, screen.height / 1.4 - number[i]);
  }
endShape();
