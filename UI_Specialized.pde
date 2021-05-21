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
  
  public void loadStatesFromDataFile(StringList ls){
    for(int r = 1; r<rows; r++){
      for(int c = 1; c<columns; c++){
        active[r][c] = ls.hasValue( split(text[r][c],'\n')[0] );
      }
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
  
  public void loadStatesFromDataFile(UI_SelectionTable ct, UI_SelectionTable vt){
    onsetAmount = languageData.onsetAmount;
    doubleNucleus = languageData.nucleusAmount > 1;
    codaAmount = languageData.codaAmount;
    
    onsetDetails = new ArrayList<UI_SyllablePartEditor>();
    nucleusDetails = new ArrayList<UI_SyllablePartEditor>();
    codaDetails = new ArrayList<UI_SyllablePartEditor>();
    for(int i = 0; i<onsetAmount; i++){ 
      onsetDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5-expanse.y*0.9 -(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, ct) ); }
    nucleusDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5-expanse.y*0.45,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), true, vt) );
    for(int i = 0; i<codaAmount; i++){
      codaDetails.add( new UI_SyllablePartEditor(new Vector2(position.x+expanse.x*0.5 +(1+i)*expanse.y,position.y+expanse.y), new Vector2(expanse.y*0.9,downSpace), false, ct) ); }
    
    for(int i = 0 ; i < onsetAmount ; i++){
      onsetDetails.get(i).loadStatesFromDataFile( languageData.onsetOptions[i] );
    }
    for(int i = 0 ; i < languageData.nucleusAmount ; i++){
      nucleusDetails.get(i).loadStatesFromDataFile( languageData.nucleusOptions[i] );
    }
    for(int i = 0 ; i < codaAmount ; i++){
      codaDetails.get(i).loadStatesFromDataFile( languageData.codaOptions[i] );
    }
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
  
  public void loadStatesFromDataFile(StringList ls){
    for(int i = 0; i<sounds.size(); i++){
      for(int o = 0; o<sounds.get(i).size(); o++){
        sounds.get(i).get(o).state = ls.hasValue( sounds.get(i).get(o).text );
      }
    }
    for(int i = 0; i<soundtypes.size(); i++){
      soundtypes.get(i).state = false;
      for(int o = 0; o<sounds.get(i).size(); o++){
        if(sounds.get(i).get(o).state){
          soundtypes.get(i).state = true;
          break;
        }
      }
    }
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
  
  public StringList toList(){
    StringList tmp = new StringList();
    
    for(int i = 0; i < soundtypes.size() ; i++){
      if(soundtypes.get(i).state){
        for(int s = 0; s < sounds.get(i).size() ; s++){
          if(sounds.get(i).get(s).state){
            tmp.append(sounds.get(i).get(s).text);
          }
        }
      }
    }
    return tmp;
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
        selectable[r+1][c+1] = table.active[rowlist.get(r)][columnlist.get(c)];
        if(selectable[r+1][c+1]){
          text[r+1][c+1] = table.text[rowlist.get(r)][columnlist.get(c)];
        }else{
          text[r+1][c+1] = "";
        }
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
  
  public StringList toList(){
    StringList tmp = new StringList();
    
    for(int r = 1; r < rows; r++){
      for(int c = 1; c < columns; c++){
        if(selectable[r][c]){
          tmp.append(split(text[r][c],'\n')[0]);
        }
      }
    }
    
    return tmp;
  }
}



//InputKeyboard
public class UI_InputKeyboard extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public int hovering = -4; //-1 to -3 is back space and enter
  
  public UI_Button backBtn;
  public UI_Button spaceBtn;
  public UI_Button enterBtn;
  public ArrayList<UI_Button> soundBtn;
  
  public String output = "";
  public boolean changed = false;
  public boolean isEnter = false;
  public boolean isBack = false;
  
  public UI_InputKeyboard(Vector2 pos, Vector2 exp, UI_Table t){ 
    position = pos;
    expanse = exp;
    
    hovering = -4;
    
    backBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.05),new Vector2(expanse.x*0.09,expanse.y*0.25)," Delete",true);
    spaceBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.35),new Vector2(expanse.x*0.09,expanse.y*0.25)," Space",true);
    enterBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.65),new Vector2(expanse.x*0.09,expanse.y*0.25)," Enter",true);
    soundBtn = new ArrayList<UI_Button>();
    
    importSounds(t.toList());
  }
  
  public UI_InputKeyboard(Vector2 pos, Vector2 exp, UI_Table t1, UI_Table t2){ 
    position = pos;
    expanse = exp;
    
    hovering = -4;
    
    backBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.05),new Vector2(expanse.x*0.09,expanse.y*0.25)," Delete",true);
    spaceBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.35),new Vector2(expanse.x*0.09,expanse.y*0.25)," Space",true);
    enterBtn = new UI_Button(new Vector2(position.x+expanse.x*0.01,position.y+expanse.y*0.65),new Vector2(expanse.x*0.09,expanse.y*0.25)," Enter",true);
    soundBtn = new ArrayList<UI_Button>();
    
    importSounds(t1.toList());
    importSounds(t2.toList());
  }
  
  public void importSounds(StringList ls){
    for(int i = 0; i < ls.size() ; i++){
      soundBtn.add(new UI_Button(new Vector2(position.x+expanse.x* (0.12+ (soundBtn.size()%25)*0.035),position.y+expanse.y* (0.05 +floor(soundBtn.size()/25.0)*0.22))
          ,new Vector2(expanse.x*0.032,expanse.y*0.18), split(ls.get(i),'\n')[0] ,true) );
    }
  }
  
  public void draw(){
    if(mouseY > position.y && mouseY < position.y+expanse.y){
      if(mouseX > position.x+expanse.x*0.01 && mouseX < position.x+expanse.x*0.11){ //Back Space and Enter
        //Buttons
        backBtn.draw();
        enterBtn.draw();
        spaceBtn.draw();
        
        if(backBtn.hovered){ hovering = -1; }
        if(enterBtn.hovered){ hovering = -2; }
        if(spaceBtn.hovered){ hovering = -3; }
      
      }else if(mouseX > position.x+expanse.x*0.13 && mouseX < position.x+expanse.x){//Sound Buttons
      
        //Buttons
        for(int i = 0; i<soundBtn.size();i++){
          soundBtn.get(i).draw();
          
          if(soundBtn.get(i).hovered){ hovering = i; }
        }
      }
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
    line(position.x+expanse.x*0.11,position.y+expanse.y*0.03,position.x+expanse.x*0.11,position.y+expanse.y*0.97);
    
    //Buttons
    backBtn.show();
    enterBtn.show();
    spaceBtn.show();
    for(int i = 0; i<soundBtn.size();i++){
      soundBtn.get(i).show();
    }
  }
  
  public void onMouseDown(){
    //Buttons
    if(hovering == -1){
      backBtn.onMouseDown();
    }else if(hovering == -2){
      enterBtn.onMouseDown();
    }else if(hovering == -3){
      spaceBtn.onMouseDown();
    }else if(hovering >= 0){
      soundBtn.get(hovering).onMouseDown();
    }
    
    //Btn Functions
    if(backBtn.getTrigger()){
      isBack = true;
      changed = true;
    }
    if(enterBtn.getTrigger()){
      isEnter = true;
      changed = true;
    }
    if(spaceBtn.getTrigger()){
      output = " ";
      changed = true;
    }    
    if(hovering >= 0){
      
      if(soundBtn.get(hovering).getTrigger()){
        output = soundBtn.get(hovering).text;
        changed = true;
      }
    }
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
  
  public String getOutput(){
    String tmp = output;
    reset();
    return tmp;
  }
  
  public void reset(){
    output = "";
    isEnter = false;
    isBack = false;
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
  public UI_Button deleteButton;
  
  public boolean changed = false; //for adding and removing words
  public WordTranslation word = null;
  
  public UI_WordEditor(Vector2 pos, Vector2 exp, UI_InputKeyboard k){ 
    position = pos;
    expanse = exp;
    
    wordInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.02,position.y+expanse.y*0.02), new Vector2(expanse.x*0.7,expanse.y*0.1),"Word",k,false);
    randomButton = new UI_Button(new Vector2(pos.x+expanse.x*0.74,position.y+expanse.y*0.03), new Vector2(expanse.x*0.24,expanse.y*0.08)," Random",true);
    wordTypeSelection = new UI_SwitchcaseButton(new Vector2(pos.x+expanse.x*0.02,position.y+expanse.y*0.15), new Vector2(expanse.x*0.35,expanse.y*0.82));
    translationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.16), new Vector2(expanse.x*0.2,expanse.y*0.06), "Translation:");;
    translationInput = new UI_TextInputField(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.22), new Vector2(expanse.x*0.6,expanse.y*0.1), "Translation",true);
    rootwordText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.34), new Vector2(expanse.x*0.6,expanse.y*0.08), "Root: [None]");
    pronounciationText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.44), new Vector2(expanse.x*0.6,expanse.y*0.2), "Pronounciation:\n\n");
    syllableAnalysisText = new UI_Text(new Vector2(pos.x+expanse.x*0.38,position.y+expanse.y*0.66), new Vector2(expanse.x*0.6,expanse.y*0.16),"Syllable Analysis:\n");
    confirmButton = new UI_Button(new Vector2(pos.x+expanse.x*0.4,position.y+expanse.y*0.87), new Vector2(expanse.x*0.28,expanse.y*0.1)," Confirm",true);
    deleteButton = new UI_Button(new Vector2(pos.x+expanse.x*0.7,position.y+expanse.y*0.87), new Vector2(expanse.x*0.28,expanse.y*0.1)," Delete",true);
    
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.2), new Vector2(expanse.x*0.31,expanse.y*0.08),"Noun",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.3), new Vector2(expanse.x*0.31,expanse.y*0.08),"Verb",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.4), new Vector2(expanse.x*0.31,expanse.y*0.08),"Adjective",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.5), new Vector2(expanse.x*0.31,expanse.y*0.08),"Personal Pronoun",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.6), new Vector2(expanse.x*0.31,expanse.y*0.08),"Conjunction",true) );
    wordTypeSelection.addButton( new UI_Button(new Vector2(pos.x+expanse.x*0.04,position.y+expanse.y*0.7), new Vector2(expanse.x*0.31,expanse.y*0.08),"Other",true) );
  }
  
  public void setWord( WordTranslation wt){
    word = wt;
    
    wordInput.text = word.word;
    wordTypeSelection.selected = word.wordtype == -1?6:word.wordtype;
    translationInput.text = word.translation;
    rootwordText.text = "Root: [None]";
    pronounciationText.text = " Pronounciation:\n  "+word.word+"\n  "+languageData.convertToSimplifiedPronounciation(word.word);
    syllableAnalysisText.text = " Syllable Analysis:\n  "+languageData.subdivideWordToSyllables(word.word);
    
    uiRefreshed = true;
  }
  
  public void draw(){
    wordInput.draw();
    randomButton.draw();
    wordTypeSelection.draw();
    translationInput.draw();
    confirmButton.draw();
    deleteButton.draw();
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
    deleteButton.show();
  }
  
  public void onMouseDown(){
    wordInput.onMouseDown();
    randomButton.onMouseDown();
    wordTypeSelection.onMouseDown();
    translationInput.onMouseDown();
    confirmButton.onMouseDown();
    deleteButton.onMouseDown();
    
    //ButtonFunctions
    if(randomButton.getTrigger()){
      println("Generate random word");
      wordInput.text = languageData.generateRandomWord();
      wordInput.changed = true;
    }
    if(confirmButton.getTrigger()){
      if(word == null){
        //NOTHING
      }else{
        println("Updated Word");
        word.update( wordInput.text, translationInput.text, wordTypeSelection.selected );
        changed = true;
      }
    }
    if(deleteButton.getTrigger()){
      if(word == null){
        reset();
      }else{
        println("Removed Word");
        languageData.wordlist.remove( word );
        reset();
        changed = true;
      }
    }
    if(wordInput.getTrigger()){ // word updated (DUPLICATE! (onMouseDown & onKeyDown))
      println("Word updated");
      pronounciationText.text = " Pronounciation:\n  "+wordInput.text+"\n  "+languageData.convertToSimplifiedPronounciation(wordInput.text);
      syllableAnalysisText.text = " Syllable Analysis:\n  "+languageData.subdivideWordToSyllables(wordInput.text);
    }
  }
  
  public void reset(){
    wordInput.text = "Word";
    wordTypeSelection.selected = -1;
    translationInput.text = "Translation";
    rootwordText.text = "Root: [None]";
    pronounciationText.text = "Pronounciation:\n\n";
    syllableAnalysisText.text = "Syllable Analysis:\n";
    word = null;
  }
  
  public void onKeyDown(){
    translationInput.onKeyDown();
    wordInput.onKeyDown();
    
    if(wordInput.getTrigger()){ // word updated (DUPLICATE! (onMouseDown & onKeyDown))
      println("Word updated");
      pronounciationText.text = " Pronounciation:\n  "+wordInput.text+"\n  "+languageData.convertToSimplifiedPronounciation(wordInput.text);
      syllableAnalysisText.text = " Syllable Analyis:\n  "+languageData.subdivideWordToSyllables(wordInput.text);
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
