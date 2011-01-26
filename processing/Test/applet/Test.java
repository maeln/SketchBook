import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Test extends PApplet {
  public void setup() {
/*
 * My first Sketch
 * Dunno wat im going to do
 * -- Maeln
*/

size(800, 600);
background(0,0,0);
smooth();
PImage av2;
av2 = loadImage("av2.png");
PFont font;
font = loadFont("Balker-48.vlw");
textFont(font, 48);

for (int i = 0; i < 800; i++) {
  fill(i, i/3, i/2);
  noStroke();
  rect(i, 0, 1, 600);
}
pushStyle();
fill(0xffCD2E2E);
// noStroke();
stroke(0xffCB49BE);
strokeWeight(10);
ellipse(100, 100, 150, 150);
popStyle();
text("WTF !", 600, 50);
print("hauteur : " + height + " || Largeur : " + width + "\n");
pushStyle();
stroke(128);
strokeWeight(4);
strokeCap(ROUND);
line(100, 100, 500, 500);
popStyle();
pushStyle();
strokeJoin(ROUND);
stroke(0);
pushMatrix();
rotate(PI/30);
rect(500, 500, 50, 50);
popMatrix();
popStyle();
fill(100, 32, 125, 127);
triangle(20, 30, 10, 15, 23, 21);
fill(0xffCD2E2E, 100);
beginShape();
curveVertex(100, 10);
curveVertex(300, 18);
curveVertex(35, 35);
curveVertex(800, 500);
endShape();
fill(150, 150, 28);
beginShape();
vertex(15, 56);
vertex(16, 55);
vertex(13, 35);
vertex(50, 15);
endShape();
image(av2, 600, 150);
image(av2, 700, 150, 50, 50);
tint(255, 0, 0, 255);
image(av2, 600, 250);
tint(0, 255, 0, 255);
image(av2, 600, 350);
tint(0, 0, 255, 255);
image(av2, 600, 450);

  noLoop();
} 
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "Test" });
  }
}
