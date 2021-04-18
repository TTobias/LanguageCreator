import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LanguageCreator extends PApplet {



//For Settings
public SceneManager sceneManager;
public void settings(){
  size(1400,900);
  languageData = new LanguageData();
  sceneManager = new SceneManager();
}

//Called once at the beginning
public void start(){
}

//Called every frame
public void draw(){
  sceneManager.draw();
  mouseInput();
  sceneManager.btnFunctions();
  
  redrawUI();
}

//Called when using the MouseWheel
public void mouseWheel(MouseEvent ev){
  float e = ev.getCount();
  if(e < 0){
    sceneManager.onScrollDown();
    //println("scrolldown");
  }
  else if (e > 0){
    sceneManager.onScrollUp();
    //println("scrollup");
  }
}

//Called when a key is pressed or released
public void keyPressed(){
  sceneManager.onKeyDown();
}
public void keyReleased(){
  sceneManager.onKeyUp();
}

//Called every frame by draw(), checks for mouse Input
public static boolean pmouse = false;
public void mouseInput(){
  //OnMouseDown: any
  if(!pmouse && mousePressed){
    sceneManager.onMouseDown();
  }
  
  //OnMouse: any
  if(pmouse && mousePressed){
    sceneManager.onMouse();
  }
  
  //OnMouseUp: any
  if(pmouse && !mousePressed){
    sceneManager.onMouseUp();
  }
  
  pmouse = mousePressed;
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
public class AnalysisScene extends Scene{
  
  public AnalysisScene(){
    super("Analysis");
    constructGui();
    onInstanciate();
  }
  
  public UI_Button creationModulButton;
  public UI_Button backButton;
  
  public void constructGui(){
    creationModulButton = new UI_Button( new Vector2(300,300),new Vector2(300,60),"Start Analysis",true );
    backButton = new UI_Button( new Vector2(10,10),new Vector2(200,30),"Back to Menu",true );
    
    addUiElement(creationModulButton);
    addUiElement(backButton);
  }
  
  public void onInstanciate(){ }
  
  public void btnFunctions(){
    if(creationModulButton.getTrigger()){
      println("\nDebug: Button pressed");
      startAnalysis();
    }
    if(backButton.getTrigger()){
      println("Debug: Back to Menu pressed");
      sceneManager.switchSceneByName("Startup");
    }
  }
}


//ANALYSIS : Lexer >> Parser >> (Later semantic tests)
public String originalText;
public void startAnalysis(){
  String tmp[] = loadStrings("analysis_input.txt");
  originalText = "";
  for(int i = 0; i< tmp.length; i++){ //turns the array into a single string
    originalText += tmp[i] + "\n";
  }
  
  println("START TEXT:\n"+originalText);
  lexer(originalText);
  println( arraylistToString(tokenList) +"\n\n");
  parser();
  println(expression.toString());
}



//LEXER : turns text into a token list
public char[] lexer_characters;
public void lexer(String s){
  lexer_characters = s.toCharArray();
  println( arrayToString(lexer_characters) );
  lex(0);
}
//i is the actual position in the string
public void lex(int i){
  if(i >= lexer_characters.length){ return; }
  
  else if(lexer_characters[i] == ' '){ lex(i+1); }
  else if(lexer_characters[i] == '.'){ tokenList.add(new langToken(tokenDef.ENDMARK)); lex(i+1); }
  else if(lexer_characters[i] == '?'){ tokenList.add(new langToken(tokenDef.QUESTMARK)); lex(i+1); }
  else if(lexer_characters[i] == '!'){ tokenList.add(new langToken(tokenDef.EXCMARK)); lex(i+1); }
  else if(lexer_characters[i] == ','){ tokenList.add(new langToken(tokenDef.COMMA)); lex(i+1); }
  else if(lexer_characters[i] == ';'){ tokenList.add(new langToken(tokenDef.SEMICOLON)); lex(i+1); }
  else if(lexer_characters[i] == ':'){ tokenList.add(new langToken(tokenDef.COLON)); lex(i+1); }
  else if(lexer_characters[i] == '('){ tokenList.add(new langToken(tokenDef.LPAR)); lex(i+1); }
  else if(lexer_characters[i] == ')'){ tokenList.add(new langToken(tokenDef.RPAR)); lex(i+1); }
  else if(lexer_characters[i] == '"'){ tokenList.add(new langToken(tokenDef.QUOT)); lex(i+1); }
  else if(lexer_characters[i] == '„'){ tokenList.add(new langToken(tokenDef.QUOT)); lex(i+1); }
  else if(lexer_characters[i] == '“'){ tokenList.add(new langToken(tokenDef.QUOT)); lex(i+1); }
  else if(lexer_characters[i] == '/'){ tokenList.add(new langToken(tokenDef.SLASH)); lex(i+1); }
  else if(lexer_characters[i] == '\n'){ tokenList.add(new langToken(tokenDef.BREAK)); lex(i+1); }
  else if(isLetter(lexer_characters[i])){ lex_word(i+1, ""+lexer_characters[i]); }
  else{ tokenList.add(new langToken(tokenDef.UNKNOWN)); lex(i+1); }
}
public void lex_word(int i, String s){
  if(isLetter(lexer_characters[i]) && i < lexer_characters.length) {
    lex_word(i+1,s+lexer_characters[i]);
  }else{
    tokenList.add(new langToken(tokenDef.WORD, s));
    lex(i);
  }
}





//PARSER : turns a token list into an expression
public void parser(){
  expression = new Exp_text(new ArrayList<LangExp>());
  pars(0, new ArrayList<LangExp>());
}
public void pars(int i, ArrayList<LangExp> ls){
  if(i >= tokenList.size()){ if(ls.size() > 0) { expression.exp.add(new Exp_error()); } }
  else if(tokenList.get(i).type == tokenDef.BREAK){ pars(i+1, ls); }
  
  else if(tokenList.get(i).type == tokenDef.WORD){ pars(i+1, copyAndExtend(ls,pars_word(tokenList.get(i).accu, ls)) ); }
  else if(tokenList.get(i).type == tokenDef.COMMA){ pars(i+1, copyAndExtend(ls,new Exp_symbol(ExpSymbolDef.COMMA)) ); }
  else if(tokenList.get(i).type == tokenDef.SEMICOLON){ pars(i+1, copyAndExtend(ls,new Exp_symbol(ExpSymbolDef.SEMICOLON)) ); }
  else if(tokenList.get(i).type == tokenDef.SLASH){ pars(i+1, copyAndExtend(ls,new Exp_symbol(ExpSymbolDef.SLASH)) ); }
  
  else if(tokenList.get(i).type == tokenDef.ENDMARK){ if(ls.size() > 0){  expression.exp.add(new Exp_statement(ls)); } pars(i+1, new ArrayList<LangExp>()); }
  else if(tokenList.get(i).type == tokenDef.QUESTMARK){ if(ls.size() > 0){ expression.exp.add(new Exp_question(ls)); } pars(i+1, new ArrayList<LangExp>()); }
  else if(tokenList.get(i).type == tokenDef.EXCMARK){ if(ls.size() > 0){ expression.exp.add(new Exp_exclemation(ls)); } pars(i+1, new ArrayList<LangExp>()); }
  
  else if(tokenList.get(i).type == tokenDef.COLON){ pars_colon(i+1,ls,new ArrayList<LangExp>()); }
  else if(tokenList.get(i).type == tokenDef.LPAR){ pars_remark(i+1,ls,new ArrayList<LangExp>()); }
  else if(tokenList.get(i).type == tokenDef.QUOT){ pars_quotation(i+1,ls,new ArrayList<LangExp>()); }
  
  else{ pars(i+1, copyAndExtend(ls,new Exp_error()) ); }
}
public void pars_colon(int i, ArrayList<LangExp> es, ArrayList<LangExp> cs){
  if(i >= tokenList.size()){ expression.exp.add(new Exp_error()); }
  
  else if(tokenList.get(i).type == tokenDef.WORD){ pars_colon(i+1,es, copyAndExtend(cs,pars_word(tokenList.get(i).accu, cs)) ); }
  else if(tokenList.get(i).type == tokenDef.COMMA){ pars_colon(i+1,es, copyAndExtend(cs,new Exp_symbol(ExpSymbolDef.COMMA)) ); }
  else if(tokenList.get(i).type == tokenDef.SEMICOLON){ pars_colon(i+1,es, copyAndExtend(cs,new Exp_symbol(ExpSymbolDef.SEMICOLON)) ); }
  else if(tokenList.get(i).type == tokenDef.SLASH){ pars_colon(i+1,es, copyAndExtend(cs,new Exp_symbol(ExpSymbolDef.SLASH)) ); }
  
  else{ pars(i+1, copyAndExtend(es, new Exp_colon(cs)) ); }
}
public void pars_remark(int i, ArrayList<LangExp> es, ArrayList<LangExp> rs){
  if(i >= tokenList.size()){ expression.exp.add(new Exp_error()); }
  
  else if(tokenList.get(i).type == tokenDef.WORD){ pars_colon(i+1,es, copyAndExtend(rs,pars_word(tokenList.get(i).accu, rs)) ); }
  else if(tokenList.get(i).type == tokenDef.COMMA){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.COMMA)) ); }
  else if(tokenList.get(i).type == tokenDef.SEMICOLON){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.SEMICOLON)) ); }
  else if(tokenList.get(i).type == tokenDef.SLASH){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.SLASH)) ); }
  
  else if(tokenList.get(i).type == tokenDef.RPAR){ pars(i+1,copyAndExtend(es,new Exp_remark(rs)) ); }
  else{ pars(i+1, copyAndExtend(es, new Exp_error()) ); }
}
public void pars_quotation(int i, ArrayList<LangExp> es, ArrayList<LangExp> rs){
  if(i >= tokenList.size()){ expression.exp.add(new Exp_error()); }
  
  else if(tokenList.get(i).type == tokenDef.WORD){ pars_colon(i+1,es, copyAndExtend(rs,pars_word(tokenList.get(i).accu, rs)) ); }
  else if(tokenList.get(i).type == tokenDef.COMMA){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.COMMA)) ); }
  else if(tokenList.get(i).type == tokenDef.SEMICOLON){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.SEMICOLON)) ); }
  else if(tokenList.get(i).type == tokenDef.SLASH){ pars_colon(i+1,es, copyAndExtend(rs,new Exp_symbol(ExpSymbolDef.SLASH)) ); }
  
  else if(tokenList.get(i).type == tokenDef.QUOT){ pars(i+1,copyAndExtend(es,new Exp_remark(rs)) ); }
  else{ pars(i+1, copyAndExtend(es, new Exp_error()) ); }
}
public LangExp pars_word(String s, ArrayList<LangExp> ls){ //List is used for checking older words
  if( isArticle( s ) ) { return new Exp_article( uncapitalize(s) ); }
  if( isPronoun( s ) ) { return new Exp_pronoun( uncapitalize(s) ); }
  if( isQuantifier( s ) ) { return new Exp_quantifier( uncapitalize(s) ); }
  if( isAdverb( s ) ) { return new Exp_adverb( uncapitalize(s) ); }
  if( isConnector( s ) ) { return new Exp_connector( uncapitalize(s) ); }
  if( isPreposition( s ) ) { return new Exp_preposition( uncapitalize(s) ); }
  if( ls.size() != 0 && isCapitalized( s )){ return new Exp_noun( s ); }
  return new Exp_word(s);
}




//REFINER : turns sentences based on a word list into grammatical structure with subjects, predicated and objects divided into articles verbs nouns adjectives and other stuff









//GRAMMAR EXPRESSION definitions
public GExp_text grammarExpression;
public static class GExpSymbolDef{
  public static int COMMA = 0;
  public static int SEMICOLON = 1;
  public static int SLASH = 2;
}
public class GammarExp{ 
  public String toString(){ println("ERROR: Language Expression"); return ""; }
}
public class GExp_text extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_text(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += "\n, "+ exp.get(i).toString(); }  return "TEXT[ "+tmp+" \n]"; }
}
public class GExp_statement extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_statement(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "STATEMENT[ "+tmp+" ]"; }
}
public class GExp_question extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_question(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "QUESTION[ "+tmp+" ]"; }
}
public class GExp_exclemation extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_exclemation(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "EXCLEMATION[ "+tmp+" ]"; }
}
public class GExp_quotation extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_quotation(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "QUOTATION[ "+tmp+" ]"; }
}
public class GExp_remark /*()*/ extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_remark(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "REMARK[ "+tmp+" ]"; }
}
public class GExp_colon extends GammarExp{ 
  public ArrayList<LangExp> exp; 
  public GExp_colon(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "COLON[ "+tmp+" ]"; }
}
public class GExp_subject extends GammarExp{ 
  public ArrayList<LangExp> exp;
  public GExp_subject(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "SUBJECT{ "+tmp+" }"; }
}
public class GExp_predicate extends GammarExp{ 
  public ArrayList<LangExp> exp;
  public GExp_predicate(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "PREDICATE{ "+tmp+" }"; }
}
public class GExp_object extends GammarExp{ 
  public ArrayList<LangExp> exp;
  public GExp_object(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "OBJECT{ "+tmp+" }"; }
}
public class GExp_word extends GammarExp{ 
  public String word; 
  public GExp_word(String w){ word = w; }
  public String toString(){ return "WORD("+word+")"; }
}
public class GExp_symbol extends GammarExp{ 
  public int symbol; 
  public GExp_symbol(int s){ symbol = s; }
  public String toString(){ return symbol==0?"COMMA": symbol==1?"SEMICOLON": symbol==2?"SLASH": "???"; }
}
public class GExp_error extends GammarExp{ 
  public GExp_error(){}
  public String toString(){ return "--ERROR--"; }
}






//EXPRESSION definitions
public Exp_text expression;
public static class ExpSymbolDef{
  public static int COMMA = 0;
  public static int SEMICOLON = 1;
  public static int SLASH = 2;
}
public class LangExp{ 
  public String toString(){ println("ERROR: Language Expression"); return ""; }
}
public class Exp_text extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_text(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += "\n, "+ exp.get(i).toString(); }  return "TEXT[ "+tmp+" \n]"; }
}
public class Exp_statement extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_statement(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "STATEMENT[ "+tmp+" ]"; }
}
public class Exp_question extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_question(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "QUESTION[ "+tmp+" ]"; }
}
public class Exp_exclemation extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_exclemation(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "EXCLEMATION[ "+tmp+" ]"; }
}
public class Exp_quotation extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_quotation(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "QUOTATION[ "+tmp+" ]"; }
}
public class Exp_remark /*()*/ extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_remark(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "REMARK[ "+tmp+" ]"; }
}
public class Exp_colon extends LangExp{ 
  public ArrayList<LangExp> exp; 
  public Exp_colon(ArrayList<LangExp> e){ exp = e; }
  public String toString(){ String tmp = ""; for(int i = 0; i<exp.size();i++){ tmp += exp.get(i).toString()+" , "; }  return "COLON[ "+tmp+" ]"; }
}
public class Exp_word extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_word(String w){ word = w; }
  public String toString(){ return "WORD("+word+")"; }
}
public class Exp_noun extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_noun(String w){ word = w; }
  public String toString(){ return "NOUN("+word+")"; }
}
public class Exp_article extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_article(String w){ word = w; }
  public String toString(){ return "ARTICLE("+word+")"; }
}
public class Exp_pronoun extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_pronoun(String w){ word = w; }
  public String toString(){ return "PRONOUN("+word+")"; }
}
public class Exp_quantifier extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_quantifier(String w){ word = w; }
  public String toString(){ return "QUANTIFIER("+word+")"; }
}
public class Exp_adverb extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_adverb(String w){ word = w; }
  public String toString(){ return "ADVERB("+word+")"; }
}
public class Exp_particle extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_particle(String w){ word = w; }
  public String toString(){ return "PARTICLE("+word+")"; }
}
public class Exp_connector extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_connector(String w){ word = w; }
  public String toString(){ return "CONNECTOR("+word+")"; }
}
public class Exp_preposition extends LangExp{ //Used when the word can't be identified
  public String word; 
  public Exp_preposition(String w){ word = w; }
  public String toString(){ return "Prepsoition("+word+")"; }
}
public class Exp_symbol extends LangExp{ 
  public int symbol; 
  public Exp_symbol(int s){ symbol = s; }
  public String toString(){ return symbol==0?"COMMA": symbol==1?"SEMICOLON": symbol==2?"SLASH": "???"; }
}
public class Exp_error extends LangExp{ 
  public Exp_error(){}
  public String toString(){ return "--ERROR--"; }
}



//TOKEN definitions
public ArrayList<langToken> tokenList = new ArrayList<langToken>();
public static class tokenDef{ 
  public static int UNKNOWN = -1;  // >>???
  public static int ENDMARK = 0;  // .
  public static int QUESTMARK = 1; // ?
  public static int EXCMARK = 2; // !
  public static int COMMA = 3; // ,
  public static int COLON = 4; // :
  public static int SEMICOLON = 5; // ;
  public static int SLASH = 6; // /
  public static int LPAR = 7; // ( 
  public static int RPAR = 8; // ) 
  public static int QUOT = 9; // " 
  public static int WORD = 10;
  public static int BREAK = 11; // \n
}
public class langToken{  
  public int type = -1;
  public String accu = ""; //Used in case of words
  
  public langToken(int t){ type = t; }
  public langToken(int t, String a) { type = t; accu = a; }
  
  public String toString(){
    return type==0?"ENDMARK": type==1?"QUESTMARK": type==2?"EXCMARK": type==3?"COMMA": type==4?"COLON": type==5?"SEMICOLON": type==6?"SLASH": type==7?"LPAR": 
           type==8?"RPAR": type==9?"QUOT": type==10?"WORD:"+accu: type==11?"BREAK":// type==12?"ENDMARK": type==13?"ENDMARK": type==14?"ENDMARK": type==15?"ENDMARK": 
           "???";
  }
}
public class CreationScene extends Scene{
  
  public CreationScene(){
    super("Creation");
    constructGui();
    onInstanciate();
  }
  
  public UI_Button backButton;
  public UI_LayerSwitch mainLayerSwitch;
  public UI_Text missingLowPriority;
  public UI_Text missingMediumPriority;
  public UI_Text missingHighPriority;
  
  //Layer0 - DATA
  public UI_Layer layer0_data;
    public UI_Text dataFileText;
    public UI_TextInputField dataFileNameInput;
    public UI_Button saveDataButton; 
    public UI_Button loadDataButton; 
  
  //Layer1 - PHONOLOGY
  public UI_Layer layer1_phonology;
  public UI_LayerSwitch layer1Switch;
  
  public UI_Layer layer1a_inventory;
    public UI_SelectionTable selectPhonologyConsonantTable;
    public UI_SelectionTable selectPhonologyVowelTable;
    public UI_Button bakePhoneticInventoryButton;
    public UI_Text phoneticInventoryInstructionText;
  public UI_Layer layer1b_phonotactics;
    public UI_SyllableShapeEditor syllableShapeEditor;
    public UI_Button bakeSyllableShapeButton;
    public UI_Text syllableShapeInstructionText;
  public UI_Layer layer1c_exceptions;
    ///////////////////////////
  public UI_Layer layer1d_stressing;
    public UI_IntegerField primaryStressingPositionField;
    public UI_Text syllableStressingInstructionText;
    public UI_Button confirmSyllableStressButton;
  public UI_Layer layer1e_result;
    public UI_Table resultPhonologyConsonantTable;
    public UI_Table resultPhonologyVowelTable;
    public UI_Text resultSyllableStructureText;
    public UI_Text resultPhonotacticalRulesText;
    public UI_Text resultPhonotacticalStressingText;
    public UI_Button confirmPhoneticResultsButton;
  
  //Layer2 - PROTOLANGUAGE
  public UI_Layer layer2_protolanguage;
  public UI_LayerSwitch layer2Switch;
  
  public UI_Layer layer2a_rootWords;
    public UI_Button addNewRootWordButton;
    public UI_Button appendRootWordButton;
    public UI_MultiText rootWordMultiText;
    public UI_VocabularyList rootWordVocabularyList;
    public UI_WordEditor rootWordEditor;
    public UI_InputKeyboard layer2a_keyboard;
  public UI_Layer layer2b_wordOrder;
  public UI_Layer layer2c_quantifiers;
  public UI_Layer layer2d_tenses;
  public UI_Layer layer2e_valency;
  public UI_Layer layer2f_testing;
  
  //Layer3 - DUMMY
  public UI_Layer layer3_;
  
  public void constructGui(){
    
        missingLowPriority = new UI_Text(new Vector2(width*0.5f-260,height*0.5f-100),new Vector2(500,100), "Not implemented yet\nlow priority");
        missingMediumPriority = new UI_Text(new Vector2(width*0.5f-260,height*0.5f-100),new Vector2(500,100), "Not implemented yet\nmedium priority");
        missingHighPriority = new UI_Text(new Vector2(width*0.5f-260,height*0.5f-100),new Vector2(500,100), "Not implemented yet\nhigh priority");
    
    
    layer0_data = new UI_Layer( "0: Data" );
      dataFileText = new UI_Text( new Vector2( 30, 50), new Vector2(200,25), " Filename:");
      dataFileNameInput = new UI_TextInputField( new Vector2( 30, 75), new Vector2(300,35), "temp",false);
      saveDataButton = new UI_Button(new Vector2( 80, 120), new Vector2(200,30), " Save to File",true); 
      loadDataButton = new UI_Button(new Vector2( 80, 155), new Vector2(200,30), " Load from File",true); 
        
      layer0_data.addObject(dataFileText);
      layer0_data.addObject(dataFileNameInput);
      layer0_data.addObject(saveDataButton);
      layer0_data.addObject(loadDataButton);
    
    layer1_phonology = new UI_Layer( "1: Phonology" );
    
      layer1a_inventory = new UI_Layer( "1a: Inventory" );
        selectPhonologyConsonantTable = new UI_SoundSelectionTable(new Vector2(15,75),new Vector2(1180,460), "data/phonetic_consonant_table.txt");
        selectPhonologyVowelTable = new UI_SoundSelectionTable(new Vector2(15,545),new Vector2(470,340), "data/phonetic_vowel_table.txt");
        phoneticInventoryInstructionText = new UI_Text(new Vector2(500,555),new Vector2(700,260), "Select a few of these symbols: sounds usually appear in sequences."+
        "\nVoiced version usually imply their voiceless equivalents.\n At least 1 nasal and 1 liquid sound.\nChoose at least 2 vowels and up to 20 consonants, the less the better.\n"+
        "Very Common: p,t,l,m,n,s,h,j,w    Rare: θ,ð,q,tɬ.\nWhen you are finished, press 'Bake Table'\n");
        bakePhoneticInventoryButton = new UI_Button(new Vector2(800,height-55),new Vector2(200,40), "Bake Table", true);
        
        layer1a_inventory.addObject(selectPhonologyConsonantTable);
        layer1a_inventory.addObject(selectPhonologyVowelTable);
        layer1a_inventory.addObject(phoneticInventoryInstructionText);
        layer1a_inventory.addObject(bakePhoneticInventoryButton);
    
      layer1b_phonotactics = new UI_Layer( "1b: Phonotactics" );
        syllableShapeEditor = new UI_SyllableShapeEditor(new Vector2(15,75), new Vector2(width-30,100),600,selectPhonologyConsonantTable,selectPhonologyVowelTable);
        bakeSyllableShapeButton = new UI_Button(new Vector2(800,height-95),new Vector2(300,60), "Bake Syllable Structure", true);
        syllableShapeInstructionText = new UI_Text(new Vector2(25,height-115),new Vector2(700,100), "Set up the syllable structure: each Syllable consists of 3 parts: A number of x consonants\n"+
        "(onset) [green], a vowel (nucleus) [blue] and more consonants (coda) [red].\nThe onset consists of up to 4 sounds and the coda up to 5. A lot of languages don't usa a coda at all.\n"+
        "Double vowels or combinations of 2 vowels are possible. All parts but the primary vowel are optional.");
        
        layer1b_phonotactics.addObject(syllableShapeEditor);
        layer1b_phonotactics.addObject(bakeSyllableShapeButton);
        layer1b_phonotactics.addObject(syllableShapeInstructionText);
      
      layer1c_exceptions = new UI_Layer( "1c: Exceptions" );
        
        layer1c_exceptions.addObject(missingLowPriority);
      
      layer1d_stressing = new UI_Layer( "1d: Stressing" );
        primaryStressingPositionField = new UI_IntegerField(new Vector2(15,75), new Vector2(500,40),"Default Stress Position:",1,-5,8);
        syllableStressingInstructionText = new UI_Text(new Vector2(625,75),new Vector2(700,120), "Decide which syllable should be stressed.\n 0 means no stressing at all. \n"+
        "A negative number is counted from the \nend of the word backwards.");
        confirmSyllableStressButton = new UI_Button(new Vector2(825,225),new Vector2(300,30), "Confirm Stressing", true);
        
        layer1d_stressing.addObject(primaryStressingPositionField);
        layer1d_stressing.addObject(syllableStressingInstructionText);
        layer1d_stressing.addObject(confirmSyllableStressButton);
      
      layer1e_result = new UI_Layer( "1e: Result" );
        resultPhonologyConsonantTable = new UI_Table(new Vector2(15,75),new Vector2(730,420),selectPhonologyConsonantTable);
        resultPhonologyVowelTable = new UI_Table(new Vector2(15,505),new Vector2(400,300),selectPhonologyVowelTable);
        resultSyllableStructureText = new UI_Text(new Vector2(750,75),new Vector2(630,750), "Rules: \nNone \n\n\n\n\n\n\n\n\n\n\n");
        resultPhonotacticalRulesText = new UI_Text(new Vector2(430,505),new Vector2(300,100), "Syllable Shape:\n"+"  C V C");
        resultPhonotacticalStressingText = new UI_Text(new Vector2(430,615),new Vector2(300,180), "Stress\n\n\n");
        confirmPhoneticResultsButton = new UI_Button(new Vector2(230,height-80),new Vector2(300,60), "Confirm",true);
        
        layer1e_result.addObject(resultPhonologyConsonantTable);
        layer1e_result.addObject(resultPhonologyVowelTable);
        layer1e_result.addObject(resultSyllableStructureText);
        layer1e_result.addObject(resultPhonotacticalRulesText);
        layer1e_result.addObject(resultPhonotacticalStressingText);
        layer1e_result.addObject(confirmPhoneticResultsButton);
    
      layer1Switch = new UI_LayerSwitch(new Vector2(10,40),new Vector2(width-20,height-50));
      layer1Switch.addLayer(layer1a_inventory);
      layer1Switch.addLayer(layer1b_phonotactics);
      layer1Switch.addLayer(layer1c_exceptions);
      layer1Switch.addLayer(layer1d_stressing);
      layer1Switch.addLayer(layer1e_result);
      layer1_phonology.addObject(layer1Switch);
    
    
    layer2_protolanguage = new UI_Layer( "2: Protolanguage" );
    
      layer2a_rootWords = new UI_Layer( "2a: Root Words" );
        rootWordMultiText = new UI_MultiText(new Vector2(15,75),new Vector2(700,210));
        rootWordMultiText.addPage( " Instruction", "Instructions not added yet" );
        rootWordMultiText.addPage( " Sound-List", "Sounds not added yet" );
        rootWordMultiText.addPage( " Syllable Data", "Syllable Data not added yet" );
        rootWordMultiText.addPage( " Main Roots", "Important root words not added yet" );
        addNewRootWordButton = new UI_Button(new Vector2(15,305),new Vector2(300,40), "new Word",true);
        appendRootWordButton = new UI_Button(new Vector2(415,305),new Vector2(300,40), "append Word",true);
        layer2a_keyboard = new UI_InputKeyboard(new Vector2(15,740),new Vector2(700,130),resultPhonologyConsonantTable,resultPhonologyVowelTable);
        rootWordVocabularyList = new  UI_VocabularyList(new Vector2(725,75),new Vector2(650,750), layer2a_keyboard);
        rootWordEditor = new UI_WordEditor(new Vector2(15,350),new Vector2(700,380), layer2a_keyboard);
        
        layer2a_rootWords.addObject(addNewRootWordButton);
        layer2a_rootWords.addObject(appendRootWordButton);
        layer2a_rootWords.addObject(rootWordMultiText);
        layer2a_rootWords.addObject(rootWordVocabularyList);
        layer2a_rootWords.addObject(rootWordEditor);
    
      layer2b_wordOrder = new UI_Layer( "2b: Word Order" );
        
        layer2b_wordOrder.addObject(missingHighPriority);
      
      layer2c_quantifiers = new UI_Layer( "2c: Quantifiers" );
        
        layer2c_quantifiers.addObject(missingHighPriority);
      
      layer2d_tenses = new UI_Layer( "2d: Tenses" );
        
        layer2d_tenses.addObject(missingHighPriority);
      
      layer2e_valency = new UI_Layer( "2e: Valency" );
        
        layer2e_valency.addObject(missingMediumPriority);
      
      layer2f_testing = new UI_Layer( "2f: Testing" );
        
        layer2f_testing.addObject(missingLowPriority);
    
      layer2Switch = new UI_LayerSwitch(new Vector2(10,40),new Vector2(width-20,height-50));
      layer2Switch.addLayer(layer2a_rootWords);
      layer2Switch.addLayer(layer2b_wordOrder);
      layer2Switch.addLayer(layer2c_quantifiers);
      layer2Switch.addLayer(layer2d_tenses);
      layer2Switch.addLayer(layer2e_valency);
      layer2Switch.addLayer(layer2f_testing);
      layer2_protolanguage.addObject(layer2Switch);
    
    
    layer3_ = new UI_Layer( "3: Dummy" );
    
    
    mainLayerSwitch = new UI_LayerSwitch(new Vector2(5,5),new Vector2(width-10,height-10));
    mainLayerSwitch.addLayer(layer0_data);
    mainLayerSwitch.addLayer(layer1_phonology);
    mainLayerSwitch.addLayer(layer2_protolanguage);
    mainLayerSwitch.addLayer(layer3_);
    addUiElement(mainLayerSwitch);
    
    backButton = new UI_Button( new Vector2(width-215,height-45),new Vector2(200,30),"Back to Menu",true );
    addUiElement(backButton);
  }
  
  public void onInstanciate(){ }
  
  public void btnFunctions(){
    //ALL LAYERS
    if(backButton.getTrigger()){
      println("Debug: Back to Menu pressed");
      sceneManager.switchSceneByName("Startup");
    }
    
    //LAYER 0
    if(saveDataButton.getTrigger()){
      println("Save Data");
      languageData.projectpath = dataFileNameInput.text;
      languageData.saveToFile();
    }
    if(loadDataButton.getTrigger()){
      println("Load Data");
      languageData.projectpath = dataFileNameInput.text;
      languageData.loadFromFile();
      onDataFileLoad();
    }
    
    //LAYER 1
    if(bakePhoneticInventoryButton.getTrigger()){
      println("Rebake Inventory");
      syllableShapeEditor.reimport();
      resultPhonologyConsonantTable.applyTable(selectPhonologyConsonantTable);
      resultPhonologyVowelTable.applyTable(selectPhonologyVowelTable);
    }
    if(bakeSyllableShapeButton.getTrigger()){
      println("Rebake Syllable Shape");
      updateSyllableShapeResults();
      //syllableShapeEditor.reimport(); ////////////////////////////////////////
    }
    if(confirmSyllableStressButton.getTrigger()){
      println("Confirm Syllable Stressing");
      updateSyllableStressResults();
      //syllableShapeEditor.reimport(); ////////////////////////////////////////
    }
    if(primaryStressingPositionField.getTrigger()){
      //////////////////////////////////////// /////////////////////////////////
    }
    if(confirmPhoneticResultsButton.getTrigger()){
      println("Confirmed Phonetics");
      confirmPhonetics();
    }
    
    //LAYER2
    if(rootWordEditor.getTrigger()){
      println("Changed the wordlist");
      rootWordVocabularyList.reloadWords();
    }
    if(addNewRootWordButton.getTrigger()){
      println("Add new Word");
      rootWordEditor.reset();
    }
    if(appendRootWordButton.getTrigger()){
      println("Append Word to the List");
      rootWordEditor.word = new WordTranslation(rootWordEditor.wordInput.text, rootWordEditor.translationInput.text, rootWordEditor.wordTypeSelection.selected);
      languageData.wordlist.add( rootWordEditor.word );
      rootWordVocabularyList.reloadWords();
      rootWordEditor.reset();
    }
    if(rootWordVocabularyList.getTrigger()){
      println("Set Word As \"Active to Edit\"");
      rootWordEditor.setWord( rootWordVocabularyList.selection );
    }
  }
  
  
  
  public void updateSyllableShapeResults(){
    String tmpShape = "  "+(syllableShapeEditor.onsetDetails.size()>0? "C"+(syllableShapeEditor.onsetDetails.size()>1?syllableShapeEditor.onsetDetails.size():"") : "") +
         (syllableShapeEditor.nucleusDetails.size()==2? " VV " : " V ") +
         (syllableShapeEditor.codaDetails.size()>0? "C"+(syllableShapeEditor.codaDetails.size()>1?syllableShapeEditor.codaDetails.size():"") : "");
    resultPhonotacticalRulesText.text = "Syllable Shape:\n"+tmpShape;
    
    resultSyllableStructureText.text = "Syllable Rules:\n\n";
    for(int i = 0; i<syllableShapeEditor.onsetDetails.size() ; i++){
      resultSyllableStructureText.text += "oC" + (i+1) + ": "  + syllableShapeEditor.onsetDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.text += "\n";
    for(int i = 0; i<syllableShapeEditor.nucleusDetails.size() ; i++){
      resultSyllableStructureText.text += "nV" + (i==0?"":i) + ": " + syllableShapeEditor.nucleusDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.text += "\n";
    for(int i = 0; i<syllableShapeEditor.codaDetails.size() ; i++){
      resultSyllableStructureText.text += "cC" + (i+1) + ": "  + syllableShapeEditor.codaDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.textSize = 14;
  }
  
  public void updateSyllableStressResults(){
    resultPhonotacticalStressingText.text = "Default Word Stressing Position :\n"+primaryStressingPositionField.value+
          "'nd syllable of each word.\n\nIf the word has less syllables:\nThe closest one.";
    resultPhonotacticalStressingText.textSize = 18;
  }
  
  public void confirmPhonetics(){
    //Add those infos to the languageData
    languageData.vowels = resultPhonologyVowelTable.toList();
    languageData.consonants = resultPhonologyConsonantTable.toList();
    
    languageData.onsetAmount = syllableShapeEditor.onsetAmount;
    languageData.nucleusAmount = syllableShapeEditor.doubleNucleus?2:1;
    languageData.codaAmount = syllableShapeEditor.codaAmount;
    
    languageData.onsetOptions = new StringList[languageData.onsetAmount];
    languageData.nucleusOptions = new StringList[languageData.nucleusAmount];
    languageData.codaOptions = new StringList[languageData.codaAmount];
    for(int i = 0; i<languageData.onsetAmount; i++)  { languageData.onsetOptions[i]   = syllableShapeEditor.onsetDetails.get(i).toList(); }
    for(int i = 0; i<languageData.nucleusAmount; i++){ languageData.nucleusOptions[i] = syllableShapeEditor.nucleusDetails.get(i).toList(); }
    for(int i = 0; i<languageData.codaAmount; i++)   { languageData.codaOptions[i]    = syllableShapeEditor.codaDetails.get(i).toList();    }
    
    languageData.stressingPosition = primaryStressingPositionField.value;
    
    //Rootword
    rootWordEditor.wordInput.keyboard.soundBtn = new ArrayList<UI_Button>(); 
    rootWordEditor.wordInput.keyboard.importSounds(languageData.consonants);
    rootWordEditor.wordInput.keyboard.importSounds(languageData.vowels);
  }
  
  public void onDataFileLoad(){
    // // // INCOMPLETE: LAYERS ARE NOT UPDATED
    
    selectPhonologyConsonantTable.loadStatesFromDataFile(languageData.consonants);
    selectPhonologyVowelTable.loadStatesFromDataFile(languageData.vowels);
    syllableShapeEditor.reimport();
    resultPhonologyConsonantTable.applyTable(selectPhonologyConsonantTable);
    resultPhonologyVowelTable.applyTable(selectPhonologyVowelTable);
    
    syllableShapeEditor.loadStatesFromDataFile(selectPhonologyConsonantTable,selectPhonologyVowelTable);
    updateSyllableShapeResults();
    
    primaryStressingPositionField.value = languageData.stressingPosition;
    primaryStressingPositionField.number.text = ""+languageData.stressingPosition;
    updateSyllableStressResults();
    
    rootWordEditor.wordInput.keyboard.soundBtn = new ArrayList<UI_Button>(); 
    rootWordEditor.wordInput.keyboard.importSounds(languageData.consonants);
    rootWordEditor.wordInput.keyboard.importSounds(languageData.vowels);
    
    //rootWordMultiText;
    rootWordVocabularyList.reloadWords();
    //rootWordEditor;
    //layer2a_keyboard;
    
  }
}
public class TranslationScene extends Scene{
  
  public TranslationScene(){
    super("Translation");
    constructGui();
    onInstanciate();
  }
  
  public UI_Button creationModulButton;
  public UI_Button backButton;
  
  public void constructGui(){
    creationModulButton = new UI_Button( new Vector2(300,300),new Vector2(300,60),"Placeholder",true );
    backButton = new UI_Button( new Vector2(10,10),new Vector2(200,30),"Back to Menu",true );
    
    addUiElement(creationModulButton);
    addUiElement(backButton);
  }
  
  public void onInstanciate(){ }
  
  public void btnFunctions(){
    if(creationModulButton.getTrigger()){
      println("Debug: Button pressed");
      //SWITCH SCENE
    }
    if(backButton.getTrigger()){
      println("Debug: Back to Menu pressed");
      sceneManager.switchSceneByName("Startup");
    }
  }
}




public class SceneManager{
  public ArrayList<Scene> scenes = new ArrayList<Scene>();
  public int activeSceneIndex = -1; //don't modify this number directly!
  
  public SceneManager(){
    sceneManager = this;
    
    //Add all the scenes
    scenes.add(new StartupScene());
    scenes.add(new AnalysisScene());
    scenes.add(new CreationScene());
    scenes.add(new TranslationScene());
    
    switchSceneByName("Startup");
  }
  
  public void draw(){ activeScene().draw(); }
  public void show(){ activeScene().show(); }
  public void onKeyUp(){ activeScene().onKeyUp(); }
  public void onKeyDown(){ activeScene().onKeyDown(); }
  public void onMouse(){ activeScene().onMouse(); }
  public void onMouseUp(){ activeScene().onMouseUp(); }
  public void onMouseDown(){ activeScene().onMouseDown(); }
  public void onScrollDown(){ activeScene().onScrollDown(); }
  public void onScrollUp(){ activeScene().onScrollUp(); }
  public void btnFunctions(){ activeScene().btnFunctions(); }
  
  public Scene activeScene(){
    if(activeSceneIndex < 0 || activeSceneIndex >= scenes.size()){
      println("Error 404: Active Scene could not be found");
      return dummyScene;
    }else{
      return scenes.get(activeSceneIndex);
    }
  }
  
  public void switchSceneByName(String n){
    for(int i = 0; i < scenes.size() ; i++){
      if(scenes.get(i).name.equals(n)){
        activeSceneIndex = i;
        break;
      }
    }
  }
  public void switchSceneByReference(Scene s){
    for(int i = 0; i < scenes.size() ; i++){
      if(scenes.get(i).equals( s )){
        activeSceneIndex = i;
        break;
      }else if(i == scenes.size()-1 ){
        scenes.add(s);
        activeSceneIndex = scenes.size()-1;
      }
    }
  }
  public void switchByIndex(int i){
    if(i >= 0 && i < scenes.size()){ activeSceneIndex = i; }
  }
  
  public Scene getByName(String n){
    for(int i = 0; i < scenes.size() ; i++){
      if(scenes.get(i).name.equals(n)){
        return scenes.get(i);
      }
    }
    return null;
  }
}





public Scene dummyScene = new Scene("dummy"); //loaded when active scene cannpt be found to avoid exceptions
public class Scene{
  public ArrayList<UIObject> uiElements = new ArrayList<UIObject>();
  public String name = "";
  
  public Scene(String n){ 
    name = n;
  }
  
  public void draw(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).draw(); } }
  public void show(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).show(); } }
  public void onKeyDown(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onKeyDown(); } }
  public void onKeyUp(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onKeyUp(); } }
  public void onMouse(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onMouse(); } }
  public void onMouseUp(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onMouseUp(); } }
  public void onMouseDown(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onMouseDown(); } }
  public void onScrollUp(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onScrollUp(); } }
  public void onScrollDown(){ for(int i = 0; i<uiElements.size() ;i++){ uiElements.get(i).onScrollDown(); } }
  
  public void btnFunctions(){}
  
  public void addUiElement(UIObject ui){ uiElements.add(ui); }
  //public void removeUiElement(UIObject ui){ /*MISSING*/ }
}
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
  
  public static int background = 0xff3f422e;
  public static int guiBackground = 0xffd4da9f;
  public static int guiTextBackground = 0xffafafaf;
  public static int guiBorder = 0xff161616;
  public static int guiText = 0xff323232;
  public static int guiTextBox = 0xff7a777d;
  public static int guiInactiveTextBox = 0xff6a676d;
  public static int guiHighlight = 0xffeeff53;
  public static int guiTriggered = 0xffd67c2e;
  public static int guiInactive = 0xff4b4b4b;
  public static int guiEnabled = 0xff4eff4b;
  public static int guiDisabled = 0xffff461a;
  public static int guiLayer = 0xff8a877d;
  public static int guiLayerInactive = 0xff57554f;
  public static int guiLayerHovered = 0xff87858f;
  
  public static int black = 0xff111111;
  public static int grey = 0xff7b7b7b;
  public static int white = 0xfff3f3f3;
  public static int red = 0xffff0000;
  public static int blue = 0xff0000ff;
  public static int green = 0xff00ff00;
  public static int yellow = 0xfffff600;
  public static int orange = 0xffff8500;
  public static int purple = 0xffd000ff;
  public static int cyan = 0xff00ffb2;
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
    int offset = PApplet.parseInt(split(dat[0],' ')[1]);
    for(int i = offset+1; i<dat.length; i++){
      if((i-offset-1)%offset != 0 && !dat[i].equals("")){
        simplifiedSounds[0][tmp] = split(dat[i],' ')[0];
        simplifiedSounds[1][tmp] = split(dat[i],' ')[1];
        tmp++;
      }
    }
    dat = loadStrings("data/phonetic_vowel_table.txt");
    offset = PApplet.parseInt(split(dat[0],' ')[1]);
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
    int syls = floor(random(1,3.9999f))+floor(random(0,2.9999f));
    
    for(int i = 0; i<syls; i++){
      for(int a = 0; a<onsetAmount;a++){
        if(random(0,100) < 60){
          out += onsetOptions[a].get( floor( random(0,0.999f+ onsetOptions[a].size() -1) ) );
        }
      }
      for(int a = 0; a<nucleusAmount;a++){
        if(a == 0 || random(0,100) < 30){
          out += nucleusOptions[a].get( floor( random(0,0.999f+ nucleusOptions[a].size() -1) ) );
        }
      }
      for(int a = 0; a<codaAmount;a++){
        if(random(0,100) < 40){
          out += codaOptions[a].get( floor( random(0,0.999f+ codaOptions[a].size() -1) ) );
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
    int tmpconsonants = PApplet.parseInt(split(lodSounds[0]," ")[0]), tmpvowels = PApplet.parseInt(split(lodSounds[0]," ")[1]);
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
    onsetAmount =   PApplet.parseInt(split(lodSyllables[0]," ")[0]);
    nucleusAmount = PApplet.parseInt(split(lodSyllables[0]," ")[1]);
    codaAmount =    PApplet.parseInt(split(lodSyllables[0]," ")[2]);
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
    stressingPosition = PApplet.parseInt( loadStrings(filepath+projectpath+"/stressing.txt")[0] );
    
    //WORDS
    println( "load words");
    String[] lodWords = loadStrings(filepath+projectpath+"/wordlist.txt");
    wordlist = new ArrayList<WordTranslation>();
    for(int i = 1; i<PApplet.parseInt(lodWords[0]); i++){
      wordlist.add(new WordTranslation(split(lodWords[i]," : ")[0],split(lodWords[i]," : ")[1],PApplet.parseInt(split(lodWords[i]," : ")[1])) );
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
public boolean uiRefreshed = true;
public void redrawUI(){ 
  if(uiRefreshed){
    background(ColorCode.background);
    
    sceneManager.show();
    
    uiRefreshed = false;
  }
}


//Base Class for UI Objects
public class UIObject{
  //public Scene parentScene;
  
  public UIObject(){ }
  
  public void draw(){ }
  
  public void show(){ }
  public void onMouse(){ }
  public void onMouseUp(){ }
  public void onMouseDown(){ }
  public void onKeyUp(){ }
  public void onKeyDown(){ }
  public void onScrollDown(){ }
  public void onScrollUp(){ }
  
  /*public void delete(){
    if(parentScene == null){
      println("Error: Cannot delete UI, parentScene is missing");
    }else{
      parentScene.removeUiElement(this);
    }
  }*/
}








//Vocabulary List
public class UI_VocabularyList extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_TextInputField searchInput;
  public UI_Button searchButton;
  
  public ArrayList<UI_Checkbox> filterBoxes;
  public String searchFilter = "";
  
  public UI_Scrollwheel scrollwheel;
  public int shift = 0;
  
  public ArrayList<WordTranslation> list;
  
  public boolean changed = false;
  public WordTranslation selection = null;
  public int hovered = -1;
  
  public UI_VocabularyList(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    searchInput = new UI_TextInputField( new Vector2(position.x+expanse.x*0.02f, position.y+expanse.y*0.955f), new Vector2(expanse.x*0.75f, expanse.y*0.04f), "Searchword", k, false);
    searchButton = new UI_Button( new Vector2(position.x+expanse.x*0.78f, position.y+expanse.y*0.955f), new Vector2(expanse.x*0.2f, expanse.y*0.04f), " Search", true);
    
    scrollwheel = new UI_Scrollwheel(new Vector2(position.x+expanse.x*0.97f, position.y+expanse.y*0.095f), new Vector2(expanse.x*0.03f, expanse.y*0.855f) ,true);
    
    filterBoxes = new ArrayList<UI_Checkbox>();
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.01f, position.y+expanse.y*0.01f),  new Vector2(expanse.x*0.23f, expanse.y*0.03f), " Nouns", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.25f, position.y+expanse.y*0.01f),  new Vector2(expanse.x*0.24f, expanse.y*0.03f), " Verbs", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.50f, position.y+expanse.y*0.01f),  new Vector2(expanse.x*0.24f, expanse.y*0.03f), " Adjectives", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.75f, position.y+expanse.y*0.01f),  new Vector2(expanse.x*0.24f, expanse.y*0.03f), " Pers. Pronouns", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.01f, position.y+expanse.y*0.055f), new Vector2(expanse.x*0.23f, expanse.y*0.03f), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.25f, position.y+expanse.y*0.055f), new Vector2(expanse.x*0.24f, expanse.y*0.03f), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.50f, position.y+expanse.y*0.055f), new Vector2(expanse.x*0.24f, expanse.y*0.03f), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.75f, position.y+expanse.y*0.055f), new Vector2(expanse.x*0.24f, expanse.y*0.03f), " ?", true) );
    
    reloadWords();
  }
  
  public void reloadWords(){
    list = new ArrayList<WordTranslation>();
    
    //Words are loaded from the languageData Word List
    for(int i = 0; i<languageData.wordlist.size(); i++){
      WordTranslation tmp = languageData.wordlist.get(i);
      //FILTER TYPES
      println(tmp.word,tmp.translation,searchFilter);
      if(tmp.wordtype == -1 || filterBoxes.get(tmp.wordtype).state ){
        if(searchFilter.equals("") || tmp.word.indexOf(searchFilter) != -1 || tmp.translation.indexOf(searchFilter) != -1){
          list.add(tmp);
        }
      }
    }
    
    uiRefreshed = true;
    shift = 0;
  }
  
  public void draw() {
    searchInput.draw();
    searchButton.draw();
    scrollwheel.draw();
    for(int i = 0; i<filterBoxes.size() ; i++){
      filterBoxes.get(i).draw();
    }
    
    //List
    int old = hovered;
    if(mouseX > position.x+expanse.x*0.01f && mouseX < position.x+expanse.x*0.96f){
      if(mouseY > position.y+expanse.y*0.1f && mouseY < position.y+expanse.y*0.95f){
        if( (mouseY -position.y-expanse.y*0.1f)%(expanse.y*0.1f) < expanse.y*0.095f ){
          hovered = PApplet.parseInt((mouseY -position.y-expanse.y*0.1f)/(expanse.y*0.1f)) + shift;
        }else{
          hovered = -1;
        }
      }else{
        hovered = -1;
      }
    }else{
      hovered = -1;
    }
    if(old != hovered){
      uiRefreshed = true; 
    }
  }
  
  public void show(){
    //background
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    //List
    for(int i = shift; i<shift+9; i++){
      if(i < list.size()){
        showListObject(position.x+expanse.x*0.01f,position.y+expanse.y*(0.1f+ (i-shift)*0.1f),expanse.x*0.95f,expanse.y*0.09f,i);
      }
    }
    
    //Overlay
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y*0.095f); //Filter
    rect(position.x,position.y+expanse.y*0.95f,expanse.x,expanse.y*0.05f); //Search
    
    //Reference
    searchInput.show();
    searchButton.show();
    scrollwheel.show();
    for(int i = 0; i<filterBoxes.size() ; i++){
      filterBoxes.get(i).show();
    }
  }
  
  public void showListObject(float posx, float posy, float expx, float expy, int index){
    stroke(0);
    if(list.get(index) == selection){
      fill(ColorCode.blue);
    }else if(hovered == index){
      fill(ColorCode.cyan);
    }else{
      fill(ColorCode.white);
    }
    rect(posx,posy,expx,expy);
    
    fill(ColorCode.guiText);
    textSize(expy*0.3f);
    text( list.get(index).word, posx+expx*0.02f,posy+expy*0.33f);
    text( list.get(index).translation, posx+expx*0.02f,posy+expy*0.68f);
    text( WordType.toString(list.get(index).wordtype), posx+expx*0.02f,posy+expy*0.97f);
  }
  
  public void onMouseDown() {
    searchInput.onMouseDown();
    searchButton.onMouseDown();
    scrollwheel.onMouseDown();
    for(int i = 0; i<filterBoxes.size() ; i++){
      filterBoxes.get(i).onMouseDown();
    }
    
    //List
    if(hovered > -1 && hovered < list.size()){
      selection = list.get(hovered);
      changed = true;
      uiRefreshed = true;
    }
    
    //Buttons
    if(searchButton.getTrigger()){
      println("Updated Search Filter");
      searchFilter = searchInput.text;
      reloadWords();
    }
    for(int i = 0; i<filterBoxes.size() ; i++){
      if( filterBoxes.get(i).getTrigger() ){
        println("Updated Filter");
        reloadWords();
      }
    }
  }
  
  public void onScrollUp(){
    if(list.size() >= 9){
      if(shift < list.size()-8){
        shift++;
        uiRefreshed = true;
      }
    }
  }
  
  public void onScrollDown(){
    if(list.size() >= 9){
      if(shift > 0){
        shift--;
        uiRefreshed = true;
      }
    }
  }
  
  public void onKeyDown(){
    searchInput.onKeyDown();
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}


//Scrollwheel panel
public class UI_Scrollwheel extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public boolean isVertical;
  
  public UI_Scrollwheel(Vector2 pos, Vector2 exp, boolean v){ 
    position = pos;
    expanse = exp;
    
    isVertical = v;
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
  }
}














//Button
public class UI_Button extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public float textSize;
  
  public boolean hovered = false;
  public boolean clicked = false;
  public boolean active;
  
  public UI_Button(Vector2 pos, Vector2 exp, String txt, boolean act){
    position = pos;
    expanse = exp;
    text = txt;
    active = act;
    
    textSize = expanse.y-2 > (expanse.x / (float)text.length())*1.5f? (expanse.x / (float)text.length())*1.8f : expanse.y-2;
  }
  
  public void draw(){
    if(mouseX > position.x && mouseY > position.y && mouseX < position.x+expanse.x && mouseY < position.y+expanse.y){
      if(!hovered){
        uiRefreshed = true;
      }
      hovered = true;
    }else{
      if(hovered){
        uiRefreshed = true;
      }
      hovered = false;
    }
  }
  
  public void show(){
    if(!active){ fill(ColorCode.guiInactive); 
    }else if(clicked){ fill(ColorCode.guiTriggered);
    }else if(hovered){ fill(ColorCode.guiHighlight);
    }else{ fill(ColorCode.guiBackground); }
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    fill(ColorCode.guiText);
    textSize(textSize);
    //text(text,position.x+1, position.y-4+expanse.y);
    text(text,position.x+1, position.y+0.5f*expanse.y+textSize*0.3f);
  }
  
  public void onMouseDown(){
    if(hovered && active){ 
      clicked = true; 
      uiRefreshed = true;
    }
  }
  
  public boolean getTrigger(){
    if(clicked){
      clicked = false;
      return true;
    }
    return false;
  }
}


//Layer (technical)
public class UI_Layer extends UIObject{
  //public Scene parentScene;
  public ArrayList<UIObject> objects = new ArrayList<UIObject>();
  public String name = "";
  
  public UI_Layer(String t){ name = t; }
  
  public void addObject(UIObject obj){
    objects.add(obj);
  }
  
  public void draw(){         for(int i = 0; i<objects.size() ;i++){ objects.get(i).draw();         } }
  public void show(){         for(int i = 0; i<objects.size() ;i++){ objects.get(i).show();         } }
  public void onKeyDown(){    for(int i = 0; i<objects.size() ;i++){ objects.get(i).onKeyDown();    } }
  public void onKeyUp(){      for(int i = 0; i<objects.size() ;i++){ objects.get(i).onKeyUp();      } }
  public void onMouse(){      for(int i = 0; i<objects.size() ;i++){ objects.get(i).onMouse();      } }
  public void onMouseUp(){    for(int i = 0; i<objects.size() ;i++){ objects.get(i).onMouseUp();    } }
  public void onMouseDown(){  for(int i = 0; i<objects.size() ;i++){ objects.get(i).onMouseDown();  } }
  public void onScrollUp(){   for(int i = 0; i<objects.size() ;i++){ objects.get(i).onScrollUp();   } }
  public void onScrollDown(){ for(int i = 0; i<objects.size() ;i++){ objects.get(i).onScrollDown(); } }
}


//Base Class for UI Objects
public class UI_LayerSwitch extends UIObject{
  //public Scene parentScene;
  public ArrayList<UI_Layer> layers = new ArrayList<UI_Layer>();
  public int activeLayer = 0;
  
  public int hovering = -1;
  
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_LayerSwitch(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
  }
  
  public void addLayer(UI_Layer obj){
    layers.add(obj);
  }
  
  
  public void draw(){
    int old = hovering;
    if(mouseY > position.y && mouseY < position.y+25 && mouseX > position.x){
      hovering = PApplet.parseInt((mouseX - position.x) / 120f);
      if(hovering >= layers.size()){ hovering = -1; }
    }else{
      hovering = -1;
    }
    layers.get(activeLayer).draw();
    if(hovering != old) { uiRefreshed = true; }
  }
  
  public void show(){ 
    //Show Background
    stroke(0);
    fill(ColorCode.guiLayer);
    rect(position.x,position.y+25,expanse.x,expanse.y-25);
    
    //Show Selection
    for(int i = 0; i<layers.size(); i++){
      if(i == activeLayer){
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiLayer);
        }
        rect(position.x+120*i,position.y,120,25);
      }else{
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiLayerInactive);
        }
        rect(position.x+120*i+2,position.y+2,120-4,25-2);
      }
      fill(ColorCode.black);
      textSize(13);
      text(layers.get(i).name,position.x+120*i+2,position.y+4,120-3,25-2);
    }
    
    //Render Layer
    layers.get(activeLayer).show();
  }
  
  public void onKeyDown(){    layers.get(activeLayer).onKeyDown();    }
  public void onKeyUp(){      layers.get(activeLayer).onKeyUp();      }
  public void onMouse(){      layers.get(activeLayer).onMouse();      }
  public void onMouseUp(){    layers.get(activeLayer).onMouseUp();    }
  public void onMouseDown(){
    if(hovering != -1){ activeLayer = hovering; hovering = -1; }
    layers.get(activeLayer).onMouseDown();
  }
  public void onScrollUp(){   layers.get(activeLayer).onScrollUp();   }
  public void onScrollDown(){ layers.get(activeLayer).onScrollDown(); }
}


//Checkbox
public class UI_Checkbox extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public boolean state;
  
  public boolean active = true;
  public boolean hovering = false;
  public boolean changed = false;
  
  public UI_Checkbox(Vector2 pos, Vector2 exp, String t, boolean s){
    position = pos;
    expanse = exp;
    text = t;
    state = s;
  }
  
  public void draw(){
    hovering = mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y;
  }
  
  public void show(){
    if( active ){
      if( state ){
        fill(ColorCode.guiEnabled);
      }else{
        fill(ColorCode.guiDisabled);
      }
    }else{
      fill(ColorCode.guiInactive);
    }
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    textSize(expanse.y*0.9f);
    fill(ColorCode.guiText);
    text(text,position.x+1, position.y+expanse.y*0.9f);
  }
  
  public void onMouseDown(){
    if(hovering){
      state = !state;
      changed = true;
      uiRefreshed = true;
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      uiRefreshed = true;
      changed = false;
      return true;
    }
    return false;
  }
}



//Text
public class UI_Text extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public float textSize;
  public int lines = 1;
  public int textColor;
  
  public UI_Text(Vector2 pos, Vector2 exp, String txt){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; }
    }
    
    textColor = ColorCode.guiText;
    recalculateTextSize();
  }
  
  public UI_Text(Vector2 pos, Vector2 exp, String txt, int c){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; }
    }
    
    textColor = c;
    recalculateTextSize();
  }
  
  public void recalculateTextSize(){
    textSize = (expanse.y-2.0f) / (1.5f * lines) *0.85f;
  }
  
  public void show(){
    fill(ColorCode.guiTextBox);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    fill(textColor);
    textSize(textSize);
    //text(text,position.x+1, position.y-4+expanse.y);
    text(text,position.x+1, position.y+0.5f+textSize);
  }
}



//Integer Field
public class UI_IntegerField extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_Text text;
  public UI_Text number;
  public UI_Button add;
  public UI_Button subtract;
  
  public int value, min, max;
  public boolean changed = false;
  
  public UI_IntegerField(Vector2 pos, Vector2 exp, String txt, int v, int mi, int ma){
    position = pos;
    expanse = exp;
    
    text = new UI_Text(new Vector2(position.x,position.y), new Vector2(expanse.x *0.65f,expanse.y),txt);
    number = new UI_Text(new Vector2(position.x+expanse.x*0.75f,position.y+expanse.y*0.08f), new Vector2(expanse.x *0.15f,expanse.y*0.86f),v+"");
    subtract = new UI_Button(new Vector2(position.x+expanse.x*0.69f,position.y+expanse.y*0.05f), new Vector2(expanse.x *0.06f,expanse.y*0.9f),"-",true);
    add = new UI_Button(new Vector2(position.x+expanse.x*0.9f,position.y+expanse.y*0.05f), new Vector2(expanse.x *0.06f,expanse.y*0.9f),"+",true);
    
    value = v;
    max = ma;
    min = mi;
  }
  
  public void draw(){
    text.draw();
    number.draw();
    add.draw();
    subtract.draw();
  }
  
  public void show(){
    text.show();
    number.show();
    add.show();
    subtract.show();
  }
  
  public void onMouseDown(){
    text.onMouseDown();
    number.onMouseDown();
    add.onMouseDown();
    subtract.onMouseDown();
    
    //Button Function
    if(add.getTrigger()){
      changed = true;
      value++;
      if(value >= max){ add.active = false; }
      subtract.active = true;
      number.text = value+"";
    }
    if(subtract.getTrigger()){
      changed = true;
      value--;
      if(value <= min){ subtract.active = false; }
      add.active = true;
      number.text = value+"";
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}


//Multi Text
public class UI_MultiText extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public ArrayList<String> names;
  public ArrayList<String> texts;
  public float textSize;
  public int textColor;
  
  public int activeLayer = 0;
  public int hovering = -1;
  
  public UI_MultiText(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    textColor = ColorCode.guiText;
    textSize = 16;
    
    names = new ArrayList<String>();
    texts = new ArrayList<String>();
  }
  
  public void addPage(String n, String t){
    names.add(n);
    texts.add(t);
  }
  
  public void draw(){
    int old = hovering;
    if(mouseY > position.y && mouseY < position.y+25 && mouseX > position.x){
      hovering = PApplet.parseInt((mouseX - position.x) / 100f);
      if(hovering >= texts.size()){ hovering = -1; }
    }else{
      hovering = -1;
    }
    if(hovering != old) { uiRefreshed = true; }
  }
  
  public void show(){ 
    
    //Show Background
    stroke(0);
    fill(ColorCode.guiTextBox);
    rect(position.x,position.y+25,expanse.x,expanse.y-25);
    
    //Show Selection
    for(int i = 0; i<texts.size(); i++){
      if(i == activeLayer){
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiTextBox);
        }
        rect(position.x+100*i,position.y,100,25);
      }else{
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiInactiveTextBox);
        }
        rect(position.x+100*i+2,position.y+2,100-4,25-2);
      }
      fill(ColorCode.black);
      textSize(13);
      text(names.get(i),position.x+100*i+2,position.y+16);
    }
    
    //Render Layer
    textSize(textSize);
    if(texts.size() > 0){
      text(texts.get(activeLayer),position.x+4,position.y+29+textSize);
    }
  }
  
  public void onMouseDown(){
    if(hovering != -1){ activeLayer = hovering; hovering = -1; }
  }
}


//Text Input Field
public class UI_TextInputField extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public String tmpText;
  
  public boolean active;
  public boolean hovering;
  public boolean changed;
  
  public boolean hasKeyboard = false;
  public boolean hideInactiveKeyboard = true;
  public UI_InputKeyboard keyboard;
  
  public boolean allowSpaces = true;
  
  public UI_TextInputField(Vector2 pos, Vector2 exp, String t, UI_InputKeyboard k, boolean as){ 
    position = pos;
    expanse = exp;
    
    text = t;
    tmpText = "";
    
    active = false;
    hovering = false;
    changed = false;
    
    hasKeyboard = true;
    keyboard = k;
    
    allowSpaces = as;
    if(!as && hasKeyboard){
      k.spaceBtn.active = false;
    }
  }
  
  public UI_TextInputField(Vector2 pos, Vector2 exp, String t, boolean as){ 
    position = pos;
    expanse = exp;
    
    text = t;
    tmpText = "";
    
    active = false;
    hovering = false;
    changed = false;
    
    hasKeyboard = false;
    
    allowSpaces = as;
  }
  
  
  public void draw(){
    hovering = mouseX > position.x && mouseY > position.y && mouseX < position.x+expanse.x && mouseY < position.y+expanse.y;
    
    //keyboard
    if(hasKeyboard){
      keyboard.draw();
    }
  }
  
  public void show(){
    //Show textbox
    if(active){
      fill(ColorCode.guiTriggered);
    }else{
      fill(ColorCode.guiTextBackground);
    }
    stroke(ColorCode.guiBorder);
    rect(position.x, position.y, expanse.x, expanse.y);
    
    //show Text
    fill(ColorCode.guiText);
    textSize(expanse.y*0.8f);
    if(active){
      text(tmpText,position.x+1, position.y+expanse.y*0.7f);
    }else{
      text(text,position.x+1, position.y+expanse.y*0.7f);
    }
    
    //keyboard
    if(hasKeyboard && (!hideInactiveKeyboard || active)){
      keyboard.show();
    }
  }
  
  public void onMouseDown(){
    //keyboard
    if(hasKeyboard && (!hideInactiveKeyboard || active)){
      keyboard.onMouseDown();
    }
    
    //Inputfield
    if(active){
      if(hovering){
        tmpText = text;
        uiRefreshed = true;
      }else if(hasKeyboard && keyboard.hovering > -4){
        addKeyboardLetter();
      }else{
        active = false;
        tmpText = "";
        uiRefreshed = true;
      }
    }else{
      if(hovering){ active = true;  uiRefreshed = true; }
      uiRefreshed = true;
    }
  }
  
  public void onKeyDown(){
    if(active){
      if(key != CODED && key != BACKSPACE){
        if(allowSpaces || key != ' '){
          tmpText += key;
          uiRefreshed = true;
        }
      }
      if(key == ENTER || key == RETURN){
        updateText();
        uiRefreshed = true;
      }
      if(key == BACKSPACE){
        if(tmpText.toCharArray().length > 0){
          tmpText = new String(shorten(tmpText.toCharArray()));
        }else{
          tmpText = "";
        }
        uiRefreshed = true;
      }
    }
  }
  
  public void addKeyboardLetter(){
    if(keyboard.getTrigger()){
      if(keyboard.isEnter){
        updateText();
        uiRefreshed = true;
        keyboard.reset();
        
      }else if(keyboard.isBack){
        if(tmpText.toCharArray().length > 0){
          tmpText = new String(shorten(tmpText.toCharArray()));
        }else{
          tmpText = "";
        }
        uiRefreshed = true;
        keyboard.reset();
        
      }else{
        if(allowSpaces || !keyboard.output.equals(" ")){
          tmpText += keyboard.getOutput();
          keyboard.reset();
          uiRefreshed = true;
        }
      }
    }
  }
  
  public void updateText(){
    active = false;
    text = trim(tmpText);
    tmpText = "";
    changed = true;
    
    uiRefreshed = true;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



//Panel with multiple Buttons of which 1 (or 0?) can be selected (basically multiple choice)
public class UI_SwitchcaseButton extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public ArrayList<UI_Button> buttons;
  public int selected = -1;
  
  public UI_SwitchcaseButton(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    buttons = new ArrayList<UI_Button>();
    selected = -1;
  }
  
  public void addButton(UI_Button btn){
    buttons.add(btn);
  }
  
  public void draw(){
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).draw();
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).show();
    }
    
    if(selected >= 0 && selected < buttons.size()){
      strokeWeight(5);
      stroke(ColorCode.red);
      UI_Button tmp = buttons.get(selected);
      line(tmp.position.x,tmp.position.y,tmp.position.x+tmp.expanse.x,tmp.position.y);
      line(tmp.position.x,tmp.position.y,tmp.position.x,tmp.position.y+tmp.expanse.y);
      line(tmp.position.x+tmp.expanse.x,tmp.position.y,tmp.position.x+tmp.expanse.x,tmp.position.y+tmp.expanse.y);
      line(tmp.position.x,tmp.position.y+tmp.expanse.y,tmp.position.x+tmp.expanse.x,tmp.position.y+tmp.expanse.y);
      strokeWeight(1);
    }
  }
  
  public void onMouseDown(){
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).onMouseDown();
      
      if(buttons.get(i).getTrigger()){
        if(i != selected){
          selected = i;
        }else{selected = -1;}
      }
    }
  }
  
  public String getSelected(){
    if(selected >= 0 && selected < buttons.size()){
      return buttons.get(selected).text;
    }else{
      return "";
    }
  }
}
//Selection Table
public class UI_SelectionTable extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int rows, columns;
  
  public String[][] text = new String[0][0];
  
  public boolean[][] active = new boolean[0][0];
  public boolean[][] selectable = new boolean[0][0];
  public Vector2 hovering = new Vector2(-1,-1);
  
  public Vector2 boxExpanse;
  
  public UI_SelectionTable(Vector2 pos, Vector2 exp, String file){ //file = "" makes it skip the import
    //The table is saved in a textfile: 1st line: row and column count, each following line one object. Default: none selected
    //The first row and line are not selectable. Empty fields can not be selected
    position = pos;
    expanse = exp;
    
    if(file != ""){
      importFile(file);
    }else{
      rows = 0;
      columns = 0;
      text = new String[rows][columns];
      active = new boolean[rows][columns];
      selectable = new boolean[rows][columns];
      boxExpanse = expanse;
    }
  }
  
  public void loadStatesFromDataFile(StringList ls){
    for(int r = 1; r<rows; r++){
      for(int c = 1; c<columns; c++){
        active[r][c] = ls.hasValue( split(text[r][c],'\n')[0] );
      }
    }
  }
  
  public void importFile(String f){
    String[] tmp = loadStrings(f);
    rows = PApplet.parseInt(tmp[0].split(" ")[0]);
    columns = PApplet.parseInt(tmp[0].split(" ")[1]);
    
    text = new String[rows][columns];
    active = new boolean[rows][columns];
    selectable = new boolean[rows][columns];
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < columns; c++){
        text[r][c] = join(split(tmp[1 + r*columns + c],' '),'\n');
        active[r][c] = false;
        selectable[r][c] = !text[r][c].equals("");
      }
    }
    
    boxExpanse = new Vector2(expanse.x / PApplet.parseFloat(columns), expanse.y / PApplet.parseFloat(rows));
  }
  
  public void draw(){
    Vector2 old = new Vector2(hovering.x, hovering.y);
    hovering = new Vector2(-1,-1);
    if(mouseX > position.x && mouseX < position.x+expanse.x){
      hovering.x = PApplet.parseInt((mouseX - position.x) / boxExpanse.x);
    }
    if(mouseY > position.y && mouseY < position.y+expanse.y){
      hovering.y = PApplet.parseInt((mouseY - position.y) / boxExpanse.y);
    }
    if(hovering.x != old.x || hovering.y != old.y) { uiRefreshed = true; }
  }
  
  public void show(){
    stroke(0);
    for(int r = 0 ; r<rows ; r++){
      for(int c = 0 ; c<columns ; c++){
        textSize(18);
        if(r == 0 || c == 0){
          textSize(10);
          fill(ColorCode.guiBackground);
        }else if(selectable[r][c]){
          if(c == PApplet.parseInt(hovering.x) && r == PApplet.parseInt(hovering.y)){
            fill(ColorCode.guiHighlight);
          }else if(active[r][c]){
            fill(ColorCode.guiEnabled);
          }else{
            fill(ColorCode.guiDisabled);
          }
        }else{
          fill(ColorCode.guiInactive);
        }
        rect(position.x + c*boxExpanse.x, position.y + r*boxExpanse.y, boxExpanse.x, boxExpanse.y);
        fill(ColorCode.black);
        text(text[r][c], position.x + c*boxExpanse.x + boxExpanse.x*0.1f, position.y + r*boxExpanse.y + 16);
      }
    }
  }
  
  public void onMouseDown(){
    if(hovering.x > 0 && hovering.y > 0 && selectable[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)]){
      active[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)] = !active[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)];
    }
  }
  
  public boolean getTrigger(){
    return false;
  }
}


//Sound Selection Table
public class UI_SoundSelectionTable extends UI_SelectionTable{
  
  public UI_SoundSelectionTable(Vector2 pos, Vector2 exp, String file){ 
    super(pos, exp, file);
  }
  
  public void onMouseDown(){
    if(mouseButton == LEFT){
      if(hovering.x > 0 && hovering.y > 0 && selectable[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)]){
        active[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)] = !active[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)];
      }
    }else if(mouseButton == RIGHT){
      if(hovering.x > 0 && hovering.y > 0 && selectable[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)]){
        playSound("sounds/"+split(text[PApplet.parseInt(hovering.y)][PApplet.parseInt(hovering.x)],'\n')[1]);
      }
    }
  }
}



//Syllable Shape Editor
public class UI_SyllableShapeEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  public float downSpace;
  
  public int onsetAmount = 1;
  public int codaAmount = 1;
  public boolean doubleNucleus = false;
  
  public UI_SelectionTable vowelTable;
  public UI_SelectionTable consonantTable;
  
  public UI_Button addOnset;
  public UI_Button removeOnset;
  public UI_Button addCoda;
  public UI_Button removeCoda;
  public UI_Button toggleNucleus;
  
  public ArrayList<UI_SyllablePartEditor> onsetDetails;
  public ArrayList<UI_SyllablePartEditor> nucleusDetails;
  public ArrayList<UI_SyllablePartEditor> codaDetails;
  
  //public ArrayList<boolean> onsetOption;
  //public boolean nucleusOption;
  //public ArrayList<boolean> codaOption;
  
  public UI_SyllableShapeEditor(Vector2 pos, Vector2 exp, float space, UI_SelectionTable ct, UI_SelectionTable vt){
    position = pos;
    expanse = exp;
    downSpace = space;
    
    onsetAmount = 1;
    codaAmount = 1;
    doubleNucleus = false;
    
    vowelTable = vt;
    consonantTable = ct;
    
    addOnset =      new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeOnset =   new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
    addCoda =       new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeCoda =    new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
    toggleNucleus = new UI_Button(new Vector2(pos.x+exp.y*0.5f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"V",true);
    
    onsetDetails = new ArrayList<UI_SyllablePartEditor>();
    nucleusDetails = new ArrayList<UI_SyllablePartEditor>();
    codaDetails = new ArrayList<UI_SyllablePartEditor>();
    for(int i = 0; i<onsetAmount; i++){ 
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f-expanse.y*0.9f -(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, ct) ); }
    nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f-expanse.y*0.45f,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), true, vt) );
    for(int i = 0; i<codaAmount; i++){
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f +(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, ct) ); }
  }
  
  public void loadStatesFromDataFile(UI_SelectionTable ct, UI_SelectionTable vt){
    onsetAmount = languageData.onsetAmount;
    doubleNucleus = languageData.nucleusAmount > 1;
    codaAmount = languageData.codaAmount;
    
    onsetDetails = new ArrayList<UI_SyllablePartEditor>();
    nucleusDetails = new ArrayList<UI_SyllablePartEditor>();
    codaDetails = new ArrayList<UI_SyllablePartEditor>();
    for(int i = 0; i<onsetAmount; i++){ 
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f-expanse.y*0.9f -(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, ct) ); }
    nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f-expanse.y*0.45f,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), true, vt) );
    for(int i = 0; i<codaAmount; i++){
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f +(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, ct) ); }
    
    for(int i = 0 ; i < onsetAmount ; i++){
      onsetDetails.get(i).loadStatesFromDataFile( languageData.onsetOptions[i] );
    }
    for(int i = 0 ; i < languageData.nucleusAmount ; i++){
      nucleusDetails.get(i).loadStatesFromDataFile( languageData.nucleusOptions[i] );
    }
    for(int i = 0 ; i < codaAmount ; i++){
      codaDetails.get(i).loadStatesFromDataFile( languageData.codaOptions[i] );
    }
  }
  
  public void reimport(){
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).importSounds(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).importSounds(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).importSounds(); }
  }
  
  public void draw(){
    addOnset.draw();
    removeOnset.draw();
    addCoda.draw();
    removeCoda.draw();
    toggleNucleus.draw();
    
    //Part-Editors
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).draw(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).draw(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).draw(); }
  }
  
  public void show(){
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    addOnset.show();
    removeOnset.show();
    addCoda.show();
    removeCoda.show();
    toggleNucleus.show();
    
    textSize(expanse.y*0.9f);
    //show Nucleus
    if(doubleNucleus){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5f+expanse.y*0.02f, position.y+expanse.y*0.02f, expanse.y*0.9f, expanse.y*0.96f);
      rect(position.x+expanse.x*0.5f-expanse.y*0.92f, position.y+expanse.y*0.02f, expanse.y*0.9f, expanse.y*0.96f);
      fill(ColorCode.blue);
      text("V",position.x+expanse.x*0.5f+expanse.y*0.2f, position.y+expanse.y*0.8f);
      text("V",position.x+expanse.x*0.5f-expanse.y*0.75f, position.y+expanse.y*0.8f);
    }else{
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5f-expanse.y*0.45f, position.y+expanse.y*0.02f, expanse.y*0.9f, expanse.y*0.96f);
      fill(ColorCode.blue);
      text("V",position.x+expanse.x*0.5f-expanse.y*0.3f, position.y+expanse.y*0.8f);
    }
    
    //show Onset
    for(int i = 0 ; i<onsetAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5f-expanse.y*0.9f -(1+i)*expanse.y, position.y+expanse.y*0.02f, expanse.y*0.9f, expanse.y*0.96f);
      fill(ColorCode.green);
      text("C",position.x+expanse.x*0.5f-expanse.y*0.78f -(1+i)*expanse.y, position.y+expanse.y*0.8f);
    }
    
    //show Coda
    for(int i = 0 ; i<codaAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5f +(1+i)*expanse.y, position.y+expanse.y*0.02f, expanse.y*0.9f, expanse.y*0.96f);
      fill(ColorCode.red);
      text("C",position.x+expanse.x*0.5f+expanse.y*0.15f +(1+i)*expanse.y, position.y+expanse.y*0.8f);
    }
    
    //Part-Editors
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).show(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).show(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).show(); }
  }
  
  public void onMouseDown(){
    //Redirection to the buttons and other child-UI
    if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y){
      addOnset.onMouseDown();
      removeOnset.onMouseDown();
      addCoda.onMouseDown();
      removeCoda.onMouseDown();
      toggleNucleus.onMouseDown();
    }else if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y+expanse.y){
      //Part-Editors
      for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).onMouseDown(); }
      for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).onMouseDown(); }
      for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).onMouseDown(); }
    }
    
    //Toggle optionality
    
    
    //Button Functions
    if(addOnset.getTrigger()){
      onsetAmount++;
      removeOnset.active = true;
      uiRefreshed = true;
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f-expanse.y*0.9f -(onsetAmount)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, consonantTable) );
    }
    if(removeOnset.getTrigger()){
      onsetAmount--;
      if( onsetAmount == 0 ){ removeOnset.active = false; }
      uiRefreshed = true;
      onsetDetails.remove(onsetDetails.get(onsetDetails.size()-1));
    }
    if(addCoda.getTrigger()){
      codaAmount++;
      removeCoda.active = true;
      uiRefreshed = true;
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f +(codaAmount)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), false, consonantTable) );
    }
    if(removeCoda.getTrigger()){
      codaAmount--;
      if( codaAmount == 0 ){ removeCoda.active = false; }
      uiRefreshed = true;
      codaDetails.remove(codaDetails.get(codaDetails.size()-1));
    }
    if(toggleNucleus.getTrigger()){
      if(doubleNucleus){
        nucleusDetails.remove(1);
        nucleusDetails.get(0).position.set(position.x+expanse.x*0.5f-expanse.y*0.45f,position.y+expanse.y);
        uiRefreshed = true;
      }else{
        nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5f+expanse.y*0.02f,position.y+expanse.y), new Vector2(expanse.y*0.9f,downSpace), true, vowelTable) );
        nucleusDetails.get(0).position.set(position.x+expanse.x*0.5f-expanse.y*0.92f,position.y+expanse.y);
        uiRefreshed = true;
      }
      doubleNucleus = !doubleNucleus;
    }
  }
}


//SyllablePartEditor
public class UI_SyllablePartEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public boolean isVowel;
  public UI_SelectionTable table;
  
  public ArrayList<UI_Checkbox> soundtypes;
  public ArrayList<ArrayList<UI_Checkbox>> sounds;
  
  public UI_SyllablePartEditor(Vector2 pos, Vector2 exp, boolean v, UI_SelectionTable t){
    position = pos;
    expanse = exp;
    
    isVowel = v;
    table = t;
    
    importSounds();
  }
  
  public void loadStatesFromDataFile(StringList ls){
    for(int i = 0; i<sounds.size(); i++){
      for(int o = 0; o<sounds.get(i).size(); o++){
        sounds.get(i).get(o).state = ls.hasValue( sounds.get(i).get(o).text );
      }
    }
    for(int i = 0; i<soundtypes.size(); i++){
      soundtypes.get(i).state = false;
      for(int o = 0; o<sounds.get(i).size(); o++){
        if(sounds.get(i).get(o).state){
          soundtypes.get(i).state = true;
          break;
        }
      }
    }
  }
  
  public void importSounds(){
    soundtypes = new ArrayList<UI_Checkbox>();
    sounds = new ArrayList<ArrayList<UI_Checkbox>>();
    
    //Sounds are importet from the ModulCreation- layer1a tables.
    float tmpY = 0; //downshift
    if(isVowel){
      
      for(int r = 1; r<table.text.length; r+=2){
        UI_Checkbox tmpSoundType = new UI_Checkbox( new Vector2(position.x+expanse.x*0.05f,position.y+expanse.x*0.1f+tmpY), new Vector2(expanse.x*0.9f,16), table.text[r][0], true);
        ArrayList<UI_Checkbox> tmpSounds = new ArrayList<UI_Checkbox>();
        
        int tmpa = 0; //counts how many sounds there are in the category
        int tmpp = -1; //position on the x axis
        for(int c = 1; c<table.text[r].length; c++){
          
          if(table.selectable[r][c] && table.active[r][c]){ //Test if the sound is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05f +tmpp*expanse.x*0.3f,position.y+expanse.x*0.1f+tmpY), new Vector2(expanse.x*0.25f,24), split(table.text[r][c],'\n')[0], true) );
          }
          
          if(r+1 < table.text.length && table.selectable[r+1][c] && table.active[r+1][c]){ //Test if the sound in the next row is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05f +tmpp*expanse.x*0.3f,position.y+expanse.x*0.1f+tmpY), new Vector2(expanse.x*0.25f,24), split(table.text[r+1][c],'\n')[0], true) );
          }
        }
        
        if(tmpa > 0){
          soundtypes.add( tmpSoundType );
          sounds.add( tmpSounds );
          tmpY += 34;
        }
      }
      
    }else{
      
      for(int r = 1; r<table.text.length; r++){
        UI_Checkbox tmpSoundType = new UI_Checkbox( new Vector2(position.x+expanse.x*0.05f,position.y+expanse.x*0.1f+tmpY), new Vector2(expanse.x*0.9f,16), table.text[r][0], true);
        ArrayList<UI_Checkbox> tmpSounds = new ArrayList<UI_Checkbox>();
        
        int tmpa = 0; //counts how many sounds there are in the category
        int tmpp = -1; //position on the x axis
        for(int c = 1; c<table.text[r].length; c++){
          
          if(table.selectable[r][c] && table.active[r][c]){ //Test if the sound is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05f +tmpp*expanse.x*0.3f,position.y+expanse.x*0.1f+tmpY), new Vector2(expanse.x*0.25f,24), split(table.text[r][c],'\n')[0], true) );
          }
        }
        
        if(tmpa > 0){
          soundtypes.add( tmpSoundType );
          sounds.add( tmpSounds );
          tmpY += 34;
        }
      }
    }
  }
  
  public void draw(){
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).draw();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).draw();
        }
      }
    }
  }
  
  public void show(){
    fill(ColorCode.guiBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).show();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).show();
        }
      }
    }
  }
  
  public void onMouseDown(){
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).onMouseDown();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).onMouseDown();
        }
      }
    }
    
    //ButtonFunctions
    for(int i = 0; i < soundtypes.size(); i++){
      if(soundtypes.get(i).getTrigger()){
        if(soundtypes.get(i).state){ //EXPAND
          float shift = 28 * (floor((sounds.get(i).size()-1) / 3.0f)+1);
          for( int s = i+1; s < soundtypes.size(); s++){
            soundtypes.get(s).position.y += shift;
            
            for( int o = 0; o < sounds.get(s).size(); o++){
              sounds.get(s).get(o).position.y += shift;
            }
          }
        }else{ //RESTRICT
          float shift = 28 * (floor((sounds.get(i).size()-1) / 3.0f)+1);
          for( int s = i+1; s < soundtypes.size(); s++){
            soundtypes.get(s).position.y -= shift;
            
            for( int o = 0; o < sounds.get(s).size(); o++){
              sounds.get(s).get(o).position.y -= shift;
            }
          }
        }
      }
    }
  }
  
  public String toText(){
    boolean all = true;
    String minus = "";
    String only = "";
    for(int i = 0; i < soundtypes.size() ; i++){
      if(soundtypes.get(i).state){
        for(int s = 0; s < sounds.get(i).size() ; s++){
          if(sounds.get(i).get(s).state){
            only += sounds.get(i).get(s).text +", ";
          }else{
            all = false;
          }
        }
      }else{
        minus += soundtypes.get(i).text+", ";
        all = false;
      }
    }
    
    if(all){
      return "All valid sounds";
    }else{
      return (minus == ""? "" : "No "+trim(minus)+" Sounds " )+(only==""?"" : "only "+only);
    }
  }
  
  public StringList toList(){
    StringList tmp = new StringList();
    
    for(int i = 0; i < soundtypes.size() ; i++){
      if(soundtypes.get(i).state){
        for(int s = 0; s < sounds.get(i).size() ; s++){
          if(sounds.get(i).get(s).state){
            tmp.append(sounds.get(i).get(s).text);
          }
        }
      }
    }
    return tmp;
  }
}


//Table
public class UI_Table extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int rows, columns;
  
  public String[][] text = new String[0][0];
  public boolean[][] selectable = new boolean[0][0];
  
  public Vector2 boxExpanse;
  
  //public UI_Table(Vector2 pos, Vector2 exp, String file){ }//unused atm
  
  public UI_Table(Vector2 pos, Vector2 exp, UI_SelectionTable table){ //filters a selectiontable
    position = pos;
    expanse = exp;
    
    applyTable(table);
  }
  
  public void applyTable(UI_SelectionTable table){
      
    IntList rowlist = new IntList();
    IntList columnlist = new IntList();
    
    for(int r = 1; r < table.rows; r++){
      boolean test = false; //checks if anything in the row is selected
      for(int c = 1; c < table.columns; c++){
        if(table.active[r][c]){
          test = true;
        }
      }
      if(test){
        rowlist.append(r);
      }
    }
    rows = rowlist.size()+1;
    
    for(int c = 1; c < table.columns; c++){
      boolean test = false; //checks if anything in the row is selected
      for(int r = 1; r < table.rows; r++){
        if(table.active[r][c]){
          test = true;
        }
      }
      if(test){
        columnlist.append(c);
      }
    }
    columns = columnlist.size()+1;
    
    text = new String[rows][columns];
    selectable = new boolean[rows][columns];
    
    for(int r = 0; r < rows-1; r++){
      for(int c = 0; c < columns-1; c++){
        selectable[r+1][c+1] = table.active[rowlist.get(r)][columnlist.get(c)];
        if(selectable[r+1][c+1]){
          text[r+1][c+1] = table.text[rowlist.get(r)][columnlist.get(c)];
        }else{
          text[r+1][c+1] = "";
        }
      }
    }
    
    text[0][0] = table.text[0][0];
    for(int i = 0; i < columns-1; i++){
      text[0][i+1] = table.text[0][columnlist.get(i)];
    }
    for(int i = 0; i < rows-1; i++){
      text[i+1][0] = table.text[rowlist.get(i)][0];
    }
      
    boxExpanse = new Vector2(expanse.x / PApplet.parseFloat(columns), expanse.y / PApplet.parseFloat(rows));
  }
  
  public void show(){
    stroke(0);
    for(int r = 0 ; r<rows ; r++){
      for(int c = 0 ; c<columns ; c++){
        textSize(18);
        if(r == 0 || c == 0){
          textSize(10);
          fill(ColorCode.guiBackground);
        }else if(selectable[r][c]){
          fill(ColorCode.guiHighlight);
        }else{
          fill(ColorCode.guiInactive);
        }
        rect(position.x + c*boxExpanse.x, position.y + r*boxExpanse.y, boxExpanse.x, boxExpanse.y);
        fill(ColorCode.black);
        text(text[r][c], position.x + c*boxExpanse.x + boxExpanse.x*0.1f, position.y + r*boxExpanse.y + 16);
      }
    }
  }
  
  public StringList toList(){
    StringList tmp = new StringList();
    
    for(int r = 1; r < rows; r++){
      for(int c = 1; c < columns; c++){
        if(selectable[r][c]){
          tmp.append(split(text[r][c],'\n')[0]);
        }
      }
    }
    
    return tmp;
  }
}



//InputKeyboard
public class UI_InputKeyboard extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int hovering = -4; //-1 to -3 is back space and enter
  
  public UI_Button backBtn;
  public UI_Button spaceBtn;
  public UI_Button enterBtn;
  public ArrayList<UI_Button> soundBtn;
  
  public String output = "";
  public boolean changed = false;
  public boolean isEnter = false;
  public boolean isBack = false;
  
  public UI_InputKeyboard(Vector2 pos, Vector2 exp, UI_Table t){ 
    position = pos;
    expanse = exp;
    
    hovering = -4;
    
    backBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.05f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Delete",true);
    spaceBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.35f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Space",true);
    enterBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.65f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Enter",true);
    soundBtn = new ArrayList<UI_Button>();
    
    importSounds(t.toList());
  }
  
  public UI_InputKeyboard(Vector2 pos, Vector2 exp, UI_Table t1, UI_Table t2){ 
    position = pos;
    expanse = exp;
    
    hovering = -4;
    
    backBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.05f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Delete",true);
    spaceBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.35f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Space",true);
    enterBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01f,position.y+expanse.y*0.65f),new Vector2(expanse.x*0.09f,expanse.y*0.25f)," Enter",true);
    soundBtn = new ArrayList<UI_Button>();
    
    importSounds(t1.toList());
    importSounds(t2.toList());
  }
  
  public void importSounds(StringList ls){
    for(int i = 0; i < ls.size() ; i++){
      soundBtn.add(new UI_Button(new Vector2(position.x+expanse.x* (0.12f+ (soundBtn.size()%25)*0.035f),position.y+expanse.y* (0.05f +floor(soundBtn.size()/25.0f)*0.22f))
          ,new Vector2(expanse.x*0.032f,expanse.y*0.18f), split(ls.get(i),'\n')[0] ,true) );
    }
  }
  
  public void draw(){
    if(mouseY > position.y && mouseY < position.y+expanse.y){
      if(mouseX > position.x+expanse.x*0.01f && mouseX < position.x+expanse.x*0.11f){ //Back Space and Enter
        //Buttons
        backBtn.draw();
        enterBtn.draw();
        spaceBtn.draw();
        
        if(backBtn.hovered){ hovering = -1; }
        if(enterBtn.hovered){ hovering = -2; }
        if(spaceBtn.hovered){ hovering = -3; }
      
      }else if(mouseX > position.x+expanse.x*0.13f && mouseX < position.x+expanse.x){//Sound Buttons
      
        //Buttons
        for(int i = 0; i<soundBtn.size();i++){
          soundBtn.get(i).draw();
          
          if(soundBtn.get(i).hovered){ hovering = i; }
        }
      }
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
    line(position.x+expanse.x*0.11f,position.y+expanse.y*0.03f,position.x+expanse.x*0.11f,position.y+expanse.y*0.97f);
    
    //Buttons
    backBtn.show();
    enterBtn.show();
    spaceBtn.show();
    for(int i = 0; i<soundBtn.size();i++){
      soundBtn.get(i).show();
    }
  }
  
  public void onMouseDown(){
    //Buttons
    if(hovering == -1){
      backBtn.onMouseDown();
    }else if(hovering == -2){
      enterBtn.onMouseDown();
    }else if(hovering == -3){
      spaceBtn.onMouseDown();
    }else if(hovering >= 0){
      soundBtn.get(hovering).onMouseDown();
    }
    
    //Btn Functions
    if(backBtn.getTrigger()){
      isBack = true;
      changed = true;
    }
    if(enterBtn.getTrigger()){
      isEnter = true;
      changed = true;
    }
    if(spaceBtn.getTrigger()){
      output = " ";
      changed = true;
    }    
    if(hovering >= 0){
      
      if(soundBtn.get(hovering).getTrigger()){
        output = soundBtn.get(hovering).text;
        changed = true;
      }
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
  
  public String getOutput(){
    String tmp = output;
    reset();
    return tmp;
  }
  
  public void reset(){
    output = "";
    isEnter = false;
    isBack = false;
  }
}



//Word Editor
public class UI_WordEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_TextInputField wordInput;
  public UI_Button randomButton;
  public UI_SwitchcaseButton wordTypeSelection;
  public UI_TextInputField translationInput;
  public UI_Text translationText;
  public UI_Text rootwordText;
  public UI_Text pronounciationText;
  public UI_Text syllableAnalysisText;
  public UI_Button confirmButton;
  public UI_Button deleteButton;
  
  public boolean changed = false; //for adding and removing words
  public WordTranslation word = null;
  
  public UI_WordEditor(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    wordInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.02f,position.y+expanse.y*0.02f), new Vector2(expanse.x*0.7f,expanse.y*0.1f),"Word",k,false);
    randomButton = new UI_Button(new Vector2(pos.x+expanse.x*0.74f,position.y+expanse.y*0.03f), new Vector2(expanse.x*0.24f,expanse.y*0.08f)," Random",true);
    wordTypeSelection = new UI_SwitchcaseButton(new Vector2(pos.x+expanse.x*0.02f,position.y+expanse.y*0.15f), new Vector2(expanse.x*0.35f,expanse.y*0.82f));
    translationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38f,position.y+expanse.y*0.16f), new Vector2(expanse.x*0.2f,expanse.y*0.06f), "Translation:");;
    translationInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.38f,position.y+expanse.y*0.22f), new Vector2(expanse.x*0.6f,expanse.y*0.1f), "Translation",true);
    rootwordText = new UI_Text(new Vector2(pos.x+expanse.x*0.38f,position.y+expanse.y*0.34f), new Vector2(expanse.x*0.6f,expanse.y*0.08f), "Root: [None]");
    pronounciationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38f,position.y+expanse.y*0.44f), new Vector2(expanse.x*0.6f,expanse.y*0.2f), "Pronounciation:\n\n");
    syllableAnalysisText = new UI_Text(new Vector2(pos.x+expanse.x*0.38f,position.y+expanse.y*0.66f), new Vector2(expanse.x*0.6f,expanse.y*0.16f),"Syllable Analysis:\n");
    confirmButton = new UI_Button(new Vector2(pos.x+expanse.x*0.4f,position.y+expanse.y*0.87f), new Vector2(expanse.x*0.28f,expanse.y*0.1f)," Confirm",true);
    deleteButton = new UI_Button(new Vector2(pos.x+expanse.x*0.7f,position.y+expanse.y*0.87f), new Vector2(expanse.x*0.28f,expanse.y*0.1f)," Delete",true);
    
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04f,position.y+expanse.y*0.2f), new Vector2(expanse.x*0.31f,expanse.y*0.08f),"Noun",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04f,position.y+expanse.y*0.3f), new Vector2(expanse.x*0.31f,expanse.y*0.08f),"Verb",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04f,position.y+expanse.y*0.4f), new Vector2(expanse.x*0.31f,expanse.y*0.08f),"Adjective",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04f,position.y+expanse.y*0.5f), new Vector2(expanse.x*0.31f,expanse.y*0.08f),"Personal Pronoun",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04f,position.y+expanse.y*0.6f), new Vector2(expanse.x*0.31f,expanse.y*0.08f),"Other",true) );
  }
  
  public void setWord( WordTranslation wt){
    word = wt;
    
    wordInput.text = word.word;
    wordTypeSelection.selected = word.wordtype == -1?5:word.wordtype;
    translationInput.text = word.translation;
    rootwordText.text = "Root: [None]";
    pronounciationText.text = " Pronounciation:\n  "+word.word+"\n  "+languageData.convertToSimplifiedPronounciation(word.word);
    syllableAnalysisText.text = " Syllable Analysis:\n  "+languageData.subdivideWordToSyllables(word.word);
    
    uiRefreshed = true;
  }
  
  public void draw(){
    wordInput.draw();
    randomButton.draw();
    wordTypeSelection.draw();
    translationInput.draw();
    confirmButton.draw();
    deleteButton.draw();
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    wordInput.show();
    randomButton.show();
    wordTypeSelection.show();
    translationText.show();
    translationInput.show();
    rootwordText.show();
    pronounciationText.show();
    syllableAnalysisText.show();
    confirmButton.show();
    deleteButton.show();
  }
  
  public void onMouseDown(){
    wordInput.onMouseDown();
    randomButton.onMouseDown();
    wordTypeSelection.onMouseDown();
    translationInput.onMouseDown();
    confirmButton.onMouseDown();
    deleteButton.onMouseDown();
    
    //ButtonFunctions
    if(randomButton.getTrigger()){
      println("Generate random word");
      wordInput.text = languageData.generateRandomWord();
      wordInput.changed = true;
    }
    if(confirmButton.getTrigger()){
      if(word == null){
        //NOTHING
      }else{
        println("Updated Word");
        word.update( wordInput.text, translationInput.text, wordTypeSelection.selected );
        changed = true;
      }
    }
    if(deleteButton.getTrigger()){
      if(word == null){
        reset();
      }else{
        println("Removed Word");
        languageData.wordlist.remove( word );
        reset();
        changed = true;
      }
    }
    if(wordInput.getTrigger()){ // word updated (DUPLICATE! (onMouseDown & onKeyDown))
      println("Word updated");
      pronounciationText.text = " Pronounciation:\n  "+wordInput.text+"\n  "+languageData.convertToSimplifiedPronounciation(wordInput.text);
      syllableAnalysisText.text = " Syllable Analysis:\n  "+languageData.subdivideWordToSyllables(wordInput.text);
    }
  }
  
  public void reset(){
    wordInput.text = "Word";
    wordTypeSelection.selected = -1;
    translationInput.text = "Translation";
    rootwordText.text = "Root: [None]";
    pronounciationText.text = "Pronounciation:\n\n";
    syllableAnalysisText.text = "Syllable Analysis:\n";
    word = null;
  }
  
  public void onKeyDown(){
    translationInput.onKeyDown();
    wordInput.onKeyDown();
    
    if(wordInput.getTrigger()){ // word updated (DUPLICATE! (onMouseDown & onKeyDown))
      println("Word updated");
      pronounciationText.text = " Pronounciation:\n  "+wordInput.text+"\n  "+languageData.convertToSimplifiedPronounciation(wordInput.text);
      syllableAnalysisText.text = " Syllable Analyis:\n  "+languageData.subdivideWordToSyllables(wordInput.text);
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



public void playSound(String path){
  println("Error: Failed to play sound '"+path+"' : not implemented yet");
}



public void advancedText(String s, int tsize, int posx, int posy){
  //Function: the String s is scanned: stuff written as /x/ will be replaced by a importet letter, stuff marked as §x§ will be highlighted in red. 
  //The first symbol is decisive. Incomplete stuff is treated as normals text
  char[] tmpC = s.toCharArray();
  float tmpX = posx;
  String tmpS = "";
  textSize(tsize);
  int mode = 0;//mode; 0:x, 1:/, 2:§
  
  for(int i = 0; i < tmpC.length; i++){ 
    
    if(tmpC[i] == '/'){
      if(mode == 0){
        fill(ColorCode.black);
        mode = 1;
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6f * tsize;
        tmpS = "";
      }else if(mode == 1){
        mode = 0;
        //showSymbol(tmpS, tsize, tmpX, tmpY);
        tmpX += 0.7f * tsize;
        tmpS = "";
      }else if(mode == 2){
        tmpS += tmpC[i];
      }
      
    }else if (tmpC[i] == '§'){
      if(mode == 0){
        mode = 2;
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6f * tsize;
        tmpS = "";
      }else if(mode == 1){
        tmpS += tmpC[i];
      }else if(mode == 2){
        mode = 0;
        fill(ColorCode.red);
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6f * tsize;
        tmpS = "";
      }
      
    }else{
      tmpS += tmpC[i];
    }
  }
  
  fill(ColorCode.black);
  text(tmpS, tmpX, posy);
}

public void showSymbol(String path, float exp, float posx, float posy){
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LanguageCreator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
