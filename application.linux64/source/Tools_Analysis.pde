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
