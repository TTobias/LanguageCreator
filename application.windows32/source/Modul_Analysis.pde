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
