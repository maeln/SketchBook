                                  // RIPPLES Base source release 2.
                                  // July 7th, 2005
                                  // Robert Hodgin
                                  //
                                  // robert {at} flight404 {dot} com
                                  // robert {at} barbariangroup {dot} com
                                  //
                                  // source code is provided as a gesture of good faith. Do with it what you will,
                                  // but remember this...
                                  //
                                  // 1) code is unsupported. please post questions regarding functionality to the processing forum.
                                  // 2) code is sometimes sloppy and may contain bugs.
                                  // 3) if code is repurposed and reposted, include a link back to flight404.
                                  // 4) if code is improved, i would love a copy.

import processing.opengl.*;
import pitaru.sonia_v2_9.*;

//int xSize           = screen.width;
//int ySize           = screen.height;
int xSize           = 800;
int ySize           = 600;
int xMid            = xSize/2;
int yMid            = ySize/2;

                                    // customize these to your liking
                                    // my dual 1.4 Mac does okay with 65x65 if just using strokes
                                    // and about 40x40 if you turn off strokes
int xRes            = 75;           // number of rows
int yRes            = 35;           // number of columns

int displaySize     = 8;             
int res             = 7;
                                
                                    // sound multiplier for adjusting the strength of the audio input
                                    // press + and - to control this variable
float soundMulti    = 1.0;

LightGrid lightGrid;                // 2D array of objects
Sounds sounds;                      // audio analysis engine (powered by Amit Pitaru's Sonia library
POV pov;                            // rudimentary camera object (the OCD camera library is much nicer... look it up)
Ripple ripple;                      // ripple algorithm

boolean pixelScale  = true;         // press 'a' to have audio input control 'res' variable
boolean strokes     = true;         // press 's' to toggle strokes vs. fill
boolean depth       = false;        // press 'd' to toggle the z axis
boolean broken      = false;        // press 'f' to switch to a happy accident (only works if 'depth' is true)


void setup(){
  size(xSize, ySize, OPENGL);
  rectMode(CENTER);
  colorMode(HSB,255);
  background(0);

  Sonia.start(this);

  sounds         = new Sounds();
  pov            = new POV(xSize/3);  // create camera (distance, lensAngle)
  ripple         = new Ripple();
  lightGrid      = new LightGrid();
}

void draw(){
  background(0);

  pov.exist();
  sounds.exist();
  ripple.exist();
  lightGrid.exist();
}

void keyPressed(){
  if (key == '=' || key == '+'){
    soundMulti += .1;
  } else if (key == '-'){
    soundMulti -= .1;
  }
  
  if (key == 'c' || key == 'C'){
    lightGrid.colorToggle();
  }
  
  if (key == 'a' || key == 'A'){
    pixelScale = !pixelScale;
  } else if (key == 's' || key == 'S'){
    strokes = !strokes;
  } else if (key == 'd' || key == 'D'){
    depth = !depth;
  } else if (key == 'f' || key == 'F'){
    broken = !broken;
  }
  
  if (key == '.'){
    lightGrid.brightLines(500.0);
  } else if (key == ','){
    lightGrid.brightLines(-1500.0);
  }
  
  
  // camera controls
  // designed for use with number keypad
  if (key == '7'){
    pov.distance += 50;
  } else if (key == '1'){
    pov.distance -= 50;
  } else if (key == '4'){
    pov.azimuth -= PI/6.0;
  } else if (key == '6'){
    pov.azimuth += PI/6.0;
  } else if (key == '2'){
    pov.elevation -= PI/6.0;
  } else if (key == '8'){
    pov.elevation += PI/6.0;
  }
}



public void stop(){
  Sonia.stop();
  super.stop();
}
