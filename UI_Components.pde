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
    
    textSize = expanse.y-2 > (expanse.x / (float)text.length())*1.5? (expanse.x / (float)text.length())*1.8 : expanse.y-2;
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
    text(text,position.x+1, position.y+0.5*expanse.y+textSize*0.3);
  }
  
  public void onMouseDown(){
    if(hovered){ 
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


//Base Class for UI Objects
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
      hovering = int((mouseX - position.x) / 150f);
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
        rect(position.x+150*i,position.y,150,25);
      }else{
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiLayerInactive);
        }
        rect(position.x+150*i+2,position.y+2,150-4,25-2);
      }
      fill(ColorCode.black);
      textSize(16);
      text(layers.get(i).name,position.x+150*i+3,position.y+1,150-6,25-2);
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
  
  public UI_SelectionTable(Vector2 pos, Vector2 exp, String file){ 
    //The table is saved in a textfile: 1st line: row and column count, each following line one object. Default: none selected
    //The first row and line are not selectable. Empty fields can not be selected
    position = pos;
    expanse = exp;
    
    importFile(file);
  }
  
  public void importFile(String f){
    String[] tmp = loadStrings(f);
    rows = int(tmp[0].split(" ")[0]);
    columns = int(tmp[0].split(" ")[1]);
    
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
    
    boxExpanse = new Vector2(expanse.x / float(columns), expanse.y / float(rows));
  }
  
  public void draw(){
    Vector2 old = new Vector2(hovering.x, hovering.y);
    hovering = new Vector2(-1,-1);
    if(mouseX > position.x && mouseX < position.x+expanse.x){
      hovering.x = int((mouseX - position.x) / boxExpanse.x);
    }
    if(mouseY > position.y && mouseY < position.y+expanse.y){
      hovering.y = int((mouseY - position.y) / boxExpanse.y);
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
          if(c == int(hovering.x) && r == int(hovering.y)){
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
        text(text[r][c], position.x + c*boxExpanse.x + boxExpanse.x*0.1, position.y + r*boxExpanse.y + 16);
      }
    }
  }
  
  public void onMouseDown(){
    if(hovering.x > 0 && hovering.y > 0 && selectable[int(hovering.y)][int(hovering.x)]){
      active[int(hovering.y)][int(hovering.x)] = !active[int(hovering.y)][int(hovering.x)];
    }
  }
  
  public boolean getTrigger(){
    return false;
  }
}


//Selection Table
public class UI_SoundSelectionTable extends UI_SelectionTable{
  
  public UI_SoundSelectionTable(Vector2 pos, Vector2 exp, String file){ 
    super(pos, exp, file);
  }
  
  public void onMouseDown(){
    if(mouseButton == LEFT){
      if(hovering.x > 0 && hovering.y > 0 && selectable[int(hovering.y)][int(hovering.x)]){
        active[int(hovering.y)][int(hovering.x)] = !active[int(hovering.y)][int(hovering.x)];
      }
    }else if(mouseButton == RIGHT){
      if(hovering.x > 0 && hovering.y > 0 && selectable[int(hovering.y)][int(hovering.x)]){
        playSound("sounds/"+split(text[int(hovering.y)][int(hovering.x)],'\n')[1]);
      }
    }
  }
}


//Text
public class UI_Text extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public float textSize;
  public int lines = 1;
  public color textColor;
  
  public UI_Text(Vector2 pos, Vector2 exp, String txt){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; println("n"); }
    }
    
    textSize = (expanse.y-2.0) / (1.5f * lines) *0.7f;
    textColor = ColorCode.guiText;
  }
  
  public UI_Text(Vector2 pos, Vector2 exp, String txt, color c){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; println("n"); }
    }
    
    textSize = (expanse.y-2.0) / (1.5f * lines) *0.7f;
    textColor = c;
  }
  
  public void show(){
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    fill(textColor);
    textSize(textSize);
    //text(text,position.x+1, position.y-4+expanse.y);
    text(text,position.x+1, position.y+0.5+textSize);
  }
}

/*
//Text
public class UI_SoundCheckbox extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public float textSize;
  public int lines = 1;
  public color textColor;
  
  public UI_SoundCheckbox(Vector2 pos, Vector2 exp, String txt){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; println("n"); }
    }
    
    textSize = (expanse.y-2.0) / (1.5f * lines) *0.7f;
    textColor = ColorCode.guiText;
  }
  
  public void show(){
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    fill(textColor);
    textSize(textSize);
    //text(text,position.x+1, position.y-4+expanse.y);
    text(text,position.x+1, position.y+0.5+textSize);
  }
}*/


//Syllable Shape Editor
public class UI_SyllableShapeEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int onsetAmount = 1;
  public int codaAmount = 1;
  
  public UI_Button addOnset;
  public UI_Button removeOnset;
  public UI_Button addCoda;
  public UI_Button removeCoda;
  
  public UI_SyllableShapeEditor(Vector2 pos, Vector2 exp){
    position = pos;
    expanse = exp;
    
    onsetAmount = 1;
    codaAmount = 1;
    
    addOnset =    new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeOnset = new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
    addCoda =     new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeCoda =  new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
  }
  
  public void draw(){
    addOnset.draw();
    removeOnset.draw();
    addCoda.draw();
    removeCoda.draw();
  }
  
  public void show(){
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    addOnset.show();
    removeOnset.show();
    addCoda.show();
    removeCoda.show();
    
    textSize(expanse.y*0.9);
    //show Nucleus
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x+expanse.x*0.5-expanse.y*0.45, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
    fill(ColorCode.blue);
    text("V",position.x+expanse.x*0.5-expanse.y*0.3, position.y+expanse.y*0.8);
    
    //show Onset
    for(int i = 0 ; i<onsetAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5-expanse.y*0.45 -(1+i)*expanse.y, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.green);
      text("C",position.x+expanse.x*0.5-expanse.y*0.3 -(1+i)*expanse.y, position.y+expanse.y*0.8);
    }
    
    //show Coda
    for(int i = 0 ; i<codaAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5-expanse.y*0.45 +(1+i)*expanse.y, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.red);
      text("C",position.x+expanse.x*0.5-expanse.y*0.3 +(1+i)*expanse.y, position.y+expanse.y*0.8);
    }
  }
}
