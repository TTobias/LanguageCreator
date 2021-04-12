



public class SceneManager{
  public ArrayList<Scene> scenes = new ArrayList<Scene>();
  public int activeSceneIndex = -1; //don't modify this number directly!
  
  public SceneManager(){
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
