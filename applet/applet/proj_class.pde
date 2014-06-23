proj[] deb = new proj[1024];
fig[] mods = new fig[5];
void loadMods(){
  mods[0]=new fig("rocket1");
  mods[1]=new fig("dot");
  mods[2]=new fig("ballOfFire");
  mods[3]=new fig("dSphere"); 
  mods[4]=new fig("dot");
}
class proj{
  vector p=new vector();
  vector lp = new vector();
  vector r = new vector();
  vector v = new vector();
  vector s = new vector();
  M4 rM = new M4();
  boolean bActive=false;
  fig mod;
  int lifeLeft=0;
  int t=-1;
  imp h = new imp();
  int counter=0;
  proj(){
    bActive=false;
  }
  proj(vector p1, vector r1, vector s1,int time, int t1,int count){
    counter=count;
    M4 M;
    M4 M1;
    bActive=true;
    t=t1;
    lp=p1;
    p=p1;
    r=r1;
    s=s1;
    lifeLeft=time;
    v=new vector();
    switch(t){
    case 0:
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      mod=mods[0];
      break;
    case 1:
      mod=mods[1];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 2:
      mod=mods[1];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 3:
      mod=mods[3];
      break;

    case 4:
      mod=mods[4];
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      break;
    case 5:
      M = new M4();
      M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      rM=M;
      v=s.vMRot(rM);
      mod=mods[0];
      break;
    }
  }
  void upDate(){
    M4 M;
    M4 M1;
    M = new M4();
    M1 = new M4();
    M.MRot(0,0,r.z());
    M1.MRot(r.x(),0,0);
    M1=MMulti(M1,M);
    M.MRot(0,r.y(),0);
    M=MMulti(M,M1);
    rM=M;
    if(bActive){
      lifeLeft--;
      if(lifeLeft<0){
        bActive=false;
      }
      switch(t){
      case -1:
        break;
      case 0:
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          bActive=false; 
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          for(int i= 0; i < 8; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-48),floor(64),1,0);
          }
          for(int i= 0; i < 16; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-48),floor(64),4,0);
          }
          for(int i= 0; i < 1; i++){
            addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(random(32,128)),2,0);
          }
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5-abs(h.n().x())));
          temp.y(temp.y()*2*(.5-abs(h.n().y())));
          temp.z(temp.z()*2*(.5-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5-abs(h.n().x())));
          v.y(v.y()*2*(.5-abs(h.n().y())));
          v.z(v.z()*2*(.5-abs(h.n().z())));
          counter++;
          //addProj(h.p(),r,s,16,3);
          //bActive=false;
          h=b.hit(h.p(),p);
        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512&&j!=0){
              bActive=false;
              for(int i= 0; i < 16; i++){
                addProj(p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-64),floor(64),1,0);
              }
              for(int i= 0; i < 1; i++){
                addProj(p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(128),2,0);
              }
              //peeps[j].bActive=false;
            } 
          }
        }
        if(counter>0){
          bActive=false; 
        }
        mod.draw(p,rM);
        break;
      case 1:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
          v.y(-abs(v.y())*.5);
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5-abs(h.n().x())));
          temp.y(temp.y()*2*(.5-abs(h.n().y())));
          temp.z(temp.z()*2*(.5-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5-abs(h.n().x())));
          v.y(v.y()*2*(.5-abs(h.n().y())));
          v.z(v.z()*2*(.5-abs(h.n().z())));
          //b.builds[h.iHit()].health=b.builds[h.iHit()].health-.1;
          h=b.hit(h.p(),p);
          //if(counter<2){
          // for(int i= 0; i < 10; i++){
          //  addProj(h.p().vPlus(h.n().vTimes(5)),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-128),64,1,counter+1);
          //  }
          //  }
          //bActive=false;

        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512){
              bActive=false;
              for(int i= 0; i < 16; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
              }
              for(int i= 0; i < 32; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
              }
              for(int i= 0; i < 1; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-256),floor(128),2,0);
              }
              peeps[j].bActive=false;
              kills++;
            } 
          }
        }
        mod.draw(p,rM);
        break;
      case 2:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
        }
        h=b.hit(lp,p);
        while(h.t()>=0){
          vector temp = p.vMinus(h.p());
          temp.x(temp.x()*2*(.5-abs(h.n().x())));
          temp.y(temp.y()*2*(.5-abs(h.n().y())));
          temp.z(temp.z()*2*(.5-abs(h.n().z())));
          p=h.p().vPlus(temp);
          p=p.vPlus(h.n().vTimes(1));
          v.x(v.x()*2*(.5-abs(h.n().x())));
          v.y(v.y()*2*(.5-abs(h.n().y())));
          v.z(v.z()*2*(.5-abs(h.n().z())));
          h=b.hit(h.p(),p);
          if(counter<25){
            for(int i= 0; i < 16; i++){
              addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
            }
            for(int i= 0; i < 16; i++){
              addProj(h.p().vPlus(h.n()),new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
            }
          }
          bActive=false;
        }
        mod.draw(p,rM);
        break;
      case 3:
        mod.draw(p,rM);
        break;
      case 4:
        v.y(v.y()+1);
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          p.y(0);
          v.y(-abs(v.y())*.5);
        }
        mod.draw(p,rM);
        break;
      case 5:
        lp=p;
        p=p.vPlus(v);
        if(p.y()>0){
          bActive=false; 
        }
        for(int j =0; j < peeps.length;j++){
          if(peeps[j].bActive){
            if(p.vMinus(peeps[j].p).vMag()<512){
              bActive=false;
              for(int i= 0; i < 4; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),1,0);
              }
              for(int i= 0; i < 8; i++){
                addProj(peeps[j].p,new vector(random(TWO_PI),random(TWO_PI),0),new vector(0,0,-32),floor(64),4,0);
              }
              peeps[j].bActive=false;
              kills++;
            } 
          }
        }
        if(counter>0){
          bActive=false; 
        }
        mod.draw(p,rM);
        break;
      }
    }
  }
}
void addProj(vector p,vector r, vector s, int t, int t1,int counter){
  boolean bAlready=false;
  for(int i = 0; i < deb.length&&!bAlready; i++){
    if(deb[i].bActive==false){
      deb[i]=new proj(new vector(p.x(),p.y(),p.z()),new vector(r.x(),r.y(),r.z()),new vector(s.x(),s.y(),s.z()),t,t1,counter);
      bAlready=true; 
    }
  }
  /*if(!bAlready){
   proj[] td = new proj[deb.length+1];
   for(int i = 0; i < deb.length; i++){
   td[i]=deb[i];
   }
   td[td.length-1]=new proj(new vector(p.x(),p.y(),p.z()),new vector(r.x(),r.y(),r.z()),new vector(s.x(),s.y(),s.z()),t,t1,counter);
   deb=td;
   }*/
}
void projUpdate(){
  for(int i = 0; i < deb.length;i++){
    deb[i].upDate();
  } 
}
