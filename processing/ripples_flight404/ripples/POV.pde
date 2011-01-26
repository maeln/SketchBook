// my Point Of View camera class.  Not that robust.
// I suggest looking into the OCD library for camera controls.
// http://www.cise.ufl.edu/%7Ekdamkjer/processing/libraries/ocd/

class POV{
  float elevation, elevationVar;
  float azimuth, azimuthVar;
  float distance, distanceVar;

  boolean elevationAuto;
  boolean azimuthAuto;

  float elevationSpeed;
  float azimuthSpeed;

  POV (float sentDistance){
    distance     = sentDistance;
  }

  void exist(){
    checkAuto();
    setCamera();
  }

  void resetAutoRotate(){
    azimuthAuto = false;
    elevationAuto = false;
    azimuthSpeed = 0.0;
    elevationSpeed = 0.0;
  }

  void checkAuto(){
    if (azimuthAuto){
      azimuth += azimuthSpeed;
    }

    if (elevationAuto){
      elevation += elevationSpeed;
    }
  }

  void setCamera(){
    elevationVar -= (elevationVar - elevation) * .25;
    azimuthVar -= (azimuthVar - azimuth) * .25;
    distanceVar -= (distanceVar - distance) * .25;

    translate(xMid, yMid, distanceVar);
    rotateX(elevationVar);
    rotateZ(-azimuthVar);
  }
}
