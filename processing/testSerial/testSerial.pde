import processing.serial.*;
println(Serial.list());

Serial arduino;
arduino = new Serial(this, "/dev/ttyS0", 9600);
println(arduino.available());
while(arduino.available() > 0) {
  println(arduino.last());
}

