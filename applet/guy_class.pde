class guy{
  gun myGun=new gun();
  boolean bAi=true;
  boolean bShoot=false;
  vector p=new vector();
  vector lp = new vector();
  vector r=new vector();
  vector s=new vector();
  vector v=new vector();
  vector goalPos=new vector();
  vector mr = new vector();
  boolean bActive=true;
  vector pGoal=new vector();
  boolean trackTarget=false;
  int target;
  int moveMode=0;
  int team = -1;
  M4 rM = new M4();
  fig mod;
  int iAm;
  guy(int me,String name){
    pGoal=new vector(random(32*4*bw,96*4*bw),random(-24*4*bh,0),random(32*4*bw,96*4*bw)); 
    bActive=true;
    iAm=me;
    if(iAm!=0){
      int test =floor(random(1.25));
      /*switch(test){
      case 0:
        mod = new fig(name,color(255,0,0));
        target=iAm;
        break;
      case 1:
        mod=new fig(name,color(0,255,0));
        target=iAm;
        break;
      }*/
      if(0<iAm&&iAm<33){
        team=0; 
      }else{
      if(33<=iAm&&iAm<65){
        team=1; 
      }else{team=-1;
      }
      }
          if(iAm==0){
      team = -1; 
    }
    else{
      myGun.shotType=5;
      ;
    }
      if(team==-1){

        mod=new fig(name,color(0,255,0)); 
      }
      if(team==0){
        mod=new fig(name,color(255,0,0)); 
      }
      if(team==1){
        mod=new fig(name,color(0,0,255)); 
      }
    }
    else{
      mod = new fig(name);
    }
  }
  void upDate(){
    imp h=new imp();
    if(bActive){
      M4 M = new M4();
      M4 M1 = new M4();
      if(!bAi){
        if(keysPressed[ascii('u')]){
          bShoot=true; 
        }
        else{
          bShoot=false; 
        }
        if(keysPressed[ascii('w')]||keysPressed[ascii('W')]){
          moveMode=1;
          //mr.x(PI/12);
        }
        if(keysPressed[ascii('s')]||keysPressed[ascii('S')]){
          moveMode=2;
          //mr.x(-PI/12);
        }
        if(keysPressed[ascii('a')]||keysPressed[ascii('A')]){
          r.y(r.y()-PI/100);
          mr.z(-PI/8);
          mr.y(-PI/8);
        }
        if(keysPressed[ascii('d')]||keysPressed[ascii('D')]){
          r.y(r.y()+PI/100);
          mr.z(PI/8);
          mr.y(PI/8);
        }
        if(!(keysPressed[ascii('a')]||keysPressed[ascii('A')]||keysPressed[ascii('d')]||keysPressed[ascii('D')])){
          mr.z(0);
          mr.y(0);
        }
        if(keysPressed[32]){
          if(moveMode==1){
            moveMode=3; 
          }
          if(moveMode==2){
            moveMode=4; 
          }
        }
        if(!(keysPressed[ascii('w')]||keysPressed[ascii('W')])&&!(keysPressed[ascii('s')]||keysPressed[ascii('S')])){
          moveMode=0;
        }
        if(moveMode==0){
          r.x(0);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-128){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==1){
          r.x(PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          //s.z(s.z()-1);
          if(s.z()>-32){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==2){
          r.x(-PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-128){
            s.z(s.z()+1); 
          }
          if(s.z()>-32){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==3){
          r.x(PI/2);
          v.y(v.y()+abs(s.z()));
          v.y(v.y+1);
          s.z(0);
          v.y(min(v.y,128));
        }
        if(moveMode==4){
          r.x(-PI/2);
          v.y(v.y()-abs(s.z()));
          v.y(v.y+1);
          v.y(min(v.y,-32));
          s.z(0);
        }
      }
      //target=-1;
      if(bAi){
        /*float range=-1;
         for(int i = 0; i<peeps.length;i++){
         if((i==iAm)==false){
         if(p.vMinus(peeps[i].p).vMag()<range||target==iAm||target<0){
         target=i;
         range=p.vMinus(peeps[i].p).vMag();
         }
         }
         }*/
        //target=0;
        if(frameCount%32==iAm%32){
          while(target==iAm){
            target=floor(random(peeps.length)); 
          }
          int d = -1;
          if(team>=0){
            trackTarget=false;
            for(int i = 0; i < peeps.length; i++){
              if(i!=iAm&&peeps[i].team>=0&&peeps[i].team!=team){
                if((peeps[i].p.vMinus(p).vMag()<28*bw*4)&&(d<0||peeps[i].p.vMinus(p).vMag()<d)){
                  target=i;
                  d=floor(peeps[i].p.vMinus(p).vMag());
                  trackTarget=true;
                }
              }
            }
          }
          while(pGoal.vMinus(p).vMag()<2048){
            int k = floor(random(estments.length));
            pGoal.x(estments[k].x());
            pGoal.y(estments[k].y());
            pGoal.z(estments[k].z());
          }
          if(trackTarget){
            pGoal.x(peeps[target].p.x());
            pGoal.y(peeps[target].p.y());
            pGoal.z(peeps[target].p.z());
          }
          M.MRot(0,0,r.z());
          M1.MRot(r.x(),0,0);
          M1=MMulti(M1,M);
          M.MRot(0,r.y(),0);
          M=MMulti(M,M1);
          vector tS1 = s.vMRot(M).vPlus(v);
          rM=M;
          vector isop1 = new vector();
          vector isolp1=new vector();
          isop1.x(p.x()/bw+sign(tS1.x()));
          isop1.y(p.y()/bh+sign(tS1.y()));
          isop1.z(p.z()/bw+sign(tS1.z()));
          goalPos.x(pGoal.x());
          goalPos.y(pGoal.y());
          goalPos.z(pGoal.z());
          d=-1;
          isop1.x(floor(p.x()/bw));
          isop1.y(floor(p.y()/bh));
          isop1.z(floor(p.z()/bw));
          h=b.hit(new vector(p.x(),p.y(),p.z()),new vector(pGoal.x(),pGoal.y(),pGoal.z()));
          if(h.t()>=0){         
            for(int i = -3; i<4; i++){
              for(int j = -3; j <4; j++){
                if(i!=0||j!=0){
                  isolp1.x(isop1.x()+i);
                  isolp1.y(isop1.y());
                  isolp1.z(isop1.z()+j);
                  if(!b.bIn(isolp1)){
                    isolp1.x(isolp1.x()*bw+bw/2);
                    isolp1.y(isolp1.y()*bh);
                    isolp1.z(isolp1.z()*bw+bw/2);
                    if(d<0||isolp1.vMinus(pGoal).vMag()<d){
                      d=floor(isolp1.vMinus(pGoal).vMag());
                      goalPos.x(isolp1.x());
                      goalPos.y(isolp1.y());
                      goalPos.z(isolp1.z());
                    }
                  }
                }
              }
            }
          }
          if(trackTarget){
            rM.MTrans();
            vector tAt = peeps[target].p.vMinus(p).vMRot(rM);
            if(mag(tAt.x(),tAt.y())<512&&tAt.z()<0){
              bShoot=true;
            }else{
              bShoot=false; 
            }
          }
          if(peeps[target].p.y()<p.y()-bh/2){
            moveMode=2; 
          }
          else{
            if(peeps[target].p.y()>p.y()+bh/2){
              moveMode=1; 
            }
            else{
              moveMode=0; 
            }
          }
        }
        //
        r.z(0);
        float theta=limit(atan2((goalPos.vMinus(p)).z(),(goalPos.vMinus(p)).x())+PI/2-r.y());
        if(theta<-PI/10){
          r.y(r.y()-PI/500);
          mr.z(-PI/8);
          mr.y(-PI/8);
        }
        else{
          if(theta>PI/10){
            r.y(r.y()+PI/500);
            mr.z(PI/8);
            mr.y(PI/8);
          }
          else{
            mr.z(0);
            mr.y(0); 
          }
        }
        if(moveMode==0){
          r.x(0);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==1){
          r.x(PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==2){
          r.x(-PI/4);
          s.z(s.z()-abs(v.y()));
          v.y(0);
          if(s.z()<-64){
            s.z(s.z()+1); 
          }
          if(s.z()>-16){
            s.z(s.z()-1); 
          }
        }
        if(moveMode==3){
          r.x(PI/2);
          v.y(v.y()+abs(s.z()));
          v.y(v.y+1);
          s.z(0);
          v.y(min(v.y,256));
        }
        if(moveMode==4){
          r.x(-PI/2);
          v.y(v.y()-abs(s.z()));
          v.y(v.y+1);
          v.y(min(v.y,-64));
          s.z(0);
        }
      }

      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      vector tS = s.vMRot(M).vPlus(v);
      rM=M;
      lp = p;
      p=p.vPlus(tS);
      if(p.y()>=-1){
        p.y(-1); 
      }
      vector isop = new vector();
      vector isolp=new vector();
      isop.x(p.x());
      isop.y(p.y());
      isop.z(p.z());
      isolp.x(lp.x());
      isolp.y(lp.y());
      isolp.z(lp.z());
      h = b.hit(isolp,isop);
      while(h.t()>=0){
        vector t = p.vMinus(h.p());
        t.x(t.x()*(1-abs(h.n().x())));
        t.y(t.y()*(1-abs(h.n().y())));
        t.z(t.z()*(1-abs(h.n().z())));
        p=h.p().vPlus(t);
        p=p.vPlus(h.n().vTimes(4));
        isolp=p;
        isop=h.p();
        h=b.hit(isop,isolp);
      }
      myGun.upDate(bShoot,p,r);
    }
  }
  void draw(){
    if(bActive){
      M4 M = new M4();
      M4 M1 = new M4();
      M.MRot(0,0,r.z());
      M1.MRot(r.x(),0,0);
      M1=MMulti(M1,M);
      M.MRot(0,r.y(),0);
      M=MMulti(M,M1);
      M1.MRot(mr.x(),mr.y(),mr.z());
      M=MMulti(M,M1);
      mod.draw(p,M); 
    }
  }
}
class imp{
  float t=-1;
  vector n=new vector();
  vector p=new vector();
  int iHit=-1;
  imp(){
    t=-1;
  }
  imp(vector p1, vector n1, float t1){
    p=p1;
    n=n1;
    t=t1;
  }
  imp(vector p1, vector n1){
    p=p1;
    n=n1;
  }
  float t(){
    return t; 
  }
  int iHit(){
    return iHit; 
  }
  vector n(){
    return n; 
  }
  vector p(){
    return p; 
  }
  void t(float t1){
    t=t1; 
  }
  void n(vector n1){
    n=n1; 
  }
  void p(vector p1){
    p=p1; 
  }
  void iHit(int hit){
    iHit=hit; 
  }
}
class gun{
  int clipSize=4;
  int clip=0;
  int reLoadCounter=0;
  int reLoadTime=60;
  int shotCounter=0;
  int shotTime=8;
  vector fireFrom=new vector();
  vector fireAngle=new vector();
  vector fireVel=new vector(0,0,-1024);
  int shotType=0;
  int shotRange=64;
  gun(){
  }
  void upDate(boolean firing,vector p, vector r){
    shotCounter--;
    reLoadCounter--;
    if(firing&&reLoadCounter<0){
      if(shotCounter<0&&clip>0){
        clip--;
        shotCounter=shotTime-1;
        M4 M;
        M4 M1;
        M = new M4();
        M1 = new M4();
        M.MRot(0,0,r.z());
        M1.MRot(r.x(),0,0);
        M1=MMulti(M1,M);
        M.MRot(0,r.y(),0);
        M=MMulti(M,M1);
        addProj(p,r.vPlus(fireAngle),fireVel,shotRange,shotType,0);
      }
    }
    if(clip<=0){
      clip=clipSize;
      reLoadCounter=reLoadTime-1;
    }
  }
}
