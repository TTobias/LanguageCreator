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
  public UI_Layer layer1e_result;
  
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
        "Very Common: p,t,l,m,n,s,h,j,w    Rare: θ,ð,q,tɬ.\nWhen you are finished, press 'Bake Table'");
        bakePhoneticInventoryButton = new UI_Button(new Vector2(800,height-55),new Vector2(200,40), "Bake Table", true);
        
        layer1a_inventory.addObject(selectPhonologyConsonantTable);
        layer1a_inventory.addObject(selectPhonologyVowelTable);
        layer1a_inventory.addObject(phoneticInventoryInstructionText);
        layer1a_inventory.addObject(bakePhoneticInventoryButton);
    
      layer1b_phonotactics = new UI_Layer( "1b: Phonotactics" );
        syllableShapeEditor = new UI_SyllableShapeEditor(new Vector2(15,75), new Vector2(width-30,100),600,selectPhonologyConsonantTable,selectPhonologyVowelTable);
        bakeSyllableShapeButton = new UI_Button(new Vector2(800,height-65),new Vector2(300,50), "Bake Syllable Structure", true);
        syllableShapeInstructionText = new UI_Text(new Vector2(25,height-115),new Vector2(700,100), "Set up the syllable structure: each Syllable consists of 3 parts: A number of x consonants\n"+
        " (onset) [green], a vowel (nucleus) [blue] and more consonants (coda) [red].\nThe onset consists of up to 4 sounds and the coda up to 5. A lot of languages don't usa a coda at all.\n"+
        "Double vowels or combinations of 2 vowels are possible.");
        
        layer1b_phonotactics.addObject(syllableShapeEditor);
        layer1b_phonotactics.addObject(bakeSyllableShapeButton);
        layer1b_phonotactics.addObject(syllableShapeInstructionText);
      
      layer1c_exceptions = new UI_Layer( "1c: Exceptions" );
        phoneticExceptionText = new UI_Text(new Vector2(width*0.5-200,height*0.5-100),new Vector2(400,150), "Placeholder Text. ");
        
        layer1c_exceptions.addObject(phoneticExceptionText);
      
      layer1d_stressing = new UI_Layer( "1d: Stressing" );
      
      layer1e_result = new UI_Layer( "1e: Result" );
    
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
    if(backButton.getTrigger()){
      println("Debug: Back to Menu pressed");
      sceneManager.switchSceneByName("Startup");
    }
    if(bakePhoneticInventoryButton.getTrigger()){
      println("Rebake Inventory");
      syllableShapeEditor.reimport();
    }
  }
}
