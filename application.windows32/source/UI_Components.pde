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
    
    scrollwheel = new UI_Scrollwheel(new Vector2(position.x+expanse.x*0.97, position.y+expanse.y*0.095), new Vector2(expanse.x*0.03, expanse.y*0.855) ,true);
    
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
