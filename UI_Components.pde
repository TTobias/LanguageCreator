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
    if(hovered && active){ 
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


//Layer (technical)
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


//Checkbox
public class UI_Checkbox extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public boolean state;
  
  public boolean active = true;
  public boolean hovering = false;
  public boolean changed = false;
  
  public UI_Checkbox(Vector2 pos, Vector2 exp, String t, boolean s){
    position = pos;
    expanse = exp;
    text = t;
    state = s;
  }
  
  public void draw(){
    hovering = mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y;
  }
  
  public void show(){
    if( active ){
      if( state ){
        fill(ColorCode.guiEnabled);
      }else{
        fill(ColorCode.guiDisabled);
      }
    }else{
      fill(ColorCode.guiInactive);
    }
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    textSize(expanse.y*0.9);
    fill(ColorCode.guiText);
    text(text,position.x+1, position.y+expanse.y*0.9);
  }
  
  public void onMouseDown(){
    if(hovering){
      state = !state;
      changed = true;
      uiRefreshed = true;
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      uiRefreshed = true;
      changed = false;
      return true;
    }
    return false;
  }
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
  
  public UI_SelectionTable(Vector2 pos, Vector2 exp, String file){ //file = "" makes it skip the import
    //The table is saved in a textfile: 1st line: row and column count, each following line one object. Default: none selected
    //The first row and line are not selectable. Empty fields can not be selected
    position = pos;
    expanse = exp;
    
    if(file != ""){
      importFile(file);
    }else{
      rows = 0;
      columns = 0;
      text = new String[rows][columns];
      active = new boolean[rows][columns];
      selectable = new boolean[rows][columns];
      boxExpanse = expanse;
    }
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


//Sound Selection Table
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
      if(tmp[i] == '\n') { lines++; }
    }
    
    textColor = ColorCode.guiText;
    recalculateTextSize();
  }
  
  public UI_Text(Vector2 pos, Vector2 exp, String txt, color c){
    position = pos;
    expanse = exp;
    text = txt;
    
    char[] tmp = txt.toCharArray();
    for(int i = 0; i<tmp.length;i++){
      if(tmp[i] == '\n') { lines++; }
    }
    
    textColor = c;
    recalculateTextSize();
  }
  
  public void recalculateTextSize(){
    textSize = (expanse.y-2.0) / (1.5f * lines) *0.85f;
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


//Syllable Shape Editor
public class UI_SyllableShapeEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  public float downSpace;
  
  public int onsetAmount = 1;
  public int codaAmount = 1;
  public boolean doubleNucleus = false;
  
  public UI_SelectionTable vowelTable;
  public UI_SelectionTable consonantTable;
  
  public UI_Button addOnset;
  public UI_Button removeOnset;
  public UI_Button addCoda;
  public UI_Button removeCoda;
  public UI_Button toggleNucleus;
  
  public ArrayList<UI_SyllablePartEditor> onsetDetails;
  public ArrayList<UI_SyllablePartEditor> nucleusDetails;
  public ArrayList<UI_SyllablePartEditor> codaDetails;
  
  //public ArrayList<boolean> onsetOption;
  //public boolean nucleusOption;
  //public ArrayList<boolean> codaOption;
  
  public UI_SyllableShapeEditor(Vector2 pos, Vector2 exp, float space, UI_SelectionTable ct, UI_SelectionTable vt){
    position = pos;
    expanse = exp;
    downSpace = space;
    
    onsetAmount = 1;
    codaAmount = 1;
    doubleNucleus = false;
    
    vowelTable = vt;
    consonantTable = ct;
    
    addOnset =      new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeOnset =   new UI_Button(new Vector2(pos.x+exp.y*0.05f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
    addCoda =       new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"+",true);
    removeCoda =    new UI_Button(new Vector2(pos.x+exp.x-exp.y*0.45f,pos.y + exp.y*0.55f),new Vector2(exp.y*0.4f,exp.y*0.4f),"-",true);
    toggleNucleus = new UI_Button(new Vector2(pos.x+exp.y*0.5f,pos.y+exp.y*0.05f),new Vector2(exp.y*0.4f,exp.y*0.4f),"V",true);
    
    onsetDetails = new ArrayList<UI_SyllablePartEditor>();
    nucleusDetails = new ArrayList<UI_SyllablePartEditor>();
    codaDetails = new ArrayList<UI_SyllablePartEditor>();
    for(int i = 0; i<onsetAmount; i++){ 
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5-expanse.y*0.9 -(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, ct) ); }
    nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5-expanse.y*0.45,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), true, vt) );
    for(int i = 0; i<codaAmount; i++){
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5 +(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, ct) ); }
  }
  
  public void reimport(){
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).importSounds(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).importSounds(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).importSounds(); }
  }
  
  public void draw(){
    addOnset.draw();
    removeOnset.draw();
    addCoda.draw();
    removeCoda.draw();
    toggleNucleus.draw();
    
    //Part-Editors
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).draw(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).draw(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).draw(); }
  }
  
  public void show(){
    fill(ColorCode.guiTextBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    addOnset.show();
    removeOnset.show();
    addCoda.show();
    removeCoda.show();
    toggleNucleus.show();
    
    textSize(expanse.y*0.9);
    //show Nucleus
    if(doubleNucleus){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5+expanse.y*0.02, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      rect(position.x+expanse.x*0.5-expanse.y*0.92, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.blue);
      text("V",position.x+expanse.x*0.5+expanse.y*0.2, position.y+expanse.y*0.8);
      text("V",position.x+expanse.x*0.5-expanse.y*0.75, position.y+expanse.y*0.8);
    }else{
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5-expanse.y*0.45, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.blue);
      text("V",position.x+expanse.x*0.5-expanse.y*0.3, position.y+expanse.y*0.8);
    }
    
    //show Onset
    for(int i = 0 ; i<onsetAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5-expanse.y*0.9 -(1+i)*expanse.y, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.green);
      text("C",position.x+expanse.x*0.5-expanse.y*0.78 -(1+i)*expanse.y, position.y+expanse.y*0.8);
    }
    
    //show Coda
    for(int i = 0 ; i<codaAmount ; i++){
      fill(ColorCode.guiTextBackground);
      stroke(0);
      rect(position.x+expanse.x*0.5 +(1+i)*expanse.y, position.y+expanse.y*0.02, expanse.y*0.9, expanse.y*0.96);
      fill(ColorCode.red);
      text("C",position.x+expanse.x*0.5+expanse.y*0.15 +(1+i)*expanse.y, position.y+expanse.y*0.8);
    }
    
    //Part-Editors
    for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).show(); }
    for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).show(); }
    for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).show(); }
  }
  
  public void onMouseDown(){
    //Redirection to the buttons and other child-UI
    if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y && mouseY < position.y+expanse.y){
      addOnset.onMouseDown();
      removeOnset.onMouseDown();
      addCoda.onMouseDown();
      removeCoda.onMouseDown();
      toggleNucleus.onMouseDown();
    }else if(mouseX > position.x && mouseX < position.x+expanse.x && mouseY > position.y+expanse.y){
      //Part-Editors
      for(int i = 0; i<onsetDetails.size(); i++){ onsetDetails.get(i).onMouseDown(); }
      for(int i = 0; i<nucleusDetails.size(); i++){ nucleusDetails.get(i).onMouseDown(); }
      for(int i = 0; i<codaDetails.size(); i++){ codaDetails.get(i).onMouseDown(); }
    }
    
    //Toggle optionality
    
    
    //Button Functions
    if(addOnset.getTrigger()){
      onsetAmount++;
      removeOnset.active = true;
      uiRefreshed = true;
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5-expanse.y*0.9 -(onsetAmount)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, consonantTable) );
    }
    if(removeOnset.getTrigger()){
      onsetAmount--;
      if( onsetAmount == 0 ){ removeOnset.active = false; }
      uiRefreshed = true;
      onsetDetails.remove(onsetDetails.get(onsetDetails.size()-1));
    }
    if(addCoda.getTrigger()){
      codaAmount++;
      removeCoda.active = true;
      uiRefreshed = true;
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5 +(codaAmount)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, consonantTable) );
    }
    if(removeCoda.getTrigger()){
      codaAmount--;
      if( codaAmount == 0 ){ removeCoda.active = false; }
      uiRefreshed = true;
      codaDetails.remove(codaDetails.get(codaDetails.size()-1));
    }
    if(toggleNucleus.getTrigger()){
      if(doubleNucleus){
        nucleusDetails.remove(1);
        nucleusDetails.get(0).position.set(position.x+expanse.x*0.5-expanse.y*0.45,position.y+expanse.y);
        uiRefreshed = true;
      }else{
        nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5+expanse.y*0.02,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), true, vowelTable) );
        nucleusDetails.get(0).position.set(position.x+expanse.x*0.5-expanse.y*0.92,position.y+expanse.y);
        uiRefreshed = true;
      }
      doubleNucleus = !doubleNucleus;
    }
  }
}


//SyllablePartEditor
public class UI_SyllablePartEditor extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public boolean isVowel;
  public UI_SelectionTable table;
  
  public ArrayList<UI_Checkbox> soundtypes;
  public ArrayList<ArrayList<UI_Checkbox>> sounds;
  
  public UI_SyllablePartEditor(Vector2 pos, Vector2 exp, boolean v, UI_SelectionTable t){
    position = pos;
    expanse = exp;
    
    isVowel = v;
    table = t;
    
    importSounds();
  }
  
  public void importSounds(){
    soundtypes = new ArrayList<UI_Checkbox>();
    sounds = new ArrayList<ArrayList<UI_Checkbox>>();
    
    //Sounds are importet from the ModulCreation- layer1a tables.
    float tmpY = 0; //downshift
    if(isVowel){
      
      for(int r = 1; r<table.text.length; r+=2){
        UI_Checkbox tmpSoundType = new UI_Checkbox( new Vector2(position.x+expanse.x*0.05,position.y+expanse.x*0.1+tmpY), new Vector2(expanse.x*0.9,16), table.text[r][0], true);
        ArrayList<UI_Checkbox> tmpSounds = new ArrayList<UI_Checkbox>();
        
        int tmpa = 0; //counts how many sounds there are in the category
        int tmpp = -1; //position on the x axis
        for(int c = 1; c<table.text[r].length; c++){
          
          if(table.selectable[r][c] && table.active[r][c]){ //Test if the sound is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05 +tmpp*expanse.x*0.3,position.y+expanse.x*0.1+tmpY), new Vector2(expanse.x*0.25,24), split(table.text[r][c],'\n')[0], true) );
          }
          
          if(r+1 < table.text.length && table.selectable[r+1][c] && table.active[r+1][c]){ //Test if the sound in the next row is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05 +tmpp*expanse.x*0.3,position.y+expanse.x*0.1+tmpY), new Vector2(expanse.x*0.25,24), split(table.text[r+1][c],'\n')[0], true) );
          }
        }
        
        if(tmpa > 0){
          soundtypes.add( tmpSoundType );
          sounds.add( tmpSounds );
          tmpY += 34;
        }
      }
      
    }else{
      
      for(int r = 1; r<table.text.length; r++){
        UI_Checkbox tmpSoundType = new UI_Checkbox( new Vector2(position.x+expanse.x*0.05,position.y+expanse.x*0.1+tmpY), new Vector2(expanse.x*0.9,16), table.text[r][0], true);
        ArrayList<UI_Checkbox> tmpSounds = new ArrayList<UI_Checkbox>();
        
        int tmpa = 0; //counts how many sounds there are in the category
        int tmpp = -1; //position on the x axis
        for(int c = 1; c<table.text[r].length; c++){
          
          if(table.selectable[r][c] && table.active[r][c]){ //Test if the sound is selectable and active
            tmpa++;
            
            tmpY += tmpp == 0? 0: tmpp == 2? 28 : tmpp == -1? 20 : 0;
            tmpp = tmpp == 2? 0:tmpp+1;
            tmpSounds.add( new UI_Checkbox( new Vector2(position.x+expanse.x*0.05 +tmpp*expanse.x*0.3,position.y+expanse.x*0.1+tmpY), new Vector2(expanse.x*0.25,24), split(table.text[r][c],'\n')[0], true) );
          }
        }
        
        if(tmpa > 0){
          soundtypes.add( tmpSoundType );
          sounds.add( tmpSounds );
          tmpY += 34;
        }
      }
    }
  }
  
  public void draw(){
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).draw();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).draw();
        }
      }
    }
  }
  
  public void show(){
    fill(ColorCode.guiBackground);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).show();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).show();
        }
      }
    }
  }
  
  public void onMouseDown(){
    for(int i = 0; i< soundtypes.size(); i++){
      soundtypes.get(i).onMouseDown();
      if(soundtypes.get(i).state){
        for(int s = 0; s<sounds.get(i).size(); s++){
          sounds.get(i).get(s).onMouseDown();
        }
      }
    }
    
    //ButtonFunctions
    for(int i = 0; i < soundtypes.size(); i++){
      if(soundtypes.get(i).getTrigger()){
        if(soundtypes.get(i).state){ //EXPAND
          float shift = 28 * (floor((sounds.get(i).size()-1) / 3.0)+1);
          for( int s = i+1; s < soundtypes.size(); s++){
            soundtypes.get(s).position.y += shift;
            
            for( int o = 0; o < sounds.get(s).size(); o++){
              sounds.get(s).get(o).position.y += shift;
            }
          }
        }else{ //RESTRICT
          float shift = 28 * (floor((sounds.get(i).size()-1) / 3.0)+1);
          for( int s = i+1; s < soundtypes.size(); s++){
            soundtypes.get(s).position.y -= shift;
            
            for( int o = 0; o < sounds.get(s).size(); o++){
              sounds.get(s).get(o).position.y -= shift;
            }
          }
        }
      }
    }
  }
  
  public String toText(){
    boolean all = true;
    String minus = "";
    String only = "";
    for(int i = 0; i < soundtypes.size() ; i++){
      if(soundtypes.get(i).state){
        for(int s = 0; s < sounds.get(i).size() ; s++){
          if(sounds.get(i).get(s).state){
            only += sounds.get(i).get(s).text +", ";
          }else{
            all = false;
          }
        }
      }else{
        minus += soundtypes.get(i).text+", ";
        all = false;
      }
    }
    
    if(all){
      return "All valid sounds";
    }else{
      return (minus == ""? "" : "No "+trim(minus)+" Sounds " )+(only==""?"" : "only "+only);
    }
  }
}




//Integer Field
public class UI_IntegerField extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public UI_Text text;
  public UI_Text number;
  public UI_Button add;
  public UI_Button subtract;
  
  public int value, min, max;
  public boolean changed = false;
  
  public UI_IntegerField(Vector2 pos, Vector2 exp, String txt, int v, int mi, int ma){
    position = pos;
    expanse = exp;
    
    text = new UI_Text(new Vector2(position.x,position.y), new Vector2(expanse.x *0.65,expanse.y),txt);
    number = new UI_Text(new Vector2(position.x+expanse.x*0.75,position.y+expanse.y*0.08), new Vector2(expanse.x *0.15,expanse.y*0.86),v+"");
    subtract = new UI_Button(new Vector2(position.x+expanse.x*0.69,position.y+expanse.y*0.05), new Vector2(expanse.x *0.06,expanse.y*0.9),"-",true);
    add = new UI_Button(new Vector2(position.x+expanse.x*0.9,position.y+expanse.y*0.05), new Vector2(expanse.x *0.06,expanse.y*0.9),"+",true);
    
    value = v;
    max = ma;
    min = mi;
  }
  
  public void draw(){
    text.draw();
    number.draw();
    add.draw();
    subtract.draw();
  }
  
  public void show(){
    text.show();
    number.show();
    add.show();
    subtract.show();
  }
  
  public void onMouseDown(){
    text.onMouseDown();
    number.onMouseDown();
    add.onMouseDown();
    subtract.onMouseDown();
    
    //Button Function
    if(add.getTrigger()){
      changed = true;
      value++;
      if(value >= max){ add.active = false; }
      subtract.active = true;
      number.text = value+"";
    }
    if(subtract.getTrigger()){
      changed = true;
      value--;
      if(value <= min){ subtract.active = false; }
      add.active = true;
      number.text = value+"";
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}


//Table
public class UI_Table extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int rows, columns;
  
  public String[][] text = new String[0][0];
  public boolean[][] selectable = new boolean[0][0];
  
  public Vector2 boxExpanse;
  
  //public UI_Table(Vector2 pos, Vector2 exp, String file){ }//unused atm
  
  public UI_Table(Vector2 pos, Vector2 exp, UI_SelectionTable table){ //filters a selectiontable
    position = pos;
    expanse = exp;
    
    applyTable(table);
  }
  
  public void applyTable(UI_SelectionTable table){
      
    IntList rowlist = new IntList();
    IntList columnlist = new IntList();
    
    for(int r = 1; r < table.rows; r++){
      boolean test = false; //checks if anything in the row is selected
      for(int c = 1; c < table.columns; c++){
        if(table.active[r][c]){
          test = true;
        }
      }
      if(test){
        rowlist.append(r);
      }
    }
    rows = rowlist.size()+1;
    
    for(int c = 1; c < table.columns; c++){
      boolean test = false; //checks if anything in the row is selected
      for(int r = 1; r < table.rows; r++){
        if(table.active[r][c]){
          test = true;
        }
      }
      if(test){
        columnlist.append(c);
      }
    }
    columns = columnlist.size()+1;
    
    text = new String[rows][columns];
    selectable = new boolean[rows][columns];
    
    for(int r = 0; r < rows-1; r++){
      for(int c = 0; c < columns-1; c++){
        text[r+1][c+1] = table.text[rowlist.get(r)][columnlist.get(c)];
        selectable[r+1][c+1] = table.selectable[rowlist.get(r)][columnlist.get(c)];
      }
    }
    
    text[0][0] = table.text[0][0];
    for(int i = 0; i < columns-1; i++){
      text[0][i+1] = table.text[0][columnlist.get(i)];
    }
    for(int i = 0; i < rows-1; i++){
      text[i+1][0] = table.text[rowlist.get(i)][0];
    }
      
    boxExpanse = new Vector2(expanse.x / float(columns), expanse.y / float(rows));
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
          fill(ColorCode.guiHighlight);
        }else{
          fill(ColorCode.guiInactive);
        }
        rect(position.x + c*boxExpanse.x, position.y + r*boxExpanse.y, boxExpanse.x, boxExpanse.y);
        fill(ColorCode.black);
        text(text[r][c], position.x + c*boxExpanse.x + boxExpanse.x*0.1, position.y + r*boxExpanse.y + 16);
      }
    }
  }
}
