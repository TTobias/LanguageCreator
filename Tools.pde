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
  
  public void setToMouse(){
    x = mouseX;
    y = mouseY;
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
  
  //WORD ORDER
  //Needs some changes later
  public int i;
    
  //QUANTIFIERS
  //public ArrayList<Quantifier> quantifiers = new ArrayList<Quantifier>();
  public ArrayList<WordModifier> quantifiers = new ArrayList<WordModifier>();
  
  //TENSES
  //public ArrayList<Tense> tenses = new ArrayList<Tense>();
  public ArrayList<WordModifier> tenses = new ArrayList<WordModifier>();
  
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
      wordlist.add(new WordTranslation(split(lodWords[i]," : ")[0],split(lodWords[i]," : ")[1],int(split(lodWords[i]," : ")[2])) );
    }
    
    //WORD ORDER
    
    
    //QUANTIFIERS
    println( "load quantifiers");
    String[] lodQuantifiers = loadStrings(filepath+projectpath+"/quantifierList.txt");
    quantifiers = new ArrayList<WordModifier>();
    for(int i = 1; i< 1+int(lodQuantifiers[0]); i++){
      quantifiers.add( new WordModifier(lodQuantifiers[i]) );
    }
    
    //TENSES
    println( "load tenses");
    String[] lodTenses = loadStrings(filepath+projectpath+"/tenseList.txt");
    tenses = new ArrayList<WordModifier>();
    for(int i = 1; i< 1+int(lodTenses[0]); i++){
      tenses.add( new WordModifier(lodTenses[i]) );
    }
    
    
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
    
    //WORD ORDER
    
    
    //QUANTIFIERS
    String[] savQuantifiers = new String[quantifiers.size()+1];
    savQuantifiers[0] = ""+quantifiers.size();
    for(int i = 0; i<quantifiers.size(); i++){
      savQuantifiers[1+i] = quantifiers.get(i).saveModifier();
    }
    saveStrings(filepath+projectpath+"/quantifierList.txt",savQuantifiers);
    
    //TENSES
    String[] savTenses = new String[tenses.size()+1];
    savTenses[0] = ""+tenses.size();
    for(int i = 0; i<tenses.size(); i++){
      savTenses[1+i] = tenses.get(i).saveModifier();
    }
    saveStrings(filepath+projectpath+"/tenseList.txt",savTenses);
    
    
    
  }
}


public static class WordType{
  public static int NOUN = 0;
  public static int VERB = 1;
  public static int ADJECTIVE = 2;
  public static int PERSPRONOUN = 3;
  public static int CONJUNCTION = 3;
  
  public static int OTHER = -1;
  
  public static String toString(int i){
    switch(i){
      default:return "Other";
      case(0):return "Noun";
      case(1):return "Verb";
      case(2):return "Adjective";
      case(3):return "Pers. Pronoun";
      case(4):return "Conjunction";
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



void UNUSED_QUANTIFIER(int i){}
//Will be needed for adding auxiliary Words
/*
public class Quantifier{
  public int type = -1;
  public WordModifier modifier;
}

public class Tense{
  public int type = -1;
  
}
*/

public static class QuantifierType{
  public static int SINGULAR = 0;
  public static int PLURAL = 1;
  public static int DUAL = 2;
  public static int NONE = 3;
  public static int ALL = 4;
  public static int OLIGO = 5;
  public static int POLY = 6;
  public static int UNKNOWN = 7; //if it'S irrelevant or unknown if plural or singular
  public static int ANY = 8;
  public static int SPECIFIC = 9;
  public static int NEGATIVE = 10;
  public static int SAME = 11;
  public static int DIFFERENT = 12;
  public static int TRI = 13;
  public static int HALF = 14;
  public static int QUARTER = 15;
  
  public static int OTHER = -1;
  
  public static String toString(int i){
    switch(i){
      default:return "Other";
      case( 0):return "Singular";
      case( 1):return "Plural";
      case( 2):return "Dual";
      case( 3):return "None";
      case( 4):return "All";
      case( 5):return "Oligo";
      case( 6):return "Poly";
      case( 7):return "Unknown";
      case( 8):return "Any";
      case( 9):return "Specific";
      case(10):return "Negative";
      case(11):return "Same";
      case(12):return "Different";
      case(13):return "Tri";
      case(14):return "Half";
      case(15):return "Quarter";
    }
  }
  
  public static String description(int i){
    switch(i){
      default:return "-";
      case( 0):return "A single instance";
      case( 1):return "Multiple instances ";
      case( 2):return "Exactly two instances";
      case( 3):return "No instance";
      case( 4):return "All instances";
      case( 5):return "A small amomunt of instances (~2 - 12, can vary with context)";
      case( 6):return "A big amount of instances (~12+, can vary with context)";
      case( 7):return "An unknown or irrelevant amount of instances";
      case( 8):return "An unspecified instance out of all";
      case( 9):return "A specific identified instance";
      case(10):return "A negative amount of instances (if possible in the context)";
      case(11):return "The same instances as refered to in earlier context";
      case(12):return "Different instances as refered to in earlier context";
      case(13):return "Excatly three instances";
      case(14):return "Half of the instances";
      case(15):return "A Quarter of the instances";
    }
  }
  
  public static int getAmount(){
    return 15; //NEEDS TO BE UPDATED WHEN ADDING NEW QUANTIFIERS
  }
}

public static class TenseType{
  public static int PRESENT = 0;
  public static int PAST = 1;
  public static int FUTURE = 2;
  public static int PASTPROGRESSIV = 3;
  public static int PERFERCT = 4;
  public static int IMPERFECT = 5;
  public static int FUTUREPROGRESSIVE = 6;
  public static int NEARFUTURE = 7;
  public static int FARFUTURE = 8;
  public static int FUTUREINPAST = 9;
  public static int PASTINFUTURE = 10;
  public static int DISTANTPAST = 11;
  public static int CLOSEPAST = 12;
  public static int GENERALISATION = 13;
  public static int HYPOTHETICAL = 14;
  public static int QUESTION = 15; //Not sure what to do with this
  public static int RELATIVEFUTURE = 16;
  public static int RELATIVEPAST = 17;
  public static int NECESSITY = 18;
  public static int CONDITIONAL = 19;
  public static int CONDITIONALPAST = 20;
  public static int CONDITIONALFUTURE = 21;
  public static int PLUSPERFECT = 22;
  //public static int PASSIVE = 18; rn in valency, can be applied to any tense in theory
  //public static int ACTIVE = 18;
  
  public static int OTHER = -1;
  
  public static String toString(int i){
    switch(i){
      default:return "Other";
      case( 0):return "Present";
      case( 1):return "Past";
      case( 2):return "Future";
      case( 3):return "Past Progressive";
      case( 4):return "Perfect";
      case( 5):return "Imperfect";
      case( 6):return "Future Progressive";
      case( 7):return "Near Future";
      case( 8):return "Far Future";
      case( 9):return "Future in the Past";
      case(10):return "Past in the Future";
      case(11):return "Distant Past";
      case(12):return "Close Past";
      case(13):return "Generalisation";
      case(14):return "Hypothetical";
      case(15):return "Question";
      case(16):return "Relative Future";
      case(17):return "Relative Past";
      case(18):return "Necessity";
      case(19):return "Conditional";
      case(20):return "Conditional Past";
      case(21):return "Conditional Future";
      case(22):return "Plus-Perfect";
    }
  }
  
  public static String description(int i){
    switch(i){
      default:return "-";
      case( 0):return "Action in the present";
      case( 1):return "Action in the past";
      case( 2):return "Action in the future";
      case( 3):return "Continuing action in the past";
      case( 4):return "Action that was completed in the past";
      case( 5):return "Action that happened for an undefined time in the past";
      case( 6):return "Continuing Action in the future";
      case( 7):return "Action in the near future";
      case( 8):return "Action in the far future";
      case( 9):return "Action that happens in the future from a past perspective";
      case(10):return "Action that already happened from a future perspective";
      case(11):return "Action in the distant past";
      case(12):return "Action in the near past";
      case(13):return "Action portrayed as a general truth or very usual";
      case(14):return "Hypothetical action that might occur";
      case(15):return "Questioning an action in a statement";
      case(16):return "Action that happens in the future from a time perspective in the context";
      case(17):return "Action that happened in the past from a time perspective in the context";
      case(18):return "Action that is or is seen as necessary";
      case(19):return "Action that is bound to a condition in the context";
      case(20):return "Past Action that was bound to a condition in the context";
      case(21):return "Future Action that is bound to a condition in the context";
      case(22):return "Action that happened before the past";
    }
  }
  
  public static int getAmount(){
    return 22; //NEEDS TO BE UPDATED WHEN ADDING NEW QUANTIFIERS
  }
}



public static class ConjunctionTypes{
  public static int ADDITIVE = 0;
  public static int DISJUNCTIVE = 1;
  public static int NEGATIVE = 2;
  public static int CONTRAJUNCTIVE = 3;
  public static int NONJUNCTIVE = 4;
  public static int CONTINUITIVE = 5;
  public static int NONADDITIVE = 6;
  public static int ADVERSATIVE = 7;
  public static int OPPOSITIVE = 8;
  public static int IMPLICATIVE = 9;
  public static int CONDITIVE = 10;
  public static int BICONDITIVE = 11;
  public static int EXTENSIVE = 12;
  public static int SUBTRACTIVE = 13;
  public static int COMPERATIVE = 14;
  public static int CONZESSIVE = 15;
  public static int CAUSATIVE = 16;
  public static int CONTRAADVERSATIVE = 17;
  public static int PURPOSIVE = 18;
  public static int DISCONZESSIVE = 19;
  public static int CONSECUTIVE = 20;
  public static int RESTRICTIVE = 21;
  public static int ALTERATIVE = 22;
  public static int EXPLANATIVE = 23;
  public static int SIMULTIVE = 24;
  public static int PRETEMPORATIVE = 25;
  public static int POSTTEMPORATIVE = 26;
  public static int DISCOMPERATIVE = 27;
  
  public static int OTHER = -1;
  
  public static String toString(int i){
    switch(i){
      default:return "Other";
      case( 0):return "Additive";
      case( 1):return "Disjunctive";
      case( 2):return "Negative";
      case( 3):return "Contrajunctive";
      case( 4):return "Nonjunctive";
      case( 5):return "Continuitive";
      case( 6):return "Nonadditive";
      case( 7):return "Adversative";
      case( 8):return "Oppositive";
      case( 9):return "Implicative";
      case(10):return "Conditive";
      case(11):return "Biconditive";
      case(12):return "Extensive";
      case(13):return "Subtractive";
      case(14):return "Comperative";
      case(15):return "Conzessive";
      case(16):return "Causative";
      case(17):return "Contraadversative";
      case(18):return "Purposive";
      case(19):return "Disconzessive";
      case(20):return "Consecutive";
      case(21):return "Restrictive";
      case(22):return "Alterantive";
      case(23):return "Explanative";
      case(24):return "Simultive";
      case(25):return "Pretemporative";
      case(26):return "Posttemporative";
      case(27):return "Discomperative";
    }
  }
  
  public static String description(int i){
    switch(i){
      default:return "-";
      case( 0):return "Adding two objects/sentences";
      case( 1):return "Choosing between two options or both";
      case( 2):return "Negating an object/sentence";
      case( 3):return "Choosing only one out of multiple options";
      case( 4):return "Choosing none of muliple options";
      case( 5):return "Making a sequence of options/objects/sentences";
      case( 6):return "Negating a certain combination of options";
      case( 7):return "EXPLANATION MISSING (but)";
      case( 8):return "The secondary option contradicts the primary option";
      case( 9):return "The first option implies the second";
      case(10):return "The first option influences the second";
      case(11):return "Both options are the same (or extremely similar)";
      case(12):return "extends the first object with information";
      case(13):return "extracts information from the first object";
      case(14):return "compares two options as similar";
      case(15):return "EXPLANATION MISSING (obwohl)";
      case(16):return "option 2 is the reason for option 1";
      case(17):return "preferable to option 2";
      case(18):return "option 1 is neccessary for option 2";
      case(19):return "taking option 1 while ignoring option 2's effects";
      case(20):return "option 1 is the precondition for option 2";
      case(21):return "EXPLANATION MISSING (wohingegen)";
      case(22):return "option 2 is an alternative to option 1";
      case(23):return "option 1 is explained by option 2";
      case(24):return "both options happen at the same time";
      case(25):return "option 1 happened after option 2";
      case(26):return "option 1 happened before option 2";
      case(27):return "compares two options as not similar";
    }
  }
  
  public static String exampleEng(int i){
    switch(i){
      default:return "-";
      case( 0):return "and, aswell";
      case( 1):return "or";
      case( 2):return "not";
      case( 3):return "either or";
      case( 4):return "neither";
      case( 5):return "(comma), and";
      case( 6):return "(none of the options)";
      case( 7):return "but";
      case( 8):return "yet, contrasting";
      case( 9):return "causing, implying";
      case(10):return "if, when";
      case(11):return "euqals";
      case(12):return "with";
      case(13):return "without";
      case(14):return "like, similar to";
      case(15):return "although, though";
      case(16):return "because, cause";
      case(17):return "rather";
      case(18):return "for (doing so, the purpose of)";
      case(19):return "regardless";
      case(20):return "so that";
      case(21):return "while";
      case(22):return "instead";
      case(23):return "by (doing)";
      case(24):return "while also";
      case(25):return "after";
      case(26):return "before";
      case(27):return "unlike";
    }
  }
  
  public static String exampleGer(int i){
    switch(i){
      default:return "-";
      case( 0):return "und";
      case( 1):return "oder";
      case( 2):return "nicht, kein";
      case( 3):return "entweder oder";
      case( 4):return "weder noch";
      case( 5):return "(Komma einer Aufzählung), und";
      case( 6):return "(keines davon)";
      case( 7):return "aber";
      case( 8):return "trotzdem";
      case( 9):return "impliziert, dadurch, folglich";
      case(10):return "wodurch, weshalb";
      case(11):return "entspricht, gleicht";
      case(12):return "mit";
      case(13):return "ohne";
      case(14):return "wie, ähnlich";
      case(15):return "obwohl";
      case(16):return "weil";
      case(17):return "anstatt";
      case(18):return "um (zu erreichen), für";
      case(19):return "trotz, obwohl";
      case(20):return "damit, für";
      case(21):return "wohingegen, während";
      case(22):return "alternativ, anstatt";
      case(23):return "um (zu schaffen), für";
      case(24):return "während, zuweilen";
      case(25):return "nachdem";
      case(26):return "bevor";
      case(27):return "anders als";
    }
  }
  
  public static int getAmount(){
    return 22; //NEEDS TO BE UPDATED WHEN ADDING NEW QUANTIFIERS
  }
}




public class WordModifier{ //Used for adding Pre/Post-Syllables or modifications
  public SyllableModifier[] modifiers = new SyllableModifier[0]; 
  public String name = "";
  public int nameId = -1;
  
  public WordModifier(SyllableModifier[] sl, String n){
    modifiers = sl;
    name = n;
    //sort();
  }
  
  public WordModifier(String s){ //Used for loading from a file
    String[] tmp = split(s,':');
    nameId = int( split(tmp[0], ',')[0] );
    name = split(tmp[0], ',')[2];
    
    modifiers = new SyllableModifier[int( split(tmp[0], ',')[1] )];
    for(int i = 0; i<modifiers.length;i++){
      modifiers[i] = new SyllableModifier( tmp[i+1] );
    }
    
    println("Quantifier: "+nameId+", "+name+" : "+toString());
  }
  
  public String toString(){
    String tmp = "";
    for(int i = 0; i<modifiers.length ; i++){ 
      tmp += modifiers[i].toString();
    }
    return tmp;
  }
  
  public String saveModifier(){
    String tmp = ""+nameId +","+ modifiers.length +","+name;
    for(int i = 0; i<modifiers.length;i++){
      tmp += ":"+modifiers[i].saveModifier();
    }
    return tmp;
  }
  
  public void sort(){
    SyllableModifier[] m = new SyllableModifier[modifiers.length];
    /*
    for(int i = 0;i<m.length;i++){
      for(int o = 0; o < modifiers.length;o++){
        if(modifiers[o] != null){
          if(modifiers[o].preSyllable){
            m[i] = modifiers[o];
            modifiers[o] = null;
            break;
          }else if(modifiers[o].postSyllable){
            
          }else if(modifiers[o].inSyllable){
            
          }else { //syllable modification
            
          }
        }
      }
    }
    modifiers = m;*/
  }
}
public class SyllableModifier{
  public int syllablePosition = -1; //either the position, the priority (post/pre) or the inset position (after >0 else before)
  
  public boolean preSyllable = false;
  public boolean postSyllable = false;
  public boolean inSyllable = false;
  
  public boolean onsetFixed = false;
  public String onsetSound = ""; //if fixed
  public int onsetReferencePosition = -1;     //if not fixed
  public boolean onsetCopyOnset = true;       //if not fixed (if the onset or the coda of the selected syllable should be copied)
  
  public boolean nucleusFixed = false;
  public String nucleusSound = ""; //if fixed
  public int nucleusReferencePosition = -1;    //if not fixed

  public boolean codaFixed = false;
  public String codaSound = ""; //if fixed
  public int codaReferencePosition = -1;      //if not fixed
  public boolean codaCopyCoda = true;       //if not fixed (if the onset or the coda of the selected syllable should be copied)
  
  public SyllableModifier(int type, int pos, String on, String nu, String co){ //cvc
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = true;   onsetSound = on;
    nucleusFixed = true; nucleusSound = nu;
    codaFixed = true;    codaSound = co;
  }
  public SyllableModifier(int type, int pos, String on, String nu,int coP, boolean coR){ //cvC
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = true;   onsetSound = on;
    nucleusFixed = true; nucleusSound = nu;
    codaFixed = false;   codaReferencePosition = coP; codaCopyCoda = coR;
  }
  public SyllableModifier(int type, int pos, String on, int nuP, String co){ //cNc
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = true;   onsetSound = on;
    nucleusFixed = false; nucleusReferencePosition = nuP;
    codaFixed = true;    codaSound = co;
  }
  public SyllableModifier(int type, int pos, int onP, boolean onR, String nu, String co){ //Ovc
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = false;   onsetReferencePosition = onP; onsetCopyOnset = onR;
    nucleusFixed = true; nucleusSound = nu;
    codaFixed = true;    codaSound = co;
  }
  public SyllableModifier(int type, int pos, String on, int nuP, int coP, boolean coR){ //cNC
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = true;    onsetSound = on;
    nucleusFixed = false; nucleusReferencePosition = nuP;
    codaFixed = false;    codaReferencePosition = coP; codaCopyCoda = coR;
  }
  public SyllableModifier(int type, int pos, int onP, boolean onR, int nuP, String co){ //ONc
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = false;   onsetReferencePosition = onP; onsetCopyOnset = onR;
    nucleusFixed = false; nucleusReferencePosition = nuP;
    codaFixed = true;     codaSound = co;
  }
  public SyllableModifier(int type, int pos, int onP, boolean onR, String nu, int coP, boolean coR){  //OvC
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = false;   onsetReferencePosition = onP; onsetCopyOnset = onR;
    nucleusFixed = true;  nucleusSound = nu;
    codaFixed = false;    codaReferencePosition = coP; codaCopyCoda = coR;
  }
  public SyllableModifier(int type, int pos, int onP, boolean onR, int nuP, int coP, boolean coR){ //ONC
    preSyllable = type == 1; postSyllable = type == 2; inSyllable = type == 3;
    syllablePosition = pos;
    
    onsetFixed = false;   onsetReferencePosition = onP; onsetCopyOnset = onR;
    nucleusFixed = false; nucleusReferencePosition = nuP;
    codaFixed = false;    codaReferencePosition = coP; codaCopyCoda = coR;
  }
  
  public SyllableModifier(String s){ //For the save/load system
    String[] tmp = split(s,',');
    syllablePosition = int(tmp[0]);
    preSyllable = int(tmp[1]) == 1;
    postSyllable = int(tmp[1]) == 2;
    inSyllable = int(tmp[1]) == 3;
    onsetFixed = int(tmp[2]) == 1;
    onsetSound = tmp[3];
    onsetReferencePosition = int(tmp[4]);
    onsetCopyOnset = int(tmp[5]) == 1;
    nucleusFixed = int(tmp[6]) == 1;
    nucleusSound = tmp[7];
    nucleusReferencePosition = int(tmp[8]);
    codaFixed = int(tmp[9]) == 1;
    codaSound = tmp[10];
    codaReferencePosition = int(tmp[11]);
    codaCopyCoda = int(tmp[12]) == 1;
  }
  
  public String toString(){
    String tmp = "";
    tmp += (postSyllable || inSyllable)?"-[":"[";
    
    tmp += (preSyllable || postSyllable)? "": syllablePosition+"_";
    
    tmp += onsetFixed? onsetSound : onsetCopyOnset? "Oo"+onsetReferencePosition:"Oc";
    tmp += nucleusFixed? nucleusSound : "N"+nucleusReferencePosition;
    tmp += codaFixed? codaSound : codaCopyCoda? "Cc"+codaReferencePosition:"Co";
    
    tmp += (preSyllable || inSyllable)?"]-":"]";
    return tmp;
  }
  
  public String saveModifier(){
    String tmp = syllablePosition +","+ (preSyllable?"1":postSyllable?"2":inSyllable?"3":"0");
    tmp += ","+ (onsetFixed?"1":"0") +","+ onsetSound +","+ onsetReferencePosition +","+ (onsetCopyOnset?"1":"0");
    tmp += ","+ (nucleusFixed?"1":"0") +","+ nucleusSound +","+ nucleusReferencePosition;
    tmp += ","+ (codaFixed?"1":"0") +","+ codaSound +","+ codaReferencePosition +","+ (codaCopyCoda?"1":"0");
    return tmp;
  }
}
