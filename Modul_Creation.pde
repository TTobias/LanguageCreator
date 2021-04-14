public class CreationScene extends Scene{
  
  public CreationScene(){
    super("Creation");
    constructGui();
    onInstanciate();
  }
  
  public UI_Button backButton;
  public UI_LayerSwitch mainLayerSwitch;
  
  //Layer0 - DATA
  public UI_Layer layer0_data;
    public UI_Text dataFileName; //Has to be replaced by a textfield later
    public UI_Button saveDataButton; 
    public UI_Button loadDataButton; 
  
  //Layer1 - PHONOLOGY
  public UI_Layer layer1_phonology;
  public UI_LayerSwitch layer1Switch;
  
  public UI_Layer layer1a_inventory;
    public UI_SelectionTable selectPhonologyConsonantTable;
    public UI_SelectionTable selectPhonologyVowelTable;
    public UI_Button bakePhoneticInventoryButton;
    public UI_Text phoneticInventoryInstructionText;
  public UI_Layer layer1b_phonotactics;
    public UI_SyllableShapeEditor syllableShapeEditor;
    public UI_Button bakeSyllableShapeButton;
    public UI_Text syllableShapeInstructionText;
  public UI_Layer layer1c_exceptions;
    public UI_Text phoneticExceptionText;
  public UI_Layer layer1d_stressing;
    public UI_IntegerField primaryStressingPositionField;
    public UI_Text syllableStressingInstructionText;
    public UI_Button confirmSyllableStressButton;
  public UI_Layer layer1e_result;
    public UI_Table resultPhonologyConsonantTable;
    public UI_Table resultPhonologyVowelTable;
    public UI_Text resultSyllableStructureText;
    public UI_Text resultPhonotacticalRulesText;
    public UI_Text resultPhonotacticalStressingText;
    public UI_Button confirmPhoneticResultsButton;
  
  //Layer2 - DUMMY
  public UI_Layer layer2_dummy;
  
  //Layer3 - DUMMY
  public UI_Layer layer3_dummy;
  
  public void constructGui(){
    layer0_data = new UI_Layer( "0: Data" );
    
    layer1_phonology = new UI_Layer( "1: Phonology" );
    
      layer1a_inventory = new UI_Layer( "1a: Inventory" );
        selectPhonologyConsonantTable = new UI_SoundSelectionTable(new Vector2(15,75),new Vector2(1180,460), "data/phonetic_consonant_table.txt");
        selectPhonologyVowelTable = new UI_SoundSelectionTable(new Vector2(15,545),new Vector2(470,340), "data/phonetic_vowel_table.txt");
        phoneticInventoryInstructionText = new UI_Text(new Vector2(500,555),new Vector2(700,260), "Select a few of these symbols: sounds usually appear in sequences."+
        "\nVoiced version usually imply their voiceless equivalents.\n At least 1 nasal and 1 liquid sound.\nChoose at least 2 vowels and up to 20 consonants, the less the better.\n"+
        "Very Common: p,t,l,m,n,s,h,j,w    Rare: θ,ð,q,tɬ.\nWhen you are finished, press 'Bake Table'\n");
        bakePhoneticInventoryButton = new UI_Button(new Vector2(800,height-55),new Vector2(200,40), "Bake Table", true);
        
        layer1a_inventory.addObject(selectPhonologyConsonantTable);
        layer1a_inventory.addObject(selectPhonologyVowelTable);
        layer1a_inventory.addObject(phoneticInventoryInstructionText);
        layer1a_inventory.addObject(bakePhoneticInventoryButton);
    
      layer1b_phonotactics = new UI_Layer( "1b: Phonotactics" );
        syllableShapeEditor = new UI_SyllableShapeEditor(new Vector2(15,75), new Vector2(width-30,100),600,selectPhonologyConsonantTable,selectPhonologyVowelTable);
        bakeSyllableShapeButton = new UI_Button(new Vector2(800,height-95),new Vector2(300,60), "Bake Syllable Structure", true);
        syllableShapeInstructionText = new UI_Text(new Vector2(25,height-115),new Vector2(700,100), "Set up the syllable structure: each Syllable consists of 3 parts: A number of x consonants\n"+
        "(onset) [green], a vowel (nucleus) [blue] and more consonants (coda) [red].\nThe onset consists of up to 4 sounds and the coda up to 5. A lot of languages don't usa a coda at all.\n"+
        "Double vowels or combinations of 2 vowels are possible. All parts but the primary vowel are optional.");
        
        layer1b_phonotactics.addObject(syllableShapeEditor);
        layer1b_phonotactics.addObject(bakeSyllableShapeButton);
        layer1b_phonotactics.addObject(syllableShapeInstructionText);
      
      layer1c_exceptions = new UI_Layer( "1c: Exceptions" );
        phoneticExceptionText = new UI_Text(new Vector2(width*0.5-260,height*0.5-100),new Vector2(500,100), "Placeholder Text.");
        
        layer1c_exceptions.addObject(phoneticExceptionText);
      
      layer1d_stressing = new UI_Layer( "1d: Stressing" );
        primaryStressingPositionField = new UI_IntegerField(new Vector2(15,75), new Vector2(500,40),"Default Stress Position:",1,-5,8);
        syllableStressingInstructionText = new UI_Text(new Vector2(625,75),new Vector2(700,120), "Decide which syllable should be stressed.\n 0 means no stressing at all. \n"+
        "A negative number is counted from the \nend of the word backwards.");
        confirmSyllableStressButton = new UI_Button(new Vector2(825,225),new Vector2(300,30), "Confirm Stressing", true);
        
        layer1d_stressing.addObject(primaryStressingPositionField);
        layer1d_stressing.addObject(syllableStressingInstructionText);
        layer1d_stressing.addObject(confirmSyllableStressButton);
      
      layer1e_result = new UI_Layer( "1e: Result" );
        resultPhonologyConsonantTable = new UI_Table(new Vector2(15,75),new Vector2(730,420),selectPhonologyConsonantTable);
        resultPhonologyVowelTable = new UI_Table(new Vector2(15,505),new Vector2(400,300),selectPhonologyVowelTable);
        resultSyllableStructureText = new UI_Text(new Vector2(750,75),new Vector2(630,750), "Rules: \nNone \n\n\n\n\n\n\n\n\n\n\n");
        resultPhonotacticalRulesText = new UI_Text(new Vector2(430,505),new Vector2(300,100), "Syllable Shape:\n"+"  C V C");
        resultPhonotacticalStressingText = new UI_Text(new Vector2(430,615),new Vector2(300,180), "Stress\n\n\n");
        confirmPhoneticResultsButton = new UI_Button(new Vector2(230,height-80),new Vector2(300,60), "Confirm",true);
        
        layer1e_result.addObject(resultPhonologyConsonantTable);
        layer1e_result.addObject(resultPhonologyVowelTable);
        layer1e_result.addObject(resultSyllableStructureText);
        layer1e_result.addObject(resultPhonotacticalRulesText);
        layer1e_result.addObject(resultPhonotacticalStressingText);
        layer1e_result.addObject(confirmPhoneticResultsButton);
    
      layer1Switch = new UI_LayerSwitch(new Vector2(10,40),new Vector2(width-20,height-50));
      layer1Switch.addLayer(layer1a_inventory);
      layer1Switch.addLayer(layer1b_phonotactics);
      layer1Switch.addLayer(layer1c_exceptions);
      layer1Switch.addLayer(layer1d_stressing);
      layer1Switch.addLayer(layer1e_result);
      layer1_phonology.addObject(layer1Switch);
    
    layer2_dummy = new UI_Layer( "2: Dummy" );
    
    
    layer3_dummy = new UI_Layer( "3: Dummy" );
    
    
    mainLayerSwitch = new UI_LayerSwitch(new Vector2(5,5),new Vector2(width-10,height-10));
    mainLayerSwitch.addLayer(layer0_data);
    mainLayerSwitch.addLayer(layer1_phonology);
    mainLayerSwitch.addLayer(layer2_dummy);
    mainLayerSwitch.addLayer(layer3_dummy);
    addUiElement(mainLayerSwitch);
    
    backButton = new UI_Button( new Vector2(width-215,height-45),new Vector2(200,30),"Back to Menu",true );
    addUiElement(backButton);
  }
  
  public void onInstanciate(){ }
  
  public void btnFunctions(){
    //ALL LAYERS
    if(backButton.getTrigger()){
      println("Debug: Back to Menu pressed");
      sceneManager.switchSceneByName("Startup");
    }
    
    //LAYER 1
    if(bakePhoneticInventoryButton.getTrigger()){
      println("Rebake Inventory");
      syllableShapeEditor.reimport();
      resultPhonologyConsonantTable.applyTable(selectPhonologyConsonantTable);
      resultPhonologyVowelTable.applyTable(selectPhonologyVowelTable);
    }
    if(bakeSyllableShapeButton.getTrigger()){
      println("Rebake Syllable Shape");
      updateSyllableShapeResults();
      //syllableShapeEditor.reimport(); ////////////////////////////////////////
    }
    if(confirmSyllableStressButton.getTrigger()){
      println("Confirm Syllable Stressing");
      updateSyllableStressResults();
      //syllableShapeEditor.reimport(); ////////////////////////////////////////
    }
    if(primaryStressingPositionField.getTrigger()){
      //////////////////////////////////////// /////////////////////////////////
    }
    if(confirmPhoneticResultsButton.getTrigger()){
      println("Confirmed Phonetics");
      //////////////////////////////////////// /////////////////////////////////
    }
  }
  
  
  
  public void updateSyllableShapeResults(){
    String tmpShape = "  "+(syllableShapeEditor.onsetDetails.size()>0? "C"+(syllableShapeEditor.onsetDetails.size()>1?syllableShapeEditor.onsetDetails.size():"") : "") +
         (syllableShapeEditor.nucleusDetails.size()==2? " VV " : " V ") +
         (syllableShapeEditor.codaDetails.size()>0? "C"+(syllableShapeEditor.codaDetails.size()>1?syllableShapeEditor.codaDetails.size():"") : "");
    resultPhonotacticalRulesText.text = "Syllable Shape:\n"+tmpShape;
    
    resultSyllableStructureText.text = "Syllable Rules:\n\n";
    for(int i = 0; i<syllableShapeEditor.onsetDetails.size() ; i++){
      resultSyllableStructureText.text += "oC" + (i+1) + ": "  + syllableShapeEditor.onsetDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.text += "\n";
    for(int i = 0; i<syllableShapeEditor.nucleusDetails.size() ; i++){
      resultSyllableStructureText.text += "nV" + (i==0?"":i) + ": " + syllableShapeEditor.nucleusDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.text += "\n";
    for(int i = 0; i<syllableShapeEditor.codaDetails.size() ; i++){
      resultSyllableStructureText.text += "cC" + (i+1) + ": "  + syllableShapeEditor.codaDetails.get(i).toText() +"\n";
    }
    resultSyllableStructureText.textSize = 14;
  }
  
  public void updateSyllableStressResults(){
    resultPhonotacticalStressingText.text = "Default Word Stressing Position :\n"+primaryStressingPositionField.value+
          "'nd syllable of each word.\n\nIf the word has less syllables:\nThe closest one.";
    resultPhonotacticalStressingText.textSize = 18;
  }
}
