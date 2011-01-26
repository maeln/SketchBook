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

public class TriangleSierpinski extends PApplet {

/*
 * Triangle of Sierpinski.
 * Auteur : Maeln
 * Licence : CC0 1.0 Universal
 * Licence url : http://creativecommons.org/publicdomain/zero/1.0/
*/

public void setup() {
  size(800, 800);
  background(200);
  smooth();
  noStroke();
  colorMode(HSB, 8, 100, 100);
  triangleSier(0, 700, 400, 0, 800, 700, 8);
}

public void triangleSier(float x1, float y1, float x2, float y2, float x3, float y3, int n) {
  // 'n' is the number of iteration.
  if ( n > 0 ) {
    fill(0, 128/n, 128);
    triangle(x1, y1, x2, y2, x3, y3);
    
    // Calculating the midpoints of all segments.
    float h1 = (x1+x2)/2.0f;
    float w1 = (y1+y2)/2.0f;
    float h2 = (x2+x3)/2.0f;
    float w2 = (y2+y3)/2.0f;
    float h3 = (x3+x1)/2.0f;
    float w3 = (y3+y1)/2.0f;
    
    // Trace the triangle with the new coordinates.
    triangleSier(x1, y1, h1, w1, h3, w3, n-1);
    triangleSier(h1, w1, x2, y2, h2, w2, n-1);
    triangleSier(h3, w3, h2, w2, x3, y3, n-1);
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "TriangleSierpinski" });
  }
}
