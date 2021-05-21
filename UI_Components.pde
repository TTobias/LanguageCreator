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
    
    searchInput = new UI_TextInputField( new Vector2(position.x+expanse.x*0.02, position.y+expanse.y*0.955), new Vector2(expanse.x*0.75, expanse.y*0.04), "Searchword", k, false);
    searchButton = new UI_Button( new Vector2(position.x+expanse.x*0.78, position.y+expanse.y*0.955), new Vector2(expanse.x*0.2, expanse.y*0.04), " Search", true);
    
    scrollwheel = new UI_Scrollwheel(new Vector2(position.x+expanse.x*0.97, position.y+expanse.y*0.095), new Vector2(expanse.x*0.03, expanse.y*0.855) ,true, false);
    
    filterBoxes = new ArrayList<UI_Checkbox>();
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.01, position.y+expanse.y*0.01),  new Vector2(expanse.x*0.23, expanse.y*0.03), " Nouns", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.25, position.y+expanse.y*0.01),  new Vector2(expanse.x*0.24, expanse.y*0.03), " Verbs", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.50, position.y+expanse.y*0.01),  new Vector2(expanse.x*0.24, expanse.y*0.03), " Adjectives", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.75, position.y+expanse.y*0.01),  new Vector2(expanse.x*0.24, expanse.y*0.03), " Pers. Pronouns", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.01, position.y+expanse.y*0.055), new Vector2(expanse.x*0.23, expanse.y*0.03), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.25, position.y+expanse.y*0.055), new Vector2(expanse.x*0.24, expanse.y*0.03), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.50, position.y+expanse.y*0.055), new Vector2(expanse.x*0.24, expanse.y*0.03), " ?", true) );
    filterBoxes.add( new UI_Checkbox(new Vector2(position.x+expanse.x*0.75, position.y+expanse.y*0.055), new Vector2(expanse.x*0.24, expanse.y*0.03), " ?", true) );
    
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
    
    scrollwheel.active = list.size() > 9;
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
    if(mouseX > position.x+expanse.x*0.01 && mouseX < position.x+expanse.x*0.96){
      if(mouseY > position.y+expanse.y*0.1 && mouseY < position.y+expanse.y*0.95){
        if( (mouseY -position.y-expanse.y*0.1)%(expanse.y*0.1) < expanse.y*0.095 ){
          hovered = int((mouseY -position.y-expanse.y*0.1)/(expanse.y*0.1)) + shift;
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
        showListObject(position.x+expanse.x*0.01,position.y+expanse.y*(0.1+ (i-shift)*0.1),expanse.x*0.95,expanse.y*0.09,i);
      }
    }
    
    //Overlay
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y*0.095); //Filter
    rect(position.x,position.y+expanse.y*0.95,expanse.x,expanse.y*0.05); //Search
    
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
    textSize(expy*0.3);
    text( list.get(index).word, posx+expx*0.02,posy+expy*0.33);
    text( list.get(index).translation, posx+expx*0.02,posy+expy*0.68);
    text( WordType.toString(list.get(index).wordtype), posx+expx*0.02,posy+expy*0.97);
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
  
  public void onMouse() {
    scrollwheel.onMouse();
  }
  
  public void onMouseUp() {
    scrollwheel.onMouseUp();
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
  
  public boolean active;
  public boolean isVertical;
  
  public float state = 0f;  //[0,1]
  
  public boolean onMove = false;
  public float tmpState = 0f;
  public Vector2 tmpMouse = new Vector2(0,0);
  
  public boolean changed = true;
  
  public UI_Scrollwheel(Vector2 pos, Vector2 exp, boolean v, boolean a){ 
    position = pos;
    expanse = exp;
    
    isVertical = v;
    active = a;
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    if(onMove){
      stroke(0);
      fill(ColorCode.guiTriggered);
      rect(position.x,position.y+ (expanse.y*0.9 * tmpState),expanse.x,expanse.y*0.1);
    }else{
      stroke(0);
      fill(ColorCode.grey);
      rect(position.x,position.y+ (expanse.y*0.9 * state),expanse.x,expanse.y*0.1);
    }
  }
  
  public void onMouseDown(){
    if(active && mouseButton == LEFT && !onMove && mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y+ (expanse.y*0.9*state) && mouseY < position.y+ (expanse.y*state)){
      onMove = true;
      tmpMouse.setToMouse();
    }else if(active && onMove){
      /////REVERT
    }
  }
  
  public void onMouse(){
    if(active && onMove){
      float old = tmpState;
      float shift = tmpMouse.y - mouseY;
      float posy = position.y + expanse.y*0.9+state + shift;
      tmpState = position.y;
      changed = (old != tmpState);
    }
  }
  
  public void onMouseUp(){
    
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



//Quantifier List
public class UI_QuantifierList extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_Scrollwheel scrollwheel;
  public int shift = 0;
  
  public ArrayList<WordModifier> list;
  
  public boolean changed = false;
  public WordModifier selection = null;
  public int hovered = -1;
  
  public UI_QuantifierList(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    scrollwheel = new UI_Scrollwheel(new Vector2(position.x+expanse.x*0.97, position.y+expanse.y*0.095), new Vector2(expanse.x*0.03, expanse.y*0.855) ,true, false);
    
    list = new ArrayList<WordModifier>();
    
    reload();
  }
  
  public void reload(){
    list = new ArrayList<WordModifier>();
    
    //Words are loaded from the languageData Word List
    for(int i = 0; i<languageData.quantifiers.size(); i++){
      WordModifier tmp = languageData.quantifiers.get(i);
      list.add(tmp);
    }
    
    uiRefreshed = true;
    shift = 0;
    
    scrollwheel.active = list.size() > 9;
  }
  
  public void draw() {
    scrollwheel.draw();
    
    //List
    int old = hovered;
    if(mouseX > position.x+expanse.x*0.01 && mouseX < position.x+expanse.x*0.96){
      if(mouseY > position.y+expanse.y*0.1 && mouseY < position.y+expanse.y*0.95){
        if( (mouseY -position.y-expanse.y*0.1)%(expanse.y*0.1) < expanse.y*0.095 ){
          hovered = int((mouseY -position.y-expanse.y*0.1)/(expanse.y*0.1)) + shift;
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
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    //List
    for(int i = shift; i<shift+9; i++){
      if(i < list.size()){
        showListObject(position.x+expanse.x*0.01,position.y+expanse.y*(0.1+ (i-shift)*0.1),expanse.x*0.95,expanse.y*0.09,i);
      }
    }
    
    //Overlay
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y*0.095); //Filter
    rect(position.x,position.y+expanse.y*0.95,expanse.x,expanse.y*0.05); //Search
    
    //Reference
    scrollwheel.show();
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
    textSize(expy*0.3);
    text( list.get(index).name, posx+expx*0.02,posy+expy*0.33);
    text( list.get(index).toString(), posx+expx*0.02,posy+expy*0.78);
  }
  
  public void onMouseDown() {
    scrollwheel.onMouseDown();
    
    //List
    if(hovered > -1 && hovered < list.size()){
      selection = list.get(hovered);
      changed = true;
      uiRefreshed = true;
    }
  }
  
  public void onMouse() {
    scrollwheel.onMouse();
  }
  
  public void onMouseUp() {
    scrollwheel.onMouseUp();
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
  
  public ArrayList<WordModifier> getCopy(){
    ArrayList<WordModifier> tmp = new ArrayList<WordModifier>();
    for(int i = 0; i<list.size(); i++){
      tmp.add( list.get(i) );
    }
    return tmp;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



//Quantifier Editor
public class UI_QuantifierEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public WordModifier activeQuantifier = null;
  public UI_QuantifierList listReference;
  
  public UI_SwitchcaseButton wordTypeSelection;
  public UI_SwitchcaseButton modificationSelection;
  public UI_InputKeyboard keyboard;
  public UI_Layer preSyllableLayer;
  public UI_Layer postSyllableLayer;
  public UI_Layer inSyllableLayer;
  public UI_Layer partDuplicationLayer;
  public UI_Layer replacementLayer;
  public UI_Layer syllableModification;
  public UI_Button deleteButton;
  public UI_Button applyButton;  //Kinda redundant as everything saves with every change
  
  public UI_Layer activeLayer = null;
  public boolean changed = false;
  
  //STUFF FOR THE LAYERS
  public UI_Text previewText;
  public UI_Checkbox onsetFixedCheckbox;
  public UI_Checkbox nucleusFixedCheckbox;
  public UI_Checkbox codaFixedCheckbox;
  public UI_TextInputField onsetTextInput;
  public UI_TextInputField nucleusTextInput;
  public UI_TextInputField codaTextInput;
  public UI_IntegerField onsetPositionInput;
  public UI_IntegerField nucleusPositionInput;
  public UI_IntegerField codaPositionInput;
  public UI_Checkbox onsetActiveCheckbox;
  public UI_Checkbox codaActiveCheckbox;
  
  public UI_IntegerField syllablePositionInput;
  public UI_IntegerField duplicationStartInput;
  public UI_IntegerField duplicationEndInput;
  public UI_Checkbox duplicateWithCodaCheckbox;
  public UI_Checkbox duplicateWithOnsetCheckbox;
  public UI_Checkbox duplicatePositionCheckbox;
  
  public UI_QuantifierEditor(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    keyboard = k;
    
    wordTypeSelection = new UI_SwitchcaseButton(new Vector2(position.x+3,position.y+3), new Vector2(expanse.x*0.15, expanse.y-6));
    for(int i = 0; i<QuantifierType.getAmount(); i++){
      wordTypeSelection.addButton( new UI_Button(new Vector2(position.x+8,position.y+8+expanse.y*0.05*i), new Vector2(expanse.x*0.15-16,expanse.y*0.045), QuantifierType.toString(i) ,true) );
    }
    
    modificationSelection = new UI_SwitchcaseButton(new Vector2(position.x+10+expanse.x*0.15,position.y+5), new Vector2(expanse.x*0.82, expanse.y*0.12));
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.2,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " Pre-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.45,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " Post-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.7,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " In-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.2,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Part Duplication" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.45,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Replacement" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.7,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Modification" ,true) );
    
    deleteButton = new UI_Button(new Vector2(position.x+expanse.x*0.8, position.y+expanse.y*0.92),new Vector2(expanse.x*0.15,expanse.y*0.045), " Delete",true);
    applyButton = new UI_Button(new Vector2(position.x+expanse.x*0.6, position.y+expanse.y*0.92),new Vector2(expanse.x*0.15,expanse.y*0.045), " Apply",true);
    
    //Layer Stuff
    preSyllableLayer = new UI_Layer("Pre Syllable");
    postSyllableLayer = new UI_Layer("Post Syllable");
    inSyllableLayer = new UI_Layer("In Syllable");
    partDuplicationLayer = new UI_Layer("Part Duplication");
    replacementLayer = new UI_Layer("Replacement");
    syllableModification = new UI_Layer("Syllable Modification");
    
    previewText = new UI_Text(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.25), new Vector2(expanse.x*0.75, expanse.y*0.12), "PREVIEW");
    onsetFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Onset?", true);
    nucleusFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.45,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Nucleus?", true);
    codaFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.7,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Coda?", true);
    onsetTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    nucleusTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.5,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    codaTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.75,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    onsetPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Onset",1,-8,8);
    nucleusPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.45,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Nucleus",1,-8,8);
    codaPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.7,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Coda",1,-8,8);
    onsetActiveCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.22,position.y+expanse.y*0.67), new Vector2(expanse.x*0.15, expanse.y*0.04),"copy onset?",true);
    codaActiveCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.72,position.y+expanse.y*0.67), new Vector2(expanse.x*0.15, expanse.y*0.04),"copy coda?",true);
    
    syllablePositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.15),new Vector2(expanse.x*0.75,expanse.y*0.05)," Syllable Position:",1,-8,8);
    duplicationStartInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.25),new Vector2(expanse.x*0.6,expanse.y*0.05)," Starting Syllable:",1,-8,8);
    duplicationEndInput =   new UI_IntegerField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.32),new Vector2(expanse.x*0.6,expanse.y*0.05)," Ending Syllable:",1,-8,8);
    duplicateWithCodaCheckbox =  new UI_Checkbox(new Vector2(position.x+expanse.x*0.35,position.y+expanse.y*0.45),new Vector2(expanse.x*0.4,expanse.y*0.05),"keep First Coda?",true);
    duplicateWithOnsetCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.35,position.y+expanse.y*0.52),new Vector2(expanse.x*0.4,expanse.y*0.05),"keep Last Onset?",true);
    duplicatePositionCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.3,position.y+expanse.y*0.62),new Vector2(expanse.x*0.5,expanse.y*0.05),"copy to preposition?",true);
    
    preSyllableLayer.addObject(previewText);
    preSyllableLayer.addObject(onsetFixedCheckbox);  preSyllableLayer.addObject(nucleusFixedCheckbox);  preSyllableLayer.addObject(codaFixedCheckbox);
    preSyllableLayer.addObject(onsetTextInput);      preSyllableLayer.addObject(nucleusTextInput);      preSyllableLayer.addObject(codaTextInput);
    preSyllableLayer.addObject(onsetPositionInput);  preSyllableLayer.addObject(nucleusPositionInput);  preSyllableLayer.addObject(codaPositionInput);
    preSyllableLayer.addObject(onsetActiveCheckbox); preSyllableLayer.addObject(codaActiveCheckbox);
    
    postSyllableLayer.addObject(previewText);
    postSyllableLayer.addObject(onsetFixedCheckbox);  postSyllableLayer.addObject(nucleusFixedCheckbox);  postSyllableLayer.addObject(codaFixedCheckbox);
    postSyllableLayer.addObject(onsetTextInput);      postSyllableLayer.addObject(nucleusTextInput);      postSyllableLayer.addObject(codaTextInput);
    postSyllableLayer.addObject(onsetPositionInput);  postSyllableLayer.addObject(nucleusPositionInput);  postSyllableLayer.addObject(codaPositionInput);
    postSyllableLayer.addObject(onsetActiveCheckbox); postSyllableLayer.addObject(codaActiveCheckbox);
    
    inSyllableLayer.addObject(previewText);         inSyllableLayer.addObject(syllablePositionInput);
    inSyllableLayer.addObject(onsetFixedCheckbox);  inSyllableLayer.addObject(nucleusFixedCheckbox);  inSyllableLayer.addObject(codaFixedCheckbox);
    inSyllableLayer.addObject(onsetTextInput);      inSyllableLayer.addObject(nucleusTextInput);      inSyllableLayer.addObject(codaTextInput);
    inSyllableLayer.addObject(onsetPositionInput);  inSyllableLayer.addObject(nucleusPositionInput);  inSyllableLayer.addObject(codaPositionInput);
    inSyllableLayer.addObject(onsetActiveCheckbox); inSyllableLayer.addObject(codaActiveCheckbox);
    
    partDuplicationLayer.addObject(duplicationStartInput);     partDuplicationLayer.addObject(duplicationEndInput);
    partDuplicationLayer.addObject(duplicateWithCodaCheckbox); partDuplicationLayer.addObject(duplicateWithOnsetCheckbox);
    partDuplicationLayer.addObject(duplicatePositionCheckbox);
    
    replacementLayer.addObject(previewText);         replacementLayer.addObject(syllablePositionInput);
    replacementLayer.addObject(onsetFixedCheckbox);  replacementLayer.addObject(nucleusFixedCheckbox);  replacementLayer.addObject(codaFixedCheckbox);
    replacementLayer.addObject(onsetTextInput);      replacementLayer.addObject(nucleusTextInput);      replacementLayer.addObject(codaTextInput);
    replacementLayer.addObject(onsetPositionInput);  replacementLayer.addObject(nucleusPositionInput);  replacementLayer.addObject(codaPositionInput);
    replacementLayer.addObject(onsetActiveCheckbox); replacementLayer.addObject(codaActiveCheckbox);
    
    syllableModification.addObject(previewText);         syllableModification.addObject(syllablePositionInput);
    syllableModification.addObject(onsetFixedCheckbox);  syllableModification.addObject(nucleusFixedCheckbox);  syllableModification.addObject(codaFixedCheckbox);
    syllableModification.addObject(onsetTextInput);      syllableModification.addObject(nucleusTextInput);      syllableModification.addObject(codaTextInput);
    syllableModification.addObject(onsetPositionInput);  syllableModification.addObject(nucleusPositionInput);  syllableModification.addObject(codaPositionInput);
    syllableModification.addObject(onsetActiveCheckbox); syllableModification.addObject(codaActiveCheckbox);
  }
  
  public void setQuantifier(WordModifier wm){
    activeQuantifier = wm;
    
    int c;
    ///MISSING STUFF
    wordTypeSelection.selected = wm.nameId;
    SyllableModifier[] tmp = wm.modifiers;
    if(tmp.length == 0){
      modificationSelection.selected = -1;
      
      previewText.text = "";
      onsetFixedCheckbox.state = true; nucleusFixedCheckbox.state = true; codaFixedCheckbox.state = true;
      onsetTextInput.text = "";  nucleusTextInput.text = "";  codaTextInput.text = "";
      onsetPositionInput.value = 0;  nucleusPositionInput.value = 0;  codaPositionInput.value = 0;
      onsetActiveCheckbox.state = true;  codaActiveCheckbox.state = true;
      syllablePositionInput.value = 0; duplicationStartInput.value = 0; duplicationEndInput.value = 0;
      duplicateWithCodaCheckbox.state = true;  duplicateWithOnsetCheckbox.state = true;   duplicatePositionCheckbox.state = true;
      
    }else if(tmp.length == 1){
      modificationSelection.selected = tmp[0].preSyllable?0: tmp[0].postSyllable?1: tmp[0].inSyllable?2: 4;
      
      previewText.text = tmp[0].toString();
      onsetFixedCheckbox.state = tmp[0].onsetFixed; nucleusFixedCheckbox.state = tmp[0].nucleusFixed; codaFixedCheckbox.state = tmp[0].codaFixed;
      onsetTextInput.text = tmp[0].onsetSound;  nucleusTextInput.text = tmp[0].nucleusSound;  codaTextInput.text = tmp[0].codaSound;
      onsetPositionInput.value = tmp[0].onsetReferencePosition;  nucleusPositionInput.value = tmp[0].nucleusReferencePosition;  codaPositionInput.value = tmp[0].codaReferencePosition;
      onsetActiveCheckbox.state = tmp[0].onsetCopyOnset;  codaActiveCheckbox.state = tmp[0].codaCopyCoda;
      syllablePositionInput.value = tmp[0].syllablePosition; duplicationStartInput.value = 0; duplicationEndInput.value = 0;
      duplicateWithCodaCheckbox.state = true;  duplicateWithOnsetCheckbox.state = true;   duplicatePositionCheckbox.state = true;
     
    }else{
      modificationSelection.selected = 3;
      
      previewText.text = "";
      onsetFixedCheckbox.state = true; nucleusFixedCheckbox.state = true; codaFixedCheckbox.state = true;
      onsetTextInput.text = "";  nucleusTextInput.text = "";  codaTextInput.text = "";
      onsetPositionInput.value = 0;  nucleusPositionInput.value = 0;  codaPositionInput.value = 0;
      onsetActiveCheckbox.state = true;  codaActiveCheckbox.state = true;
      syllablePositionInput.value = 0;
      
      if(tmp[0].codaFixed){//Coda replacement
        duplicateWithCodaCheckbox.state = false;
        duplicationStartInput.value = tmp[1].onsetReferencePosition;
        duplicatePositionCheckbox.state = tmp[1].preSyllable;
        
      }else{//No changes to coda
        duplicateWithCodaCheckbox.state = true;
        duplicationStartInput.value = tmp[0].onsetReferencePosition;
        duplicatePositionCheckbox.state = tmp[0].preSyllable;
      }
      
      if(tmp[ tmp.length-1 ].onsetFixed){//Onset replacement
        duplicateWithOnsetCheckbox.state = false;
        duplicationEndInput.value = tmp[ tmp.length-2 ].onsetReferencePosition;
        
      }else{//No changes to onset
        duplicateWithOnsetCheckbox.state = true;
        duplicationEndInput.value = tmp[ tmp.length-1 ].onsetReferencePosition;
      }
    }
  }
  
  public void draw(){
    if(activeQuantifier != null){
      //if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y){
        wordTypeSelection.draw();
        modificationSelection.draw();
        deleteButton.draw();
        applyButton.draw();
        
        if(activeLayer != null) { activeLayer.draw(); }
      //}
      
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    if(activeQuantifier != null){
      wordTypeSelection.show();
      modificationSelection.show();
      deleteButton.show();
      applyButton.show();
        
      if(activeLayer != null) { activeLayer.show(); }
    }
  }
  
  public void onMouseDown(){
    
    if(activeQuantifier != null){
      wordTypeSelection.onMouseDown();
      modificationSelection.onMouseDown();
      deleteButton.onMouseDown();
      applyButton.onMouseDown();
      
      if(activeLayer != null) { activeLayer.onMouseDown(); }
      
      //BUTTON FUNCTIONS
      if(deleteButton.getTrigger()){
        listReference.list.remove(activeQuantifier);
        uiRefreshed = true;
        activeQuantifier = null;
      }
      if(applyButton.getTrigger()){
        applyChanges();
        uiRefreshed = true;
      }
      if(modificationSelection.getTrigger()){
        if(modificationSelection.selected == 0){ //Pre Syllable
          activeLayer = preSyllableLayer;
        }else if(modificationSelection.selected == 1){ //Post Syllable
          activeLayer = postSyllableLayer;
        }else if(modificationSelection.selected == 2){ //In Syllable
          activeLayer = inSyllableLayer;
        }else if(modificationSelection.selected == 3){ //Part Duplication
          activeLayer = partDuplicationLayer;
        }else if(modificationSelection.selected == 4){ //Replacement
          activeLayer = replacementLayer;
        }else if(modificationSelection.selected == 5){ //Modification
          activeLayer = syllableModification;
        }else{
          activeLayer = null;
        }
        uiRefreshed = true;
      }
      
      if(onsetFixedCheckbox.getTrigger() || nucleusFixedCheckbox.getTrigger() || codaFixedCheckbox.getTrigger()
      || onsetTextInput.getTrigger() || nucleusTextInput.getTrigger() || codaTextInput.getTrigger()
      || onsetPositionInput.getTrigger() || nucleusPositionInput.getTrigger() || codaPositionInput.getTrigger() 
      || onsetActiveCheckbox.getTrigger() || codaActiveCheckbox.getTrigger()){
        applyChanges();
        previewText.text = activeQuantifier.toString();
      }
    }
  }
  
  public void onKeyDown(){
    keyboard.onKeyDown();
  }
  
  public void applyChanges(){
    
    SyllableModifier[] tmp = new SyllableModifier[0];
    if(modificationSelection.selected == 0){ //Pre Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
        
    }else if(modificationSelection.selected == 1){ //Post Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    
    }else if(modificationSelection.selected == 2){ //In Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    
    }else if(modificationSelection.selected == 3){ //Part Duplication
      if(duplicationStartInput.value <= duplicationEndInput.value){
        tmp = new SyllableModifier[ duplicationEndInput.value - duplicationStartInput.value + (duplicateWithOnsetCheckbox.state?1:0) + (duplicateWithCodaCheckbox.state?1:0) ];
        
        for(int i = 0; i< duplicationEndInput.value - duplicationStartInput.value ; i++){
          tmp[i] = new SyllableModifier(duplicatePositionCheckbox.state?1:2, 0, duplicationStartInput.value +i, true, duplicationStartInput.value +i, duplicationStartInput.value +i, true);
        }
        
        if(duplicateWithOnsetCheckbox.state && duplicateWithCodaCheckbox.state){
          tmp[ tmp.length-2 ] = new SyllableModifier(0, duplicationStartInput.value-1, duplicationStartInput.value-1, true, duplicationStartInput.value-1, "");
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationEndInput.value+1, "", duplicationEndInput.value+1, duplicationEndInput.value+1, true);
        }else if(duplicateWithCodaCheckbox.state){
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationStartInput.value-1, duplicationStartInput.value-1, true, duplicationStartInput.value-1, "");
        }else if(duplicateWithOnsetCheckbox.state){
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationEndInput.value+1, "", duplicationEndInput.value+1, duplicationEndInput.value+1, true);
        }
      }
      //////////////////////////////////////////////////
      /// RIGHT NOW START MUST BE SMALLER THAN END   ///
      //////////////////////////////////////////////////
    
    
    }else if(modificationSelection.selected == 4){ //Replacement
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);

    
    }else if(modificationSelection.selected == 5){ //Modification
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    }
    if(tmp[0] == null){
      tmp = new SyllableModifier[0];
    }
    activeQuantifier.modifiers = tmp;
    
    activeQuantifier.name = QuantifierType.toString(wordTypeSelection.selected);
    activeQuantifier.nameId = wordTypeSelection.selected;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}




//Tense List
public class UI_TenseList extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_Scrollwheel scrollwheel;
  public int shift = 0;
  
  public ArrayList<WordModifier> list;
  
  public boolean changed = false;
  public WordModifier selection = null;
  public int hovered = -1;
  
  public UI_TenseList(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    scrollwheel = new UI_Scrollwheel(new Vector2(position.x+expanse.x*0.97, position.y+expanse.y*0.095), new Vector2(expanse.x*0.03, expanse.y*0.855) ,true, false);
    
    list = new ArrayList<WordModifier>();
    
    reload();
  }
  
  public void reload(){
    list = new ArrayList<WordModifier>();
    
    //Words are loaded from the languageData Word List
    for(int i = 0; i<languageData.tenses.size(); i++){
      WordModifier tmp = languageData.tenses.get(i);
      list.add(tmp);
    }
    
    uiRefreshed = true;
    shift = 0;
    
    scrollwheel.active = list.size() > 9;
  }
  
  public void draw() {
    scrollwheel.draw();
    
    //List
    int old = hovered;
    if(mouseX > position.x+expanse.x*0.01 && mouseX < position.x+expanse.x*0.96){
      if(mouseY > position.y+expanse.y*0.1 && mouseY < position.y+expanse.y*0.95){
        if( (mouseY -position.y-expanse.y*0.1)%(expanse.y*0.1) < expanse.y*0.095 ){
          hovered = int((mouseY -position.y-expanse.y*0.1)/(expanse.y*0.1)) + shift;
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
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    //List
    for(int i = shift; i<shift+9; i++){
      if(i < list.size()){
        showListObject(position.x+expanse.x*0.01,position.y+expanse.y*(0.1+ (i-shift)*0.1),expanse.x*0.95,expanse.y*0.09,i);
      }
    }
    
    //Overlay
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y*0.095); //Filter
    rect(position.x,position.y+expanse.y*0.95,expanse.x,expanse.y*0.05); //Search
    
    //Reference
    scrollwheel.show();
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
    textSize(expy*0.3);
    text( list.get(index).name, posx+expx*0.02,posy+expy*0.33);
    text( list.get(index).toString(), posx+expx*0.02,posy+expy*0.78);
  }
  
  public void onMouseDown() {
    scrollwheel.onMouseDown();
    
    //List
    if(hovered > -1 && hovered < list.size()){
      selection = list.get(hovered);
      changed = true;
      uiRefreshed = true;
    }
  }
  
  public void onMouse() {
    scrollwheel.onMouse();
  }
  
  public void onMouseUp() {
    scrollwheel.onMouseUp();
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
  
  public ArrayList<WordModifier> getCopy(){
    ArrayList<WordModifier> tmp = new ArrayList<WordModifier>();
    for(int i = 0; i<list.size(); i++){
      tmp.add( list.get(i) );
    }
    return tmp;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



//Tense Editor
public class UI_TenseEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public WordModifier activeTense = null;
  public UI_TenseList listReference;
  
  public UI_SwitchcaseButton wordTypeSelection;
  public UI_SwitchcaseButton modificationSelection;
  public UI_InputKeyboard keyboard;
  public UI_Layer preSyllableLayer;
  public UI_Layer postSyllableLayer;
  public UI_Layer inSyllableLayer;
  public UI_Layer partDuplicationLayer;
  public UI_Layer replacementLayer;
  public UI_Layer syllableModification;
  public UI_Button deleteButton;
  public UI_Button applyButton;
  
  public UI_Layer activeLayer = null;
  public boolean changed = false;
  
  //STUFF FOR THE LAYERS
  public UI_Text previewText;
  public UI_Checkbox onsetFixedCheckbox;
  public UI_Checkbox nucleusFixedCheckbox;
  public UI_Checkbox codaFixedCheckbox;
  public UI_TextInputField onsetTextInput;
  public UI_TextInputField nucleusTextInput;
  public UI_TextInputField codaTextInput;
  public UI_IntegerField onsetPositionInput;
  public UI_IntegerField nucleusPositionInput;
  public UI_IntegerField codaPositionInput;
  public UI_Checkbox onsetActiveCheckbox;
  public UI_Checkbox codaActiveCheckbox;
  
  public UI_IntegerField syllablePositionInput;
  public UI_IntegerField duplicationStartInput;
  public UI_IntegerField duplicationEndInput;
  public UI_Checkbox duplicateWithCodaCheckbox;
  public UI_Checkbox duplicateWithOnsetCheckbox;
  public UI_Checkbox duplicatePositionCheckbox;
  
  public UI_TenseEditor(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    keyboard = k;
    
    wordTypeSelection = new UI_SwitchcaseButton(new Vector2(position.x+3,position.y+3), new Vector2(expanse.x*0.15, expanse.y-6));
    for(int i = 0; i<TenseType.getAmount(); i++){
      wordTypeSelection.addButton( new UI_Button(new Vector2(position.x+8,position.y+8+expanse.y*0.043*i), new Vector2(expanse.x*0.15-16,expanse.y*0.04), TenseType.toString(i) ,true) );
    }
    
    modificationSelection = new UI_SwitchcaseButton(new Vector2(position.x+10+expanse.x*0.15,position.y+5), new Vector2(expanse.x*0.82, expanse.y*0.12));
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.2,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " Pre-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.45,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " Post-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.7,position.y+12), new Vector2(expanse.x*0.22,expanse.y*0.045), " In-Syllable" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.2,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Part Duplication" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.45,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Replacement" ,true) );
    modificationSelection.addButton( new UI_Button(new Vector2(position.x+15+expanse.x*0.7,position.y+12+expanse.y*0.05), new Vector2(expanse.x*0.22,expanse.y*0.045), " Modification" ,true) );
    
    deleteButton = new UI_Button(new Vector2(position.x+expanse.x*0.8, position.y+expanse.y*0.92),new Vector2(expanse.x*0.15,expanse.y*0.045), " Delete",true);
    applyButton = new UI_Button(new Vector2(position.x+expanse.x*0.6, position.y+expanse.y*0.92),new Vector2(expanse.x*0.15,expanse.y*0.045), " Apply",true);
    
    //Layer Stuff
    preSyllableLayer = new UI_Layer("Pre Syllable");
    postSyllableLayer = new UI_Layer("Post Syllable");
    inSyllableLayer = new UI_Layer("In Syllable");
    partDuplicationLayer = new UI_Layer("Part Duplication");
    replacementLayer = new UI_Layer("Replacement");
    syllableModification = new UI_Layer("Syllable Modification");
    
    previewText = new UI_Text(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.25), new Vector2(expanse.x*0.75, expanse.y*0.12), "PREVIEW");
    onsetFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Onset?", true);
    nucleusFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.45,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Nucleus?", true);
    codaFixedCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.7,position.y+expanse.y*0.45), new Vector2(expanse.x*0.22, expanse.y*0.04), "Fixed Coda?", true);
    onsetTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    nucleusTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.5,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    codaTextInput = new UI_TextInputField(new Vector2(position.x+expanse.x*0.75,position.y+expanse.y*0.52), new Vector2(expanse.x*0.1, expanse.y*0.06),"",keyboard,true);
    onsetPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Onset",1,-8,8);
    nucleusPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.45,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Nucleus",1,-8,8);
    codaPositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.7,position.y+expanse.y*0.6), new Vector2(expanse.x*0.24, expanse.y*0.05),"Coda",1,-8,8);
    onsetActiveCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.22,position.y+expanse.y*0.67), new Vector2(expanse.x*0.15, expanse.y*0.04),"copy onset?",true);
    codaActiveCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.72,position.y+expanse.y*0.67), new Vector2(expanse.x*0.15, expanse.y*0.04),"copy coda?",true);
    
    syllablePositionInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.2,position.y+expanse.y*0.15),new Vector2(expanse.x*0.75,expanse.y*0.05)," Syllable Position:",1,-8,8);
    duplicationStartInput = new UI_IntegerField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.25),new Vector2(expanse.x*0.6,expanse.y*0.05)," Starting Syllable:",1,-8,8);
    duplicationEndInput =   new UI_IntegerField(new Vector2(position.x+expanse.x*0.25,position.y+expanse.y*0.32),new Vector2(expanse.x*0.6,expanse.y*0.05)," Ending Syllable:",1,-8,8);
    duplicateWithCodaCheckbox =  new UI_Checkbox(new Vector2(position.x+expanse.x*0.35,position.y+expanse.y*0.45),new Vector2(expanse.x*0.4,expanse.y*0.05),"keep First Coda?",true);
    duplicateWithOnsetCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.35,position.y+expanse.y*0.52),new Vector2(expanse.x*0.4,expanse.y*0.05),"keep Last Onset?",true);
    duplicatePositionCheckbox = new UI_Checkbox(new Vector2(position.x+expanse.x*0.3,position.y+expanse.y*0.62),new Vector2(expanse.x*0.5,expanse.y*0.05),"copy to preposition?",true);
    
    preSyllableLayer.addObject(previewText);
    preSyllableLayer.addObject(onsetFixedCheckbox);  preSyllableLayer.addObject(nucleusFixedCheckbox);  preSyllableLayer.addObject(codaFixedCheckbox);
    preSyllableLayer.addObject(onsetTextInput);      preSyllableLayer.addObject(nucleusTextInput);      preSyllableLayer.addObject(codaTextInput);
    preSyllableLayer.addObject(onsetPositionInput);  preSyllableLayer.addObject(nucleusPositionInput);  preSyllableLayer.addObject(codaPositionInput);
    preSyllableLayer.addObject(onsetActiveCheckbox); preSyllableLayer.addObject(codaActiveCheckbox);
    
    postSyllableLayer.addObject(previewText);
    postSyllableLayer.addObject(onsetFixedCheckbox);  postSyllableLayer.addObject(nucleusFixedCheckbox);  postSyllableLayer.addObject(codaFixedCheckbox);
    postSyllableLayer.addObject(onsetTextInput);      postSyllableLayer.addObject(nucleusTextInput);      postSyllableLayer.addObject(codaTextInput);
    postSyllableLayer.addObject(onsetPositionInput);  postSyllableLayer.addObject(nucleusPositionInput);  postSyllableLayer.addObject(codaPositionInput);
    postSyllableLayer.addObject(onsetActiveCheckbox); postSyllableLayer.addObject(codaActiveCheckbox);
    
    inSyllableLayer.addObject(previewText);         inSyllableLayer.addObject(syllablePositionInput);
    inSyllableLayer.addObject(onsetFixedCheckbox);  inSyllableLayer.addObject(nucleusFixedCheckbox);  inSyllableLayer.addObject(codaFixedCheckbox);
    inSyllableLayer.addObject(onsetTextInput);      inSyllableLayer.addObject(nucleusTextInput);      inSyllableLayer.addObject(codaTextInput);
    inSyllableLayer.addObject(onsetPositionInput);  inSyllableLayer.addObject(nucleusPositionInput);  inSyllableLayer.addObject(codaPositionInput);
    inSyllableLayer.addObject(onsetActiveCheckbox); inSyllableLayer.addObject(codaActiveCheckbox);
    
    partDuplicationLayer.addObject(duplicationStartInput);     partDuplicationLayer.addObject(duplicationEndInput);
    partDuplicationLayer.addObject(duplicateWithCodaCheckbox); partDuplicationLayer.addObject(duplicateWithOnsetCheckbox);
    partDuplicationLayer.addObject(duplicatePositionCheckbox);
    
    replacementLayer.addObject(previewText);         replacementLayer.addObject(syllablePositionInput);
    replacementLayer.addObject(onsetFixedCheckbox);  replacementLayer.addObject(nucleusFixedCheckbox);  replacementLayer.addObject(codaFixedCheckbox);
    replacementLayer.addObject(onsetTextInput);      replacementLayer.addObject(nucleusTextInput);      replacementLayer.addObject(codaTextInput);
    replacementLayer.addObject(onsetPositionInput);  replacementLayer.addObject(nucleusPositionInput);  replacementLayer.addObject(codaPositionInput);
    replacementLayer.addObject(onsetActiveCheckbox); replacementLayer.addObject(codaActiveCheckbox);
    
    syllableModification.addObject(previewText);         syllableModification.addObject(syllablePositionInput);
    syllableModification.addObject(onsetFixedCheckbox);  syllableModification.addObject(nucleusFixedCheckbox);  syllableModification.addObject(codaFixedCheckbox);
    syllableModification.addObject(onsetTextInput);      syllableModification.addObject(nucleusTextInput);      syllableModification.addObject(codaTextInput);
    syllableModification.addObject(onsetPositionInput);  syllableModification.addObject(nucleusPositionInput);  syllableModification.addObject(codaPositionInput);
    syllableModification.addObject(onsetActiveCheckbox); syllableModification.addObject(codaActiveCheckbox);
  }
  
  public void setTense(WordModifier wm){
    activeTense = wm;
    
    ///MISSING STUFF
    wordTypeSelection.selected = wm.nameId;
    SyllableModifier[] tmp = wm.modifiers;
    if(tmp.length == 0){
      modificationSelection.selected = -1;
      
      previewText.text = "";
      onsetFixedCheckbox.state = true; nucleusFixedCheckbox.state = true; codaFixedCheckbox.state = true;
      onsetTextInput.text = "";  nucleusTextInput.text = "";  codaTextInput.text = "";
      onsetPositionInput.value = 0;  nucleusPositionInput.value = 0;  codaPositionInput.value = 0;
      onsetActiveCheckbox.state = true;  codaActiveCheckbox.state = true;
      syllablePositionInput.value = 0; duplicationStartInput.value = 0; duplicationEndInput.value = 0;
      duplicateWithCodaCheckbox.state = true;  duplicateWithOnsetCheckbox.state = true;   duplicatePositionCheckbox.state = true;
      
    }else if(tmp.length == 1){
      modificationSelection.selected = tmp[0].preSyllable?0: tmp[0].postSyllable?1: tmp[0].inSyllable?2: 4;
      
      previewText.text = tmp[0].toString();
      onsetFixedCheckbox.state = tmp[0].onsetFixed; nucleusFixedCheckbox.state = tmp[0].nucleusFixed; codaFixedCheckbox.state = tmp[0].codaFixed;
      onsetTextInput.text = tmp[0].onsetSound;  nucleusTextInput.text = tmp[0].nucleusSound;  codaTextInput.text = tmp[0].codaSound;
      onsetPositionInput.value = tmp[0].onsetReferencePosition;  nucleusPositionInput.value = tmp[0].nucleusReferencePosition;  codaPositionInput.value = tmp[0].codaReferencePosition;
      onsetActiveCheckbox.state = tmp[0].onsetCopyOnset;  codaActiveCheckbox.state = tmp[0].codaCopyCoda;
      syllablePositionInput.value = tmp[0].syllablePosition; duplicationStartInput.value = 0; duplicationEndInput.value = 0;
      duplicateWithCodaCheckbox.state = true;  duplicateWithOnsetCheckbox.state = true;   duplicatePositionCheckbox.state = true;
     
    }else{
      modificationSelection.selected = 3;
      
      previewText.text = "";
      onsetFixedCheckbox.state = true; nucleusFixedCheckbox.state = true; codaFixedCheckbox.state = true;
      onsetTextInput.text = "";  nucleusTextInput.text = "";  codaTextInput.text = "";
      onsetPositionInput.value = 0;  nucleusPositionInput.value = 0;  codaPositionInput.value = 0;
      onsetActiveCheckbox.state = true;  codaActiveCheckbox.state = true;
      syllablePositionInput.value = 0;
      
      if(tmp[0].codaFixed){//Coda replacement
        duplicateWithCodaCheckbox.state = false;
        duplicationStartInput.value = tmp[1].onsetReferencePosition;
        duplicatePositionCheckbox.state = tmp[1].preSyllable;
        
      }else{//No changes to coda
        duplicateWithCodaCheckbox.state = true;
        duplicationStartInput.value = tmp[0].onsetReferencePosition;
        duplicatePositionCheckbox.state = tmp[0].preSyllable;
      }
      
      if(tmp[ tmp.length-1 ].onsetFixed){//Onset replacement
        duplicateWithOnsetCheckbox.state = false;
        duplicationEndInput.value = tmp[ tmp.length-2 ].onsetReferencePosition;
        
      }else{//No changes to onset
        duplicateWithOnsetCheckbox.state = true;
        duplicationEndInput.value = tmp[ tmp.length-1 ].onsetReferencePosition;
      }
    }
  }
  
  public void draw(){
    if(activeTense != null){
      //if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y){
        wordTypeSelection.draw();
        modificationSelection.draw();
        deleteButton.draw();
        applyButton.draw();
        
        if(activeLayer != null) { activeLayer.draw(); }
      //}
      
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiInactive);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    if(activeTense != null){
      wordTypeSelection.show();
      modificationSelection.show();
      deleteButton.show();
      applyButton.show();
        
      if(activeLayer != null) { activeLayer.show(); }
    }
  }
  
  public void onMouseDown(){
    
    if(activeTense != null){
      wordTypeSelection.onMouseDown();
      modificationSelection.onMouseDown();
      deleteButton.onMouseDown();
      applyButton.onMouseDown();
        
      if(activeLayer != null) { activeLayer.onMouseDown(); }
      
      //BUTTON FUNCTIONS
      if(deleteButton.getTrigger()){
        listReference.list.remove(activeTense);
        uiRefreshed = true;
        activeTense = null;
      }
      if(applyButton.getTrigger()){
        applyChanges();
        uiRefreshed = true;
      }
      if(modificationSelection.getTrigger()){
        if(modificationSelection.selected == 0){ //Pre Syllable
          activeLayer = preSyllableLayer;
        }else if(modificationSelection.selected == 1){ //Post Syllable
          activeLayer = postSyllableLayer;
        }else if(modificationSelection.selected == 2){ //In Syllable
          activeLayer = inSyllableLayer;
        }else if(modificationSelection.selected == 3){ //Part Duplication
          activeLayer = partDuplicationLayer;
        }else if(modificationSelection.selected == 4){ //Replacement
          activeLayer = replacementLayer;
        }else if(modificationSelection.selected == 5){ //Modification
          activeLayer = syllableModification;
        }else{
          activeLayer = null;
        }
        uiRefreshed = true;
      }
      
      if(onsetFixedCheckbox.getTrigger() || onsetFixedCheckbox.getTrigger() || onsetFixedCheckbox.getTrigger()){
        
      }
    }
  }
  
  public void onKeyDown(){
    keyboard.onKeyDown();
  }
  
  public void applyChanges(){
    
    SyllableModifier[] tmp = new SyllableModifier[0];
    if(modificationSelection.selected == 0){ //Pre Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(1, 0, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(1, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
        
    }else if(modificationSelection.selected == 1){ //Post Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(2, 0, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(2, 0, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    
    }else if(modificationSelection.selected == 2){ //In Syllable
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(3, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    
    }else if(modificationSelection.selected == 3){ //Part Duplication
      if(duplicationStartInput.value <= duplicationEndInput.value){
        tmp = new SyllableModifier[ duplicationEndInput.value - duplicationStartInput.value + (duplicateWithOnsetCheckbox.state?1:0) + (duplicateWithCodaCheckbox.state?1:0) ];
        
        for(int i = 0; i< duplicationEndInput.value - duplicationStartInput.value ; i++){
          tmp[i] = new SyllableModifier(duplicatePositionCheckbox.state?1:2, 0, duplicationStartInput.value +i, true, duplicationStartInput.value +i, duplicationStartInput.value +i, true);
        }
        
        if(duplicateWithOnsetCheckbox.state && duplicateWithCodaCheckbox.state){
          tmp[ tmp.length-2 ] = new SyllableModifier(0, duplicationStartInput.value-1, duplicationStartInput.value-1, true, duplicationStartInput.value-1, "");
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationEndInput.value+1, "", duplicationEndInput.value+1, duplicationEndInput.value+1, true);
        }else if(duplicateWithCodaCheckbox.state){
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationStartInput.value-1, duplicationStartInput.value-1, true, duplicationStartInput.value-1, "");
        }else if(duplicateWithOnsetCheckbox.state){
          tmp[ tmp.length-1 ] = new SyllableModifier(0, duplicationEndInput.value+1, "", duplicationEndInput.value+1, duplicationEndInput.value+1, true);
        }
      }
      //////////////////////////////////////////////////
      /// RIGHT NOW START MUST BE SMALLER THAN END   ///
      //////////////////////////////////////////////////
    
    
    }else if(modificationSelection.selected == 4){ //Replacement
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);

    
    }else if(modificationSelection.selected == 5){ //Modification
      tmp = new SyllableModifier[1];
      if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && codaFixedCheckbox.state) //cvc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //Ovc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //cNC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetTextInput.text, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //OvC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusTextInput.text, codaPositionInput.value, codaActiveCheckbox.state);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONc
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaTextInput.text);
        
      else if(onsetFixedCheckbox.state && nucleusFixedCheckbox.state && !codaFixedCheckbox.state) //ONC
        tmp[0] = new SyllableModifier(0, syllablePositionInput.value, onsetPositionInput.value, onsetActiveCheckbox.state, nucleusPositionInput.value, codaPositionInput.value, codaActiveCheckbox.state);
    
    }
    if(tmp[0] == null){
      tmp = new SyllableModifier[0];
    }
    
    activeTense.modifiers = tmp;
    
    activeTense.name = QuantifierType.toString(wordTypeSelection.selected);
    activeTense.nameId = wordTypeSelection.selected;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}
