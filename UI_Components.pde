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
  
  public UI_VocabularyList(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
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
  
  public UI_WordEditor(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    wordInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.02,position.y+expanse.y*0.02), new Vector2(expanse.x*0.7,expanse.y*0.1),"Word",k,false);
    randomButton = new UI_Button(new Vector2(pos.x+expanse.x*0.74,position.y+expanse.y*0.03), new Vector2(expanse.x*0.24,expanse.y*0.08)," Random",true);
    wordTypeSelection = new UI_SwitchcaseButton(new Vector2(pos.x+expanse.x*0.02,position.y+expanse.y*0.15), new Vector2(expanse.x*0.35,expanse.y*0.82));
    translationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.16), new Vector2(expanse.x*0.2,expanse.y*0.06), "Translation:");;
    translationInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.22), new Vector2(expanse.x*0.6,expanse.y*0.1), "Translation",true);
    rootwordText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.34), new Vector2(expanse.x*0.6,expanse.y*0.08), "Root: [None]");
    pronounciationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.44), new Vector2(expanse.x*0.6,expanse.y*0.2), "Pronounciation:");
    syllableAnalysisText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.66), new Vector2(expanse.x*0.6,expanse.y*0.16),"Syllable Analysis:");
    confirmButton = new UI_Button(new Vector2(pos.x+expanse.x*0.45,position.y+expanse.y*0.87), new Vector2(expanse.x*0.45,expanse.y*0.1)," Confirm",true);
  }
  
  public void draw(){
    wordInput.draw();
    randomButton.draw();
    wordTypeSelection.draw();
    translationInput.draw();
    confirmButton.draw();
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
  }
  
  public void onMouseDown(){
    wordInput.onMouseDown();
    randomButton.onMouseDown();
    wordTypeSelection.onMouseDown();
    translationInput.onMouseDown();
    confirmButton.onMouseDown();
    
    //ButtonFunctions
    /*
    if(randomButton.getTrigger()){
      //
    }
    if(confirmButton.getTrigger()){
      //
    }*/
  }
  
  public void onKeyDown(){
    translationInput.onKeyDown();
    wordInput.onKeyDown();
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



//Panel with multiple Buttons of which 1 (or 0?) can be selected (basically multiple choice)
public class UI_SwitchcaseButton extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_SwitchcaseButton(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
  }
}
