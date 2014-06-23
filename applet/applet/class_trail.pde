class pTrail{
  float perFrame=1;
  vector[]  p = new vector[0];
  int cur = 0;
  boolean[] filled=new boolean[0];
  pTrail(int l,float k){
    p=new vector[l];
    filled=new boolean[l];
    for(int i = 0; i < l; i++){
      filled[i]=false; 
    }
    cur = 0;
    perFrame = k;
    for(int i = 0; i < l; i++){
      p[i]=new vector();
    }
  }
  void addPoint(vector nP){
    vector lp = p[cur];
    if(perFrame>=1){
      int pF = floor(perFrame); 
      for(int i = 0; i < pF;i++){
        cur=(cur+1)%p.length;
                filled[cur]=true;
        p[cur]=lp.vPlus((nP.vMinus(lp).vTimes(float(i+1)/perFrame)));
      }
    }
    if(perFrame<1){
      if(frameCount%floor(1/perFrame)==0){
        filled[cur]=true;
        cur=(cur+1)%p.length;
        p[cur]=nP;
      } 
    }
  }
  void draw(){
    for(int i = 0; i < p.length; i++){
      if(filled[i]);
      render.addPoint(p[i]);
    } 
  }

}
class lTrail{
  vector[]  p = new vector[0];
  color c;
  int cur = 0;
  boolean[] filled=new boolean[0];
  lTrail(int l,color col){
    p=new vector[l];
    c=col;
    filled=new boolean[l];
    for(int i = 0; i < l; i++){
      filled[i]=false; 
    }
    cur = 0;
    for(int i = 0; i < l; i++){
      p[i]=new vector();
    }
  }
  void addVert(vector nP){
    cur=(cur+1)%p.length;
    p[cur]=nP;
    filled[cur]=true;
   
  }
  void draw(){
    for(int i = 0; i < p.length; i++){
      if(filled[i]&&filled[(i+1)%p.length]);
      render.addLine(p[i],p[(i+1)%p.length],c);
    } 
  }

}
