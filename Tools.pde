//Class for the Vector2 Datatype storing positions and expanses
public class Vector2{
  public float x,y;
  
  public Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public void Add(Vector2 a){
    x += a.x;
    y += a.y;
  }
  
  
  public float distanceTo(Vector2 a){
    return new Vector2(x-a.x,y-a.y).getLength();
  }
  
  public float getLength(){
    return sqrt(x*x + y*y);
  }
}


//Contains most of the Color Information the Game needs
public static class ColorCode{
  
  public static color background = #3f422e;
  public static color guiBackground = #d4da9f;
  public static color guiTextBackground = #afafaf;
  public static color guiBorder = #161616;
  public static color guiText = #323232;
  public static color guiHighlight = #eeff53;
  public static color guiTriggered = #d67c2e;
  public static color guiInactive = #4b4b4b;
  public static color guiEnabled = #4eff4b;
  public static color guiDisabled = #ff461a;
  public static color guiLayer = #8a877d;
  public static color guiLayerInactive = #57554f;
  public static color guiLayerHovered = #87858f;
  
  public static color black = #111111;
  public static color grey = #7b7b7b;
  public static color white = #f3f3f3;
  public static color red = #ff0000;
  public static color blue = #0000ff;
  public static color green = #00ff00;
  public static color yellow = #fff600;
  public static color orange = #ff8500;
  public static color purple = #d000ff;
  public static color cyan = #00ffb2;
}



//Array to String conversion
public <T> String arrayToString(T[] a){
  String tmp = "[ ";
  if(a.length > 0){ tmp += a[0].toString(); }
  for(int i = 1;i<a.length;i++){
    tmp += " , "+ a[i].toString();
  }
  tmp += " ]";
  return tmp;
}
public String arrayToString(char[] c){
  String tmp = "[ ";
  if(c.length > 0){ tmp += c[0]; }
  for(int i = 1;i<c.length;i++){
    tmp += " , "+ c[i];
  }
  tmp += " ]";
  return tmp;
}


//ArrayList to String conversion
/*public <T> String arraylistToString(ArrayList<T> ls){
  String tmp = "[ ";
  if(ls.size() > 0){ tmp += ls.get(0).toString(); }
  for(int i = 1;i<ls.size();i++){
    tmp += " , "+ ls.get(i).toString();
  }
  tmp += " ]";
  return tmp;
}*/
public String arraylistToString(ArrayList<langToken> as){
  String tmp = "[ ";
  if(as.size() > 0){ tmp += as.get(0).toString(); }
  for(int i = 1;i<as.size();i++){
    tmp += " , "+ as.get(i).toString();
  }
  tmp += " ]";
  return tmp;
}



//Test Methods
public boolean isLetter(char c){
  if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == 'ä' || c == 'ü' || c == 'ö' || c == 'Ä' || c == 'Ü' || c == 'Ö' || c == 'ß' || c =='\'' || c =='_' || c == '-'){
    return true;
  }return false;
}

public String uncapitalize(String s){
  return s.toLowerCase();
}

public boolean isCapitalized(String s){
  return !(s.toLowerCase().equals( s ));
}

public boolean isNumerical(String s){
  char[] tmp = s.toCharArray();
  for(int i = 0; i<tmp.length; i++){
    if(!(tmp[i] == '0' || tmp[i] == '1' || tmp[i] == '2' || tmp[i] == '3' || tmp[i] == '4' || tmp[i] == '5' || tmp[i] == '6' || tmp[i] == '7' || tmp[i] == '8' || tmp[i] == '9')){
      return false;
    }
  }
  return true;
}

public String[] gerArticleList = { "der", "die", "das" };
public boolean isArticle(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerArticleList.length; i++) {if ( tmp.equals(gerArticleList[i]) ){ return true; }}
  return false;
}

public String[] gerPronounList = { 
"ich", "du", "er", "sie", "es", "wir", "ihr", //Personal
"mein", "meine", "meiner", "meins", "dein", "deine", "deiner", "deins", "sein", "seine", "seiner", "seins", "ihr", "ihre", "ihrer", "ihres", "ihrs", //Possessiv
"unser", "unsere", "unserer", "unsers", "unseres", "euer", "eure", "eurer", "eures", //Possessiv
"mich", "dich", "sich", "uns", "euch", //Reflexiv
//"der", "die", "das", "welche", "welcher", "welches", //Relativ
//"wer, "was", "wem", "wen", "wessen", //Interrogativ (replaces noun in questions)
//"dieser", "diese", "dieses", "jener", "derjenige", "diejenige", //Demonstrativ
"etwas", "nichts", "man", "jemand", "jeder" //Indefinit
//Deklination
}; 
public boolean isPronoun(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerPronounList.length; i++) {if ( tmp.equals(gerPronounList[i]) ){ return true; }}
  return false;
}

public String[] gerPreposList = { "ich", "du", "er", "sie", "es", "wir", "ihr" }; 
public boolean isPreposition(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerPreposList.length; i++) {if ( tmp.equals(gerPreposList[i]) ){ return true; }}
  return false;
}

public String[] gerConnectorList = { "und", "oder", "weil", "denn", "obwohl", "wenn", "seit", "nachdem", "während", "aber" }; 
public boolean isConnector(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerConnectorList.length; i++) {if ( tmp.equals(gerConnectorList[i]) ){ return true; }}
  return false;
}

public String[] gerParticleList = { "sogar", "eben", "gerade", "ziemlich", "sehr", "auch" }; 
public boolean isParticle(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerParticleList.length; i++) {if ( tmp.equals(gerParticleList[i]) ){ return true; }}
  return false;
}

public String[] gerNumericalList = { "ein", "eins", "eines", "einen", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun", "zehn", "elf", "zwölf", "zwanzig", "fünfzig", "hundert" }; 
public String[] gerQuantifierList = { "paar", "einige", "viele" }; 
public boolean isQuantifier(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerNumericalList.length; i++) {if ( tmp.equals(gerNumericalList[i]) ){ return true; }}
  for(int i = 0; i<gerQuantifierList.length; i++) {if ( tmp.equals(gerQuantifierList[i]) ){ return true; }}
  if( isNumerical( s ) ){ return true; }
  return false;
}

public String[] gerAdverbList = { "schon", "noch", "meistens", "genug", "jetzt", "innen", "hier", "dort", "damals", "halbwegs" };
public boolean isAdverb(String s){
  String tmp = uncapitalize(s);
  for(int i = 0; i<gerAdverbList.length; i++) {if ( tmp.equals(gerAdverbList[i]) ){ return true; }}
  return false;
}



//Copy an ArrayList and extend it by 1 element
public <T> ArrayList<T> copyAndExtend(ArrayList<T> ls, T t){
  ArrayList<T> tmp = new ArrayList<T>();
  for(int i = 0; i<ls.size(); i++){ tmp.add(ls.get(i)); }
  tmp.add(t);
  return tmp;
}




//Scene that will be loaded on starting
public class StartupScene extends Scene{
  public StartupScene(){ super("Startup"); 
    constructGui();
    onInstanciate();
  }
  
  public UI_Button creationModulButton;
  public UI_Button translationModulButton;
  public UI_Button analyseModulButton;
  
  public void constructGui(){
    creationModulButton = new UI_Button( new Vector2(300,300),new Vector2(300,60),"Create Language",true );
    translationModulButton = new UI_Button( new Vector2(300,400),new Vector2(300,60),"Translate Abstraction",true );
    analyseModulButton = new UI_Button( new Vector2(300,500),new Vector2(300,60),"Analyse Language",true );
    
    addUiElement(creationModulButton);
    addUiElement(translationModulButton);
    addUiElement(analyseModulButton);
  }
  
  public void onInstanciate(){ }
  
  public void btnFunctions(){
    if(creationModulButton.getTrigger()){
      println("Debug: Scene switched from Startup to Creation");
      sceneManager.switchSceneByName("Creation");
    }
    if(translationModulButton.getTrigger()){
      println("Debug: Scene switched from Startup to Translation");
      sceneManager.switchSceneByName("Translation");
    }
    if(analyseModulButton.getTrigger()){
      println("Debug: Scene switched from Startup to Analysis");
      sceneManager.switchSceneByName("Analysis");
    }
  }
}
