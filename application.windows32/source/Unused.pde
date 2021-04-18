

public void playSound(String path){
  println("Error: Failed to play sound '"+path+"' : not implemented yet");
}



public void advancedText(String s, int tsize, int posx, int posy){
  //Function: the String s is scanned: stuff written as /x/ will be replaced by a importet letter, stuff marked as §x§ will be highlighted in red. 
  //The first symbol is decisive. Incomplete stuff is treated as normals text
  char[] tmpC = s.toCharArray();
  float tmpX = posx;
  String tmpS = "";
  textSize(tsize);
  int mode = 0;//mode; 0:x, 1:/, 2:§
  
  for(int i = 0; i < tmpC.length; i++){ 
    
    if(tmpC[i] == '/'){
      if(mode == 0){
        fill(ColorCode.black);
        mode = 1;
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6 * tsize;
        tmpS = "";
      }else if(mode == 1){
        mode = 0;
        //showSymbol(tmpS, tsize, tmpX, tmpY);
        tmpX += 0.7 * tsize;
        tmpS = "";
      }else if(mode == 2){
        tmpS += tmpC[i];
      }
      
    }else if (tmpC[i] == '§'){
      if(mode == 0){
        mode = 2;
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6 * tsize;
        tmpS = "";
      }else if(mode == 1){
        tmpS += tmpC[i];
      }else if(mode == 2){
        mode = 0;
        fill(ColorCode.red);
        text(tmpS, tmpX, posy);
        tmpX += tmpS.toCharArray().length * 0.6 * tsize;
        tmpS = "";
      }
      
    }else{
      tmpS += tmpC[i];
    }
  }
  
  fill(ColorCode.black);
  text(tmpS, tmpX, posy);
}

public void showSymbol(String path, float exp, float posx, float posy){
  
}
