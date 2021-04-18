

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
