


public void settings(){
  size(1400,900);
  sceneManager = new SceneManager();
}

//Called once at the beginning
public SceneManager sceneManager;
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
