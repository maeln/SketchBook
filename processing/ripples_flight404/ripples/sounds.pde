
class Sounds{
  float[][] tempVar;

  Sounds(){
    LiveInput.start(256);
    LiveInput.useEqualizer(true);
    LiveInput.useEnvelope(true,1.5);

    tempVar = new float[xRes][yRes];
  }

  void exist(){
    LiveInput.getSpectrum(false);
    
    drawHorizontal();
    // uncomment the following if you want a cross hair of audio input
    // instead of just the horizontal.
    // drawVertical();
  }
  
  void drawHorizontal(){
    for (int i=0; i<xRes; i++){
      tempVar[i][int(yRes/2)] -= (tempVar[i][int(yRes/2)] - LiveInput.spectrum[int(abs(i - (xRes/2))+4)]) * 1.0;

      for (int j=-2; j<3; j++){
        float d = dist(i, yRes/2+j, i, yRes/2);
        ripple.r1[i][int(yRes/2)+j] += pow(((3 - d)/3.0),4) * (tempVar[i][int(yRes/2)+j]) * soundMulti;
      }
    }
  }
  
  void drawVertical(){
    for (int i=0; i<yRes; i++){
      tempVar[int(xRes/2)][i] -= (tempVar[int(xRes/2)][i] - LiveInput.spectrum[int(abs(i - (yRes/2))+4)]) * 1.0;

      for (int j=-2; j<3; j++){
        float d = dist(xRes/2+j, i, xRes/2, i);
        ripple.r1[int(xRes/2)+j][i] += pow(((3 - d)/3.0),4) * (tempVar[int(xRes/2)+j][i]) * soundMulti;
      }
    }
  }
}
