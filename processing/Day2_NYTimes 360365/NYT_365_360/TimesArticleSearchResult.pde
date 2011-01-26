/*

 TimesArticleSearchResult Class
 
 February, 2009
 blprnt@blprnt.com

*/


public class TimesArticleSearchResult {

  String cmonth;
  String cyear;

  String[] facetStrings;
  int total;

  JSONObject facets;
  TimesResultObject[] results;

  TimesArticleSearchResult() {
  };

  void processResults(JSONArray e, String f) {
    //println("PROCESS");
    results = new TimesResultObject[e.length()];
    for (int i=0; i < e.length(); i++) {
      String[] fields = split(f, ",");
      TimesResultObject r = new TimesResultObject();
      JSONObject o;
      try {
        o = e.getJSONObject(i);
        
        for (int j = 0; j < fields.length; j++) {
          
          String s = fields[j];
          
          if (match(s, "body") != null) {
            r.body = o.getString("body");
          }
          else if (match(s, "title") != null) {
            r.title = o.getString("title");
          }
          else if (match(s, "abstract") != null) {
            r._abstract = o.getString("abstract");
          }
          else if (match(s, "url") != null) {
            r.url = o.getString("url");
          }
          else if (match(s, "author") != null) {
            r.author = o.getString("author");
          }
          else if (match(s, "date") != null) {
            r.date = o.getString("date");
          }
          else if (match(s, "byline") != null) {
            r.byline = o.getString("byline");
          };
        };

      }
      catch (JSONException je) {

      };
      
      results[i] = r;
    };
  };
  /*
  
   getFacetList
   - Returns an array of TimesFacetObjects
   
   */

  TimesFacetObject[] getFacetList(String facetName) {

    int facetNum = 0;
    TimesFacetObject[] flist;

    try {
      JSONArray facetArray = (JSONArray) facets.getJSONArray(facetName);
      facetNum = facetArray.length();
      flist = new TimesFacetObject[facetNum];

      for (int i = 0; i < facetNum; i++) {
        //1. Retrieve the JSONObject
        JSONObject jo;
        try {
          jo = (JSONObject) facetArray.get(i);
        }
        catch (JSONException e)  {
          jo = new JSONObject();
        };

        //2 For each item, create a TFO
        TimesFacetObject tfo = new TimesFacetObject();
        tfo.count = jo.getInt("count");
        tfo.term = jo.getString("term");
        tfo.type = facetName;
        //println("TERM - " + tfo.term);

        //3 File it into the array
        flist[i] = tfo;
      };

    }
    catch (JSONException e) {
      flist = new TimesFacetObject[facetNum];
    };

    return(flist);
  };




};






