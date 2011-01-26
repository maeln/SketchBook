// my generic ripple algorithm.  Decay is the only thing here worth futzing with.
// decay > 1.0 will make the ripple feed off itself.

class Ripple{
  float[][] r0;
  float[][] r1;
  float[][] r2;
  float decay;

  Ripple(){
    r0                 = new float[xRes][yRes];
    r1                 = new float[xRes][yRes];
    r2                 = new float[xRes][yRes];
    decay              = .94;
  }

  void exist(){
    findRipples();
    swapBuffers();
  }

  void findRipples(){
    for (int y=1; y<yRes-1; y++){
      for (int x=1; x<xRes-1; x++){
        r0[x][y] = (r1[x-1][y] + r1[x+1][y] + r1[x][y-1] + r1[x][y+1]) / 4.0;
        r0[x][y] = r0[x][y] * 2.0 - r2[x][y];
        r0[x][y] *= decay;
      }
    }
  }

  void swapBuffers(){
    for (int y=0; y<yRes; y++){
      for (int x=0; x<xRes; x++){
        r2[x][y] -= (r2[x][y] - r1[x][y]) * decay;
        r1[x][y] -= (r1[x][y] - r0[x][y]) * decay;
      }
    }
  }
}
