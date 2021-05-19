













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
      hovering = int((mouseX - position.x) / 120f);
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
        rect(position.x+120*i,position.y,120,25);
      }else{
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiLayerInactive);
        }
        rect(position.x+120*i+2,position.y+2,120-4,25-2);
      }
      fill(ColorCode.black);
      textSize(13);
      text(layers.get(i).name,position.x+120*i+2,position.y+4,120-3,25-2);
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
    fill(ColorCode.guiTextBox);
    stroke(0);
    rect(position.x, position.y, expanse.x, expanse.y);
    fill(textColor);
    textSize(textSize);
    //text(text,position.x+1, position.y-4+expanse.y);
    text(text,position.x+1, position.y+0.5+textSize);
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


//Multi Text
public class UI_MultiText extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public ArrayList<String> names;
  public ArrayList<String> texts;
  public float textSize;
  public color textColor;
  
  public int activeLayer = 0;
  public int hovering = -1;
  
  public UI_MultiText(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    textColor = ColorCode.guiText;
    textSize = 16;
    
    names = new ArrayList<String>();
    texts = new ArrayList<String>();
  }
  
  public void addPage(String n, String t){
    names.add(n);
    texts.add(t);
  }
  
  public void draw(){
    int old = hovering;
    if(mouseY > position.y && mouseY < position.y+25 && mouseX > position.x){
      hovering = int((mouseX - position.x) / 100f);
      if(hovering >= texts.size()){ hovering = -1; }
    }else{
      hovering = -1;
    }
    if(hovering != old) { uiRefreshed = true; }
  }
  
  public void show(){ 
    
    //Show Background
    stroke(0);
    fill(ColorCode.guiTextBox);
    rect(position.x,position.y+25,expanse.x,expanse.y-25);
    
    //Show Selection
    for(int i = 0; i<texts.size(); i++){
      if(i == activeLayer){
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiTextBox);
        }
        rect(position.x+100*i,position.y,100,25);
      }else{
        if(i == hovering) { 
          fill(ColorCode.guiLayerHovered);
        }else{
          fill(ColorCode.guiInactiveTextBox);
        }
        rect(position.x+100*i+2,position.y+2,100-4,25-2);
      }
      fill(ColorCode.black);
      textSize(13);
      text(names.get(i),position.x+100*i+2,position.y+16);
    }
    
    //Render Layer
    textSize(textSize);
    if(texts.size() > 0){
      text(texts.get(activeLayer),position.x+4,position.y+29+textSize);
    }
  }
  
  public void onMouseDown(){
    if(hovering != -1){ activeLayer = hovering; hovering = -1; }
  }
}


//Text Input Field
public class UI_TextInputField extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public String text;
  public String tmpText;
  
  public boolean active;
  public boolean hovering;
  public boolean changed;
  
  public boolean hasKeyboard = false;
  public boolean hideInactiveKeyboard = true;
  public UI_InputKeyboard keyboard;
  
  public boolean allowSpaces = true;
  
  public UI_TextInputField(Vector2 pos, Vector2 exp, String t, UI_InputKeyboard k, boolean as){ 
    position = pos;
    expanse = exp;
    
    text = t;
    tmpText = "";
    
    active = false;
    hovering = false;
    changed = false;
    
    hasKeyboard = true;
    keyboard = k;
    
    allowSpaces = as;
    if(!as && hasKeyboard){
      k.spaceBtn.active = false;
    }
  }
  
  public UI_TextInputField(Vector2 pos, Vector2 exp, String t, boolean as){ 
    position = pos;
    expanse = exp;
    
    text = t;
    tmpText = "";
    
    active = false;
    hovering = false;
    changed = false;
    
    hasKeyboard = false;
    
    allowSpaces = as;
  }
  
  
  public void draw(){
    hovering = mouseX > position.x && mouseY > position.y && mouseX < position.x+expanse.x && mouseY < position.y+expanse.y;
    
    //keyboard
    if(hasKeyboard){
      keyboard.draw();
    }
  }
  
  public void show(){
    //Show textbox
    if(active){
      fill(ColorCode.guiTriggered);
    }else{
      fill(ColorCode.guiTextBackground);
    }
    stroke(ColorCode.guiBorder);
    rect(position.x, position.y, expanse.x, expanse.y);
    
    //show Text
    fill(ColorCode.guiText);
    textSize(expanse.y*0.8);
    if(active){
      text(tmpText,position.x+1, position.y+expanse.y*0.7);
    }else{
      text(text,position.x+1, position.y+expanse.y*0.7);
    }
    
    //keyboard
    if(hasKeyboard && (!hideInactiveKeyboard || active)){
      keyboard.show();
    }
  }
  
  public void onMouseDown(){
    //keyboard
    if(hasKeyboard && (!hideInactiveKeyboard || active)){
      keyboard.onMouseDown();
    }
    
    //Inputfield
    if(active){
      if(hovering){
        tmpText = text;
        uiRefreshed = true;
      }else if(hasKeyboard && keyboard.hovering > -4){
        addKeyboardLetter();
      }else{
        active = false;
        tmpText = "";
        uiRefreshed = true;
      }
    }else{
      if(hovering){ active = true;  uiRefreshed = true; }
      uiRefreshed = true;
    }
  }
  
  public void onKeyDown(){
    if(active){
      if(key != CODED && key != BACKSPACE){
        if(allowSpaces || key != ' '){
          tmpText += key;
          uiRefreshed = true;
        }
      }
      if(key == ENTER || key == RETURN){
        updateText();
        uiRefreshed = true;
      }
      if(key == BACKSPACE){
        if(tmpText.toCharArray().length > 0){
          tmpText = new String(shorten(tmpText.toCharArray()));
        }else{
          tmpText = "";
        }
        uiRefreshed = true;
      }
    }
  }
  
  public void addKeyboardLetter(){
    if(keyboard.getTrigger()){
      if(keyboard.isEnter){
        updateText();
        uiRefreshed = true;
        keyboard.reset();
        
      }else if(keyboard.isBack){
        if(tmpText.toCharArray().length > 0){
          tmpText = new String(shorten(tmpText.toCharArray()));
        }else{
          tmpText = "";
        }
        uiRefreshed = true;
        keyboard.reset();
        
      }else{
        if(allowSpaces || !keyboard.output.equals(" ")){
          tmpText += keyboard.getOutput();
          keyboard.reset();
          uiRefreshed = true;
        }
      }
    }
  }
  
  public void updateText(){
    active = false;
    text = trim(tmpText);
    tmpText = "";
    changed = true;
    
    uiRefreshed = true;
  }
  
  public boolean getTrigger(){
    if(changed){
      changed = false;
      return true;
    }
    return false;
  }
}



//Panel with multiple Buttons of which 1 (or 0?) can be selected (basically multiple choice)
public class UI_SwitchcaseButton extends UIObject{
  public Vector2 position;
  public Vector2 expanse;
  
  public ArrayList<UI_Button> buttons;
  public int selected = -1;
  public boolean changed = false;
  
  public UI_SwitchcaseButton(Vector2 pos, Vector2 exp){ 
    position = pos;
    expanse = exp;
    
    buttons = new ArrayList<UI_Button>();
    selected = -1;
  }
  
  public void addButton(UI_Button btn){
    buttons.add(btn);
  }
  
  public void draw(){
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).draw();
    }
  }
  
  public void show(){
    stroke(0);
    fill(ColorCode.guiTextBackground);
    rect(position.x,position.y,expanse.x,expanse.y);
    
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).show();
    }
    
    if(selected >= 0 && selected < buttons.size()){
      strokeWeight(5);
      stroke(ColorCode.red);
      UI_Button tmp = buttons.get(selected);
      line(tmp.position.x,tmp.position.y,tmp.position.x+tmp.expanse.x,tmp.position.y);
      line(tmp.position.x,tmp.position.y,tmp.position.x,tmp.position.y+tmp.expanse.y);
      line(tmp.position.x+tmp.expanse.x,tmp.position.y,tmp.position.x+tmp.expanse.x,tmp.position.y+tmp.expanse.y);
      line(tmp.position.x,tmp.position.y+tmp.expanse.y,tmp.position.x+tmp.expanse.x,tmp.position.y+tmp.expanse.y);
      strokeWeight(1);
    }
  }
  
  public void onMouseDown(){
    int old = selected;
    for(int i = 0; i<buttons.size(); i++){
      buttons.get(i).onMouseDown();
      
      if(buttons.get(i).getTrigger()){
        if(i != selected){
          selected = i;
        }else{selected = -1;}
      }
    }
    if(old != selected){ changed = true; }
  }
  
  public String getSelected(){
    if(selected >= 0 && selected < buttons.size()){
      return buttons.get(selected).text;
    }else{
      return "";
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
