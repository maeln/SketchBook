/*

 TimesArticleSearch Class
 
 February, 2009
 blprnt@blprnt.com

*/

public class TimesArticleSearch {

  ArrayList fields = new ArrayList();
  ArrayList facets = new ArrayList();
  ArrayList queries = new ArrayList();
  ArrayList extras = new ArrayList();
  ArrayList facetQueries = new ArrayList();

  String baseURL = "http://api.nytimes.com/svc/search/v1/article";
  String apiKey = "API_KEY";   //YOUR API KEY GOES HERE

  String defaultFields = "body,title,byline,date,url";
  import java.net.URLEncoder;


  /*
  *
   *  Constructor
   *
   */
  TimesArticleSearch() {
  };


  /*
  *
   * Search functions - return TimesArticleSearchResults
   *
   */
  TimesArticleSearchResult doSearch() {

    TimesArticleSearchResult dc = new TimesArticleSearchResult();
    try { 
      String url = constructURL();
      println(url);

      String JSONStr = join(loadStrings(url), "");
      JSONObject nytData = new JSONObject(JSONStr);  

      if (facets.size() > 0) dc.facets = nytData.getJSONObject("facets");
      dc.processResults(nytData.getJSONArray("results"), getFields());

      dc.total = int(nytData.getInt("total")); 
    }  
    catch (JSONException e) {  
      println (e.toString());  
    } 

    return(dc);

  };

  /*
  *
   * Search modifying functions
   *
   */
  void addQueries(String q) {
    String[] qa = split(q, ",");
    for (int i = 0; i < qa.length; i++) {
      queries.add(queries.size(), URLEncoder.encode(qa[i]));
    };  
  };
  
  void clearQueries() {
    queries = new ArrayList();
  };

  void addFacets(String q) {
    String[] qa = split(q, ",");
    for (int i = 0; i < qa.length; i++) {
      facets.add(facets.size(), qa[i]);
    };  
  };

  void addFields(String q) {
    String[] qa = split(q, ",");
    for (int i = 0; i < qa.length; i++) {
      fields.add(fields.size(), qa[i]);
    };
    println("ADD FIELDS" +  fields);
  };

  void addFacetQuery(String f, String q) {
    facetQueries.add(facetQueries.size(), f + ":[" + URLEncoder.encode(q) + "]");
  };
  
  void clearFacetQueries() {
    facetQueries = new ArrayList();
  };

  void addExtra(String e, String q) {
    extras.add(extras.size(), e + "=" + q);
  };

  /*
  *
   * URL construction
   *
   */
  String constructURL() {
    String url = baseURL + "?query=" + getQueries() + "&fields=" + getFields() + "&facets=" + getFacets() + getExtras() + "&api-key=" + apiKey;
    return(url);
  };

  String getQueries() {
    String q = "";
    for (int i = 0; i < queries.size(); i++) {
      q += (String) queries.get(i);
      if (i < queries.size() - 1) q += ",";
    };
    if (facetQueries.size() > 0) {
      q += "%20";
      for (int i = 0; i < facetQueries.size(); i++) {
        q = q + (String) facetQueries.get(i);
        if (i < facetQueries.size() - 1) q += "%20";
      };
    };
    return(q);
  };

  String getFields() {
    String q = "";
    for (int i = 0; i < fields.size(); i++) {
      q += (String) fields.get(i);
      if (i < fields.size() - 1) q += ",";
    };
    if (q == "") {
      q = defaultFields;
    };
    return(q);
  };

  String getFacets() {
    String q = "";
    for (int i = 0; i < facets.size(); i++) {
      q += (String) facets.get(i);
      if (i < facets.size() - 1) q+= ",";
    };
    return(q);
  };

  String getExtras() {
    String q = "";
    if (extras.size() > 0) {
      q += "&";
      for (int i = 0; i < extras.size(); i++) {
        q += (String) extras.get(i);
        if (i < extras.size() - 1) q += "&";
      };
    };
    return(q);
  };

};



