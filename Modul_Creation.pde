public class CreationScene extends Scene{
  
  public CreationScene(){
    super("Creation");
    constructGui();
    onInstanciate();
  }
  
  public UI_Button backButton;
  public UI_LayerSwitch mainLayerSwitch;
  public UI_Text missingLowPriority;
  public UI_Text missingMediumPriority;
  public UI_Text missingHighPriority;
  
  //Layer0 - DATA
  public UI_Layer layer0_data;
    public UI_Text dataFileText;
    public UI_TextInputField dataFileNameInput;
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
  public UI_Layer layer1b_examples;
    ///////////////////////////
  public UI_Layer layer1c_phonotactics;
    public UI_SyllableShapeEditor syllableShapeEditor;
    public UI_Button bakeSyllableShapeButton;
    public UI_Text syllableShapeInstructionText;
  public UI_Layer layer1d_exceptions;
    ///////////////////////////
  public UI_Layer layer1e_stressing;
    public UI_IntegerField primaryStressingPositionField;
    public UI_Text syllableStressingInstructionText;
    public UI_Button confirmSyllableStressButton;
  public UI_Layer layer1f_result;
    public UI_Table resultPhonologyConsonantTable;
    public UI_Table resultPhonologyVowelTable;
    public UI_Text resultSyllableStructureText;
    public UI_Text resultPhonotacticalRulesText;
    public UI_Text resultPhonotacticalStressingText;
    public UI_Button confirmPhoneticResultsButton;
  
  //Layer2 - PROTOLANGUAGE
  public UI_Layer layer2_protolanguage;
  public UI_LayerSwitch layer2Switch;
  
  public UI_Layer layer2a_rootWords;
    public UI_Button addNewRootWordButton;
    public UI_Button appendRootWordButton;
    public UI_MultiText rootWordMultiText;
    public UI_VocabularyList rootWordVocabularyList;
    public UI_WordEditor rootWordEditor;
    public UI_InputKeyboard layer2a_keyboard;
  public UI_Layer layer2b_wordOrder;
    public UI_Text svoWordOrderText;
    public UI_Text apnWordOrderText;
    public UI_Text possessorOrderText;
    public UI_Text adjectiveNounOrderText;
    public UI_Text adpositionNounOrderText;
    public UI_Text adjectiveAdpositionOrderText;
    public UI_SwitchcaseButton svoWordOrderSwitch;
    public UI_SwitchcaseButton apnWordOrderSwitch;
    public UI_SwitchcaseButton possessorOrderSwitch;
    public UI_SwitchcaseButton adjectiveNounOrderSwitch;
    public UI_SwitchcaseButton adpositionNounOrderSwitch;
    public UI_SwitchcaseButton adjectiveAdpositionOrderSwitch;
    public UI_Text wordOrderPreviewText;
    public UI_Text wordOrderInstructionText;
    public UI_Button confirmWordOrderButton;
  public UI_Layer layer2c_quantifiers;
    public UI_QuantifierList quantifierList;
    public UI_Button addQuantifierButton;
    public UI_QuantifierEditor quantifierEditor;
    public UI_Text quantifierInstructionsText;
    public UI_Button confirmQuantifierButton;
    public UI_VocabularyList quantifierReferenceVocabularyList;
    public UI_InputKeyboard layer2c_keyboard;
  public UI_Layer layer2d_tenses;
    public UI_TenseList tenseList;
    public UI_Button addTenseButton;
    public UI_TenseEditor tenseEditor;
    public UI_Text tenseInstructionsText;
    public UI_Button confirmTensesButton;
    public UI_VocabularyList tenseReferenceVocabularyList;
    public UI_InputKeyboard layer2d_keyboard;
  public UI_Layer layer2e_valency;
  public UI_Layer layer2f_testing;
  
  //Layer3 - DUMMY
  public UI_Layer layer3_;
  
  public void constructGui(){
    
        missingLowPriority = new UI_Text(new Vector2(width*0.5-260,height*0.5-100),new Vector2(500,100), "Not implemented yet\nlow priority");
        missingMediumPriority = new UI_Text(new Vector2(width*0.5-260,height*0.5-100),new Vector2(500,100), "Not implemented yet\nmedium priority");
        missingHighPriority = new UI_Text(new Vector2(width*0.5-260,height*0.5-100),new Vector2(500,100), "Not implemented yet\nhigh priority");
    
    
    layer0_data = new UI_Layer( "0: Data" );
      dataFileText = new UI_Text( new Vector2( 30, 50), new Vector2(200,25), " Filename:");
      dataFileNameInput = new UI_TextInputField( new Vector2( 30, 75), new Vector2(300,35), "temp",false);
      saveDataButton = new UI_Button(new Vector2( 80, 120), new Vector2(200,30), " Save to File",true); 
      loadDataButton = new UI_Button(new Vector2( 80, 155), new Vector2(200,30), " Load from File",true); 
        
      layer0_data.addObject(dataFileText);
      layer0_data.addObject(dataFileNameInput);
      layer0_data.addObject(saveDataButton);
      layer0_data.addObject(loadDataButton);
    
    //////////////////////////////////////////////////////////
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
      
      layer1b_examples = new UI_Layer( "1b: Examples" );
        
        layer1b_examples.addObject(missingLowPriority);
    
      layer1c_phonotactics = new UI_Layer( "1c: Phonotactics" );
        syllableShapeEditor = new UI_SyllableShapeEditor(new Vector2(15,75), new Vector2(width-30,100),600,selectPhonologyConsonantTable,selectPhonologyVowelTable);
        bakeSyllableShapeButton = new UI_Button(new Vector2(800,height-95),new Vector2(300,60), "Bake Syllable Structure", true);
        syllableShapeInstructionText = new UI_Text(new Vector2(25,height-115),new Vector2(700,100), "Set up the syllable structure: each Syllable consists of 3 parts: A number of x consonants\n"+
        "(onset) [green], a vowel (nucleus) [blue] and more consonants (coda) [red].\nThe onset consists of up to 4 sounds and the coda up to 5. A lot of languages don't usa a coda at all.\n"+
        "Double vowels or combinations of 2 vowels are possible. All parts but the primary vowel are optional.");
        
        layer1c_phonotactics.addObject(syllableShapeEditor);
        layer1c_phonotactics.addObject(bakeSyllableShapeButton);
        layer1c_phonotactics.addObject(syllableShapeInstructionText);
      
      layer1d_exceptions = new UI_Layer( "1d: Exceptions" );
        
        layer1d_exceptions.addObject(missingLowPriority);
      
      layer1e_stressing = new UI_Layer( "1e: Stressing" );
        primaryStressingPositionField = new UI_IntegerField(new Vector2(15,75), new Vector2(500,40),"Default Stress Position:",1,-5,8);
        syllableStressingInstructionText = new UI_Text(new Vector2(625,75),new Vector2(700,120), "Decide which syllable should be stressed.\n 0 means no stressing at all. \n"+
        "A negative number is counted from the \nend of the word backwards.");
        confirmSyllableStressButton = new UI_Button(new Vector2(825,225),new Vector2(300,30), "Confirm Stressing", true);
        
        layer1e_stressing.addObject(primaryStressingPositionField);
        layer1e_stressing.addObject(syllableStressingInstructionText);
        layer1e_stressing.addObject(confirmSyllableStressButton);
      
      layer1f_result = new UI_Layer( "1f: Result" );
        resultPhonologyConsonantTable = new UI_Table(new Vector2(15,75),new Vector2(730,420),selectPhonologyConsonantTable);
        resultPhonologyVowelTable = new UI_Table(new Vector2(15,505),new Vector2(400,300),selectPhonologyVowelTable);
        resultSyllableStructureText = new UI_Text(new Vector2(750,75),new Vector2(630,750), "Rules: \nNone \n\n\n\n\n\n\n\n\n\n\n");
        resultPhonotacticalRulesText = new UI_Text(new Vector2(430,505),new Vector2(300,100), "Syllable Shape:\n"+"  C V C");
        resultPhonotacticalStressingText = new UI_Text(new Vector2(430,615),new Vector2(300,180), "Stress\n\n\n");
        confirmPhoneticResultsButton = new UI_Button(new Vector2(230,height-80),new Vector2(300,60), "Confirm",true);
        
        layer1f_result.addObject(resultPhonologyConsonantTable);
        layer1f_result.addObject(resultPhonologyVowelTable);
        layer1f_result.addObject(resultSyllableStructureText);
        layer1f_result.addObject(resultPhonotacticalRulesText);
        layer1f_result.addObject(resultPhonotacticalStressingText);
        layer1f_result.addObject(confirmPhoneticResultsButton);
    
      layer1Switch = new UI_LayerSwitch(new Vector2(10,40),new Vector2(width-20,height-50));
      layer1Switch.addLayer(layer1a_inventory);
      layer1Switch.addLayer(layer1b_examples);
      layer1Switch.addLayer(layer1c_phonotactics);
      layer1Switch.addLayer(layer1d_exceptions);
      layer1Switch.addLayer(layer1e_stressing);
      layer1Switch.addLayer(layer1f_result);
      layer1_phonology.addObject(layer1Switch);
    
    //////////////////////////////////////////////////////////
    layer2_protolanguage = new UI_Layer( "2: Protolanguage" );
    
      layer2a_rootWords = new UI_Layer( "2a: Root Words" );
        rootWordMultiText = new UI_MultiText(new Vector2(15,75),new Vector2(700,210));
        rootWordMultiText.addPage( " Instruction", "Instructions not added yet" );
        rootWordMultiText.addPage( " Sound-List", "Sounds not added yet" );
        rootWordMultiText.addPage( " Syllable Data", "Syllable Data not added yet" );
        rootWordMultiText.addPage( " Main Roots", "Important root words not added yet" );
        addNewRootWordButton = new UI_Button(new Vector2(15,305),new Vector2(300,40), "new Word",true);
        appendRootWordButton = new UI_Button(new Vector2(415,305),new Vector2(300,40), "append Word",true);
        layer2a_keyboard = new UI_InputKeyboard(new Vector2(15,740),new Vector2(700,130),resultPhonologyConsonantTable,resultPhonologyVowelTable);
        rootWordVocabularyList = new  UI_VocabularyList(new Vector2(725,75),new Vector2(650,750), layer2a_keyboard);
        rootWordEditor = new UI_WordEditor(new Vector2(15,350),new Vector2(700,380), layer2a_keyboard);
        
        layer2a_rootWords.addObject(addNewRootWordButton);
        layer2a_rootWords.addObject(appendRootWordButton);
        layer2a_rootWords.addObject(rootWordMultiText);
        layer2a_rootWords.addObject(rootWordVocabularyList);
        layer2a_rootWords.addObject(rootWordEditor);
    
      layer2b_wordOrder = new UI_Layer( "2b: Word Order" );
        svoWordOrderText             = new UI_Text( new Vector2(115,75),   new Vector2(300,425),"Sentence Word Order:\nS=Subject, V=Verb, O=Object\n\n\n\n\n\n\n\n\n\n\n\n\n" );
        apnWordOrderText             = new UI_Text( new Vector2(515,75),   new Vector2(300,425),"Noun Word Order:\nA=Adjective, P=Adposition, N=Noun\n\n\n\n\n\n\n\n\n\n\n\n\n" );
        possessorOrderText           = new UI_Text( new Vector2(915,75),  new Vector2(300,200),"Possessor Position:\n\n\n\n\n\n" );
        svoWordOrderSwitch             = new UI_SwitchcaseButton( new Vector2(115,125), new Vector2(300,375) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,150), new Vector2(220,30),"    S V O", true) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,200), new Vector2(220,30),"    S O V", true) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,250), new Vector2(220,30),"    V S O", true) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,300), new Vector2(220,30),"    V O S", true) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,350), new Vector2(220,30),"    O S V", true) );
          svoWordOrderSwitch.addButton( new UI_Button(new Vector2(150,400), new Vector2(220,30),"    O V S", true) );
        apnWordOrderSwitch             = new UI_SwitchcaseButton( new Vector2(515,125), new Vector2(300,375) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,150), new Vector2(220,30),"    A P N", true) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,200), new Vector2(220,30),"    A N P", true) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,250), new Vector2(220,30),"    P A N", true) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,300), new Vector2(220,30),"    P N A", true) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,350), new Vector2(220,30),"    N A P", true) );
          apnWordOrderSwitch.addButton( new UI_Button(new Vector2(550,400), new Vector2(220,30),"    N P A", true) );
        possessorOrderSwitch           = new UI_SwitchcaseButton( new Vector2(915,100), new Vector2(300,175) );
          possessorOrderSwitch.addButton( new UI_Button(new Vector2(950,150), new Vector2(220,30)," Possessor Possesse", true) );
          possessorOrderSwitch.addButton( new UI_Button(new Vector2(950,200), new Vector2(220,30)," Possesse Possessor", true) );
        wordOrderPreviewText     = new UI_Text( new Vector2(25,520), new Vector2(width -50,50)," PREVIEW" );;
        wordOrderInstructionText = new UI_Text( new Vector2(35,600), new Vector2(800,250)," Instructions not added yet\n\n\n\n\n\n\n\n\n" );;
        confirmWordOrderButton = new UI_Button( new Vector2(900,700),new Vector2(300,40)," Confirm Word Order",true );;
        
        layer2b_wordOrder.addObject(svoWordOrderText);
        layer2b_wordOrder.addObject(apnWordOrderText);
        layer2b_wordOrder.addObject(possessorOrderText);
        layer2b_wordOrder.addObject(svoWordOrderSwitch);
        layer2b_wordOrder.addObject(apnWordOrderSwitch);
        layer2b_wordOrder.addObject(possessorOrderSwitch);
        layer2b_wordOrder.addObject(wordOrderPreviewText);
        layer2b_wordOrder.addObject(wordOrderInstructionText);
        layer2b_wordOrder.addObject(confirmWordOrderButton);
      
      layer2c_quantifiers = new UI_Layer( "2c: Quantifiers" );
        layer2c_keyboard = new UI_InputKeyboard(new Vector2(15,715),new Vector2(1000,170),resultPhonologyConsonantTable,resultPhonologyVowelTable);
        quantifierList = new UI_QuantifierList(new Vector2(20,75),new Vector2(300,600));
        addQuantifierButton = new UI_Button(new Vector2(70,680),new Vector2(200,25), " Add Quantifier", true);
        quantifierEditor = new UI_QuantifierEditor(new Vector2(350,75),new Vector2(760,630), layer2c_keyboard);
        quantifierEditor.listReference = quantifierList;
        quantifierInstructionsText = new UI_Text(new Vector2(15,715),new Vector2(1000,170)," Instructions not added yet\n\n\n\n\n");
        confirmQuantifierButton = new UI_Button(new Vector2(1050,740),new Vector2(300,30), " Confirm Quantifiers", true);
        quantifierReferenceVocabularyList = new  UI_VocabularyList(new Vector2(1130,75),new Vector2(250,630), layer2c_keyboard);
        
        layer2c_quantifiers.addObject(quantifierList);
        layer2c_quantifiers.addObject(quantifierInstructionsText);
        layer2c_quantifiers.addObject(addQuantifierButton);
        layer2c_quantifiers.addObject(quantifierEditor);
        layer2c_quantifiers.addObject(confirmQuantifierButton);
        layer2c_quantifiers.addObject(quantifierReferenceVocabularyList);
      
      layer2d_tenses = new UI_Layer( "2d: Tenses" );
        layer2d_keyboard = new UI_InputKeyboard(new Vector2(15,715),new Vector2(1000,170),resultPhonologyConsonantTable,resultPhonologyVowelTable);
        tenseList = new UI_TenseList(new Vector2(20,75),new Vector2(300,600));
        addTenseButton = new UI_Button(new Vector2(70,680),new Vector2(200,25), " Add Tense", true);
        tenseEditor = new UI_TenseEditor(new Vector2(350,75),new Vector2(760,630), layer2c_keyboard);
        tenseEditor.listReference = tenseList;
        tenseInstructionsText = new UI_Text(new Vector2(15,715),new Vector2(1000,170)," Instructions not added yet\n\n\n\n\n");
        confirmTensesButton = new UI_Button(new Vector2(1050,740),new Vector2(300,30), " Confirm Tenses", true);
        tenseReferenceVocabularyList = new  UI_VocabularyList(new Vector2(1130,75),new Vector2(250,630), layer2c_keyboard);
        
        layer2d_tenses.addObject(tenseList);
        layer2d_tenses.addObject(tenseInstructionsText);
        layer2d_tenses.addObject(addTenseButton);
        layer2d_tenses.addObject(tenseEditor);
        layer2d_tenses.addObject(confirmTensesButton);
        layer2d_tenses.addObject(tenseReferenceVocabularyList);
      
      layer2e_valency = new UI_Layer( "2e: Valency" );
        
        layer2e_valency.addObject(missingMediumPriority);
      
      layer2f_testing = new UI_Layer( "2f: Testing" );
        
        layer2f_testing.addObject(missingLowPriority);
    
      layer2Switch = new UI_LayerSwitch(new Vector2(10,40),new Vector2(width-20,height-50));
      layer2Switch.addLayer(layer2a_rootWords);
      layer2Switch.addLayer(layer2b_wordOrder);
      layer2Switch.addLayer(layer2c_quantifiers);
      layer2Switch.addLayer(layer2d_tenses);
      layer2Switch.addLayer(layer2e_valency);
      layer2Switch.addLayer(layer2f_testing);
      layer2_protolanguage.addObject(layer2Switch);
    
    //////////////////////////////////////////////////////////
    layer3_ = new UI_Layer( "3: Dummy" );
        
        layer3_.addObject(missingMediumPriority);
    
    
    mainLayerSwitch = new UI_LayerSwitch(new Vector2(5,5),new Vector2(width-10,height-10));
    mainLayerSwitch.addLayer(layer0_data);
    mainLayerSwitch.addLayer(layer1_phonology);
    mainLayerSwitch.addLayer(layer2_protolanguage);
    mainLayerSwitch.addLayer(layer3_);
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
    
    //LAYER 0
    if(saveDataButton.getTrigger()){
      println("Save Data");
      languageData.projectpath = dataFileNameInput.text;
      languageData.saveToFile();
    }
    if(loadDataButton.getTrigger()){
      println("Load Data");
      languageData.projectpath = dataFileNameInput.text;
      languageData.loadFromFile();
      onDataFileLoad();
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
      confirmPhonetics();
    }
    
    //LAYER2
    if(rootWordEditor.getTrigger()){
      println("Changed the wordlist");
      updateVocabularyLists();
    }
    if(addNewRootWordButton.getTrigger()){
      println("Add new Word");
      rootWordEditor.reset();
    }
    if(appendRootWordButton.getTrigger()){
      println("Append Word to the List");
      rootWordEditor.word = new WordTranslation(rootWordEditor.wordInput.text, rootWordEditor.translationInput.text, rootWordEditor.wordTypeSelection.selected);
      languageData.wordlist.add( rootWordEditor.word );
      updateVocabularyLists();
      rootWordEditor.reset();
    }
    if(rootWordVocabularyList.getTrigger()){
      println("Set Word As \"Active to Edit\"");
      rootWordEditor.setWord( rootWordVocabularyList.selection );
    }
        
    if(svoWordOrderSwitch.getTrigger()){
      println("Updated Word Order");
      recalculateWordOrderText();
    }
    if(apnWordOrderSwitch.getTrigger()){
      println("Updated Word Order");
      recalculateWordOrderText();
    }
    if(possessorOrderSwitch.getTrigger()){
      println("Updated Word Order");
      recalculateWordOrderText();
    }/*
    if(confirmWordOrderButton.getTrigger()){
      println("Comfirmed Word Order");
    }*/
    
    if(addQuantifierButton.getTrigger()){
      println("Added new Quantifier");
      WordModifier tmp = new WordModifier(new SyllableModifier[0], "");
      quantifierList.list.add(tmp);
      quantifierEditor.setQuantifier(tmp);
    }
    if(quantifierList.getTrigger()){
      println("Quantifier List Object Selected");
      quantifierEditor.setQuantifier(quantifierList.selection);
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
  
  public void confirmPhonetics(){
    //Add those infos to the languageData
    languageData.vowels = resultPhonologyVowelTable.toList();
    languageData.consonants = resultPhonologyConsonantTable.toList();
    
    languageData.onsetAmount = syllableShapeEditor.onsetAmount;
    languageData.nucleusAmount = syllableShapeEditor.doubleNucleus?2:1;
    languageData.codaAmount = syllableShapeEditor.codaAmount;
    
    languageData.onsetOptions = new StringList[languageData.onsetAmount];
    languageData.nucleusOptions = new StringList[languageData.nucleusAmount];
    languageData.codaOptions = new StringList[languageData.codaAmount];
    for(int i = 0; i<languageData.onsetAmount; i++)  { languageData.onsetOptions[i]   = syllableShapeEditor.onsetDetails.get(i).toList(); }
    for(int i = 0; i<languageData.nucleusAmount; i++){ languageData.nucleusOptions[i] = syllableShapeEditor.nucleusDetails.get(i).toList(); }
    for(int i = 0; i<languageData.codaAmount; i++)   { languageData.codaOptions[i]    = syllableShapeEditor.codaDetails.get(i).toList();    }
    
    languageData.stressingPosition = primaryStressingPositionField.value;
    
    
    updateKeyboards();
  }
  
  
  public void recalculateWordOrderText(){
    //svoWordOrderSwitch apnWordOrderSwitch possessorOrderSwitch
    
    String subject = "";
    String object = "";
    String undecided = "";
    String out = "";
    
    //APN ANP PAN PNA NAP NPA
    if(apnWordOrderSwitch.selected == 0){
      subject = "(Adjective) (Preposition) SUBJECT";
      object = "(Adjective) (Preposition) OBJECT";
    }else if(apnWordOrderSwitch.selected == 1){
      subject = "(Adjective) SUBJECT (Postposition)";
      object = "(Adjective) OBJECT (Postposition)";
    }else if(apnWordOrderSwitch.selected == 2){
      subject = "(Preposition) SUBJECT (Adjective)";
      object = "(Preposition) OBJECT (Adjective)";
    }else if(apnWordOrderSwitch.selected == 3){
      subject = "(Preposition) (Adjective) SUBJECT";
      object = "(Preposition) (Adjective) OBJECT";
    }else if(apnWordOrderSwitch.selected == 4){
      subject = "SUBJECT (Adjective) (Postposition)";
      object = "OBJECT (Adjective) (Postposition)";
    }else if(apnWordOrderSwitch.selected == 5){
      subject = "SUBJECT (Postposition) (Adjective)";
      object = "Object (Postposition) (Adjective)";
    }else{
      undecided += "Adjective/Adposition/Noun ";
      subject = "SUBJECT";
      object = "OBJECT";
    }
    
    //PossessorPossesse PossessePossessor
    if(possessorOrderSwitch.selected == 0){
      subject = subject +" [Possesse]";
      object = object +" [Possesse]";
    }else if(possessorOrderSwitch.selected == 1){
      subject = "[Possesse] "+subject;
      object = "[Possesse] "+object;
    }else{
      undecided += "Possessor/Possesse ";
    }
    
    //SVO SOV  VSO VOS OSV OVS
    if(svoWordOrderSwitch.selected == 0){
      out = subject+" VERB ( "+object+" )";
    }else if(svoWordOrderSwitch.selected == 1){
      out = subject+" ( "+object+" ) VERB";
    }else if(svoWordOrderSwitch.selected == 2){
      out = "VERB "+subject+" ( "+object+" )";
    }else if(svoWordOrderSwitch.selected == 3){
      out = "VERB ( "+object+" ) "+subject;
    }else if(svoWordOrderSwitch.selected == 4){
      out = "( "+object+" ) "+subject+" VERB";
    }else if(svoWordOrderSwitch.selected == 5){
      out = "( "+object+" ) VERB "+subject;
    }else{
      undecided += "Adjective/Adposition/Noun ";
      subject = "";
      object = "";
    }
    
    if(!undecided.equals("")){
      out = out+" ;Undecided: "+undecided;
    }
    wordOrderPreviewText.text = out;
  }
  
  
  public void updateVocabularyLists(){
      rootWordVocabularyList.reloadWords();
      quantifierReferenceVocabularyList.reloadWords();
  }
  
  
  public void updateKeyboards(){
    layer2a_keyboard.soundBtn = new ArrayList<UI_Button>(); 
    layer2a_keyboard.importSounds(languageData.consonants);
    layer2a_keyboard.importSounds(languageData.vowels);
    
    layer2c_keyboard.soundBtn = new ArrayList<UI_Button>(); 
    layer2c_keyboard.importSounds(languageData.consonants);
    layer2c_keyboard.importSounds(languageData.vowels);
  }
  
  
  
  public void onDataFileLoad(){
    // // // INCOMPLETE: LAYERS ARE NOT UPDATED
    
    selectPhonologyConsonantTable.loadStatesFromDataFile(languageData.consonants);
    selectPhonologyVowelTable.loadStatesFromDataFile(languageData.vowels);
    syllableShapeEditor.reimport();
    resultPhonologyConsonantTable.applyTable(selectPhonologyConsonantTable);
    resultPhonologyVowelTable.applyTable(selectPhonologyVowelTable);
    
    syllableShapeEditor.loadStatesFromDataFile(selectPhonologyConsonantTable,selectPhonologyVowelTable);
    updateSyllableShapeResults();
    
    primaryStressingPositionField.value = languageData.stressingPosition;
    primaryStressingPositionField.number.text = ""+languageData.stressingPosition;
    updateSyllableStressResults();
    
    updateKeyboards();
    updateVocabularyLists();
    
    //rootWordMultiText;
    //rootWordEditor;
    //layer2a_keyboard;
    
  }
}
