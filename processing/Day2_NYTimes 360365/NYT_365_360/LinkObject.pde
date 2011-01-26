/*

LinkObject
blprnt@blprnt.com
February, 2009

This is a simple class to store the location and some simple properties of the facet objects (the text pieces in the final graphics)

*/


public class LinkObject {
  
  TimesFacetObject facetObject;
  ArrayList links;
  float x;
  float y;
  
  float xin;
  float yin;
  
  float xin2;
  float yin2;
  
  float xout;
  float yout;
  color c;
  boolean positioned;
  int linklevel;
  int linkcount;
  
  LinkObject(TimesFacetObject f) {
    facetObject = f;
    links = new ArrayList();
    positioned = false;
    linkcount = 0;
  };
};
