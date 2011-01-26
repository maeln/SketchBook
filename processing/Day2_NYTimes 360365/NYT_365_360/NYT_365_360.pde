/*

 NYTimes - 360/365
 blprnt@blprnt.com
 February, 2009
 
 This sketch generates a series of graphics which show the top organizations and personalities in the NYTimes for every year from 1985 to 2001.
 Connections between these people & organizations are indicated by lines.
 You can view the results here: http://www.flickr.com/photos/blprnt/sets/72157614008027965/
 
 When you run this sketch, it will crank out a pile of .PDFs into the sketch folder. You'll know that its done when you see the final sketch window. 
 
 NOTE: Make sure you enter your NYTimes Article Search API on the TimesArticleSearch tab.
 
*/

// -------------------- FIRST, IMPORT SOME LIBRARIES --------------------------------
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.geom.util.*;

import processing.opengl.*;
import org.json.*;
import java.util.ArrayList;
import java.util.AbstractCollection;

import processing.pdf.*;

// --------------------  THEN, DECLARE SOME VARIABLES --------------------------------

PFont font;                                        //The display font
HashMap links = new HashMap();                     //HashMap to store all of the link objects
ArrayList linkArray = new ArrayList();             //ArrayList to store all of the link objects
HashMap localMaxes = new HashMap();                //HashMap to store the search totals for individual links

Vec2D centre;                                      //2D Vector to store center point of graphic

//Colour list for multi-color version
color[] colors = {#C9313D,#F9722E,#CDD452,#375D81,#B8CC00,#142601,#668C14,#F28705,#A3140F,#183152};
//SIngle colour for monochrome version
color mainColor;

//Which facets will be used to build the wheel? Here, we use people (per_facet) and organizations (org_facet)
//For more on facets, see this page: http://developer.nytimes.com/docs/article_search_api/#h3-facets
String[] linkFacets = {
  "per_facet", "org_facet"};
  
// --------------------  NOW, THE MAGIC HAPPENS --------------------------------
void setup() {
  
  //Load font for text display
  font = createFont("Meta-Normal", 100); 
  textFont(font); 

  //Set the stage size and the centre point
  size(3000,3000);
  centre = new Vec2D(width/2, height/2);
  smooth();
  
  //We're going to export a pile of .PDFs, one for each year.
  for (int i=1984; i < 2010; i++) {
    //Tell the .PDF engine to start up
    beginRecord(PDF, i + ".pdf"); 
    //Reset the data collections
    links = new HashMap();
    linkArray = new ArrayList();
    localMaxes = new HashMap();
    //Paint a light grey background
    background(240);
    //For monochromes, pick a random base colour  
    mainColor = color(random(150),random(150),random(150));
    //Draw the system
    connectYear(i);
    
    endRecord();
  
  };
}

void draw() {

};

/* -------------------- 

This function is the guts of it. Here, we populate the ArrayList and HashMaps with search data.
Next we set up a map of links between the various facets
After that's done, we can use those data structures to draw the graph.

--------------------  */ 

void connectYear(int y) {
  //First, load the top 10 results for each facet
  TimesArticleSearch s = new TimesArticleSearch();
  s.addFields("+");
  s.addFacets(join(linkFacets, ","));
  s.addFacetQuery("publication_year", str(y));
  s.addFacetQuery("desk_facet", "Foreign Desk"); //Restrict results to stories from the foreign desk. 
  TimesArticleSearchResult r = s.doSearch();
  
  //Put them into a big array of facets
  //*** This method is at the bottom of this tab.
  ArrayList allFacets = processLinks(r);

  //Set up local maxes
  //The MaxObject Class is defined at the bottom of the tab.
  for (int j = 0; j < linkFacets.length; j++) {
    localMaxes.put(linkFacets[j], new MaxObject(0));
  };

  //Create a link object in the links hashtable for each one
  int i;
  for (i=0; i < allFacets.size(); i++) {
    TimesFacetObject f = (TimesFacetObject) allFacets.get(i);
    MaxObject mo = (MaxObject) localMaxes.get(f.type);
    //println(mo);
    localMaxes.put(f.type, new MaxObject(max(mo.maxi, f.count)));
    LinkObject lo = new LinkObject(f);
    lo.linklevel = 0;
    if (links.get(f.term) == null) {
      links.put(f.term, lo);
      linkArray.add(i, lo);
    };  
  };

  //Run through the links array again and find the links for each new facet
  for (i=0; i < allFacets.size(); i++) {
    TimesFacetObject f = (TimesFacetObject) allFacets.get(i);
    TimesArticleSearch s2 = new TimesArticleSearch();
    s2.addFields("+");
    s2.addFacetQuery("publication_year", str(y));

    s2.addFacetQuery(f.type, f.term);
    s2.addFacets(join(linkFacets, ","));
    TimesArticleSearchResult r2 = s2.doSearch();
    
    //Put them into a big array of facets
    ArrayList linkFacets = processLinks(r2);
    for (int j=0; j < linkFacets.size(); j++) {
      TimesFacetObject f2 = (TimesFacetObject) linkFacets.get(j);
      LinkObject l2 = new LinkObject(f2);
      
      if (links.get(f2.term) == null) {
        links.put(f2.term, l2);
        l2.linklevel = 1;
      }
      else {
        //facet already exists
        LinkObject ll = (LinkObject) links.get(f2.term);
        ll.linkcount ++;
        
      };
    };
    
    LinkObject l = (LinkObject) linkArray.get(i);
    l.links = linkFacets;
    
  };

  //Draw the link map
  drawNodes();
  drawLinks();
  
  int ts = 150;
  fill(red(mainColor)/5,red(mainColor)/5,red(mainColor)/5,30);
  textFont(font);
  textSize(ts);
  float w = textWidth(str(y));
  float h = ts;
  
  text(y, 75,160);
  
};

//-------------------- 
//This function places the central and subsidiary nodes around the centre point.
//Once these are in place, we can draw the lines between them.
void drawNodes() {
  
  float ct = PI;
  float cti = (PI * 2) / links.size();
  //First, run through the main list of links, and position them around a centre point
  //Also, put their subsidiary links out
  
  int i;
  float t = PI/2;
  float ti = (PI*2)/linkArray.size();
  float rad = 175;
  float x;
  float y;
  MaxObject lm;
  for (i = 0; i < linkArray.size(); i++) {
    //Draw main
    x = centre.x + (sin(t) * rad * 2);
    y = centre.y + (cos(t) * rad * 2);
    
    float xout = centre.x + (sin(t) * rad * 4);
    float yout = centre.y + (cos(t) * rad * 4);
     
    LinkObject l = (LinkObject) linkArray.get(i);
    
    lm = (MaxObject) localMaxes.get(l.facetObject.type);
    float f = float(l.facetObject.count) / lm.maxi;
    
    textFont(font);
    textSize(12 + (40 * f));
    
    float sl = textWidth(l.facetObject.term) + 10;
    float xin = centre.x + (sin(t) * ((rad * 2) + sl));
    float yin = centre.y + (cos(t) * ((rad * 2) + sl));
    
    //Link objects have in and out points, both X and Y. This means that connections go into a link at one spot and out of a link at the other.
    //For these outer links, the in points are at the front of the text, and the out points are at the end of the text.
    l.x = x;
    l.y = y;
    l.xout = xout;
    l.yout = yout;
    l.yin = yin;
    l.xin = xin;
    l.xin2 = centre.x + (sin(t) * ((rad * 2) + sl + 200));
    l.yin2 = centre.y + (cos(t) * ((rad * 2) + sl + 200));
    
    l.positioned = true;
    
    //Set alpha and colour
    float a = 255 - (100 + (f * 155));
    float ca = 0.2;
    //Here we choose a random colour from our colour list
    l.c = colors[i % 10];
    
    //Moce to the correct position
    pushMatrix();
    translate(x,y);
    rotate(-t + (PI/2));
    fill(l.c);
    //Draw the text.
    text(l.facetObject.term, 4, 6);
    popMatrix();


    //Draw subsidiaries
    //This is the same process as with the inner ones, but they don't have separate in and out points.
    for (int j = 0; j < l.links.size(); j++) {
      float j2 = float(j);
      float frac = (j2 / float(l.links.size()));
      float t2 = t + (frac * ti * 1);
      
      TimesFacetObject fo = (TimesFacetObject) l.links.get(j);
      LinkObject l2 = (LinkObject) links.get(fo.term);

      x = centre.x + (sin(ct) * (rad - (l2.linkcount * 2)) * 6.5);
      y = centre.y + (cos(ct) * (rad - (l2.linkcount * 2)) * 6.5);
      
      if (l2 != null && !l2.positioned && l2.linklevel > 0) {

        l2.x = x;
        l2.y = y;
        l2.positioned = true;

        //Size and colour of text is dependant on how many results the search term returns.
        //To keep this balanced (we don't want text to be too big or small), it's weighted against the maximum results that any given term returned.
        lm = (MaxObject) localMaxes.get(l2.facetObject.type);
        float cf = float(l2.facetObject.count) / lm.maxi;
        l2.c = color( 200 - ((55 + (cf * 200)) * 2));

        pushMatrix();
          translate(x,y);
          rotate(-ct + (PI/2));
          fill(l2.c);
          textSize(min(4 + (200 * cf) + (l2.linkcount *2),36));
          text(l2.facetObject.term, 4, 6);
        popMatrix();
        

      };
      ct -= cti;
    };

    t += ti;
  };
};

//-------------------- 
//Once the nodes are in place, we can render the links between them.
//These are bezier lines - with slightly different control points depending on wether the nodes are central or outer.
void drawLinks() {
  
  for (int i = 0; i < linkArray.size(); i++) {
    //Draw main
    color c;
    LinkObject l = (LinkObject) linkArray.get(i);
    for (int j = 0; j < l.links.size(); j++) {
      TimesFacetObject fo = (TimesFacetObject) l.links.get(j);
      LinkObject l2 = (LinkObject) links.get(fo.term);
      c = color(red(l.c), green(l.c), blue(l.c), alpha(l.c));
      stroke(c);
      noFill();
      
      if (l2.linklevel == 0 && l.linklevel == 0) {
        //If both of the links are central, use the middle point as a control
        beginShape();
        vertex(l.x, l.y);
        bezierVertex(l.x, l.y, centre.x, centre.y, l2.x, l2.y);
        endShape();
      }
      else {
        //Otherwise, use the out point of the second link as the control
        c = color(red(l.c), green(l.c), blue(l.c), alpha(l.c)/2);
        stroke(c);
        beginShape();
        vertex(l.xin, l.yin);
        bezierVertex(l.xin2, l.yin2, l.xout, l.yout, l2.x, l2.y);
        endShape();
      };
      
    };
    
    
  };
  
};

//This is quick and dirty function to go through a TimesArticleSearchResult and file all of the facets into an ArrayList
ArrayList processLinks(TimesArticleSearchResult r) {
  ArrayList allFacets = new ArrayList();
  int c = 0;
  int i;
  TimesFacetObject[] fa;

  for (int j = 0; j < linkFacets.length; j++) {
    fa = r.getFacetList(linkFacets[j]);
    for (i = 0; i < fa.length; i++) {
      TimesFacetObject fo = fa[i];
      allFacets.add(c, fo);
      c++;
    };

  };
  return(allFacets);
};

//Simple class to store local max values from search results
public class MaxObject {
  int maxi; 
  MaxObject(int m) {
    maxi = m;
  };
}





