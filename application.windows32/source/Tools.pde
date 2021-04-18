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


public LanguageData languageData;
public class LanguageData{
  //SOUNDS
  public StringList vowels = new StringList();
  public StringList consonants = new StringList();
  
  //SYLLABLE
  public int onsetAmount = 0;
  public int nucleusAmount = 0;
  public int codaAmount = 0;
  public StringList[] onsetOptions = new StringList[0];
  public StringList[] nucleusOptions = new StringList[0];;
  public StringList[] codaOptions = new StringList[0];;
  //public ArrayList<SyllableExceptions>;

  //STRESSING
  public int stressingPosition = 1;
  
  //WORDS
  public ArrayList<WordTranslation> wordlist = new ArrayList<WordTranslation>();
  
  //GRAMMAR
  
  
  //EXTERN
  public String[][] simplifiedSounds;
  
  //DATA
  public String filepath = "languages/";
  public String projectpath = "temp";
  
  public LanguageData(){ 
    simplifiedSounds = new String[2][102];
    
    int tmp = 0;
    String[] dat = loadStrings("data/phonetic_consonant_table.txt");
    int offset = int(split(dat[0],' ')[1]);
    for(int i = offset+1; i<dat.length; i++){
      if((i-offset-1)%offset != 0 && !dat[i].equals("")){
        simplifiedSounds[0][tmp] = split(dat[i],' ')[0];
        simplifiedSounds[1][tmp] = split(dat[i],' ')[1];
        tmp++;
      }
    }
    dat = loadStrings("data/phonetic_vowel_table.txt");
    offset = int(split(dat[0],' ')[1]);
    for(int i = offset+1; i<dat.length; i++){
      if((i-offset-1)%offset != 0 && !dat[i].equals("")){
        simplifiedSounds[0][tmp] = split(dat[i],' ')[0];
        simplifiedSounds[1][tmp] = split(dat[i],' ')[1];
        tmp++;
      }
    }
  }


  public String subdivideWordToSyllables(String t){
    char[] tmp = t.toCharArray();
    String out = "";
    
    String syl = "";
    int part = 0; //0:onset, 1:nucleus, 2:coda
    int counter = 0; //counts how often the part is in use
    boolean looped  = false;
    for(int i = 0; i<tmp.length;i++){
      boolean b = false; //set to true for continue
      println(tmp[i],part,counter,syl,out);
      
      if(part == 0){
        for(int c = counter; c < onsetOptions.length; c++){
          if(onsetOptions[counter].hasValue(tmp[i]+"")){
            syl += tmp[i];
            b = true;
            counter = c+1;
            break;
          }
        }
        println("no onset");
        
        if(counter >= onsetOptions.length || !b){
          part = 1;
          counter = 0;
        }
      }
      if(part == 1){
        for(int c = counter; c < nucleusOptions.length; c++){
          if(nucleusOptions[counter].hasValue(tmp[i]+"")){
            syl += tmp[i];
            b = true;
            counter = c+1;
            break;
          }
        }
        println("no nucleus");
        
        if(counter >= nucleusOptions.length || !b){
          part = 2;
          counter = 0;
        }if(b){continue;}
      }
      if(part == 2){
        for(int c = counter; c < codaOptions.length; c++){
          if(codaOptions[counter].hasValue(tmp[i]+"")){
            syl += tmp[i];
            b = true;
            counter = c+1;
            break;
          }
        }
        println("no coda");
        
        if(counter >= codaOptions.length){
          part = 0;
          counter = 0;
          
          if(syl.equals("")){
            //ERROR///////////////////////
            syl = "Error";
          }
          out+=syl;
          syl = "";
          if(i+1 < tmp.length){ out += " - "; }
        }if(b){continue;}
      }
      
      if(looped){looped = false;continue;}
      looped = true; i--;//Causes a loop
    }
    if(!syl.equals("")){
      out+=syl;
    }
    
    return out;
  }
  
  public String convertToSimplifiedPronounciation(String t){
    char[] tmp = t.toCharArray();
    String out = "";
    for(int i = 0; i<tmp.length ; i++){
      for(int s = simplifiedSounds[0].length-1; s>=0 ; s--){ //Reversed order since affricated must be checked (At some point i'll add this)
        if(simplifiedSounds[0][s].equals(""+tmp[i])){
          out += simplifiedSounds[1][s];
          break;
        }
      }
    }
    
    return out;
  }
  
  public String generateRandomWord(){
    String out = "";
    int syls = floor(random(1,3.9999))+floor(random(0,2.9999));
    
    for(int i = 0; i<syls; i++){
      for(int a = 0; a<onsetAmount;a++){
        if(random(0,100) < 60){
          out += onsetOptions[a].get( floor( random(0,0.999+ onsetOptions[a].size() -1) ) );
        }
      }
      for(int a = 0; a<nucleusAmount;a++){
        if(a == 0 || random(0,100) < 30){
          out += nucleusOptions[a].get( floor( random(0,0.999+ nucleusOptions[a].size() -1) ) );
        }
      }
      for(int a = 0; a<codaAmount;a++){
        if(random(0,100) < 40){
          out += codaOptions[a].get( floor( random(0,0.999+ codaOptions[a].size() -1) ) );
        }
      }
    }
    
    return out;
  }
  
  
  public void loadFromFile(){
    println( "LOAD LANGUAGE DATA FROM FILE:");
    
    //SOUNDS
    println( "load sounds");
    String[] lodSounds = loadStrings(filepath+projectpath+"/soundlist.txt");
    int tmpconsonants = int(split(lodSounds[0]," ")[0]), tmpvowels = int(split(lodSounds[0]," ")[1]);
    consonants = new StringList();
    vowels = new StringList();
    for(int i = 1; i<tmpconsonants+1;i++){
      consonants.append(lodSounds[i]);
    }
    for(int i = 1+tmpconsonants; i<tmpconsonants+tmpvowels+1;i++){
      vowels.append(lodSounds[i]);
    }
    
    //SYLLABLE
    println( "load syllable structure");
    String[] lodSyllables = loadStrings(filepath+projectpath+"/syllableStructure.txt");
    onsetAmount =   int(split(lodSyllables[0]," ")[0]);
    nucleusAmount = int(split(lodSyllables[0]," ")[1]);
    codaAmount =    int(split(lodSyllables[0]," ")[2]);
    onsetOptions =   new StringList[onsetAmount];
    nucleusOptions = new StringList[nucleusAmount];
    codaOptions =    new StringList[codaAmount];
    for(int i = 0; i<onsetAmount; i++){
      String[] tmp = split(lodSyllables[1+i]," ");
      onsetOptions[i] = new StringList();
      for(int p = 0; p<tmp.length; p++){
      onsetOptions[i].append(tmp[p]);
      }
    }
    for(int i = 0; i<nucleusAmount; i++){
      String[] tmp = split(lodSyllables[1+onsetAmount+i]," ");
      nucleusOptions[i] = new StringList();
      for(int p = 0; p<tmp.length; p++){
      nucleusOptions[i].append(tmp[p]);
      }
    }
    for(int i = 0; i<codaAmount; i++){
      String[] tmp = split(lodSyllables[1+onsetAmount+nucleusAmount+i]," ");
      codaOptions[i] = new StringList();
      for(int p = 0; p<tmp.length; p++){
      codaOptions[i].append(tmp[p]);
      }
    }
  
    //STRESSING
    println( "load stressing");
    stressingPosition = int( loadStrings(filepath+projectpath+"/stressing.txt")[0] );
    
    //WORDS
    println( "load words");
    String[] lodWords = loadStrings(filepath+projectpath+"/wordlist.txt");
    wordlist = new ArrayList<WordTranslation>();
    for(int i = 1; i<int(lodWords[0]); i++){
      wordlist.add(new WordTranslation(split(lodWords[i]," : ")[0],split(lodWords[i]," : ")[1],int(split(lodWords[i]," : ")[1])) );
    }
    
    //GRAMMAR
    
    
  }
  
  public void saveToFile(){
    println( "SAVE LANGUAGE DATA TO FILE");
    
    //SOUNDS
    String[] savSounds = new String[vowels.size()+consonants.size()+1];
    savSounds[0] = consonants.size()+" "+vowels.size();
    for(int i = 0; i<consonants.size();i++){ savSounds[1+i] = consonants.get(i); }
    for(int i = 0; i<vowels.size();i++){ savSounds[1+consonants.size()+i] = vowels.get(i); }
    saveStrings(filepath+projectpath+"/soundlist.txt",savSounds);
    
    //SYLLABLE
    String[] savSyllable = new String[1+onsetOptions.length+nucleusOptions.length+codaOptions.length];
    savSyllable[0] = onsetAmount +" "+ nucleusAmount +" "+ codaAmount;
    for(int i = 0; i<onsetOptions.length;i++){ 
      savSyllable[1+i] = "";
      for(int o = 0; o<onsetOptions[i].size(); o++){
        savSyllable[1+i] += onsetOptions[i].get(o); 
        if(o+1 < onsetOptions[i].size()){ savSyllable[1+i] += " "; }
      }
    }
    for(int i = 0; i<nucleusOptions.length;i++){ 
      savSyllable[1+onsetOptions.length+i] = "";
      for(int o = 0; o<nucleusOptions[i].size(); o++){
        savSyllable[1+onsetOptions.length+i] += nucleusOptions[i].get(o); 
        if(o+1 < nucleusOptions[i].size()){ savSyllable[1+onsetOptions.length+i] += " "; }
      }
    }
    for(int i = 0; i<codaOptions.length;i++){ 
      savSyllable[1+onsetOptions.length+nucleusOptions.length+i] = "";
      for(int o = 0; o<codaOptions[i].size(); o++){
        savSyllable[1+onsetOptions.length+nucleusOptions.length+i] += codaOptions[i].get(o);
        if(o+1 < codaOptions[i].size()){ savSyllable[1+onsetOptions.length+nucleusOptions.length+i] += " "; } 
      }
    }
    saveStrings(filepath+projectpath+"/syllableStructure.txt",savSyllable);
  
    //STRESSING
    String[] savStressing = new String[1];
    savStressing[0] = ""+stressingPosition;
    saveStrings(filepath+projectpath+"/stressing.txt",savStressing);
    
    //WORDS
    String[] savWords = new String[wordlist.size()+1];
    savWords[0] = ""+wordlist.size();
    for(int i = 0; i<wordlist.size(); i++){
      savWords[1+i] = wordlist.get(i).saveWord();
    }
    saveStrings(filepath+projectpath+"/wordlist.txt",savWords);
    
    //GRAMMAR
    
    
  }
}


public static class WordType{
  public static int NOUN = 0;
  public static int VERB = 1;
  public static int ADJECTIVE = 2;
  public static int PERSPRONOUN = 3;
  
  public static int OTHER = -1;
  
  public static String toString(int i){
    switch(i){
      default:return "Other";
      case(0):return "Noun";
      case(1):return "Verb";
      case(2):return "Adjective";
      case(3):return "Pers. Pronoun";
    }
  }
}



//Used for storing the words in a dictionary
public class WordTranslation{
  public String word;
  public String translation;
  
  public int wordtype;
  
  public WordTranslation(String w, String tr, int type){
    word = w;
    translation = tr;
    wordtype = type;
  }
  
  public void update(String w, String tr, int type){
    word = w;
    translation = tr;
    wordtype = type;
  }
  
  public String saveWord(){
    return word + " : " + translation + " : " + wordtype;
  }
}