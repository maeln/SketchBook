import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Shitstorm dat   = new Shitstorm(#4E858B);
Minim audio;
AudioSnippet music;
int i           = 0;
int o           = 0;

void setup() {
  size(300, 300);
  smooth();
  background(255);
  noStroke();
  frameRate(30);
  audio = new Minim(this);
  music = audio.loadSnippet("8b.wav");
  music.play();
}

void stop() {
  audio.stop();
  super.stop();
}

void draw() {
  i++;
  float u = random(1)-random(1);
  
  background(255);
  
  if ( o == 0 ) {
    if ( u <= 0.09 && u >= -0.09 ) {
      dat.vx = 0;
    } else if ( u <= 0 ) {
      dat.vx = -1;
    } else if ( u >= 0 ) {
      dat.vx = 1;
    }
    o++;
  } else if( o != 0 ) {
    o++;
    if ( o == 30 ) {
      o = 0;
    }
  }
  
  if ( i <=  300 ) {
    dat.move();
    dat.disp();
  }
  //println(hour() + ":" + minute() + ":" + second());
}

class Shitstorm {
  color bbq;
  float x   = 150;
  float y   = 0;
  float vx  = 0;
  float vy  = 1;

  Shitstorm(color col) {
    bbq   = col;
  }
  
  void move() {
    x = x + vx;
    y = y + vy;
  }
  
  int disp() {
    fill(bbq);
    ellipse(x, y, 10, 10);
    return 0;
  }
}

