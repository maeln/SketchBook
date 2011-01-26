// here is the meat of the project.
// the setInfo method gets a brightness (bb) variable based on the
// height of the ripple at that location. this bb variable is used
// to control the height of the objects in the 2D array.

class LightGrid{
  float[][] bb;
  float[][] z;
  color[][] colors;
  color myColor;
  
  float xp, yp;
  int baseColor;
  float zOffset;
  int colorSet;

  LightGrid(){
    bb            = new float[xRes][yRes];
    z             = new float[xRes][yRes];
    colors        = new color[xRes][yRes];

    baseColor     = 255;
    colorSet      = 1;
  }

  void exist(){
    setInfo();
    if (broken){
      brokenRender();
    } else {
      render();
    }
  }
  
  void setInfo(){
    for (int y=0; y<yRes; y++){
      for (int x=0; x<xRes; x++){
        bb[x][y]       = ripple.r0[x][y];
        if (depth){
          z[x][y]      = constrain(bb[x][y]/250.0, -200, 200);
        } else {
          z[x][y]      = 0.0;
        }
        colors[x][y] = setColor(bb[x][y]);
      }
    }
  }
  
  color setColor(float sentBrightness){
    if (colorSet == 0){
      if (sentBrightness < 0){
        myColor = color(100 + sentBrightness/50.0, 255 - abs(sentBrightness/25.0), abs(sentBrightness/8.0));
      } else {
        myColor = color(sentBrightness/5.0, 255 - sentBrightness/12.0, (sentBrightness/8.0));
      }
    } else if (colorSet == 1){
      if (sentBrightness < 0){
        myColor = color(200 + sentBrightness/25.0, 255 - abs(sentBrightness/16.0), abs(sentBrightness/8.0));
      } else {
        myColor = color(sentBrightness/25.0, 255 - sentBrightness/12.0, (sentBrightness/8.0));
      }
    }
    
    return myColor;
  }
  
  // the main render method.
  void render(){
    for (int x=0; x<xRes; x++){
      xp = (x - xRes/2) * displaySize;
      yp = (-yRes/2 - 1) * displaySize;
      pushMatrix();
      translate(xp, yp, 0);
      for (int y=0; y<yRes; y++){
        if (y > 0){
          zOffset = z[x][y] - z[x][y-1];
        }
        translate(0, displaySize, zOffset);
        
        if (pixelScale){
          res = constrain(int(pow(bb[x][y]/500, 2)),0,displaySize);
        } else {
          res = displaySize - 1;
        }
        
        if (strokes){
          if (res >= displaySize - 1){
            noStroke();
            fill(colors[x][y]);
          } else {
            stroke(colors[x][y]);
            noFill();
          }
          
        } else {
          fill(colors[x][y]);
          noStroke();
        }
        
        
        rect(0,0,res,res);
      }
      popMatrix();
    }
  }
  
  // happy accident render. I was not resetting the transform matrix properly
  // and ended up with an overly rippled effect. but decided to keep it because
  // perhaps I will go back and find a way to capitalize on the effect.
  void brokenRender(){
    for (int x=0; x<xRes; x++){
      xp = (x - xRes/2) * displaySize;
      yp = 0;
      pushMatrix();
      translate(xp, 0, 0);
      for (int y=yRes/2; y<yRes; y++){
        translate(0, displaySize, z[x][y]);
        
        if (pixelScale){
          res = constrain(int(pow(bb[x][y]/500, 2)),0,displaySize);
        } else {
          res = displaySize - 1;
        }
        if (strokes){
          if (res >= displaySize - 1){
            noStroke();
            fill(colors[x][y]);
          } else {
            stroke(colors[x][y]);
            noFill();
          }
          
        } else {
          fill(colors[x][y]);
          noStroke();
        }
        
        rect(0,0,res, res);
      }
      popMatrix();
      
      xp = (x - xRes/2) * displaySize;
      yp = 0;
      pushMatrix();
      translate(xp, displaySize, 0);
      
      for (int y=yRes/2; y>=0; y--){
        translate(0, -displaySize, z[x][y]);
        if (pixelScale){
          res = constrain(int(pow(bb[x][y]/500, 2)),0,displaySize);
        } else {
          res = displaySize - 1;
        }
        if (strokes){
          if (res >= displaySize - 1){
            noStroke();
            fill(colors[x][y]);
          } else {
            stroke(colors[x][y]);
            noFill();
          }
          
        } else {
          fill(colors[x][y]);
          noStroke();
        }
        rect(0,0,res, res);
      }
      popMatrix();
    }
  }

  void colorToggle(){
    switch (colorSet){
      case 0: colorSet = 1;    break;
      case 1: colorSet = 0;    break;
    }
  }
  
  // a bit of manual control. pressing ',' or '.' will introduce a strong
  // ripple along the axis lines of the array. example of how to use manual
  // input to assist the automatic audio analysis.
  void brightLines(float sentVar){
    for (int i=0; i<xRes; i++){
      for (int j=-1; j<2; j++){
        ripple.r1[i][int(yRes/2) + j] += sentVar * (2-abs(j));
      }
    }
    for (int i=0; i<yRes; i++){
      for (int j=-1; j<2; j++){
        ripple.r1[int(xRes/2) + j][i] += sentVar * (2-abs(j));
      }
    }
  }
}
