obj[] stuff=new obj[0];
class obj{
  fig mod;
  vector p;
  vector r;
  obj(vector p1, vector r1, fig mod1){
    p=p1;
    r=r1;
    mod=mod1;
  }
  void draw(){
    if(p.vMinus(pCam).vMag()<1024*64){
      M4 M;
      M4 M1;
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      mod.draw(p,M);
    }
  }
}
void addObj(vector p, vector r, fig mod){
  obj[] tStuff = new obj[stuff.length+1];
  for(int i = 0; i < stuff.length; i++){
    tStuff[i]=stuff[i]; 
  }
  tStuff[tStuff.length-1]=new obj(p,r,mod);
  stuff=tStuff;
}
void drawObj(){
  for(int i = 0; i<stuff.length;i++){
    stuff[i].draw(); 
  }
}
