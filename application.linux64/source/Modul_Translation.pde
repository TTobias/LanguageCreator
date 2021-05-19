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
