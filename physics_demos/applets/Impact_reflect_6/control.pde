boolean[] keysPressed = new boolean[128]; 
boolean[] keysTapped = new boolean [128];
boolean[] pKeysPressed = new boolean[128];
float[] column = new float[2];
char[] type = new char[50];

void drawColumn(float x, float y, float xm, float ym){
  rectMode(CENTER);
  ellipseMode(CENTER);
  stroke(0);
  noFill();
  rect(x,y,xm,ym);
  rect(x, y, xm/8, ym);
  rect(x, y, xm, ym/8);
  fill(255,200,0);
  ellipse(column[0]*(2*width/PI)*(xm/width)+x, column[1]*(2*height/PI)*(ym/height)+y, xm/8,ym/8);
}
void columnUpdate(){
  column[0] = (mouseX-width/2)*(PI/(2*width));
  column[1] = (mouseY-height/2)*(PI/(2*width)); 
  if(abs(column[0])<PI/32){
    column[0]=0;
  }
  if(abs(column[1])<PI/32){
    column[1]=0;
  }
}
void keyPressed() {
  if(ascii(key)==8&&type.length>0){
    type = subset(type,0,type.length-1); 
  }
  if(ascii(key)>=32){
    type = append(type, key); 
  }
  if(!(ascii(key) == -1)){
    keysPressed[ascii(key)] = true;
  }
  else{
    keysPressed[keyCode] = true; 
  }
} 

void keyReleased() { 
  if(!(ascii(key) == -1)){
    keysPressed[ascii(key)] = false;
  }
  else{
    keysPressed[keyCode] = false; 
  }
} 

int ascii(char Char){
  for(int i = 0; i < 128; i++){
    if(Char == char(i)){
      return i;
    }
  }
  return -1;
}


int find(String[] file,String code,int pos){
  String[] splitData = new String[0];
  for(int i = 0; i < file.length; i++){
    splitData = split(file[i]);
    if(splitData.length>pos){
      if (splitData[pos].equals(code)){
        return(i);
      }
    }
  }
  return(-1);  
}

int find(String[] file,String code,int pos,int after){
  String[] splitData;
  if(after<file.length){
    for(int i = after; i < file.length; i++){
      splitData = split(file[i]);
      if(splitData.length>pos){
        if (splitData[pos].equals(code)){
          return(i);
        }
      }
    }
  }
  return(-1);  
}
int pressedX,pressedY = 0;
void mousePressed(){
  pressedX = mouseX;
  pressedY = mouseY;
}
float limit(float theta){
  while(theta>PI){
    theta-=TWO_PI;
  } 
  while(theta<-PI){
    theta+=TWO_PI; 
  }
  return theta;
}
void tap(){
  for(int i = 0; i < 128; i++){
    if(keysPressed[i] == true&&pKeysPressed[i]==false){
      keysTapped[i]=true;
    } 
    else{
      keysTapped[i] = false; 
    }
  }
  for(int i = 0; i < 128; i++){
    pKeysPressed[i] = keysPressed[i]; 
  }
}
class control{
  boolean[] bKeys;
  String sKeys;
  control(String sInput){
    sKeys = sInput;
    bKeys = new boolean[sKeys.length()]; 
  }
  void upDate(){
    for(int i = 0; i < bKeys.length; i++){
      bKeys[i] = keysPressed[ascii(sKeys.charAt(i))];
    } 
  }
  boolean test(String sInput){
    boolean aBool = true;
    boolean[] bBool = new boolean[bKeys.length];
    for(int i = 0; i < bBool.length; i++){
      bBool[i] = false; 
    }
    for(int i = 0; i < sKeys.length(); i++){
      for(int j = 0; j < sInput.length(); j++){
        if(sKeys.charAt(i)==sInput.charAt(j)){
          bBool[i] = true; 
        }
      }
    }
    for(int i = 0; i < bKeys.length; i++){
      if(bBool[i] !=bKeys[i]){
        aBool = false; 
      }
    }
    return aBool;
  }
}
