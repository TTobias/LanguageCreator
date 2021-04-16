//Class for the Vector2 Datatype storing positions and expanses
public class Vector2{
  public float x,y;
  
  public Vector2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public void set(float x, float y){
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
  public static color guiTextBox = #7a777d;
  public static color guiInactiveTextBox = #6a676d;
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




//Copy an ArrayList and extend it by 1 element
public <T> ArrayList<T> copyAndExtend(ArrayList<T> ls, T t){
  ArrayList<T> tmp = new ArrayList<T>();
  for(int i = 0; i<ls.size(); i++){ tmp.add(ls.get(i)); }
  tmp.add(t);
  return tmp;
}



public void 





//Used for storing the words in a dictionary
public class WordTranslation{
  public String word;
  public String translation;
}
